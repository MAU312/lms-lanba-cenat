import test from 'node:test';
import assert from 'node:assert/strict';
import fs from 'fs';
import * as userController from '../../src/controllers/user.controller.js';
import User from '../../src/models/User.js';
import { mockReq, mockRes } from '../helpers/http.js';

test('createUser: 201 y hashea la contraseña antes de guardarla', async (t) => {
  const createCall = t.mock.method(User, 'create', async () => 20);
  const req = mockReq({
    body: { name: 'Nuevo Profe', email: 'profe@test.com', username: 'nuevo.profe', password: 'Secreta123', role: 'teacher' },
    session: { user: { id: 1, role: 'admin' } }
  });
  const res = mockRes();

  await userController.createUser(req, res);

  assert.equal(res.statusCode, 201);
  const created = createCall.mock.calls[0].arguments[0];
  assert.equal(created.role, 'teacher');
  assert.equal(created.username, 'nuevo.profe');
  assert.notEqual(created.password, 'Secreta123', 'la contraseña nunca debe guardarse en texto plano');
});

test('createUser: 400 si falta el rol', async (t) => {
  const createCall = t.mock.method(User, 'create', async () => 20);
  const req = mockReq({
    body: { name: 'X', email: 'x@test.com', password: 'Secreta123' },
    session: { user: { id: 1, role: 'admin' } }
  });
  const res = mockRes();

  await userController.createUser(req, res);

  assert.equal(res.statusCode, 400);
  assert.equal(createCall.mock.calls.length, 0);
});

test('createUser: 400 si el rol no es válido', async (t) => {
  const req = mockReq({
    body: { name: 'X', email: 'x@test.com', password: 'Secreta123', role: 'superadmin' },
    session: { user: { id: 1, role: 'admin' } }
  });
  const res = mockRes();

  await userController.createUser(req, res);

  assert.equal(res.statusCode, 400);
  assert.match(res.body.message, /Rol inválido/);
});

test('createUser: 400 si la contraseña es muy corta', async (t) => {
  const req = mockReq({
    body: { name: 'X', email: 'x@test.com', password: '123', role: 'student' },
    session: { user: { id: 1, role: 'admin' } }
  });
  const res = mockRes();

  await userController.createUser(req, res);

  assert.equal(res.statusCode, 400);
});

test('createUser: 400 si el username no cumple el formato (ej. trae espacios)', async (t) => {
  const req = mockReq({
    body: { name: 'X', email: 'x@test.com', password: 'Secreta123', role: 'student', username: 'con espacio' },
    session: { user: { id: 1, role: 'admin' } }
  });
  const res = mockRes();

  await userController.createUser(req, res);

  assert.equal(res.statusCode, 400);
});

test('createUser: 400 si el email o username ya está en uso (ER_DUP_ENTRY)', async (t) => {
  t.mock.method(User, 'create', async () => {
    const err = new Error('Duplicate entry');
    err.code = 'ER_DUP_ENTRY';
    throw err;
  });
  const req = mockReq({
    body: { name: 'X', email: 'x@test.com', password: 'Secreta123', role: 'student' },
    session: { user: { id: 1, role: 'admin' } }
  });
  const res = mockRes();

  await userController.createUser(req, res);

  assert.equal(res.statusCode, 400);
  assert.match(res.body.message, /ya está en uso/);
});

test('updateUser: acepta el rol "teacher"', async (t) => {
  t.mock.method(User, 'findById', async () => ({ id: 5, name: 'Ana', email: 'ana@test.com', role: 'student' }));
  const updateCall = t.mock.method(User, 'update', async () => true);
  const req = mockReq({
    params: { id: '5' },
    body: { name: 'Ana', email: 'ana@test.com', role: 'teacher' },
    session: { user: { id: 1, role: 'admin' } }
  });
  const res = mockRes();

  await userController.updateUser(req, res);

  assert.equal(res.statusCode, 200);
  assert.equal(updateCall.mock.calls.length, 1);
  assert.equal(updateCall.mock.calls[0].arguments[1].role, 'teacher');
});

test('updateUser: sigue rechazando un rol que no existe', async (t) => {
  t.mock.method(User, 'findById', async () => ({ id: 5, name: 'Ana', email: 'ana@test.com', role: 'student' }));
  const req = mockReq({
    params: { id: '5' },
    body: { name: 'Ana', email: 'ana@test.com', role: 'superadmin' },
    session: { user: { id: 1, role: 'admin' } }
  });
  const res = mockRes();

  await userController.updateUser(req, res);

  assert.equal(res.statusCode, 400);
  assert.match(res.body.message, /Rol inválido/);
});

test('updateUser: un admin no puede quitarse su propio rol de admin', async (t) => {
  t.mock.method(User, 'findById', async () => ({ id: 1, name: 'Admin', email: 'admin@test.com', role: 'admin' }));
  const req = mockReq({
    params: { id: '1' },
    body: { name: 'Admin', email: 'admin@test.com', role: 'teacher' },
    session: { user: { id: 1, role: 'admin' } }
  });
  const res = mockRes();

  await userController.updateUser(req, res);

  assert.equal(res.statusCode, 400);
});

