#!/usr/bin/env bash
set -euo pipefail

# Usage:
#   ./scripts/export-vetorial-full.sh [input_html] [output_pdf]
# Examples:
#   ./scripts/export-vetorial-full.sh
#   ./scripts/export-vetorial-full.sh /root/projects/baruckdata/perfilflexdata02.html
#   ./scripts/export-vetorial-full.sh /root/projects/baruckdata/perfilflexdata02.html /root/projects/baruckdata/perfilflexdata02-vetorial-corrigido.pdf

input_html="${1:-/root/projects/baruckdata/perfilflexdata02.html}"
output_pdf="${2:-}"

if [[ ! -f "$input_html" ]]; then
  echo "Erro: arquivo HTML nao encontrado: $input_html" >&2
  exit 1
fi

input_html_abs="$(realpath "$input_html")"

if [[ -z "$output_pdf" ]]; then
  base_name="$(basename "$input_html_abs" .html)"
  output_pdf="$(dirname "$input_html_abs")/${base_name}-vetorial-full.pdf"
fi

output_pdf_abs="$(realpath -m "$output_pdf")"

runtime_dir="/tmp/pwpdf"
mkdir -p "$runtime_dir"

if [[ ! -d "$runtime_dir/node_modules/playwright" ]]; then
  echo "Instalando Playwright em $runtime_dir (primeira execucao)..."
  pushd "$runtime_dir" >/dev/null
  if [[ ! -f package.json ]]; then
    npm init -y >/dev/null 2>&1
  fi
  npm install playwright >/dev/null 2>&1
  popd >/dev/null
fi

cat > "$runtime_dir/export-vetorial-full.js" <<'NODE'
const { chromium } = require('playwright');
const fs = require('fs');

(async () => {
  const inputHtml = process.env.INPUT_HTML;
  const outputPdf = process.env.OUTPUT_PDF;

  if (!inputHtml || !outputPdf) {
    throw new Error('INPUT_HTML e OUTPUT_PDF sao obrigatorios.');
  }

  const inputUrl = `file://${inputHtml}`;

  const browser = await chromium.launch({ headless: true });
  const page = await browser.newPage({ viewport: { width: 1300, height: 900 } });

  await page.goto(inputUrl, { waitUntil: 'networkidle' });
  await page.waitForTimeout(300);

  // Forca pagina em pe para evitar saida deitada por regras @page preexistentes.
  await page.addStyleTag({ content: '@page { size: portrait !important; margin: 0 !important; }' });

  const doc = await page.evaluate(() => {
    const d = document.documentElement;
    const b = document.body;
    return {
      width: Math.max(d.scrollWidth, d.offsetWidth, b ? b.scrollWidth : 0),
      height: Math.max(d.scrollHeight, d.offsetHeight, b ? b.scrollHeight : 0),
    };
  });

  const MAX_PX = 19000;

  // Compensa inversao de orientacao em alguns cenarios de print CSS.
  const width = Math.min(doc.height, MAX_PX);
  const height = Math.min(doc.width, MAX_PX);

  await page.pdf({
    path: outputPdf,
    width: `${width}px`,
    height: `${height}px`,
    printBackground: true,
    margin: { top: '0px', right: '0px', bottom: '0px', left: '0px' },
    pageRanges: '1',
    preferCSSPageSize: false,
  });

  await browser.close();

  console.log(`PDF gerado: ${outputPdf}`);
  console.log(`Conteudo medido: ${doc.width}x${doc.height}px`);
  console.log(`Pagina final (1 pagina): ${width}x${height}px`);

  if (fs.existsSync('/usr/bin/pdftocairo') || fs.existsSync('/bin/pdftocairo')) {
    console.log('Dica: para SVG editavel, rode:');
    console.log(`pdftocairo -svg "${outputPdf}" "${outputPdf.replace(/\.pdf$/i, '.svg')}"`);
  }
})();
NODE

pushd "$runtime_dir" >/dev/null
INPUT_HTML="$input_html_abs" OUTPUT_PDF="$output_pdf_abs" node export-vetorial-full.js
popd >/dev/null

echo "Concluido: $output_pdf_abs"
