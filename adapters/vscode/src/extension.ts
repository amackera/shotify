import * as vscode from 'vscode';
import { renderPng, RenderOptions } from '@shotify/core';
import { homedir, tmpdir } from 'os';
import { join } from 'path';
import { readFile } from 'fs/promises';

export function activate(context: vscode.ExtensionContext) {
  // Register commands
  context.subscriptions.push(
    vscode.commands.registerCommand('shotify.screenshotSelection', () =>
      handleScreenshot(false, false)
    )
  );

  context.subscriptions.push(
    vscode.commands.registerCommand('shotify.screenshotFile', () =>
      handleScreenshot(true, false)
    )
  );

  context.subscriptions.push(
    vscode.commands.registerCommand('shotify.screenshotSelectionToClipboard', () =>
      handleScreenshot(false, true)
    )
  );

  context.subscriptions.push(
    vscode.commands.registerCommand('shotify.screenshotFileToClipboard', () =>
      handleScreenshot(true, true)
    )
  );
}

export function deactivate() {}

async function handleScreenshot(fullFile: boolean, toClipboard: boolean) {
  const editor = vscode.window.activeTextEditor;

  if (!editor) {
    vscode.window.showErrorMessage('No active editor');
    return;
  }

  const document = editor.document;
  const config = vscode.workspace.getConfiguration('shotify');

  let code: string;
  let startLine: number;
  let title: string | undefined;

  if (fullFile) {
    // Screenshot entire file
    code = document.getText();
    startLine = 1;
    title = document.fileName.split('/').pop();
  } else {
    // Screenshot selection
    const selection = editor.selection;

    if (selection.isEmpty) {
      vscode.window.showErrorMessage('No code selected');
      return;
    }

    code = document.getText(selection);
    startLine = selection.start.line + 1;
    title = document.fileName.split('/').pop();
  }

  try {
    await vscode.window.withProgress(
      {
        location: vscode.ProgressLocation.Notification,
        title: 'Generating screenshot...',
        cancellable: false,
      },
      async () => {
        const renderOptions: RenderOptions = {
          lang: mapLanguageId(document.languageId),
          theme: config.get('theme', 'github-dark'),
          title: title,
          showLineNumbers: config.get('showLineNumbers', true),
          startLine: startLine,
          width: config.get('width', 800),
          padding: config.get('padding', '2rem'),
          background: config.get('background', '#1e1e1e'),
        };

        // Determine output path
        const timestamp = new Date().toISOString().replace(/[:.]/g, '-').slice(0, -5);
        let outputPath: string;

        if (toClipboard) {
          // Use temp directory for clipboard operations
          outputPath = join(tmpdir(), `shotify-${timestamp}.png`);
        } else {
          // Save to configured directory
          const outputDir = expandPath(config.get('outputDirectory', '~/Screenshots'));
          outputPath = join(outputDir, `shotify-${timestamp}.png`);
        }

        const result = await renderPng(code, {
          ...renderOptions,
          out: outputPath,
        });

        if (toClipboard) {
          // Copy to clipboard
          await copyImageToClipboard(result.outPath);
          vscode.window.showInformationMessage('Screenshot copied to clipboard!');
        } else {
          // Show success message with action buttons
          const action = await vscode.window.showInformationMessage(
            `Screenshot saved: ${result.outPath}`,
            'Open File',
            'Reveal in Finder'
          );

          if (action === 'Open File') {
            const uri = vscode.Uri.file(result.outPath);
            await vscode.env.openExternal(uri);
          } else if (action === 'Reveal in Finder') {
            const uri = vscode.Uri.file(result.outPath);
            await vscode.commands.executeCommand('revealFileInOS', uri);
          }
        }
      }
    );
  } catch (error) {
    vscode.window.showErrorMessage(
      `Failed to generate screenshot: ${error instanceof Error ? error.message : String(error)}`
    );
  }
}

function mapLanguageId(languageId: string): string {
  // Map VS Code language IDs to Shiki language identifiers
  const languageMap: Record<string, string> = {
    'javascriptreact': 'jsx',
    'typescriptreact': 'tsx',
    'shellscript': 'bash',
    'csharp': 'cs',
    'objective-c': 'objc',
    'objective-cpp': 'objcpp',
  };

  return languageMap[languageId] || languageId;
}

function expandPath(path: string): string {
  if (path.startsWith('~/')) {
    return join(homedir(), path.slice(2));
  }
  return path;
}

async function copyImageToClipboard(imagePath: string): Promise<void> {
  // Read the image file
  const imageBuffer = await readFile(imagePath);

  // Convert to base64
  const base64Image = imageBuffer.toString('base64');

  // Copy to clipboard using VS Code API
  // Note: VS Code's clipboard API currently only supports text, so we'll copy the file path
  // and use a platform-specific command for actual image copying

  const platform = process.platform;

  if (platform === 'darwin') {
    // macOS - use osascript
    const { exec } = require('child_process');
    await new Promise<void>((resolve, reject) => {
      exec(
        `osascript -e 'set the clipboard to (read (POSIX file "${imagePath}") as JPEG picture)'`,
        (error: Error | null) => {
          if (error) reject(error);
          else resolve();
        }
      );
    });
  } else if (platform === 'win32') {
    // Windows - use PowerShell
    const { exec } = require('child_process');
    await new Promise<void>((resolve, reject) => {
      exec(
        `powershell -command "Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.Clipboard]::SetImage([System.Drawing.Image]::FromFile('${imagePath}'))"`,
        (error: Error | null) => {
          if (error) reject(error);
          else resolve();
        }
      );
    });
  } else {
    // Linux - use xclip
    const { exec } = require('child_process');
    await new Promise<void>((resolve, reject) => {
      exec(
        `xclip -selection clipboard -t image/png -i "${imagePath}"`,
        (error: Error | null) => {
          if (error) {
            reject(new Error('xclip not found. Please install xclip: sudo apt-get install xclip'));
          } else {
            resolve();
          }
        }
      );
    });
  }
}
