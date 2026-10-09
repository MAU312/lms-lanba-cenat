import test from 'node:test';
import assert from 'node:assert/strict';
import pool from '../../src/config/db.js';
import ContentQuestion from '../../src/models/ContentQuestion.js';

test('create: inserta la pregunta (con su puntaje y tipo) y devuelve el id, usando pool por defecto', async (t) => {
  const queryCall = t.mock.method(pool, 'query', async () => ([{ insertId: 5 }]));

  const result = await ContentQuestion.create(1, '¿Cuánto es 2+2?', 0, 2, 'multiple_choice');

  assert.equal(result, 5);
  const [sql, params] = queryCall.mock.calls[0].arguments;
  assert.match(sql, /INSERT INTO content_questions/);
  assert.deepEqual(params, [1, '¿Cuánto es 2+2?', null, 0, 2, 'multiple_choice', null, null]);
});

test('create: acepta attachment_type/attachment_url opcionales (adjunto de la pregunta)', async (t) => {
  const queryCall = t.mock.method(pool, 'query', async () => ([{ insertId: 5 }]));

  await ContentQuestion.create(1, '¿Qué ves en la imagen?', 0, 1, 'short_answer', pool, 'image', '/uploads/question-attachments/foo.png');

  const [, params] = queryCall.mock.calls[0].arguments;
  assert.deepEqual(params, [1, '¿Qué ves en la imagen?', null, 0, 1, 'short_answer', 'image', '/uploads/question-attachments/foo.png']);
});

test('create: points por defecto es 1 si no se indica', async (t) => {
  const queryCall = t.mock.method(pool, 'query', async () => ([{ insertId: 5 }]));

  await ContentQuestion.create(1, '¿Cuánto es 2+2?', 0);

  const [, params] = queryCall.mock.calls[0].arguments;
  assert.equal(params[4], 1);
});

test('create: acepta question_text_en opcional (traducción al inglés de la pregunta)', async (t) => {
  const queryCall = t.mock.method(pool, 'query', async () => ([{ insertId: 5 }]));

  await ContentQuestion.create(1, '¿Cuánto es 2+2?', 0, 2, 'multiple_choice', pool, null, null, 'How much is 2+2?');

  const [sql, params] = queryCall.mock.calls[0].arguments;
  assert.match(sql, /question_text_en/);
  assert.deepEqual(params, [1, '¿Cuánto es 2+2?', 'How much is 2+2?', 0, 2, 'multiple_choice', null, null]);
});

test('create: acepta un executor alternativo (ej. una connection de transacción) en vez de pool', async (t) => {
  const poolCall = t.mock.method(pool, 'query', async () => { throw new Error('no debería llamar a pool.query'); });
  const calls = [];
  const fakeConnection = { query: async (sql, params) => { calls.push([sql, params]); return [{ insertId: 9 }]; } };

  const result = await ContentQuestion.create(1, 'Pregunta', 0, 3, 'true_false', fakeConnection);

  assert.equal(result, 9);
  assert.equal(calls.length, 1);
  assert.equal(poolCall.mock.calls.length, 0, 'no debe tocar pool.query cuando se pasa un executor');
});

test('createOptions: no hace nada si no hay opciones (evita un INSERT vacío)', async (t) => {
  const queryCall = t.mock.method(pool, 'query', async () => ([{}]));
  await ContentQuestion.createOptions(1, []);
  assert.equal(queryCall.mock.calls.length, 0);
});

test('createOptions: is_correct siempre se guarda como 0/1, e infiere order_index del índice si no viene', async (t) => {
  const queryCall = t.mock.method(pool, 'query', async () => ([{}]));

  await ContentQuestion.createOptions(1, [
    { text: 'A', is_correct: true },
    { text: 'B', is_correct: false }
  ]);

  const [sql, params] = queryCall.mock.calls[0].arguments;
  assert.match(sql, /INSERT INTO content_question_options/);
  assert.deepEqual(params, [[
    [1, 'A', null, 1, 0],
    [1, 'B', null, 0, 1]
  ]]);
});

test('createOptions: acepta text_en opcional por opción (traducción al inglés)', async (t) => {
  const queryCall = t.mock.method(pool, 'query', async () => ([{}]));

  await ContentQuestion.createOptions(1, [
    { text: 'A', text_en: 'A (en)', is_correct: true }
  ]);

  const [sql, params] = queryCall.mock.calls[0].arguments;
  assert.match(sql, /option_text_en/);
  assert.deepEqual(params, [[
    [1, 'A', 'A (en)', 1, 0]
  ]]);
});

