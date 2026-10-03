import assert from "node:assert/strict";
import {readFile} from "node:fs/promises";
import {pointAt} from "./renderer.mjs";

const catalog = JSON.parse(await readFile(new URL("./data/catalog.json", import.meta.url)));
assert.equal(catalog.curves.length, 91);
assert.equal(new Set(catalog.curves.map(curve => curve.id)).size, 91);
for (const curve of catalog.curves) {
  assert(curve.title && curve.zhTitle && curve.summary && curve.zhSummary && curve.group);
  const buffer = await readFile(new URL(`./data/${curve.id}.bin`, import.meta.url));
  assert.equal(buffer.byteLength, catalog.frames * curve.points * 2 * 4, curve.id);
  const data = new Float32Array(buffer.buffer, buffer.byteOffset, buffer.byteLength / 4);
  assert(data.every(Number.isFinite), curve.id);
  for (const phase of [0, .13, .99, 1]) {
    const point = pointAt(data, catalog.frames, curve.points, phase, .5);
    assert(point.every(Number.isFinite), curve.id);
  }
  assert.deepEqual(pointAt(data, catalog.frames, curve.points, 0, 0), [data[0], data[1]]);
  assert.deepEqual(pointAt(data, catalog.frames, curve.points, 1, 0), [data[0], data[1]]);
  if (curve.id === "roseOrbit") assert(Math.abs(data[0] - .3595252967009287) < 1e-6);
}
console.log(`Web data check passed: ${catalog.curves.length} bilingual curves, frame wrapping, and a native reference sample.`);
