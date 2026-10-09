import fs from 'fs/promises';
import Course from '../models/Course.js';
import User from '../models/User.js';
import { t } from '../utils/i18n.js';
import { hasAdminAccess } from '../utils/permissions.js';

/**
 * Middleware de autenticación
 * Verifica si el usuario tiene una sesión activa Y que siga siendo válida
 * en base de datos. Sin esto, el rol/estado quedaba cacheado en
 * req.session.user desde el login: si un admin desactivaba, borraba, o le
 * cambiaba el rol a un usuario con sesión abierta, esa sesión seguía
 * funcionando con los permisos viejos hasta que expirara la cookie (24h) o
 * el usuario cerrara sesión manualmente.
 */
export const isAuthenticated = async (req, res, next) => {
  if (!req.session || !req.session.user) {
    return res.status(401).json({
      success: false,
      message: t(req.locale, 'errors.unauthorized')
    });
  }

  try {
    const user = await User.findById(req.session.user.id);

    if (!user || user.is_active == 0 || user.is_active === false) {
      return req.session.destroy(() => {
        res.status(401).json({
          success: false,
          message: t(req.locale, 'errors.session_invalid')
        });
      });
    }

    // Sincroniza la sesión con la BD (ej. si un admin cambió el rol o el
    // nombre de este usuario después de que inició sesión, o si el propio
    // usuario cambió su foto de perfil).
    req.session.user = { id: user.id, name: user.name, email: user.email, role: user.role, admin_access: Boolean(user.admin_access), avatar_url: user.avatar_url };
    next();
  } catch (error) {
    next(error);
  }
};

/**
 * Middleware para verificar rol de administrador
 * También deja pasar a un profesor con `admin_access` (doble rol
 * profesor+admin, ver User.setAdminAccess) — no solo a role==='admin'.
 */
export const isAdmin = (req, res, next) => {
  if (req.session && hasAdminAccess(req.session.user)) {
    return next();
  }

  return res.status(403).json({
    success: false,
    message: t(req.locale, 'errors.admin_access_required')
  });
};

/**
 * Corta temprano — ANTES de que corra Multer — una subida de contenido de
 * curso hecha por un estudiante. Un estudiante nunca puede crear contenido
 * bajo ninguna circunstancia (requireCourseManager lo rechaza de todos
 * modos más adelante en la misma ruta), pero en las rutas con archivo
 * (POST /video, /file, /image, /task) Multer corre ANTES que
 * requireCourseManager porque course_id viaja en el multipart — sin este
 * guard, un estudiante podía hacer que el servidor escribiera a disco un
 * archivo completo (hasta 2GB para video) antes de recibir el 403.
 * No sustituye a requireCourseManager (que sigue siendo la autorización
 * real: admin o profesor asignado al curso del body) — solo descarta
 * rápido, por rol, el caso más costoso y más común de intentarlo sin
 * ningún permiso.
 */
export const rejectStudentUploads = (req, res, next) => {
  if (req.session?.user?.role === 'student') {
    return res.status(403).json({
      success: false,
      message: t(req.locale, 'errors.admin_or_course_teacher_required')
    });
  }
  next();
};

/**
 * Middleware factory para rutas de gestión de un curso específico (editar
 * contenido, ver estudiantes inscritos, etc.): deja pasar a un admin
 * siempre, o a un profesor según Course.canManageContent. `resolveCourseId`
 * recibe `req` y devuelve el id del curso (o una Promise que lo resuelve) —
 * permite usarlo tanto cuando el id viene directo en la URL
 * (`req.params.id`) como cuando hay que buscarlo primero (ej. a partir de
 * un content_id o de `req.body`).
 *
 * `resolveFolderId` (opcional, mismo contrato que resolveCourseId) permite
 * que un profesor escopeado a un módulo puntual (course_teachers.module_id,
 * ver módulos) gestione SOLO el contenido de ese módulo — si no se pasa,
 * folderId resuelve a null y Course.canManageContent solo deja pasar a un
 * profesor "de todo el curso" (module_id NULL), que es exactamente el
 * comportamiento de siempre para cualquier ruta que no se haga consciente
 * de módulo.
 *
 * IMPORTANTE: en las rutas de subida (POST /video, POST /file), este
 * middleware va DESPUÉS de multer (no antes) porque `req.body.course_id`
 * es un campo del multipart/form-data — no existe todavía si multer no
 * corrió. Como consecuencia, si esta verificación rechaza la petición
 * *después* de que multer ya guardó el archivo en disco, hay que borrarlo
 * aquí mismo — si no, queda huérfano (nunca se inserta en la tabla
 * `contents`, así que ninguna otra limpieza lo alcanza).
 */
export function requireCourseManager(resolveCourseId, resolveFolderId) {
  const deny = async (req, res, status, message) => {
    if (req.file) {
      await fs.unlink(req.file.path).catch(() => {});
    }
    return res.status(status).json({ success: false, message });
  };

  return async (req, res, next) => {
    if (!req.session || !req.session.user) {
      return deny(req, res, 401, t(req.locale, 'errors.unauthorized'));
    }

    if (hasAdminAccess(req.session.user)) {
      return next();
    }

    if (req.session.user.role !== 'teacher') {
      return deny(req, res, 403, t(req.locale, 'errors.admin_or_course_teacher_required'));
    }

    try {
      const courseId = await resolveCourseId(req);

      if (!courseId) {
        return deny(req, res, 404, t(req.locale, 'errors.course_not_found'));
      }

      const folderId = resolveFolderId ? await resolveFolderId(req) : null;
      const canManage = await Course.canManageContent(courseId, req.session.user.id, folderId);

      if (!canManage) {
        return deny(req, res, 403, t(req.locale, 'errors.not_assigned_teacher'));
      }

      next();
    } catch (error) {
      if (req.file) {
        await fs.unlink(req.file.path).catch(() => {});
      }
      next(error);
    }
  };
}