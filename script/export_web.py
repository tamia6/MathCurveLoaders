#!/usr/bin/env python3
"""Regenerate browser assets from the canonical Swift package and gallery groups."""
import json
import pathlib
import re
import subprocess

root = pathlib.Path(__file__).resolve().parents[1]
destination = root / "web" / "data"
subprocess.run(["swift", "run", "--package-path", str(root / "CurveCore"),
                "CurveWebExport", str(destination)], check=True)
source = (root / "App/CurveGalleryView.swift").read_text()
groups = {}
for cases, group in re.findall(r"case (.*?):\s*return \.(\w+)", source, re.S):
    for curve in re.findall(r"\.(\w+)", cases):
        groups[curve] = group
manifest_path = destination / "catalog.json"
manifest = json.loads(manifest_path.read_text())
for curve in manifest["curves"]:
    curve["group"] = groups[curve["id"]] if curve["ratio"] == 1 else (
        "horizontal" if curve["ratio"] > 1 else "vertical")
manifest_path.write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + "\n")
