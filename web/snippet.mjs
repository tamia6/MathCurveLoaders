import {drawCurve, pointAt} from "./renderer.mjs";

// Embed the canonical samples and the same renderer used by the live preview.
export function htmlSnippet(curve, data, manifest, parameters, label) {
  const bytes = new Uint8Array(data.buffer, data.byteOffset, data.byteLength);
  let binary = "";
  for (let i = 0; i < bytes.length; i += 8192) binary += String.fromCharCode(...bytes.subarray(i, i + 8192));
  const json = value => JSON.stringify(value).replaceAll("<", "\\u003c");
  const escape = value => value.replaceAll("&", "&amp;").replaceAll('"', "&quot;").replaceAll("<", "&lt;");
  const width = curve.ratio >= 1 ? 240 : Math.round(240 * curve.ratio);
  const height = Math.round(width / curve.ratio);
  return `<!-- Math Curve Loaders · MIT · https://github.com/tamia6/MathCurveLoaders -->
<canvas role="img" aria-label="${escape(label)}" style="display:block;width:${width}px;height:${height}px;max-width:100%;background:#111113;border-radius:16px"></canvas>
<script>
(() => {
  const canvas = document.currentScript.previousElementSibling;
  const curve = ${json({id: curve.id, ratio: curve.ratio, points: curve.points, rotates: curve.rotates, parameters: curve.parameters})};
  const manifest = ${json({frames: manifest.frames, points: manifest.points})};
  const parameters = ${json(parameters)};
  const binary = atob("${btoa(binary)}");
  const bytes = Uint8Array.from(binary, character => character.charCodeAt(0));
  const data = new Float32Array(bytes.buffer);
  ${pointAt.toString()}
  ${drawCurve.toString()}
  const reducedMotion = matchMedia("(prefers-reduced-motion: reduce)");
  let elapsed = 0, last = 0;
  function animate(now) {
    if (!canvas.isConnected) return;
    if (last && !document.hidden && !reducedMotion.matches) elapsed += Math.min((now - last) / 1000, .1);
    last = now;
    if (!document.hidden) drawCurve(canvas, curve, data, manifest, parameters, reducedMotion.matches ? 0 : elapsed);
    requestAnimationFrame(animate);
  }
  requestAnimationFrame(animate);
})();
</script>`;
}
