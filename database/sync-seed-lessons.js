/* Synchronize the Vietnamese lesson text in the SQL seed through the UTF-8 API.
   Run after importing sample_data.sql and starting the backend. */
const fs = require('node:fs');

const api = process.env.MATH10_API_BASE_URL || 'http://127.0.0.1:8080/api/v1';
const username = process.env.BOOTSTRAP_ADMIN_USERNAME;
const password = process.env.BOOTSTRAP_ADMIN_PASSWORD;
if (!username || !password) throw new Error('Set BOOTSTRAP_ADMIN_USERNAME and BOOTSTRAP_ADMIN_PASSWORD first.');

const source = fs.readFileSync('database/sample_data.sql', 'utf8');
const start = source.indexOf('INSERT @CatalogLessons');
const end = source.indexOf('\n    UPDATE l', start);
if (start < 0 || end < 0) throw new Error('Cannot locate lesson catalog in database/sample_data.sql.');

function readLiteral(line, at) {
  while (/\s/.test(line[at] || '')) at++;
  if (line.slice(at, at + 2) !== "N'") throw new Error(`Expected SQL text literal at offset ${at}.`);
  at += 2;
  let value = '';
  while (at < line.length) {
    if (line[at] === "'" && line[at + 1] === "'") { value += "'"; at += 2; continue; }
    if (line[at] === "'") return [value, at + 1];
    value += line[at++];
  }
  throw new Error('Unclosed SQL text literal.');
}

function parseRow(line) {
  let at = line.indexOf('(') + 1;
  const [topic, afterTopic] = readLiteral(line, at); at = afterTopic;
  at = line.indexOf(',', at) + 1;
  const [title, afterTitle] = readLiteral(line, at); at = afterTitle;
  at = line.indexOf(',', at) + 1;
  const orderEnd = line.indexOf(',', at);
  const order = Number(line.slice(at, orderEnd).trim()); at = orderEnd + 1;
  const [description, afterDescription] = readLiteral(line, at); at = afterDescription;
  at = line.indexOf(',', at) + 1;
  const expression = line.slice(at, line.lastIndexOf('),')).trim();
  let content = '';
  for (let i = 0; i < expression.length;) {
    if (expression.startsWith('NCHAR(10)', i)) { content += '\n'; i += 9; continue; }
    if (expression.startsWith("N'", i)) {
      const [part, next] = readLiteral(expression, i);
      content += part;
      i = next;
      continue;
    }
    i++;
  }
  return {topic, title, order, description, content};
}

async function main() {
  const login = await fetch(`${api}/auth/login`, {
    method: 'POST', headers: {'content-type':'application/json'},
    body: JSON.stringify({username, password})
  });
  if (!login.ok) throw new Error(`Admin login failed (${login.status}).`);
  const cookie = (login.headers.get('set-cookie') || '').split(';', 1)[0];
  if (!cookie) throw new Error('No session cookie returned by the backend.');

  const managedResponse = await fetch(`${api}/manage/lessons`, {headers:{cookie}});
  if (!managedResponse.ok) throw new Error(`Could not read managed lessons (${managedResponse.status}).`);
  const managed = await managedResponse.json();
  const rows = source.slice(start, end).split(/\r?\n/)
    .filter(line => /^\s*\(N'Ch/.test(line)).map(parseRow);
  if (rows.length !== 27) throw new Error(`Expected 27 lessons in seed, found ${rows.length}.`);

  for (const row of rows) {
    const lesson = managed.find(item => item.title === row.title);
    if (!lesson) throw new Error(`Lesson not found in database: ${row.title}.`);
    const response = await fetch(`${api}/lessons/${lesson.id}`, {
      method: 'PUT', headers: {cookie, 'content-type':'application/json; charset=utf-8'},
      body: JSON.stringify({topicId:lesson.topicId,title:row.title,description:row.description,content:row.content,
        videoUrl:lesson.videoUrl,resourceUrl:lesson.resourceUrl,order:row.order,status:'PUBLISHED'})
    });
    if (!response.ok) throw new Error(`Could not sync ${row.title} (${response.status}).`);
  }

  const publicLessons = await (await fetch(`${api}/lessons`)).json();
  const corrupted = publicLessons.filter(item => (item.content || '').includes('?'));
  await fetch(`${api}/auth/logout`, {method:'POST',headers:{cookie}});
  if (corrupted.length) throw new Error(`${corrupted.length} lessons still contain question-mark replacement characters.`);
  console.log(`Synced UTF-8 lesson content: ${rows.length} lessons.`);
}

main().catch(error => { console.error(error.message); process.exitCode = 1; });
