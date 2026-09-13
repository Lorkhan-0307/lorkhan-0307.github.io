const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const vm = require('node:vm');
const test = require('node:test');

const source = fs.readFileSync(
  path.join(__dirname, '../_javascript/modules/components/toc.js'),
  'utf8'
).replace('export function toc', 'function toc');

test('a post with headings and TOC disabled does not require tocbot', () => {
  const document = {
    getElementById: () => null,
    querySelector: () => ({ tagName: 'H2' })
  };
  assert.doesNotThrow(() => vm.runInNewContext(`${source}\ntoc();`, { document }));
});

test('a post with TOC enabled initializes and reveals its navigation', () => {
  const removed = [];
  const calls = [];
  const document = {
    getElementById: () => ({ classList: { remove: (name) => removed.push(name) } }),
    querySelector: () => ({ tagName: 'H2' })
  };
  vm.runInNewContext(`${source}\ntoc();`, {
    document,
    tocbot: { init: (options) => calls.push(options) }
  });
  assert.equal(calls.length, 1);
  assert.equal(calls[0].tocSelector, '#toc');
  assert.deepEqual(removed, ['d-none']);
});
