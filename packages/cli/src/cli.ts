#!/usr/bin/env node
import { Command } from 'commander';
import { renderPng, RenderOptions } from '@shotify/core';
import { readFile } from 'fs/promises';
import { resolve } from 'path';

const program = new Command();

program
  .name('shotify')
  .description('Take beautiful screenshots of code')
  .version('0.1.0')
  .argument('[file]', 'File to screenshot (reads from stdin if omitted)')
  .option('-l, --lang <language>', 'Programming language for syntax highlighting', 'typescript')
  .option('-t, --theme <theme>', 'Color theme', 'github-dark')
  .option('--title <title>', 'Title to display in the screenshot')
  .option('--line-numbers', 'Show line numbers', true)
  .option('--no-line-numbers', 'Hide line numbers')
  .option('--start-line <number>', 'Starting line number', '1')
  .option('-w, --width <pixels>', 'Screenshot width in pixels', '800')
  .option('-p, --padding <value>', 'Padding around code', '2rem')
  .option('-b, --background <color>', 'Background color', '#1e1e1e')
  .option('-s, --scale <factor>', 'Resolution scale factor (1=normal, 2=retina, 3=ultra)', '2')
  .option('-o, --out <path>', 'Output file path')
  .action(async (file, options) => {
    try {
      let code: string;

      if (file) {
        // Read from file
        const filePath = resolve(process.cwd(), file);
        code = await readFile(filePath, 'utf-8');
      } else {
        // Read from stdin
        code = await readStdin();
        if (!code.trim()) {
          console.error('Error: No input provided');
          process.exit(1);
        }
      }

      const renderOptions: RenderOptions = {
        lang: options.lang,
        theme: options.theme,
        title: options.title,
        showLineNumbers: options.lineNumbers,
        startLine: parseInt(options.startLine, 10),
        width: parseInt(options.width, 10),
        padding: options.padding,
        background: options.background,
        scale: parseInt(options.scale, 10),
      };

      const { outPath } = await renderPng(code, {
        ...renderOptions,
        out: options.out,
      });

      console.log(`Screenshot saved: ${outPath}`);
    } catch (error) {
      console.error('Error:', error instanceof Error ? error.message : String(error));
      process.exit(1);
    }
  });

program.parse();

async function readStdin(): Promise<string> {
  return new Promise((resolve, reject) => {
    let data = '';
    process.stdin.setEncoding('utf-8');
    process.stdin.on('data', (chunk) => (data += chunk));
    process.stdin.on('end', () => resolve(data));
    process.stdin.on('error', reject);
  });
}
