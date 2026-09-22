;; -*- no-byte-compile: t; -*-
;;; packages.el

;; Packages that have no dedicated Doom module. Run 'doom sync' after editing.

(package! load-env-vars)          ; used by the .env auto-loader in config.el

;; Languages Doom has no module for
(package! protobuf-mode)          ; Spacemacs `protobuf' layer
(package! toml-mode)              ; Spacemacs `toml' layer
(package! sql-indent)             ; Spacemacs `sql' layer
(package! sqlup-mode)             ; Spacemacs `sql' layer

(package! flycheck-golangci-lint)
