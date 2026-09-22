;;; config.el -*- lexical-binding: t; -*-

;; Loaded after all modules. Run 'doom sync' after adding packages; most changes
;; here are picked up on restart (or 'M-x doom/reload').

;; Absolute line numbers in prog/text modes
(setq display-line-numbers-type t)

;;; ---------------------------------------------------------------------------
;;; Look & feel 
;;; ---------------------------------------------------------------------------
(setq doom-font (font-spec :family "Source Code Pro" :size 14)
      doom-theme 'doom-one)

;; Start maximized (fills the screen, keeps the title bar; not native fullscreen).
(add-to-list 'initial-frame-alist '(fullscreen . maximized))
(add-to-list 'default-frame-alist '(fullscreen . maximized))

;;; ---------------------------------------------------------------------------
;;; .env auto-loader
;;; Loads the closest .env up the directory tree on project/LSP/term events.
;;; ---------------------------------------------------------------------------
(defvar @-dotenv-file-name ".env"
  "The name of the .env file.")

(defun @-find-env-file ()
  "Find the closest .env file in the directory hierarchy."
  (let* ((env-file-directory (locate-dominating-file "." @-dotenv-file-name))
         (file-name (concat env-file-directory @-dotenv-file-name)))
    (when (file-exists-p file-name)
      file-name)))

(defun @-set-project-env ()
  "Export all environment variables in the closest .env file."
  (let ((env-file (@-find-env-file)))
    (when env-file
      (load-env-vars env-file))))

(dolist (hook '(projectile-mode-hook
                projectile-after-switch-project-hook
                comint-exec-hook
                lsp-mode-hook
                vterm-mode-hook))
  (add-hook hook #'@-set-project-env))

;;; ---------------------------------------------------------------------------
;;; Restart the Python LSP server after a virtualenv is activated
;;; ---------------------------------------------------------------------------
(defun my-restart-python-lsp ()
  "Restart the LSP workspace when a Python venv is activated."
  (when (bound-and-true-p lsp-mode)
    (call-interactively #'lsp-workspace-restart)))

(add-hook 'pyvenv-post-activate-hooks #'my-restart-python-lsp)

;;; ---------------------------------------------------------------------------
;;; Python: ruff for both import-sort and format-on-save
;;; (Spacemacs python-formatter 'ruff, python-format-on-save t,
;;;  python-sort-imports-on-save t). `(format +onsave)' triggers it.
;;; ---------------------------------------------------------------------------
(after! apheleia
  (setf (alist-get 'python-mode apheleia-mode-alist) '(ruff-isort ruff))
  (setf (alist-get 'python-ts-mode apheleia-mode-alist) '(ruff-isort ruff)))

;;; ---------------------------------------------------------------------------
;;; Python: ruff as the flycheck linter, chained after the pyright LSP checker.
;;; pyright owns type checking; ruff owns lint (mypy removed). Requires a ruff
;;; binary on PATH and a flycheck new enough to define `python-ruff'.
;;; ---------------------------------------------------------------------------
(after! (:and lsp-mode flycheck)
  (add-hook! 'lsp-managed-mode-hook
    (defun +python-chain-ruff-after-lsp-h ()
      (when (and (derived-mode-p 'python-mode 'python-ts-mode)
                 (flycheck-valid-checker-p 'python-ruff)
                 (not (memq 'python-ruff (flycheck-get-next-checkers 'lsp))))
        (flycheck-add-next-checker 'lsp 'python-ruff)))))

;;; ---------------------------------------------------------------------------
;;; Go: tab width 4, golangci-lint diagnostics
;;; (Spacemacs go-tab-width 4, go-use-golangci-lint t; gofmt-on-save via `(format +onsave)')
;;; ---------------------------------------------------------------------------
(setq-hook! '(go-mode-hook go-ts-mode-hook) tab-width 4)

(after! flycheck
  (add-hook! '(go-mode-hook go-ts-mode-hook) #'flycheck-golangci-lint-setup))

;; Under `+lsp' the buffer's flycheck-checker is forced to `lsp', so golangci-lint
;; only runs if chained after it (same pattern as python-ruff above).
(after! (:and lsp-mode flycheck)
  (add-hook! 'lsp-managed-mode-hook
    (defun +go-chain-golangci-after-lsp-h ()
      (when (and (derived-mode-p 'go-mode 'go-ts-mode)
                 (flycheck-valid-checker-p 'golangci-lint)
                 (not (memq 'golangci-lint (flycheck-get-next-checkers 'lsp))))
        (flycheck-add-next-checker 'lsp 'golangci-lint)))))

;;; ---------------------------------------------------------------------------
;;; vterm: force the native module to build for arm64. Without this, a runtime
;;; `vterm-module-compile' can emit x86_64 objects that fail to link against
;;; Homebrew's arm64 libvterm ("required architecture x86_64" ld error).
;;; ---------------------------------------------------------------------------
(after! vterm
  (setq vterm-module-cmake-args "-DCMAKE_OSX_ARCHITECTURES=arm64"))

;;; ---------------------------------------------------------------------------
;;; helm-projectile fuzzy matching (SPC p f) calls `flx-score' directly, but the
;;; helm module only loads `flx' via helm-flx's helm-mode hook (which
;;; helm-projectile bypasses) -> "void-function flx-score". Load flx eagerly.
;;; ---------------------------------------------------------------------------
(after! helm-projectile
  (require 'flx))

;;; ---------------------------------------------------------------------------
;;; Shorts buffers before helm-mini displays so SPC b b shows workspace buffers sorted
;;; ---------------------------------------------------------------------------

(defun +helm/workspace-mini ()
  "Like the built-in one, but sorted most-recently-used first."
  (interactive)
  (unless (modulep! :ui workspaces)
    (user-error "This command requires the :ui workspaces module"))
  (let ((mru (buffer-list))) ; real global MRU order, captured before persp-mode shadows it
    (with-no-warnings
      (with-persp-buffer-list
          (:sortp (lambda (a b)
                    (< (or (cl-position a mru) most-positive-fixnum)
                       (or (cl-position b mru) most-positive-fixnum))))
        (helm-mini)))))
