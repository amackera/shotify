;;; shotify.el --- Take beautiful screenshots of code -*- lexical-binding: t; -*-

;; Copyright (C) 2025

;; Author: Shotify Contributors
;; Version: 0.1.0
;; Package-Requires: ((emacs "25.1"))
;; Keywords: tools, convenience
;; URL: https://github.com/yourusername/shotify

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
         (filename (format "shotify-%s.png" timestamp)))
    (unless (file-exists-p dir)
      (make-directory dir t))
    (expand-file-name filename dir)))

(defun shotify--build-command (code lang start-line output-path &optional title)
  "Build the shotify CLI command.
CODE is the code to screenshot, LANG is the language,
START-LINE is the starting line number, OUTPUT-PATH is where to save,
and TITLE is an optional title."
  (let ((args (list shotify-cli-path
                    "--lang" lang
                    "--theme" shotify-theme
                    "--width" (number-to-string shotify-width)
                    "--start-line" (number-to-string start-line)
                    "--out" output-path)))
    (when title
      (setq args (append args (list "--title" title))))
    (unless shotify-show-line-numbers
      (setq args (append args (list "--no-line-numbers"))))
    args))

;;;###autoload
(defun shotify-screenshot (start end)
  "Take a screenshot of the selected region from START to END."
  (interactive "r")
  (let* ((code (buffer-substring-no-properties start end))
         (lang (shotify--get-language))
         (start-line (line-number-at-pos start))
         (filename (file-name-nondirectory (buffer-file-name)))
         (title (when filename filename))
         (output-path (shotify--get-output-path))
         (args (shotify--build-command code lang start-line output-path title)))
    (message "Generating screenshot...")
    (with-temp-buffer
      (insert code)
      (let ((exit-code (apply 'call-process-region
                              (point-min)
                              (point-max)
                              (car args)
                              nil
                              (current-buffer)
                              nil
                              (cdr args))))
        (if (= exit-code 0)
            (progn
              (message "Screenshot saved: %s" output-path)
              (when (fboundp 'do-applescript)
                ;; On macOS, open the screenshot
                (do-applescript
                 (format "tell application \"Finder\" to open POSIX file \"%s\""
                         output-path))))
          (error "Shotify failed: %s" (buffer-string)))))))

;;;###autoload
(defun shotify-screenshot-buffer ()
  "Take a screenshot of the entire buffer."
  (interactive)
  (shotify-screenshot (point-min) (point-max)))

(provide 'shotify)

;;; shotify.el ends here