// =================================
// Un profesor con admin_access (doble rol, no admin real) no puede tocar
// el nivel admin: ni editar a un admin real, ni auto-promoverse a admin.
// =================================

test('updateUser: 403 si un profesor con admin_access intenta editar a un admin real', async (t) => {
  t.mock.method(User, 'findById', async () => ({ id: 1, name: 'Admin', email: 'admin@test.com', role: 'admin' }));
  const updateCall = t.mock.method(User, 'update', async () => true);
  const req = mockReq({
    params: { id: '1' },
    body: { name: 'Admin hackeado', email: 'admin@test.com', role: 'admin' },
    session: { user: { id: 9, role: 'teacher', admin_access: true } }
  });
  const res = mockRes();

  await userController.updateUser(req, res);

  assert.equal(res.statusCode, 403);
  assert.equal(updateCall.mock.calls.length, 0);
});

test('updateUser: 403 si un profesor con admin_access intenta auto-promoverse a role=admin', async (t) => {
  t.mock.method(User, 'findById', async () => ({ id: 9, name: 'Profe', email: 'profe@test.com', role: 'teacher' }));
  const updateCall = t.mock.method(User, 'update', async () => true);
  const req = mockReq({
    params: { id: '9' },
    body: { name: 'Profe', email: 'profe@test.com', role: 'admin' },
    session: { user: { id: 9, role: 'teacher', admin_access: true } }
  });
  const res = mockRes();

  await userController.updateUser(req, res);

  assert.equal(res.statusCode, 403);
  assert.equal(updateCall.mock.calls.length, 0);
});

test('updateUser: un admin real SÍ puede editar a otro admin real', async (t) => {
  t.mock.method(User, 'findById', async () => ({ id: 1, name: 'Admin', email: 'admin@test.com', role: 'admin' }));
  const updateCall = t.mock.method(User, 'update', async () => true);
  const req = mockReq({
    params: { id: '1' },
    body: { name: 'Admin renombrado', email: 'admin@test.com', role: 'admin' },
    session: { user: { id: 2, role: 'admin' } }
  });
  const res = mockRes();

  await userController.updateUser(req, res);

  assert.equal(res.statusCode, 200);
  assert.equal(updateCall.mock.calls.length, 1);
});

test('createUser: 403 si un profesor con admin_access intenta crear otro admin', async (t) => {
  const createCall = t.mock.method(User, 'create', async () => 50);
  const req = mockReq({
    body: { name: 'Admin Nuevo', email: 'nuevo-admin@test.com', password: 'Secreta123', role: 'admin' },
    session: { user: { id: 9, role: 'teacher', admin_access: true } }
  });
  const res = mockRes();

  await userController.createUser(req, res);

  assert.equal(res.statusCode, 403);
  assert.equal(createCall.mock.calls.length, 0);
});

test('toggleUserActive: 404 si :id no es un entero limpio (ej. "1.2e2", que MySQL coacciona a 120 y saltaba el auto-guard)', async (t) => {
  const findCall = t.mock.method(User, 'findById', async () => ({ id: 120, is_active: 1 }));
  const req = mockReq({
    params: { id: '1.2e2' },
    session: { user: { id: 120, role: 'admin' } }
  });
  const res = mockRes();

  await userController.toggleUserActive(req, res);

  assert.equal(res.statusCode, 404);
  assert.equal(findCall.mock.calls.length, 0, 'no debe llegar a consultar la BD con un id mal formado');
});

test('toggleUserActive: 403 si un profesor con admin_access intenta (des)activar a un admin real', async (t) => {
  t.mock.method(User, 'findById', async () => ({ id: 1, role: 'admin', is_active: 1 }));
  const toggleCall = t.mock.method(User, 'toggleActive', async () => true);
  const req = mockReq({
    params: { id: '1' },
    session: { user: { id: 9, role: 'teacher', admin_access: true } }
  });
  const res = mockRes();

  await userController.toggleUserActive(req, res);

  assert.equal(res.statusCode, 403);
  assert.equal(toggleCall.mock.calls.length, 0);
});

test('deleteUser: 403 si un profesor con admin_access intenta eliminar a un admin real', async (t) => {
  t.mock.method(User, 'findById', async () => ({ id: 1, role: 'admin' }));
  const deleteCall = t.mock.method(User, 'delete', async () => true);
  const req = mockReq({
    params: { id: '1' },
    session: { user: { id: 9, role: 'teacher', admin_access: true } }
  });
  const res = mockRes();

  await userController.deleteUser(req, res);

  assert.equal(res.statusCode, 403);
  assert.equal(deleteCall.mock.calls.length, 0);
});

// =================================
// setUserAdminAccess (doble rol profesor+admin)
// =================================

test('setUserAdminAccess: da acceso de administrador a un profesor', async (t) => {
  t.mock.method(User, 'findById', async () => ({ id: 5, role: 'teacher' }));
  const setCall = t.mock.method(User, 'setAdminAccess', async () => true);
  const req = mockReq({
    params: { id: '5' },
    body: { admin_access: true },
    session: { user: { id: 1, role: 'admin' } }
  });
  const res = mockRes();

  await userController.setUserAdminAccess(req, res);

  assert.equal(res.statusCode, 200);
  assert.equal(res.body.data.admin_access, true);
  assert.deepEqual(setCall.mock.calls[0].arguments, ['5', true]);
});

