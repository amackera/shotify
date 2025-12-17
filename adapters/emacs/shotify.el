;;; shotify.el --- Take beautiful screenshots of code -*- lexical-binding: t; -*-

;; Copyright (C) 2025

;; Author: Shotify Contributors
;; Version: 0.1.0
;; Package-Requires: ((emacs "25.1"))
;; Keywords: tools, convenience
;; URL: https://github.com/amackera/shotify

;;; Commentary:

;; Shotify allows you to take beautiful screenshots of your code directly from Emacs.
;; Select a region and call `shotify-screenshot` to generate a PNG screenshot.
;;
;; Usage:
;;   M-x shotify-screenshot
;;   or bind it to a key: (global-set-key (kbd "C-c s") 'shotify-screenshot)

;;; Code:

(defgroup shotify nil
  "Take beautiful screenshots of code."
  :group 'tools
  :prefix "shotify-")

(defcustom shotify-cli-path "shotify"
  "Path to the shotify CLI executable."
  :type 'string
  :group 'shotify)

(defcustom shotify-theme "github-dark"
  "Default theme for screenshots."
  :type 'string
  :group 'shotify)

(defcustom shotify-width 800
  "Default screenshot width in pixels."
  :type 'integer
  :group 'shotify)

(defcustom shotify-show-line-numbers t
  "Whether to show line numbers in screenshots."
  :type 'boolean
  :group 'shotify)

(defcustom shotify-output-directory "~/Screenshots"
  "Directory to save screenshots."
  :type 'directory
  :group 'shotify)

(defcustom shotify-padding "2rem"
  "Padding around the code in the screenshot."
  :type 'string
  :group 'shotify)

(defcustom shotify-background "#1e1e1e"
  "Background color for the screenshot."
  :type 'string
  :group 'shotify)

(defcustom shotify-scale 2
  "DPI scale factor for the screenshot."
  :type 'integer
  :group 'shotify)

(defun shotify--get-language ()
  "Detect the programming language from the current major mode."
  (let ((mode-name (symbol-name major-mode)))
    (cond
     ((string-match "typescript" mode-name) "typescript")
     ((string-match "javascript" mode-name) "javascript")
     ((string-match "python" mode-name) "python")
     ((string-match "ruby" mode-name) "ruby")
     ((string-match "rust" mode-name) "rust")
     ((string-match "go" mode-name) "go")
     ((string-match "java" mode-name) "java")
     ((string-match "c\\+\\+" mode-name) "cpp")
     ((string-match "^c-mode" mode-name) "c")
     ((string-match "shell" mode-name) "bash")
     ((string-match "sh-mode" mode-name) "bash")
     ((string-match "emacs-lisp" mode-name) "lisp")
     ((string-match "lisp" mode-name) "lisp")
     ((string-match "clojure" mode-name) "clojure")
     ((string-match "html" mode-name) "html")
     ((string-match "css" mode-name) "css")
     ((string-match "json" mode-name) "json")
     ((string-match "yaml" mode-name) "yaml")
     ((string-match "markdown" mode-name) "markdown")
     (t "text"))))

(defun shotify--get-output-path ()
  "Generate an output path for the screenshot."
  (let* ((dir (expand-file-name shotify-output-directory))
         (timestamp (format-time-string "%Y%m%d-%H%M%S"))
         (filename (format "shotify-%s-%s.png" shotify-theme timestamp)))
    (unless (file-exists-p dir)
      (make-directory dir t))
    (expand-file-name filename dir)))

(defun shotify--build-command (lang start-line output-path &optional title)
  "Build the shotify CLI command arguments.
LANG is the language, START-LINE is the starting line number,
OUTPUT-PATH is where to save (nil for stdout),
and TITLE is an optional title."
  (let ((args (list shotify-cli-path
                    "--lang" lang
                    "--theme" shotify-theme
                    "--width" (number-to-string shotify-width)
                    "--padding" shotify-padding
                    "--background" shotify-background
                    "--scale" (number-to-string shotify-scale)
                    "--start-line" (number-to-string start-line))))
    (when output-path
      (setq args (append args (list "--out" output-path))))
    (when title
      (setq args (append args (list "--title" title))))
    (unless shotify-show-line-numbers
      (setq args (append args (list "--no-line-numbers"))))
    args))

(defun shotify--run-cli (code args &optional on-success)
  "Run the shotify CLI with CODE as stdin and ARGS as arguments.
ON-SUCCESS is called with no arguments if the command succeeds."
  (message "Generating screenshot...")
  (with-temp-buffer
    (insert code)
    (let ((exit-code (apply #'call-process-region
                            (point-min)
                            (point-max)
                            (car args)
                            nil
                            (current-buffer)
                            nil
                            (cdr args))))
      (if (= exit-code 0)
          (when on-success (funcall on-success))
        (error "Shotify failed: %s" (buffer-string))))))

(defun shotify--open-file (path)
  "Open PATH in the system file manager."
  (cond
   ;; macOS
   ((eq system-type 'darwin)
    (call-process "open" nil 0 nil "-R" path))
   ;; Linux
   ((eq system-type 'gnu/linux)
    (call-process "xdg-open" nil 0 nil (file-name-directory path)))
   ;; Windows
   ((memq system-type '(windows-nt cygwin))
    (call-process "explorer" nil 0 nil "/select," (convert-standard-filename path)))))

(defun shotify--copy-to-clipboard (path)
  "Copy the image at PATH to the system clipboard."
  (cond
   ;; macOS - use osascript
   ((eq system-type 'darwin)
    (call-process "osascript" nil nil nil
                  "-e" (format "set the clipboard to (read (POSIX file \"%s\") as TIFF picture)" path)))
   ;; Linux - use xclip
   ((eq system-type 'gnu/linux)
    (call-process-shell-command
     (format "xclip -selection clipboard -t image/png -i '%s'" path)))
   ;; Windows - use PowerShell
   ((memq system-type '(windows-nt cygwin))
    (call-process "powershell" nil nil nil
                  "-command" (format "Set-Clipboard -Path '%s'" (convert-standard-filename path))))))

;;;###autoload
(defun shotify-screenshot (start end)
  "Take a screenshot of the selected region from START to END."
  (interactive "r")
  (let* ((code (buffer-substring-no-properties start end))
         (lang (shotify--get-language))
         (start-line (line-number-at-pos start))
         (buf-file (buffer-file-name))
         (title (when buf-file (file-name-nondirectory buf-file)))
         (output-path (shotify--get-output-path))
         (args (shotify--build-command lang start-line output-path title)))
    (shotify--run-cli code args
                      (lambda ()
                        (message "Screenshot saved: %s" output-path)
                        (shotify--open-file output-path)))))

;;;###autoload
(defun shotify-screenshot-buffer ()
  "Take a screenshot of the entire buffer."
  (interactive)
  (shotify-screenshot (point-min) (point-max)))

;;;###autoload
(defun shotify-screenshot-to-clipboard (start end)
  "Take a screenshot of the selected region and copy to clipboard."
  (interactive "r")
  (let* ((code (buffer-substring-no-properties start end))
         (lang (shotify--get-language))
         (start-line (line-number-at-pos start))
         (buf-file (buffer-file-name))
         (title (when buf-file (file-name-nondirectory buf-file)))
         (output-path (shotify--get-output-path))
         (args (shotify--build-command lang start-line output-path title)))
    (shotify--run-cli code args
                      (lambda ()
                        (shotify--copy-to-clipboard output-path)
                        (message "Screenshot copied to clipboard")))))

;;;###autoload
(defun shotify-screenshot-buffer-to-clipboard ()
  "Take a screenshot of the entire buffer and copy to clipboard."
  (interactive)
  (shotify-screenshot-to-clipboard (point-min) (point-max)))

(provide 'shotify)

;;; shotify.el ends here
