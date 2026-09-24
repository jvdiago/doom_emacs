;;; init.el -*- lexical-binding: t; -*-

;; This file controls what Doom modules are enabled and in what order they load.
;; Run 'doom sync' after modifying it! Run 'doom doctor' to check for issues.
;; Press 'K' on a module name to view its documentation.

(doom! :input
       ;;bidi
       ;;chinese
       ;;japanese
       ;;layout

       :completion
       (vertico +icons)         ; modern completion (replaces the deprecated helm/ivy modules)
       (corfu +icons)           ; Spacemacs `auto-completion' layer (in-buffer completion + docs)

       :ui
       doom                     ; doom-one theme + defaults
       dashboard                ; startup screen (renamed from doom-dashboard in 2.1)
       hl-todo                  ; highlight TODO/FIXME/etc
       ;;indent-guides          ; (optional) visual indent guides
       modeline                 ; doom-modeline
       ophints                  ; highlight the region an operation acts on
       (popup +defaults)        ; tame popup windows
       (treemacs +lsp)          ; Spacemacs `treemacs' layer (+lsp: call hierarchy, symbols/errors tree)
       vc-gutter                ; Spacemacs `version-control' (diff in the fringe)
       vi-tilde-fringe          ; fringe tildes on empty lines (vim-like)
       workspaces               ; Spacemacs layouts / eyebrowse equivalent

       :editor
       (evil +everywhere)       ; Spacemacs vim editing style (evil-commentary -> `gc')
       file-templates           ; auto-snippets for empty files
       fold                     ; Spacemacs evil folding
       (format +onsave)         ; format on save (ruff/gofmt via apheleia)
       multiple-cursors         ; Spacemacs `multiple-cursors' layer
       snippets                 ; yasnippet

       :emacs
       dired
       electric
       undo
       vc                       ; version-control base

       :term
       vterm                    ; Spacemacs `shell' layer (vterm backend)

       :checkers
       syntax                   ; Spacemacs `syntax-checking' (flycheck)
       (spell +flyspell)        ; Spacemacs `spell-checking'

       :tools
       docker                   ; Spacemacs `docker' layer
       (eval +overlay)          ; run code, eval overlays
       (lookup +docsets)        ; jump-to-definition / docs
       lsp                      ; Spacemacs `lsp' layer
       magit                    ; Spacemacs `git' layer
       (terraform +lsp)         ; terraform-mode + hcl-mode (+lsp: terraform-ls)
       editorconfig

       :lang
       data                     ; csv + other data formats (Spacemacs `csv')
       emacs-lisp               ; Spacemacs `emacs-lisp' layer
       (go +lsp)                ; Spacemacs `go' layer
       json
       (markdown)               ; Spacemacs `markdown' layer
       (org)                    ; Spacemacs `org' layer
       plantuml                 ; Spacemacs `plantuml' layer
       (python +lsp +pyright)   ; Spacemacs `python' layer
       sh
       (web)                    ; Spacemacs `html' layer (html + css)
       (javascript +lsp +tree-sitter)  ; Spacemacs `typescript' layer (TSX/TS via treesit)
       yaml                     ; Spacemacs `yaml' layer

       :os
       (:if (featurep :system 'macos) macos)   ; macOS integration
       tty                      ; improve terminal Emacs

       :config
       (default +bindings +smartparens))
