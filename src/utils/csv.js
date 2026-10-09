/**
 * Parser de CSV minimalista: soporta campos entre comillas dobles (para
 * nombres con coma, ej. "Pérez, Juan") y comillas escapadas (""), además
 * de CRLF/LF. No se agrega una librería externa para esto — el caso real
 * es solo nombre+email exportados de Excel/Google Sheets. `delimiter` es
 * `,` o `;` (ver detectDelimiter) — Excel en configuración regional es-CR/
 * es-ES exporta con `;` porque la coma ahí es el separador decimal.
 */
function parseCsvLine(line, delimiter) {
  const fields = [];
  let current = '';
  let inQuotes = false;

  for (let i = 0; i < line.length; i++) {
    const char = line[i];
    if (inQuotes) {
      if (char === '"') {
        if (line[i + 1] === '"') {
          current += '"';
          i++;
        } else {
          inQuotes = false;
        }
      } else {
        current += char;
      }
    } else if (char === '"') {
      inQuotes = true;
    } else if (char === delimiter) {
      fields.push(current);
      current = '';
    } else {
      current += char;
    }
  }
  fields.push(current);
  return fields.map((f) => f.trim());
}

/**
 * Decide si el archivo usa `,` o `;` mirando solo el encabezado (fuera de
 * comillas): el que aparezca más veces ahí es el separador real. Antes se
 * asumía siempre `,`, así que un CSV exportado por Excel en es-CR/es-ES
 * (que usa `;` porque `,` es el separador decimal regional) quedaba como
 * una sola columna gigante por fila, y `bulkImportUsers` respondía
 * "faltan las columnas nombre/email" sin ninguna pista de por qué.
 */
function detectDelimiter(headerLine) {
  const outsideQuotes = headerLine.replace(/"[^"]*"/g, '');
  const commas = (outsideQuotes.match(/,/g) || []).length;
  const semicolons = (outsideQuotes.match(/;/g) || []).length;
  return semicolons > commas ? ';' : ',';
}

/**
 * Convierte el texto crudo del CSV en `{ headers, rows }` — `headers` en
 * minúsculas (para que el llamador busque la columna sin preocuparse por
 * mayúsculas), `rows` como array de objetos `{ [header]: valor }`.
 */
export function parseCsv(text) {
  const lines = text.split(/\r\n|\r|\n/).filter((l) => l.trim() !== '');
  if (lines.length === 0) return { headers: [], rows: [] };

  const delimiter = detectDelimiter(lines[0]);
  const headers = parseCsvLine(lines[0], delimiter).map((h) => h.toLowerCase());
  const rows = lines.slice(1).map((line) => {
    const values = parseCsvLine(line, delimiter);
    const row = {};
    headers.forEach((h, i) => {
      row[h] = values[i] !== undefined ? values[i] : '';
    });
    return row;
  });

  return { headers, rows };
}

/**
 * Arma un CSV a partir de encabezados + filas (arrays de valores, en el
 * mismo orden que `headers`) — usado para las exportaciones de notas. Un
 * campo se envuelve en comillas solo si de verdad lo necesita (contiene
 * coma, comilla, o salto de línea), igual que hace Excel al exportar.
 */
export function toCsv(headers, rows) {
  const escapeField = (value) => {
    let str = value === null || value === undefined ? '' : String(value);
    // Inyección de fórmulas CSV (CWE-1236): un valor que empieza con
    // =, +, -, @ (o tab/CR) puede interpretarse como fórmula al abrir el
    // CSV en Excel/Sheets — le antepone un apóstrofe para forzarlo a texto
    // plano, igual que recomienda OWASP. `name` en el registro de
    // usuarios no restringe su formato, así que este es el único punto
    // real de defensa antes de exportar notas a un archivo que alguien
    // abre en una planilla.
    if (/^[=+\-@\t\r]/.test(str)) str = `'${str}`;
    if (/[",\r\n]/.test(str)) return `"${str.replace(/"/g, '""')}"`;
    return str;
  };

  const lines = [headers.map(escapeField).join(',')];
  for (const row of rows) {
    lines.push(row.map(escapeField).join(','));
  }
  return lines.join('\r\n');
}

/**
 * Responde con un CSV descargable — mismo Content-Type/Content-Disposition/
 * BOM (para que Excel detecte UTF-8 y no rompa los acentos) en las dos
 * exportaciones de notas de course.controller.js.
 */
export function sendCsv(res, filename, csv) {
  res.setHeader('Content-Type', 'text/csv; charset=utf-8');
  res.setHeader('Content-Disposition', `attachment; filename="${filename}"`);
  res.send('﻿' + csv);
}
