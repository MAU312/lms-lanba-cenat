import express from 'express';
import * as submissionController from '../controllers/submission.controller.js';
import TaskSubmission from '../models/TaskSubmission.js';
import Content from '../models/Content.js';
import { isAuthenticated, requireCourseManager } from '../middlewares/auth.middleware.js';
import { validateFieldLengths } from '../middlewares/validateFieldLengths.middleware.js';

const router = express.Router();

/**
 * Resuelve el course_id de una entrega a partir de su :id de ruta
 * (entrega -> contenido -> curso), para requireCourseManager en la ruta
 * de revisión.
 */
async function courseIdFromSubmissionParam(req) {
  const submission = await TaskSubmission.findById(req.params.id);
  if (!submission) return null;
  const content = await Content.findById(submission.content_id);
  return content ? content.course_id : null;
}

/**
 * Igual que courseIdFromSubmissionParam, pero resolviendo el folder_id
 * (módulo) de la tarea — sin esto, un profesor escopeado a un módulo
 * (course_teachers.module_id) podía VER las entregas de su módulo
 * (GET /contents/:id/submissions ya usa este mismo criterio) pero nunca
 * calificarlas: esta ruta solo dejaba pasar a un profesor "de todo el
 * curso" o a un admin.
 */
async function folderIdFromSubmissionParam(req) {
  const submission = await TaskSubmission.findById(req.params.id);
  if (!submission) return null;
  const content = await Content.findById(submission.content_id);
  return content ? content.folder_id : null;
}

/**
 * GET /api/submissions/:id/download
 * Autorización fina (admin, profesor del curso, o el propio dueño de la
 * entrega) resuelta dentro del controller — no es un simple "admin o
 * profesor de curso" como requireCourseManager, así que no se usa acá.
 */
router.get('/:id/download', isAuthenticated, submissionController.downloadSubmission);

/**
 * PUT /api/submissions/:id/review
 * Admin, el profesor de todo el curso, o el profesor escopeado al módulo
 * de esa tarea (mismo alcance que GET /contents/:id/submissions).
 */
router.put(
  '/:id/review',
  isAuthenticated,
  requireCourseManager(courseIdFromSubmissionParam, folderIdFromSubmissionParam),
  validateFieldLengths('feedback'),
  submissionController.reviewSubmission
);

export default router;
