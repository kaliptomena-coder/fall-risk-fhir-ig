#!/bin/bash
# ══════════════════════════════════════════════════════════════
#  Fall Risk IG — Build & Publish Script
#  Usage: ./build.sh [--publish]
#  --publish  also copies output to docs/ and prompts for git push
# ══════════════════════════════════════════════════════════════

set -e  # Stop on any error

PUBLISHER="input-cache/publisher.jar"
PUBLISHER_URL="https://github.com/HL7/fhir-ig-publisher/releases/latest/download/publisher.jar"

echo ""
echo "╔══════════════════════════════════════════╗"
echo "║    Fall Risk IG — Build Script           ║"
echo "╚══════════════════════════════════════════╝"
echo ""

# ── Step 0: Download publisher if missing ──────────────────────
if [ ! -f "$PUBLISHER" ]; then
  echo "📥 Downloading IG Publisher..."
  mkdir -p input-cache
  curl -L "$PUBLISHER_URL" -o "$PUBLISHER"
  echo "✅ Publisher downloaded."
fi

# ── Step 1: Run SUSHI ─────────────────────────────────────────
echo ""
echo "🔨 Step 1/3: Running SUSHI (FSH → FHIR)..."
sushi .
echo "✅ SUSHI complete."

# ── Step 2: Run IG Publisher ──────────────────────────────────
echo ""
echo "📚 Step 2/3: Running IG Publisher..."
java -jar "$PUBLISHER" -ig ig.ini
echo "✅ IG Publisher complete."

# ── Step 3: Open QA report ────────────────────────────────────
echo ""
echo "🔍 Step 3/3: Opening QA report..."
if [ -f "output/qa.html" ]; then
  open output/qa.html 2>/dev/null || xdg-open output/qa.html 2>/dev/null || echo "   Open output/qa.html manually to check for errors."
fi

# ── Optional: Publish to docs/ ────────────────────────────────
if [ "$1" == "--publish" ]; then
  echo ""
  echo "🚀 Copying output to docs/ for GitHub Pages..."
  rm -rf docs
  cp -r output docs
  touch docs/.nojekyll
  echo "✅ docs/ updated."
  echo ""
  echo "Run the following to push to GitHub:"
  echo ""
  echo "  git add docs/"
  echo "  git commit -m 'Publish IG update'"
  echo "  git push"
  echo ""
fi

echo ""
echo "════════════════════════════════════════════"
echo "  Build complete!"
echo "  → Open output/index.html to preview"
echo "  → Run with --publish to update GitHub Pages"
echo "════════════════════════════════════════════"
echo ""
