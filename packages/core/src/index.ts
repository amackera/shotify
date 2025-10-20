import { codeToHtml, BundledLanguage, BundledTheme } from 'shiki';
import puppeteer from 'puppeteer';
import { writeFile, mkdir } from 'fs/promises';
import { dirname, resolve } from 'path';

export type RenderOptions = {
  lang: string;
  theme?: string;
  title?: string;
  showLineNumbers?: boolean;
  startLine?: number;
  width?: number;
  padding?: string;
  background?: string;
  scale?: number;
};

export async function renderHtml(code: string, opts: RenderOptions): Promise<string> {
  const {
    lang,
    theme = 'github-dark',
    title,
    showLineNumbers = true,
    startLine = 1,
    width = 800,
    padding = '2rem',
    background = '#1e1e1e',
  } = opts;

  // Generate syntax highlighted HTML using Shiki
  const highlightedCode = await codeToHtml(code, {
    lang: lang as BundledLanguage,
    theme: theme as BundledTheme,
  });

  // Build the complete HTML with styling
  const html = `
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <style>
    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
    }
    body {
      background: ${background};
      padding: ${padding};
      display: flex;
      justify-content: center;
      align-items: center;
      min-height: 100vh;
    }
    .screenshot-container {
      background: transparent;
      border-radius: 8px;
      overflow: hidden;
      box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
      max-width: ${width}px;
    }
    ${title ? `
    .title-bar {
      background: #2d2d2d;
      padding: 12px 16px;
      font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
      font-size: 13px;
      color: #ccc;
      border-bottom: 1px solid #1a1a1a;
    }
    ` : ''}
    .code-wrapper {
      position: relative;
    }
    pre {
      margin: 0 !important;
      padding: 1.5rem !important;
      overflow-x: auto;
    }
    ${showLineNumbers ? `
    code {
      counter-reset: line ${startLine - 1};
    }
    code .line::before {
      counter-increment: line;
      content: counter(line);
      display: inline-block;
      width: 2.5rem;
      margin-right: 1.5rem;
      text-align: right;
      color: #6e7681;
    }
    ` : ''}
  </style>
</head>
<body>
  <div class="screenshot-container">
    ${title ? `<div class="title-bar">${escapeHtml(title)}</div>` : ''}
    <div class="code-wrapper">
      ${highlightedCode}
    </div>
  </div>
</body>
</html>
  `.trim();

  return html;
}

export async function renderPng(
  code: string,
  opts: RenderOptions & { out?: string }
): Promise<{ outPath: string }> {
  const { out, ...renderOpts } = opts;

  // Generate HTML
  const html = await renderHtml(code, renderOpts);

  // Determine output path
  const theme = renderOpts.theme || 'github-dark';
  const outPath = out || resolve(process.cwd(), `screenshot-${theme}-${Date.now()}.png`);
  await mkdir(dirname(outPath), { recursive: true });

  // Launch headless browser and render
  const browser = await puppeteer.launch({
    headless: true,
    args: ['--no-sandbox', '--disable-setuid-sandbox'],
  });

  try {
    const page = await browser.newPage();

    // Set viewport with high DPI for crisp screenshots
    const scale = renderOpts.scale || 2;
    await page.setViewport({
      width: 1920,
      height: 1080,
      deviceScaleFactor: scale,
    });

    await page.setContent(html);

    // Wait for fonts and styles to load
    await page.evaluateHandle('document.fonts.ready');

    // Get the dimensions of the screenshot container
    const element = await page.$('.screenshot-container');
    if (!element) {
      throw new Error('Failed to find screenshot container');
    }

    // Take screenshot of just the container
    const screenshot = await element.screenshot({
      type: 'png',
      omitBackground: true,
    });

    await writeFile(outPath, screenshot);

    return { outPath };
  } finally {
    await browser.close();
  }
}

function escapeHtml(text: string): string {
  const map: Record<string, string> = {
    '&': '&amp;',
    '<': '&lt;',
    '>': '&gt;',
    '"': '&quot;',
    "'": '&#039;',
  };
  return text.replace(/[&<>"']/g, (m) => map[m]);
}
