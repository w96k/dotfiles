;;;; Emacs --- My config for Emacs that I use in day-to-day work
;;;;
;;;; https://w96k.com/
;;;; 2018-2019 (c) Mikhail w96k Kirillov

;;;; INIT

;;; -*- lexical-binding: t; -*-

(eval-when-compile
  ;; increase GC-limit up to 100M for boot speedup
  (setq gc-cons-threshold 500000000)

    ;;; Set font
  (add-to-list 'default-frame-alist '(font . "terminus-10"))
  (set-face-attribute 'default nil :font "-*-terminus-medium-r-*-*-*-125-75-75-*-*-iso8859-15")
  (setq-default line-spacing 0)
  

  ;;; Disable emacs gui
  (menu-bar-mode -1)
  (scroll-bar-mode -1)
  (tool-bar-mode -1)
  (tooltip-mode -1)

  (require 'package)

  (setq package-archives
        '(("gnu" . "http://elpa.gnu.org/packages/")
          ("melpa" . "http://melpa.org/packages/")))

  (package-initialize)

  ;; restore GC-limit after timeout
  (run-with-idle-timer
   15 nil
   (lambda ()
     (setq gc-cons-threshold 100000)))

  ;; Optimize loading
  (setq load-prefer-newer t
        package-user-dir "~/.emacs.d/elpa"
        package--init-file-ensured t
        package-enable-at-startup nil)
  
  (require 'use-package))

(use-package use-package
  :defer nil
  :config
  (setq use-package-verbose t)
  (setq use-package-always-defer nil)
  (setq use-package-always-ensure t))

(use-package use-package-ensure-system-package :ensure)

(use-package use-package-hydra)

(add-to-list 'load-path "~/.guix-profile/share/emacs/site-lisp/")

;; Information about me
(setq user-full-name "Mikhail Kirillov"
      user-mail-address "w96k@posteo.net")

;;;; VISUALS

;;; Color parens
(use-package rainbow-delimiters
  :hook ((prog-mode . rainbow-delimiters-mode)))

;;; Display numbers
(setq display-line-numbers 'relative)
;;(global-display-line-numbers-mode)

;;; Display current line
(global-hl-line-mode)

;;; Set Theme
(use-package doom-themes
  :config
  ;; Global settings (defaults)
  (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
        doom-themes-enable-italic t) ; if nil, italics is universally disabled

  ;; Enable flashing mode-line on errors
  (doom-themes-visual-bell-config))


(use-package color-theme-sanityinc-tomorrow
  :demand
  :config (load-theme 'sanityinc-tomorrow-eighties t))

(use-package simple-httpd)

;;; Bullets for org-mode
(use-package org-bullets
  :if window-system
  :commands org-bullets-mode
  :hook (org-mode . org-bullets-mode))

;;;; EDITING

;;; Easy undo system
(use-package undo-tree
  :diminish
  :commands
  (global-undo-tree-mode)
  :init
  (setq
   undo-tree-visualizer-timestamps t
   undo-tree-enable-undo-in-region nil
   undo-tree-history-directory-alist
   `(("." . ,(expand-file-name "undo" user-emacs-directory))))
  (global-undo-tree-mode))

;;; Jump to defenition
(use-package dumb-jump
  :bind (("M-g o" . dumb-jump-go-other-window)
         ("M-g j" . dumb-jump-go)
         ("M-g i" . dumb-jump-go-prompt)
         ("M-g x" . dumb-jump-go-prefer-external)
         ("M-g z" . dumb-jump-go-prefer-external-other-window))
  :config (setq dumb-jump-selector 'ivy)
  (setq dumb-jump-selector 'helm)
  :ensure)

(progn
  (show-paren-mode))

;;; Edit with root user
(use-package sudo-edit)

;;; Look eslint config
(defun my/use-eslint-from-node-modules ()
  (let* ((root (locate-dominating-file
                (or (buffer-file-name) default-directory)
                "node_modules"))
         (eslint
          (and root
               (expand-file-name "node_modules/.bin/eslint"
                                 root))))
    (when (and eslint (file-executable-p eslint))
      (setq-local flycheck-javascript-eslint-executable eslint))))

;;; Live-checking text
(use-package flycheck
  :init (global-flycheck-mode)
  :config
  (add-hook 'flycheck-mode-hook #'my/use-eslint-from-node-modules)
  (setq-default flycheck-disabled-checkers
                (append flycheck-disabled-checkers
                        '(javascript-jshint)))
  (flycheck-add-mode 'javascript-eslint 'web-mode)
  (setq-default flycheck-temp-prefix ".flycheck")
  (custom-set-variables
   '(flycheck-python-flake8-executable "python3")
   '(flycheck-python-pycompile-executable "python3")
   '(flycheck-python-pylint-executable "python3")))

;;; No tabs
(setq-default indent-tabs-mode nil)

;;; Version control
(use-package magit
  :bind ("C-x g" . magit-status))

;;; Git flow
(use-package magit-gitflow
  :after magit
  :init (add-hook 'magit-mode-hook 'turn-on-magit-gitflow))

;;; Show added & removed git lines
(use-package git-gutter+
  :ensure t
  :init (global-git-gutter+-mode)
  :config
  (setq git-gutter+-window-width 1)
  (set-face-background 'git-gutter+-added "#99cc99")
  (set-face-background 'git-gutter+-deleted "#f2777a")
  (set-face-background 'git-gutter+-modified "#ffcc66")
  (set-face-background 'git-gutter+-unchanged "#393939")
  (setq git-gutter+-added-sign " ")
  (setq git-gutter+-modified-sign " ")
  (setq git-gutter+-deleted-sign " ")
  (setq git-gutter+-unchanged-sign " ")

  (progn
    (define-key git-gutter+-mode-map (kbd "C-x n") 'git-gutter+-next-hunk)
    (define-key git-gutter+-mode-map (kbd "C-x p") 'git-gutter+-previous-hunk)
    (define-key git-gutter+-mode-map (kbd "C-x v =") 'git-gutter+-show-hunk)
    (define-key git-gutter+-mode-map (kbd "C-x r") 'git-gutter+-revert-hunks)
    (define-key git-gutter+-mode-map (kbd "C-x t") 'git-gutter+-stage-hunks)
    (define-key git-gutter+-mode-map (kbd "C-x c") 'git-gutter+-commit)
    (define-key git-gutter+-mode-map (kbd "C-x C") 'git-gutter+-stage-and-commit)
    (define-key git-gutter+-mode-map (kbd "C-x C-y") 'git-gutter+-stage-and-commit-whole-buffer)
    (define-key git-gutter+-mode-map (kbd "C-x U") 'git-gutter+-unstage-whole-buffer))
  :diminish (git-gutter+-mode . "gg"))

;;; Autoformatting code
(use-package aggressive-indent
  :config (global-aggressive-indent-mode))

;;; 80 column width limit highlighter
;; (use-package column-enforce-mode
;;   :diminish
;;   :config (80-column-rule)
;;   :hook (prog-mode . column-enforce-mode))

;;; Autocomplete and search
(use-package helm
  :ensure t
  :init
  :bind (("M-l" . helm-mini)
         ("M-L" . helm-browse-project)
         ("M-i" . helm-occur)
         ("M-I" . helm-do-grep-ag)
         ("C-o" . helm-imenu)
         
         ("M-x" . helm-M-x)
         ("C-x C-f" . helm-find-files)
         ("M-y" . helm-show-kill-ring)
         ("C-z" . helm-resume)
         ("C-h a" . helm-apropos)
         ("C-c f l" . helm-locate-library))
  :diminish helm-mode
  :config
  (require 'helm-config)
  (setq helm-buffers-fuzzy-matching t
        helm-recentf-fuzzy-match    t)
  (setq helm-semantic-fuzzy-match t
        helm-imenu-fuzzy-match    t)
  (setq helm-locate-fuzzy-match t)
  (setq helm-apropos-fuzzy-match t)
  (setq helm-lisp-fuzzy-completion t)
  (define-key helm-map (kbd "<tab>")    'helm-execute-persistent-action)
  (define-key helm-map (kbd "S-<tab>") 'helm-select-action)
  (helm-mode))

(use-package helm-ag
  :after helm
  :bind ("C-s" . helm-do-ag-this-file))

(use-package company
  :demand
  :diminish
  :custom
  (company-require-match nil)
  (company-minimum-prefix-length 1)
  (company-idle-delay 0.1)
  (company-tooltip-align-annotation t)
  :hook ((prog-mode . company-mode))
  :config
  (add-hook 'after-init-hook 'global-company-mode)
  :bind (:map company-active-map
              ("C-n" . company-select-next)
              ("C-p" . company-select-previous)))

;;;; LANGUAGES

(use-package anaconda-mode
  :hook (python-mode . anaconda-mode)
  :config (setq python-shell-interpreter "python3"))

(use-package company-anaconda
  :after company
  :config (add-to-list 'company-backends '(company-anaconda :with company-capf)))

(use-package pydoc
  :commands pydoc
  :config (setq pydoc-command "python3 -m pydoc"))

(use-package helm-pydoc)

(use-package company-jedi
  :after company
  :config  (add-to-list 'company-backends 'company-jedi))

;;; Vue
(use-package vue-mode
  :config (setq mmm-submode-decoration-level 0))

;;; PHP
(use-package php-mode)

;;; Templates
(use-package web-mode
  :config
  (add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-enable-auto-pairing t)
  (setq web-mode-enable-current-element-highlight t)
  (setq web-mode-enable-current-column-highlight t))

;;; Javascript
(use-package js2-mode
  :config
  (add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))
  (setq-default js2-basic-offset 2)
  (add-hook 'js2-mode-hook
            (lambda ()
              (define-key js-mode-map (kbd "C-x C-e") 'nodejs-repl-send-last-expression)
              (define-key js-mode-map (kbd "C-c C-j") 'nodejs-repl-send-line)
              (define-key js-mode-map (kbd "C-c C-r") 'nodejs-repl-send-region)
              (define-key js-mode-map (kbd "C-c C-l") 'nodejs-repl-load-file)
              (define-key js-mode-map (kbd "C-c C-z") 'nodejs-repl-switch-to-repl))))

;;; Eslint
(use-package eslint-fix
  :ensure-system-package (eslint . "npm install -g eslint")
  :config
  (eval-after-load 'js2-mode
    '(add-hook 'js2-mode-hook (lambda () (add-hook 'after-save-hook 'eslint-fix nil t)))))

(use-package json-mode)

(use-package rjsx-mode
  :config
  (add-to-list 'auto-mode-alist '(".*\.js\'" . rjsx-mode)))

;;; Yasnippet
(use-package yasnippet
  :demand
  :diminish
  :init (yas-global-mode 1))

(use-package yasnippet-snippets
  :diminish
  :after yasnippet)

;;; LSP
(use-package lsp-mode
  :hook
  (ruby-mode . lsp)
  (javascript-mode . lsp)
  (vue-mode . lsp)
  :commands lsp)

;;; LSP Flycheck
(use-package lsp-ui
  :after (lsp-mode)
  :hook lsp-mode
  :commands lsp-ui-mode)

(use-package company-lsp
  :after (lsp-mode lsp-ui)
  :commands company-lsp)

;;; Debugger
(use-package dap-mode
  :config
  (dap-mode 1)
  (dap-ui-mode 1))

;;; Ruby On Rails
(use-package rinari)

;;; Node.js Repl
(use-package nodejs-repl)

;;; Haskell
(use-package haskell-mode)

;;; Haskell support
(use-package intero
  :config (add-hook 'haskell-mode-hook 'intero-mode))

;;; Typescript support
(use-package typescript-mode)

;;; Clojure REPL
(use-package cider)

;;;; Emacs Lisp Helping Libraries
(use-package s)

;;;; MISC

;;; htmlize
(use-package htmlize)

;;; Djvu
(use-package djvu)

;;; Show last key and command in modeline
(use-package keycast)

;;; IRC
(use-package erc)

;;; Show TODO, FIX in comments
(use-package fic-mode)

(electric-pair-mode)

;;; Rest client
(use-package restclient)

;;; Telegram
(use-package telega
  :config (telega-mode-line-mode 1))

(use-package exec-path-from-shell
  :config
  (when (memq window-system '(mac ns x))
    (exec-path-from-shell-initialize)
    (exec-path-from-shell-copy-env "PATH")))

;; Kill whole line
(global-set-key (kbd "C-k") 'kill-whole-line)

;;; Volume management using thinkpad volume buttons
(use-package volume
  :config
  (global-set-key (kbd "<XF86AudioRaiseVolume>") 'volume-raise-10)
  (global-set-key (kbd "<XF86AudioLowerVolume>") 'volume-lower-10))

;;; Screenshot
(use-package frameshot
  :if window-system
  :config (frameshot-setup
           '((name   . "w96k")
             (height . 800)
             (width  . 1280))))

;;; Change Move to end & beginning of the line behavior
(use-package mwim
  :config
  (global-set-key (kbd "C-a") 'mwim-beginning)
  (global-set-key (kbd "C-e") 'mwim-end))

(use-package command-log-mode)

;;; Bug-Tracker DebBugs
(use-package debbugs)

;;; Icons
(use-package all-the-icons
  :if window-system)

;;; Icons for dired
(use-package all-the-icons-dired
  :if window-system
  :diminish
  :after all-the-icons
  :config
  (add-hook 'dired-mode-hook 'all-the-icons-dired-mode))

;;; Sidebar File-Manager
(use-package dired-sidebar
  :after exwm
  :bind (("C-x C-d" . dired-sidebar-toggle-sidebar))
  :diminish
  :after all-the-icons
  :commands (dired-sidebar-toggle-sidebar)
  :init
  (add-hook 'dired-sidebar-mode-hook
            (lambda ()
              (unless (file-remote-p default-directory)
                (auto-revert-mode))))
  :config
  (push 'toggle-window-split dired-sidebar-toggle-hidden-commands)
  (push 'rotate-windows dired-sidebar-toggle-hidden-commands)
  (setq dired-sidebar-subtree-line-prefix "__")
  (setq dired-sidebar-use-term-integration t)
  (setq dired-sidebar-use-custom-font t))

;;; Manage docker in emacs
(use-package docker
  :bind ("C-c d" . docker))

;;; hide some minor modes
(use-package diminish
  :demand)

;;; org
(use-package org
  :config
  (setq org-todo-keywords
        (quote ((sequence "TODO(t)" "MIGRATE(m)" "|" "DONE(d)")
                (sequence "WAITING(w@/!)" "HOLD(h@/!)" "|" "CANCELLED(c@/!)" "PHONE" "MEETING"))))
  (setq org-todo-keyword-faces
        (quote (("TODO" :foreground "red" :weight bold)
                ("NEXT" :foreground "blue" :weight bold)
                ("DONE" :foreground "forest green" :weight bold)
                ("WAITING" :foreground "orange" :weight bold)
                ("HOLD" :foreground "magenta" :weight bold)
                ("CANCELLED" :foreground "forest green" :weight bold)
                ("MEETING" :foreground "forest cyan" :weight bold)
                ("PHONE" :foreground "blue" :weight bold)))))

;;; Delete trailing whitespace on save
(use-package whitespace-cleanup-mode
  :diminish
  :config (global-whitespace-cleanup-mode))

;;; convert org to html in gnus
(use-package org-mime)

;;; Presentation
(use-package epresent)

;;; Email
(use-package pinentry
  :config
  (setq epa-pinentry-mode 'loopback)
  (pinentry-start))

;;; Guru mode (disable arrows and stuff)
(use-package guru-mode
  :diminish
  :config (guru-global-mode +1))

;;; PDF Tools
(use-package pdf-tools
  :if window-system
  :demand
  :config (pdf-loader-install))

;;; Short messages
(defalias 'yes-or-no-p 'y-or-n-p)

(setq-default confirm-nonexistent-file-or-buffer t)

(setq
 save-place-forget-unreadable-files t
 save-place-limit 200)

(save-place-mode 1)

;;; Markdown preview
(use-package flymd)

;;; AG Search
(use-package ag)

;;; Remove permission info from dired
(defun dired-mode-setup ()
  "to be run as hook for `dired-mode'."
  (dired-hide-details-mode 1))
(add-hook 'dired-mode-hook 'dired-mode-setup)

;;; Project Management
(use-package projectile
  :diminish 
  :bind (("s-p" . projectile-command-map)
         ("C-c p" . projectile-command-map))
  :config
  (projectile-global-mode))

;;; Editor Config support
(use-package editorconfig
  :ensure t
  :diminish
  :config
  (editorconfig-mode 1))

;;; Parens editing
(use-package paredit)

;;; Parens colorizing
(use-package rainbow-delimiters)

;;; Disable mouse
(use-package disable-mouse
  :config (global-disable-mouse-mode))

;; (use-package mood-line
;;   :config (mood-line-mode))

(use-package doom-modeline
  :ensure t
  :hook (after-init . doom-modeline-mode)
  :config
  (setq doom-modeline-bar-width 8)
  (setq inhibit-compacting-font-caches t)
  (setq find-file-visit-truename t)
  (setq doom-modeline-project-detection 'project)
  (setq doom-modeline-icon nil)
  (setq doom-modeline-buffer-modification-icon nil)
  (setq doom-modeline-major-mode-icon nil)
  (setq doom-modeline-buffer-state-icon nil)
  (setq doom-modeline-minor-modes nil)
  (setq doom-modeline-major-mode-color-icon nil)
  (set-face-attribute 'mode-line nil :height 100)
  (set-face-attribute 'mode-line-inactive nil :height 100)
  (setq doom-modeline-height 1))

(setq create-lockfiles nil)
(setq
 make-backup-files nil        ; disable backup files
 auto-save-list-file-name nil ; disable .saves files
 auto-save-default nil        ; disable auto saving
 ring-bell-function 'ignore)  ; turn off alarms completely

;;; No savefiles
(progn
  (setq make-backup-files nil)
  (setq auto-save-default nil)
  (setq create-lockfiles nil))

;;; Org-mode Setup
(setq org-agenda-files (list
                        "~/Documents/life.org"))

;;; Pomodoro technique tracking for org-mode
(use-package org-pomodoro)

;;; Accounting
(use-package ledger-mode)

;;; Diary
(use-package org-journal)

;;; Lilypond
(progn
  (autoload 'lilypond "lilypond")
  (autoload 'lilypond-mode "lilypond-mode")
  (setq auto-mode-alist
        (cons '("\\.ly$" . LilyPond-mode) auto-mode-alist))
  (add-hook 'LilyPond-mode-hook (lambda () (turn-on-font-lock))))

(column-number-mode)

;;; Flycheck lilypond
(use-package flycheck-lilypond)
