import test from 'node:test';
import assert from 'node:assert/strict';
import Content from '../../src/models/Content.js';

test('redactForNoAccess: siempre oculta la URL', () => {
  const result = Content.redactForNoAccess({ id: 1, type: 'video', url: '/uploads/videos/x.mp4', description: 'resumen corto' });
  assert.equal(result.url, null);
});

test('redactForNoAccess: para type=text, también oculta description (ahí vive el contenido real de la lección)', () => {
  const result = Content.redactForNoAccess({
    id: 1,
    type: 'text',
    url: null,
    description: 'Todo el contenido de la lección que no debería filtrarse sin inscripción'
  });
  assert.equal(result.description, null);
});

test('redactForNoAccess: para type=forum, también oculta description (ahí vive el post principal del tema)', () => {
  const result = Content.redactForNoAccess({
    id: 1,
    type: 'forum',
    url: null,
    description: 'Discutan el capítulo 3 del texto — esto no debería filtrarse sin inscripción'
  });
  assert.equal(result.description, null);
});

test('redactForNoAccess: para video/file/url, NO toca description (ahí solo hay una descripción corta, no el contenido)', () => {
  const video = Content.redactForNoAccess({ id: 1, type: 'video', url: '/uploads/videos/x.mp4', description: 'Introducción al curso' });
  const file = Content.redactForNoAccess({ id: 2, type: 'file', url: '/uploads/files/x.pdf', description: 'Guía en PDF' });
  const urlContent = Content.redactForNoAccess({ id: 3, type: 'url', url: 'https://youtube.com/x', description: 'Video externo' });

  assert.equal(video.description, 'Introducción al curso');
  assert.equal(file.description, 'Guía en PDF');
  assert.equal(urlContent.description, 'Video externo');
});

test('redactForNoAccess: oculta description_en junto con description para text/forum (misma traducción, mismo contenido real)', () => {
  const textContent = Content.redactForNoAccess({ id: 1, type: 'text', url: null, description: 'Contenido', description_en: 'Content' });
  const forumContent = Content.redactForNoAccess({ id: 2, type: 'forum', url: null, description: 'Tema', description_en: 'Topic' });

  assert.equal(textContent.description_en, null);
  assert.equal(forumContent.description_en, null);
});

test('redactForNoAccess: para video/file/url, NO toca description_en', () => {
  const video = Content.redactForNoAccess({ id: 1, type: 'video', url: '/uploads/videos/x.mp4', description: 'Intro', description_en: 'Intro (en)' });
  assert.equal(video.description_en, 'Intro (en)');
});
