export function pointAt(data, frames, points, shapePhase, progress) {
  const frame = ((shapePhase % 1 + 1) % 1) * frames;
  const f0 = Math.floor(frame), f1 = (f0 + 1) % frames, mix = frame - f0;
  const position = Math.min(Math.max(progress, 0) * points, points - 1);
  const p0 = Math.floor(position), p1 = Math.min(p0 + 1, points - 1), fraction = position - p0;
  return [0, 1].map(axis => {
    const a = data[(f0 * points + p0) * 2 + axis];
    const b = data[(f0 * points + p1) * 2 + axis];
    const c = data[(f1 * points + p0) * 2 + axis];
    const d = data[(f1 * points + p1) * 2 + axis];
    return (a + (b - a) * fraction) * (1 - mix) + (c + (d - c) * fraction) * mix;
  });
}

export function drawCurve(canvas, curve, data, manifest, parameters, elapsed) {
  const box = canvas.getBoundingClientRect();
  if (!box.width || !box.height) return;
  const dpr = Math.min(globalThis.devicePixelRatio || 1, 3);
  const width = Math.round(box.width * dpr), height = Math.round(box.height * dpr);
  if (canvas.width !== width || canvas.height !== height) { canvas.width = width; canvas.height = height; }
  const context = canvas.getContext("2d");
  context.setTransform(dpr, 0, 0, dpr, 0, 0);
  context.clearRect(0, 0, box.width, box.height);
  let w = box.width * 0.92, h = w / curve.ratio;
  if (h > box.height * 0.92) { h = box.height * 0.92; w = h * curve.ratio; }
  const scale = Math.min(w, h) / 100;
  const points = curve.points || manifest.points;
  const integrated = curve.id === "doublePendulum" || curve.id === "lorenzAttractor";
  const angle = curve.rotates ? -2 * Math.PI * elapsed / parameters.rotationDuration : 0;
  const cosine = Math.cos(angle), sine = Math.sin(angle);
  const at = progress => {
    const [x, y] = pointAt(data, manifest.frames, points, elapsed / parameters.pulseDuration, progress);
    return [box.width / 2 + (x * cosine - y * sine) * w / 2,
            box.height / 2 + (x * sine + y * cosine) * h / 2];
  };
  context.lineCap = "round"; context.lineJoin = "round";
  context.beginPath();
  for (let i = 0; i < points; i++) {
    const [x, y] = at(i / points);
    if (i === 0) context.moveTo(x, y); else context.lineTo(x, y);
  }
  context.strokeStyle = "rgba(255,255,255,.12)";
  context.lineWidth = parameters.strokeWidth * scale * (integrated ? .35 : 1);
  context.stroke();
  const head = (elapsed / parameters.loopDuration) % 1;
  if (integrated) {
    context.beginPath(); let previous = -1;
    for (let i = 0; i <= 560; i++) {
      const phase = head - parameters.trail + parameters.trail * i / 560;
      const wrapped = phase - Math.floor(phase), [x, y] = at(wrapped);
      if (i === 0 || wrapped < previous) context.moveTo(x, y); else context.lineTo(x, y);
      previous = wrapped;
    }
    context.strokeStyle = "rgba(255,255,255,.8)"; context.lineWidth = parameters.strokeWidth * scale * .5; context.stroke();
  }
  // Densify the circle trail so adjacent particles overlap at large preview sizes.
  const trailSamples = Math.max(192, parameters.particleCount * 3);
  for (let i = trailSamples - 1; i >= 0; i--) {
    const offset = i / (trailSamples - 1);
    const progress = head - offset * parameters.trail;
    const [x, y] = at(progress - Math.floor(progress));
    const fade = (1 - offset) ** 0.56;
    const radius = integrated ? (.15 + fade * .4) * parameters.strokeWidth * scale * .5
      : (0.9 + fade * 2.7) * scale * 1.35 * parameters.strokeWidth / curve.parameters.strokeWidth;
    context.beginPath(); context.arc(x, y, radius, 0, 2 * Math.PI);
    context.fillStyle = `rgba(255,255,255,${0.04 + fade * 0.96})`; context.fill();
  }
}
