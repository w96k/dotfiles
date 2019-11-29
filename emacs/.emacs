;;;; Emacs --- My config for Emacs that I use in day-to-day work
;;;;
;;;; https://w96k.com/
;;;; 2018-2019 (c) Mikhail w96k Kirillov

;;;; INIT

(eval-when-compile
  ;; increase GC-limit up to 100M for boot speedup
  (setq gc-cons-threshold 500000000)

    ;;; Set font
  (add-to-list 'default-frame-alist '(font . "terminus-12"))

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
  (setq use-package-always-defer t)
  (setq use-package-always-ensure t))

(use-package use-package-ensure-system-package :ensure)

;;;; VISUALS

;;; Color parens
(use-package rainbow-delimiters
    :hook ((prog-mode . rainbow-delimiters-mode)))

;;; Display numbers
(global-display-line-numbers-mode)

;;; Display current line
(global-hl-line-mode)

;;; Set Theme
(use-package color-theme-sanityinc-tomorrow
  :demand
  :config (load-theme 'sanityinc-tomorrow-eighties t))

;;; Doom modeline
(use-package doom-modeline
  :config
  (setq doom-modeline-height 0.95)
  (set-face-attribute 'mode-line nil :height 95)
  (set-face-attribute 'mode-line-inactive nil :height 100)
  (setq doom-modeline-indent-info t
        doom-modeline-lsp t
        doom-modeline-env-version t
        column-number-mode t
        line-number-mode t)
  :hook (after-init . doom-modeline-mode))

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
  :config (setq dumb-jump-selector 'ivy) ;; (setq dumb-jump-selector 'helm)
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
  :config
  (add-hook 'after-init-hook #'global-flycheck-mode)
  (add-hook 'flycheck-mode-hook #'my/use-eslint-from-node-modules)
  (setq-default flycheck-disabled-checkers
                (append flycheck-disabled-checkers
                        '(javascript-jshint)))
  (flycheck-add-mode 'javascript-eslint 'web-mode)
  (setq-default flycheck-temp-prefix ".flycheck"))

;;; No tabs
(setq-default indent-tabs-mode nil)

;;; Version control
(use-package magit
  :defer 2
  :bind ("C-x g" . magit-status)
  :config (setq magit-refresh-status-buffer nil))

;;; Magit' github integration
(use-package magithub
  :after magit)

;;; Git flow
(use-package magit-gitflow
  :after magit
  :init (add-hook 'magit-mode-hook 'turn-on-magit-gitflow))

;;; Show added & removed git lines
(use-package git-gutter+
  :ensure t
  :init (global-git-gutter+-mode)
  :config
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
(use-package column-enforce-mode
  :defer t
  :diminish
  :config (80-column-rule)
  :hook (prog-mode . column-enforce-mode))

;;; General autocomplete
(use-package ivy
  :demand
  :diminish
  :config
  (ivy-mode)
  (setq ivy-use-virtual-buffers t)
  (setq enable-recursive-minibuffers t)
  (global-set-key "\C-s" 'swiper)
  (global-set-key (kbd "C-c C-r") 'ivy-resume)
  (global-set-key (kbd "<f6>") 'ivy-resume))

(use-package counsel
  :demand
  :config
  (global-set-key (kbd "M-x") 'counsel-M-x)
  (global-set-key (kbd "C-x C-f") 'counsel-find-file)
  (global-set-key (kbd "<f1> f") 'counsel-describe-function)
  (global-set-key (kbd "<f1> v") 'counsel-describe-variable)
  (global-set-key (kbd "<f1> l") 'counsel-find-library)
  (global-set-key (kbd "<f2> i") 'counsel-info-lookup-symbol)
  (global-set-key (kbd "<f2> u") 'counsel-unicode-char)
  (global-set-key (kbd "C-c g") 'counsel-git)
  (global-set-key (kbd "C-c j") 'counsel-git-grep)
  (global-set-key (kbd "C-x b") 'counsel-ibuffer)
  (global-set-key (kbd "C-c k") 'counsel-ag)
  (global-set-key (kbd "C-x l") 'counsel-locate)
  (global-set-key (kbd "C-S-o") 'counsel-rhythmbox)
  (define-key minibuffer-local-map (kbd "C-r") 'counsel-minibuffer-history))

(use-package ivy-hydra)

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

;;; Python
(use-package elpy
  :init
  (elpy-enable)
  :config
  (setq elpy-rpc-python-command "python3")
  (when (load "flycheck" t t)
    (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
    (add-hook 'elpy-mode-hook 'flycheck-mode)))

;;; Vue
(use-package vue-mode
  :config (setq mmm-submode-decoration-level 0))

;;; PHP
(use-package php-mode)

;;; Templates
(use-package web-mode
  :config
  (add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
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

(use-package tide
  :ensure t
  :diminish
  :after (typescript-mode company flycheck)
  :hook ((typescript-mode . tide-setup)
         (typescript-mode . tide-hl-identifier-mode)
         (before-save . tide-format-before-save)))

;;; Clojure REPL
(use-package cider)

;;;; MISC

;;; IRC
(use-package erc
  :config
  (erc-autojoin-enable)
  (setq erc-autojoin-channels-alist
        '(("freenode.net" "#emacs" "#wiki" "#next-browser"))))

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
(global-set-key (kbd "C-u") 'kill-whole-line)

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

;;; Benchmark init
(use-package benchmark-init
  :demand
  :ensure t
  :config
  ;; To disable collection of benchmark data after init is done.
  (add-hook 'after-init-hook 'benchmark-init/deactivate))

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
  :bind (("C-x C-n" . dired-sidebar-toggle-sidebar))
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

;;; Smart mode line
(use-package smart-mode-line
  :demand
  :config
  (setq sml/no-confirm-load-theme t)
  (setq sml/theme 'respectful)
  (sml/setup))

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

;;; Hackernews
(use-package hackernews)

;;; PDF Tools
(use-package pdf-tools
  :if window-system
  :demand
  :config (pdf-loader-install))

;;; Twitter
(use-package twittering-mode
  :config (setq twittering-use-master-password t))

;;; Short messages
(defalias 'yes-or-no-p 'y-or-n-p)

(setq-default confirm-nonexistent-file-or-buffer t)

(setq
 save-place-forget-unreadable-files t
 save-place-limit 200)

(save-place-mode 1)

;;; Show Emoji in emacs
(use-package emojify
  :if window-system
  :config (add-hook 'after-init-hook #'global-emojify-mode))


;;; Server for editing web-forms in emacs
(use-package edit-server
  :if window-system
  :config (edit-server-start))

;;; Markdown preview
(use-package flymd)

;;; AG Search
(use-package ag)

;;; Remove permission info from dired
(defun dired-mode-setup ()
  "to be run as hook for `dired-mode'."
  (dired-hide-details-mode 1))
(add-hook 'dired-mode-hook 'dired-mode-setup)

;;; Dired Ranger like
(use-package peep-dired)

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

;;; Break line at 80 symbols
(use-package visual-fill-column
  :config
  (setq fill-column 80)
  (global-visual-fill-column-mode)
  (global-visual-line-mode))

;;; Disable mouse
(use-package disable-mouse
  :diminish 
  :defer 5
  :config (global-disable-mouse-mode))


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

;;; Hugo org exporter
(use-package ox-hugo
  :after oxxb
  :config
  (setq org-hugo-default-section-directory "posts")
  (setq HUGO_BASE_DIR "~/github/w96k.gitlab.io/content/"))

;;; Accounting
(use-package ledger-mode)

;;; Diary
(use-package org-journal)

(add-to-list 'exec-path "~/.nodejs/bin/")