test('setUserAdminAccess: 400 si el usuario objetivo no es profesor', async (t) => {
  t.mock.method(User, 'findById', async () => ({ id: 5, role: 'student' }));
  const setCall = t.mock.method(User, 'setAdminAccess', async () => true);
  const req = mockReq({
    params: { id: '5' },
    body: { admin_access: true },
    session: { user: { id: 1, role: 'admin' } }
  });
  const res = mockRes();

  await userController.setUserAdminAccess(req, res);

  assert.equal(res.statusCode, 400);
  assert.equal(setCall.mock.calls.length, 0);
});

test('setUserAdminAccess: 404 si el usuario no existe', async (t) => {
  t.mock.method(User, 'findById', async () => undefined);
  const req = mockReq({
    params: { id: '999' },
    body: { admin_access: true },
    session: { user: { id: 1, role: 'admin' } }
  });
  const res = mockRes();

  await userController.setUserAdminAccess(req, res);

  assert.equal(res.statusCode, 404);
});

test('getAllUsers: pasa page/limit/search al modelo con los mismos defaults que antes', async (t) => {
  const findAllCall = t.mock.method(User, 'findAll', async () => ({ rows: [], total: 0 }));
  const req = mockReq({ query: {} });
  const res = mockRes();

  await userController.getAllUsers(req, res);

  assert.deepEqual(findAllCall.mock.calls[0].arguments[0], { page: 1, limit: 10, search: '' });
});

// =================================
// updateMyAvatar / removeMyAvatar
// =================================

test('updateMyAvatar: 400 si no se sube ningún archivo', async (t) => {
  const updateCall = t.mock.method(User, 'updateAvatar', async () => true);
  const req = mockReq({ session: { user: { id: 5, avatar_url: null } } });
  const res = mockRes();

  await userController.updateMyAvatar(req, res);

  assert.equal(res.statusCode, 400);
  assert.equal(updateCall.mock.calls.length, 0);
});

test('updateMyAvatar: borra la foto anterior SOLO después de confirmar el UPDATE en BD', async (t) => {
  t.mock.method(User, 'updateAvatar', async () => true);
  const unlinkCall = t.mock.method(fs.promises, 'unlink', async () => {});
  const req = mockReq({
    session: { user: { id: 5, avatar_url: '/uploads/avatars/viejo.jpg' } },
    file: { filename: 'nuevo.jpg' }
  });
  const res = mockRes();

  await userController.updateMyAvatar(req, res);

  assert.equal(res.statusCode, 200);
  assert.equal(res.body.data.avatar_url, '/uploads/avatars/nuevo.jpg');
  assert.equal(unlinkCall.mock.calls.length, 1, 'debe borrar la foto anterior tras confirmar el UPDATE');
  assert.equal(req.session.user.avatar_url, '/uploads/avatars/nuevo.jpg', 'la sesión debe reflejar la foto nueva de inmediato');
});

test('updateMyAvatar: si el UPDATE no afecta ninguna fila, borra la foto RECIÉN subida (no la anterior)', async (t) => {
  t.mock.method(User, 'updateAvatar', async () => false);
  const unlinkCall = t.mock.method(fs.promises, 'unlink', async () => {});
  const req = mockReq({
    session: { user: { id: 5, avatar_url: '/uploads/avatars/viejo.jpg' } },
    file: { filename: 'nuevo.jpg' }
  });
  const res = mockRes();

  await userController.updateMyAvatar(req, res);

  assert.equal(res.statusCode, 400);
  assert.equal(unlinkCall.mock.calls.length, 1, 'borra la recién subida, no dos veces ni la anterior');
});

test('removeMyAvatar: 400 si el usuario no tiene foto de perfil puesta', async (t) => {
  const updateCall = t.mock.method(User, 'updateAvatar', async () => true);
  const req = mockReq({ session: { user: { id: 5, avatar_url: null } } });
  const res = mockRes();

  await userController.removeMyAvatar(req, res);

  assert.equal(res.statusCode, 400);
  assert.equal(updateCall.mock.calls.length, 0);
});

test('removeMyAvatar: borra el archivo, limpia avatar_url en BD y en la sesión', async (t) => {
  const updateCall = t.mock.method(User, 'updateAvatar', async () => true);
  const unlinkCall = t.mock.method(fs.promises, 'unlink', async () => {});
  const req = mockReq({ session: { user: { id: 5, avatar_url: '/uploads/avatars/viejo.jpg' } } });
  const res = mockRes();

  await userController.removeMyAvatar(req, res);

  assert.equal(res.statusCode, 200);
  assert.deepEqual(updateCall.mock.calls[0].arguments, [5, null]);
  assert.equal(unlinkCall.mock.calls.length, 1);
  assert.equal(req.session.user.avatar_url, null);
});
