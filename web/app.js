import {drawCurve} from "./renderer.mjs";

const $ = id => document.getElementById(id);
const groups = {
  flowersAndOrbits: ["花瓣与轨道", "Flowers & Orbits"], rollingAndCusps: ["滚线与尖点", "Rolling Curves & Cusps"],
  spiralsAndGrowth: ["螺旋与生长", "Spirals & Growth"], tracesAndOutlines: ["轨迹与轮廓", "Traces & Outlines"],
  physicsAndMotion: ["物理与运动", "Physics & Motion"], horizontal: ["横向", "Horizontal"], vertical: ["竖向", "Vertical"]
};
const controls = [
  ["particleCount", "粒子数量", "Particles", 24, 140, 1], ["trail", "拖尾长度", "Trail", .12, .68, .01],
  ["loopDuration", "运动周期", "Loop duration", 2.4, 12, .1], ["pulseDuration", "呼吸周期", "Pulse duration", 1.8, 10, .1],
  ["rotationDuration", "旋转周期", "Rotation duration", 6, 60, 1], ["strokeWidth", "线条粗细", "Stroke width", 2.5, 7.5, .1]
];
let language = "zh";
try { language = localStorage.getItem("curve-language") === "en" ? "en" : "zh"; } catch {}
let manifest, selected, parameters, filter = "all", playing = true, elapsed = 0, dirty = true;
const reducedMotion = matchMedia("(prefers-reduced-motion: reduce)");
const dataCache = new Map(), visible = new Map();
const text = (zh, en) => language === "zh" ? zh : en;
const title = curve => text(curve.zhTitle, curve.title);
const groupTitle = group => text(...groups[group]);

async function loadData(curve) {
  if (!dataCache.has(curve.id)) {
    const promise = fetch(new URL(`./data/${curve.id}.bin`, import.meta.url)).then(async response => {
      if (!response.ok) throw new Error(`HTTP ${response.status}`);
      const buffer = await response.arrayBuffer();
      if (buffer.byteLength !== manifest.frames * curve.points * 2 * 4) throw new Error("Invalid curve data");
      return new Float32Array(buffer);
    }).catch(error => { dataCache.delete(curve.id); throw error; });
    dataCache.set(curve.id, promise);
  }
  return dataCache.get(curve.id);
}
const observer = new IntersectionObserver(entries => {
  for (const entry of entries) {
    const item = entry.target.curveItem;
    if (entry.isIntersecting) {
      visible.set(entry.target, item);
      if (!item.loading && !item.data) {
        item.loading = true;
        loadData(item.curve).then(data => { item.data = data; dirty = true; }).catch(() => {
          const message = document.createElement("span"); message.className = "load-error";
          message.textContent = text("加载失败，点击重试", "Load failed. Select to retry.");
          if (entry.target.isConnected) entry.target.parentElement.append(message);
        }).finally(() => { item.loading = false; });
      }
    } else visible.delete(entry.target);
  }
}, {rootMargin: "120px"});

function makeControls() {
  $("sliders").replaceChildren();
  for (const [key, zh, en, min, max, step] of controls) {
    const label = document.createElement("label"); label.className = "control";
    const head = document.createElement("span"); head.className = "control-head";
    const caption = document.createElement("span"); caption.textContent = text(zh, en);
    const output = document.createElement("output"); output.textContent = parameters[key];
    const input = document.createElement("input"); input.type = "range"; input.min = min; input.max = max; input.step = step;
    input.value = parameters[key]; input.id = `control-${key}`; output.htmlFor = input.id;
    input.disabled = key === "rotationDuration" && !selected.rotates;
    input.addEventListener("input", () => { parameters[key] = Number(input.value); output.textContent = input.value; dirty = true; });
    head.append(caption, output); label.append(head, input); $("sliders").append(label);
  }
}

