;; Information about me
(setq user-full-name "Mikhail Kirillov"
      user-mail-address "w96k@posteo.net")

;;; Set font
(add-to-list 'default-frame-alist '(font . "terminus-10"))
(set-face-attribute 'default nil :font "-*-terminus-medium-r-*-*-*-125-75-75-*-*-iso8859-15")
(setq-default line-spacing 0)

;;; Load a theme
;;; https://emacsthemes.com/themes/sanityinc-tomorrow-themes.html
(use-package color-theme-sanityinc-tomorrow
  :demand
  :config (load-theme 'sanityinc-tomorrow-eighties t))

;;; Display numbers
(use-package display-line-numbers
  :ensure
  :init
  (global-display-line-numbers-mode)
  (setq display-line-numbers 'relative
        display-line-numbers-current-absolute t)
  (global-set-key (kbd "C-c l") 'global-display-line-numbers-mode))

(use-package mood-line
  :config (mood-line-mode))

;;; Display current line
(global-hl-line-mode)

;;; Icons
(use-package all-the-icons
  :if window-system)

;;; Live-checking text
(use-package flycheck
  :init (global-flycheck-mode)
  :config
  (setq-default flycheck-temp-prefix ".flycheck")
  (custom-set-variables
   '(flycheck-python-flake8-executable "python3")
   '(flycheck-python-pycompile-executable "python3")
   '(flycheck-python-pylint-executable "python3")))

;;; Undo system
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

;;; Autoformatting code
(use-package aggressive-indent
  :config (global-aggressive-indent-mode))

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

(use-package browse-kill-ring 
  :config (browse-kill-ring-default-keybindings))

(use-package ace-jump-mode
  :config 
  (define-key global-map (kbd "C-c s") 'ace-jump-mode))

(use-package ido
    :config
    (setq ido-enable-flex-matching t)
    (setq ido-everywhere t)
    (setq ido-use-ilename-at-point 'guess)
    (ido-mode)
    (ido-vertical-mode)
    (setq ido-vertical-define-keys 'C-n-and-C-p-only))

(use-package ido-completing-read+
  :after ido
  :config
  (ido-ubiquitous-mode))

(use-package amx
  :config
  (amx-mode))

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


(use-package company-quickhelp
  :after company)

;;; Project Management
(use-package projectile
  :diminish
  :bind (("s-p" . projectile-command-map)
         ("C-c p" . projectile-command-map))
  :config
  (projectile-global-mode))

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

;;; 80 column width limit highlighter
(use-package column-enforce-mode
  :diminish
  :config (80-column-rule)
  :hook (prog-mode . column-enforce-mode))

;;; Show pair for a parenthesis
(show-paren-mode)

;;; Input of pair delimiters
(electric-pair-mode)

;;; Remove permission info from dired
(defun dired-mode-setup ()
  "to be run as hook for `dired-mode'."
  (dired-hide-details-mode 1))
(add-hook 'dired-mode-hook 'dired-mode-setup)

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

;;; Yasnippet
(use-package yasnippet
  :demand
  :diminish
  :init (yas-global-mode 1))

(use-package yasnippet-snippets
  :diminish
  :after yasnippet)

;;; Change Move to end & beginning of the line behavior
(use-package mwim
  :config
  (global-set-key (kbd "C-a") 'mwim-beginning)
  (global-set-key (kbd "C-e") 'mwim-end))

;;; Delete trailing whitespace on save
(use-package whitespace-cleanup-mode
  :diminish
  :config (global-whitespace-cleanup-mode))

;;; Editor Config support
(use-package editorconfig
  :ensure t
  :diminish
  :config
  (editorconfig-mode 1))

;;; Edit with root user
(use-package sudo-edit)

;;; Color parens
(use-package rainbow-delimiters
  :hook ((prog-mode . rainbow-delimiters-mode)))

;;; Parens editing
(use-package paredit)

;;; Emacs Lisp string manipulation
(use-package s)

(use-package anaconda-mode
  :hook (python-mode . anaconda-mode)
  :config (setq python-shell-interpreter "python3"))

(use-package company-anaconda
  :after company
  :config (add-to-list 'company-backends '(company-anaconda :with company-capf)))

;;; Access python documentation
(use-package pydoc
  :commands pydoc
  :config (setq pydoc-command "python3 -m pydoc"))

(use-package helm-pydoc)

(use-package company-jedi
  :after company
  :hook (python-mode . enable-jedi)
  :config  (add-to-list 'company-backends 'company-jedi))

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

;;; Node.js Repl
(use-package nodejs-repl)

;;; Typescript support
(use-package typescript-mode)

;;; Vue
(use-package vue-mode
  :config (setq mmm-submode-decoration-level 0))

;;; Haskell
(use-package haskell-mode)

;;; Haskell support
(use-package intero
  :after haskell-mode
  :config (add-hook 'haskell-mode-hook 'intero-mode))

;;; Clojure REPL
(use-package cider)

;;; Templates
(use-package web-mode
  :config
  (add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-enable-auto-pairing t)
  (setq web-mode-enable-current-element-highlight t)
  (setq web-mode-enable-current-column-highlight t))

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

;;; Bullets for org-mode
(use-package org-bullets
  :if window-system
  :commands org-bullets-mode
  :hook (org-mode . org-bullets-mode))

;;; Org-mode Setup
(setq org-agenda-files (list
                        "~/Documents/life.org"))

;;; Pomodoro technique tracking for org-mode
(use-package org-pomodoro)

;;; Journal
(use-package org-journal)

;;; Presentation
(use-package epresent)

;;; Markdown preview
(use-package flymd)

;;; Lilypond
(progn
  (autoload 'lilypond "lilypond")
  (autoload 'lilypond-mode "lilypond-mode")
  (setq auto-mode-alist
        (cons '("\\.ly$" . LilyPond-mode) auto-mode-alist))
  (add-hook 'LilyPond-mode-hook (lambda () (turn-on-font-lock))))

;;; Flycheck lilypond
(use-package flycheck-lilypond
  :after flycheck)

;;; IRC
(use-package erc)

;;; Telegram client
(use-package telega
  :config (telega-mode-line-mode 1))

;;; convert org to html in gnus
(use-package org-mime)

;;; Dialog program for entering password
(use-package pinentry
  :config
  (setq epa-pinentry-mode 'loopback)
  (pinentry-start))

;;; Disable emacs gui
(menu-bar-mode -1)
(scroll-bar-mode -1)
(tool-bar-mode -1)
(tooltip-mode -1)

(setq-default confirm-nonexistent-file-or-buffer t)

;;; Short messages
(defalias 'yes-or-no-p 'y-or-n-p)

(setq
 save-place-forget-unreadable-files t
 save-place-limit 200)

(save-place-mode 1)

;; Kill whole line
(global-set-key (kbd "C-k") 'kill-whole-line)

(add-to-list 'load-path "~/.guix-profile/share/emacs/site-lisp/")

(use-package exec-path-from-shell
  :config
  (when (memq window-system '(mac ns x))
    (exec-path-from-shell-initialize)
    (exec-path-from-shell-copy-env "PATH")))

(setq create-lockfiles nil
 make-backup-files nil        ; disable backup files
 auto-save-list-file-name nil ; disable .saves files
 auto-save-default nil        ; disable auto saving
 ring-bell-function 'ignore  ; turn off alarms completely
 make-backup-files nil
 auto-save-default nil
 create-lockfiles nil)

(column-number-mode)

;;; Manage docker in emacs
(use-package docker
  :ensure-system-package docker
  :bind ("C-c d" . docker))

;;; Bug-Tracker DebBugs
(use-package debbugs)

(use-package keycast)

;;; HTTP server
(use-package simple-httpd)

;;; Rest client
(use-package restclient)

;;; Djvu
(use-package djvu)

;;; PDF Tools
(use-package pdf-tools
  :if window-system
  :demand
  :config (pdf-loader-install))

;;; Export to html
(use-package htmlize)

;;; Accounting
(use-package ledger-mode)

;;; hide some minor modes
(use-package diminish
  :demand)

;;; Guru mode (disable arrows and stuff)
(use-package guru-mode
  :diminish
  :config (guru-global-mode +1))
