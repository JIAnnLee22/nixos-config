;;; init.el -*- lexical-binding: t; -*-

;; Emacs packages are provided by Nix. Do not let package.el mutate the
;; user's profile or attempt to contact package archives at startup.
(setq package-enable-at-startup nil
      package-archives nil)

;; Emacs has no Vim-style swap file; disable backups, auto-saves and lock files.
(setq inhibit-startup-screen t
      inhibit-startup-message t
      initial-scratch-message nil
      ring-bell-function #'ignore
      make-backup-files nil
      auto-save-default nil
      auto-save-list-file-prefix nil
      create-lockfiles nil
      require-final-newline t)
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(global-display-line-numbers-mode 1)
(show-paren-mode 1)
(set-language-environment "UTF-8")
(prefer-coding-system 'utf-8-unix)
(set-default-coding-systems 'utf-8-unix)

;; Use the terminal's background rather than an Emacs-defined color.
(set-face-background 'default "unspecified-bg" t)

;; These packages are in the Nix-built Emacs closure, not installed by
;; package.el. Company is particularly useful when Emacs is run with -nw.
(require 'company)
(setq company-idle-delay 0.15
      company-minimum-prefix-length 1
      company-selection-wrap-around t
      company-tooltip-align-annotations t)
(global-company-mode 1)

(require 'which-key)
(which-key-mode 1)

;; Only start Eglot for Nix, Rust and C. Lisp uses Emacs' built-in
;; completion, xref and ElDoc: no Lisp LSP server is packaged here.
(require 'eglot)
(dolist (hook '(nix-mode-hook rust-mode-hook rust-ts-mode-hook
                c-mode-hook c-ts-mode-hook))
  (add-hook hook #'eglot-ensure))
(add-hook 'emacs-lisp-mode-hook #'eldoc-mode)
(add-hook 'lisp-mode-hook #'eldoc-mode)

(with-eval-after-load 'eglot
  ;; Resolve servers from PATH, populated by the Home Manager LSP module.
  (add-to-list 'eglot-server-programs '(nix-mode . ("nil")))
  (add-to-list 'eglot-server-programs '(rust-mode . ("rust-analyzer")))
  (add-to-list 'eglot-server-programs '(rust-ts-mode . ("rust-analyzer")))
  (add-to-list 'eglot-server-programs '(c-mode . ("clangd")))
  (add-to-list 'eglot-server-programs '(c-ts-mode . ("clangd")))

  ;; Convenient, stable bindings for the commands most often used through
  ;; an LSP client. They are local to buffers managed by Eglot.
  (define-key eglot-mode-map (kbd "M-.") #'xref-find-definitions)
  (define-key eglot-mode-map (kbd "C-c r") #'eglot-rename)
  (define-key eglot-mode-map (kbd "C-c a") #'eglot-code-actions)
  (define-key eglot-mode-map (kbd "C-c f") #'eglot-format))
