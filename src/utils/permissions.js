/**
 * `role === 'admin' || admin_access` (el flag que permite a un profesor
 * tener también permisos de admin, ver User.setAdminAccess) se repetía
 * escrito a mano en middlewares, controllers, rutas y el modelo Course —
 * centralizado acá para que un cambio futuro en la regla no dependa de
 * actualizar cada copia por separado.
 */
export function hasAdminAccess(user) {
  return Boolean(user && (user.role === 'admin' || user.admin_access));
}
