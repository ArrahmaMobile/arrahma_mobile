const assert = require('node:assert/strict');
const test = require('node:test');
const { HttpClient } = require('../dist/core/http-client');

test('navigation reuses recent parsed documents and releases older pages', async () => {
  const client = new HttpClient();
  const downloads = [];
  client.download = async (url) => {
    downloads.push(url);
    return '<h1>Course</h1>';
  };
  const visit = (id) => client.navigateTo(`https://arrahmah.org/courses/${id}`);

  const first = await visit(1);
  const second = await visit(2);
  for (let id = 3; id <= 8; id++) await visit(id);
  assert.equal(await visit(1), first);
  await visit(9);
  assert.equal(client.getCacheSize(), 8);
  assert.equal(await visit(1), first);
  assert.notEqual(await visit(2), second);
  assert.equal(downloads.length, 10);
});