test('findByContent: includeCorrect=false (default) NO trae is_correct — no filtra la respuesta antes de tiempo', async (t) => {
  const queryCall = t.mock.method(pool, 'query', async (sql) => {
    if (/FROM content_questions/.test(sql)) return [[{ id: 1, content_id: 10, question_text: 'P1', question_type: 'multiple_choice', order_index: 0 }]];
    return [[{ id: 100, question_id: 1, option_text: 'A', order_index: 0 }]];
  });

  const result = await ContentQuestion.findByContent(10);

  assert.equal(result[0].options[0].is_correct, undefined, 'sin includeCorrect, is_correct no debe estar presente');
  const [optionsSql] = queryCall.mock.calls[1].arguments;
  assert.doesNotMatch(optionsSql, /is_correct/);
});

test('findByContent: includeCorrect=true SÍ trae is_correct por opción', async (t) => {
  t.mock.method(pool, 'query', async (sql) => {
    if (/FROM content_questions/.test(sql)) return [[{ id: 1, content_id: 10, question_text: 'P1', question_type: 'multiple_choice', order_index: 0 }]];
    return [[{ id: 100, question_id: 1, option_text: 'A', is_correct: 1, order_index: 0 }]];
  });

  const result = await ContentQuestion.findByContent(10, { includeCorrect: true });

  assert.equal(result[0].options[0].is_correct, 1);
});

test('findByContent: trae attachment_type/attachment_url de cada pregunta (adjunto opcional)', async (t) => {
  t.mock.method(pool, 'query', async (sql) => {
    if (/FROM content_questions/.test(sql)) {
      assert.match(sql, /attachment_type/);
      assert.match(sql, /attachment_url/);
      return [[{ id: 1, content_id: 10, question_text: 'P1', question_type: 'short_answer', attachment_type: 'url', attachment_url: 'https://youtube.com/x', order_index: 0 }]];
    }
    return [[]];
  });

  const result = await ContentQuestion.findByContent(10);

  assert.equal(result[0].attachment_type, 'url');
  assert.equal(result[0].attachment_url, 'https://youtube.com/x');
});

test('findByContent: trae el question_type propio de cada pregunta — se pueden mezclar tipos en el mismo content', async (t) => {
  t.mock.method(pool, 'query', async (sql) => {
    if (/FROM content_questions/.test(sql)) {
      return [[
        { id: 1, content_id: 10, question_text: 'P1', question_type: 'multiple_choice', order_index: 0 },
        { id: 2, content_id: 10, question_text: 'P2', question_type: 'short_answer', order_index: 1 }
      ]];
    }
    return [[{ id: 100, question_id: 1, option_text: 'A' }]];
  });

  const result = await ContentQuestion.findByContent(10);

  assert.equal(result[0].question_type, 'multiple_choice');
  assert.equal(result[1].question_type, 'short_answer');
});

test('findByContent: sin preguntas, no consulta las opciones (evita un IN () vacío)', async (t) => {
  const queryCall = t.mock.method(pool, 'query', async () => ([[]]));

  const result = await ContentQuestion.findByContent(10);

  assert.deepEqual(result, []);
  assert.equal(queryCall.mock.calls.length, 1, 'solo la consulta de preguntas, ninguna de opciones');
});

test('deleteByContent: borra por content_id, usando pool por defecto', async (t) => {
  const queryCall = t.mock.method(pool, 'query', async () => ([{ affectedRows: 2 }]));

  await ContentQuestion.deleteByContent(10);

  const [sql, params] = queryCall.mock.calls[0].arguments;
  assert.match(sql, /DELETE FROM content_questions WHERE content_id = \?/);
  assert.deepEqual(params, [10]);
});

test('deleteByContent: acepta un executor alternativo (ej. una connection de transacción) en vez de pool', async (t) => {
  const poolCall = t.mock.method(pool, 'query', async () => { throw new Error('no debería llamar a pool.query'); });
  const calls = [];
  const fakeConnection = { query: async (sql, params) => { calls.push([sql, params]); return [{}]; } };

  await ContentQuestion.deleteByContent(10, fakeConnection);

  assert.equal(calls.length, 1);
  assert.equal(poolCall.mock.calls.length, 0, 'no debe tocar pool.query cuando se pasa un executor');
});

test('findByContent: cada pregunta trae solo sus propias opciones (filtradas por question_id)', async (t) => {
  t.mock.method(pool, 'query', async (sql) => {
    if (/FROM content_questions/.test(sql)) {
      return [[
        { id: 1, content_id: 10, question_text: 'P1', order_index: 0 },
        { id: 2, content_id: 10, question_text: 'P2', order_index: 1 }
      ]];
    }
    return [[
      { id: 100, question_id: 1, option_text: 'A' },
      { id: 101, question_id: 2, option_text: 'B' }
    ]];
  });

  const result = await ContentQuestion.findByContent(10);

  assert.equal(result[0].options.length, 1);
  assert.equal(result[0].options[0].question_id, 1);
  assert.equal(result[1].options[0].question_id, 2);
});