async function selectCurve(curve, updateURL = true) {
  selected = curve; parameters = {...curve.parameters}; elapsed = 0;
  $("preview").curveData = null; $("preview-status").textContent = text("正在加载…", "Loading…");
  if (updateURL) history.replaceState(null, "", `#${curve.id}`);
  updateDetail(); makeControls();
  for (const card of document.querySelectorAll(".curve-card")) card.setAttribute("aria-pressed", String(card.dataset.id === curve.id));
  try {
    const data = await loadData(curve);
    if (selected.id !== curve.id) return;
    $("preview").curveData = data; $("preview-status").textContent = ""; dirty = true;
  } catch {
    if (selected.id !== curve.id) return;
    const button = document.createElement("button"); button.textContent = text("加载失败，重试", "Load failed. Retry");
    button.addEventListener("click", () => selectCurve(curve, false)); $("preview-status").replaceChildren(button);
  }
}
function updateDetail() {
  if (!selected) return;
  $("curve-title").textContent = title(selected);
  $("curve-summary").textContent = text(selected.zhSummary, selected.summary);
  $("curve-equation").textContent = selected.equation;
  $("shape-type").textContent = groupTitle(selected.group);
  $("preview").setAttribute("aria-label", title(selected));
  $("pause").textContent = playing ? text("暂停", "Pause") : text("播放", "Play");
  $("pause").setAttribute("aria-pressed", String(!playing));
}
function renderGallery() {
  if (!manifest) return;
  observer.disconnect(); visible.clear(); $("gallery").replaceChildren();
  const query = $("search").value.trim().toLocaleLowerCase();
  const matches = manifest.curves.filter(curve => (filter === "all" || (filter === "square" ? curve.ratio === 1 : curve.group === filter)) &&
    [curve.id, curve.title, curve.zhTitle, curve.summary, curve.zhSummary, curve.equation].some(value => value.toLocaleLowerCase().includes(query)));
  for (const group of Object.keys(groups)) {
    const curves = matches.filter(curve => curve.group === group);
    if (!curves.length) continue;
    const section = document.createElement("section"); section.className = "curve-group";
    const heading = document.createElement("h3"); heading.textContent = groupTitle(group);
    const grid = document.createElement("div"); grid.className = "curve-grid";
    for (const curve of curves) {
      const card = document.createElement("button"); card.className = "curve-card"; card.dataset.id = curve.id;
      card.setAttribute("aria-pressed", String(selected?.id === curve.id));
      card.addEventListener("click", () => { selectCurve(curve); $("preview-stage").scrollIntoView({block: "center", behavior: reducedMotion.matches ? "instant" : "smooth"}); });
      const stage = document.createElement("span"); stage.className = "card-canvas";
      const canvas = document.createElement("canvas"); canvas.setAttribute("aria-hidden", "true"); canvas.curveItem = {curve};
      stage.append(canvas);
      const caption = document.createElement("span"); caption.className = "card-caption";
      const name = document.createElement("strong"); name.textContent = title(curve);
      const equation = document.createElement("small"); equation.textContent = curve.equation;
      caption.append(name, equation); card.append(stage, caption); grid.append(card); observer.observe(canvas);
    }
    section.append(heading, grid); $("gallery").append(section);
  }
  $("gallery-status").textContent = matches.length ? text(`${matches.length} 种曲线`, `${matches.length} curves`) : text("没有匹配的曲线", "No matching curves");
  dirty = true;
}
function localize() {
  document.documentElement.lang = language === "zh" ? "zh-CN" : "en";
  for (const element of document.querySelectorAll("[data-en]")) element.textContent = element.dataset[language];
  $("language").textContent = language === "zh" ? "🌐 EN" : "🌐 中文";
  $("search").placeholder = text("名称、公式", "Name, formula");
  $("copy-status").textContent = "";
  $("filters").replaceChildren();
  for (const [key, zh, en] of [["all", "全部", "All"], ["square", "方形", "Square"], ["horizontal", "横向", "Horizontal"], ["vertical", "竖向", "Vertical"]]) {
    const button = document.createElement("button"); button.textContent = text(zh, en);
    button.setAttribute("aria-pressed", String(filter === key));
    button.addEventListener("click", () => { filter = key; localize(); }); $("filters").append(button);
  }
  if (manifest) { updateDetail(); makeControls(); renderGallery(); }
}
$("language").addEventListener("click", () => {
  language = language === "zh" ? "en" : "zh";
  try { localStorage.setItem("curve-language", language); } catch {} localize();
});
$("search").addEventListener("input", renderGallery);
$("pause").addEventListener("click", () => { playing = !playing; updateDetail(); dirty = true; });
$("reset").addEventListener("click", () => { if (!selected) return; parameters = {...selected.parameters}; makeControls(); dirty = true; });
$("copy").addEventListener("click", async () => {
  if (!selected) return;
  const p = parameters;
  const code = `import CurveCore\nimport SwiftUI\n\nif let curve = CurveCatalog.definition(for: .${selected.id}) {\n    CurveAnimationView(\n        definition: curve,\n        parameters: .init(particleCount: ${p.particleCount}, trail: ${p.trail},\n                          loopDuration: ${p.loopDuration}, pulseDuration: ${p.pulseDuration},\n                          rotationDuration: ${p.rotationDuration}, strokeWidth: ${p.strokeWidth})\n    ).aspectRatio(curve.aspectRatio, contentMode: .fit)\n}`;
  try { await navigator.clipboard.writeText(code); $("copy-status").textContent = text("已复制", "Copied"); }
  catch { $("copy-status").textContent = text("无法访问剪贴板，请使用 HTTPS 打开页面", "Clipboard unavailable. Open this page over HTTPS."); }
});
addEventListener("resize", () => { dirty = true; }); reducedMotion.addEventListener("change", () => { dirty = true; });
let last = 0, thumbnailsAt = 0;
function animate(now) {
  const active = playing && !reducedMotion.matches && !document.hidden;
  if (active && last) elapsed += Math.min((now - last) / 1000, .1);
  last = now;
  if (!document.hidden && (active || dirty) && selected) {
    const time = reducedMotion.matches ? 0 : elapsed;
    if ($("preview").curveData) drawCurve($("preview"), selected, $("preview").curveData, manifest, parameters, time);
    if (dirty || now - thumbnailsAt > 33) {
      for (const [canvas, item] of visible) if (item.data) drawCurve(canvas, item.curve, item.data, manifest, item.curve.parameters, time);
      thumbnailsAt = now;
    }
    dirty = false;
  }
  requestAnimationFrame(animate);
}
async function start() {
  try {
    const response = await fetch("./data/catalog.json"); if (!response.ok) throw new Error(`HTTP ${response.status}`);
    manifest = await response.json();
    const curve = manifest.curves.find(item => item.id === location.hash.slice(1)) || manifest.curves[0];
    await selectCurve(curve, false); localize(); requestAnimationFrame(animate);
  } catch {
    const button = document.createElement("button"); button.textContent = text("加载失败，重试", "Load failed. Retry");
    button.addEventListener("click", start); $("gallery-status").replaceChildren(button);
  }
}
fetch("./site.json").then(response => response.ok ? response.json() : null).then(site => {
  if (site?.repository) { $("repository").href = site.repository; $("repository").hidden = false; }
}).catch(() => {});
localize(); start();
