import { defineConfig } from 'tsup';

export default defineConfig({
  entry: ['src/extension.ts'],
  format: ['cjs'],
  outDir: 'dist',
  external: ['vscode'],
  noExternal: ['@shotify/core'],
  platform: 'node',
  target: 'node16',
  bundle: true,
  clean: true,
  sourcemap: true,
  dts: false,
});
