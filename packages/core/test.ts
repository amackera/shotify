import { renderHtml, renderPng } from './dist/index.js';

const code = `function greet(name: string): string {
  return \`Hello, \${name}!\`;
}

console.log(greet("World"));`;

async function test() {
  console.log('Testing renderHtml...');
  const html = await renderHtml(code, {
    lang: 'typescript',
    theme: 'github-dark',
    title: 'greet.ts',
    showLineNumbers: true,
  });
  console.log(`✓ Generated HTML (${html.length} chars)`);

  console.log('\nTesting renderPng...');
  const { outPath } = await renderPng(code, {
    lang: 'typescript',
    theme: 'github-dark',
    title: 'greet.ts',
    showLineNumbers: true,
    out: './test-screenshot.png',
  });
  console.log(`✓ Generated PNG: ${outPath}`);
}

test().catch(console.error);
