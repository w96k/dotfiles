;; Information about me
(setq user-full-name "Mikhail Kirillov"
      user-mail-address "w96k@posteo.net")

;;; Set font
  ;;(set-frame-font "terminus 12" nil t)
  (add-to-list 'default-frame-alist '(font . "Fira Code-10.5"))
  (set-frame-font "Fira Code-10.5" nil t)
  (setq-default line-spacing 0)

(use-package fira-code-mode
  :ensure
  :config (global-fira-code-mode))

(global-prettify-symbols-mode)

;;; Load a theme
;;; https://emacsthemes.com/themes/sanityinc-tomorrow-themes.html
(use-package color-theme-sanityinc-tomorrow
  :ensure
  :config (load-theme 'sanityinc-tomorrow-eighties t))

;;; Отображение номера строки ненужно из-за наличия avy-jump
;; (use-package display-line-numbers
;;   :init
;;   (setq display-line-numbers-type 'relative)
;;   (global-display-line-numbers-mode))

(custom-set-faces
 '(mode-line ((t (:background "#333" :foreground "#cccccc" :box (:line-width 1 :color "#2d2d2d" :style released-button) :weight bold :height 1.0 :family "Fira Code")))))

;;; Display current line
(when (display-graphic-p)
(global-hl-line-mode))

(use-package emojify
  :config
  (global-emojify-mode))

;;  Live-checking text
  (use-package flymake
  :config (flymake-mode))

;;(global-flycheck-mode)

;;; Undo system
 (use-package undo-tree
   :diminish
   :config (global-undo-tree-mode))

;;; Autoformatting code
(use-package aggressive-indent
  :ensure t
  :config (global-aggressive-indent-mode))

(use-package ssh-agency
:ensure)
(use-package pass
:ensure)

;;; Show added & removed git lines
(use-package git-gutter+
  :ensure
  :config
  (global-git-gutter+-mode)
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
  :ensure
  :config (browse-kill-ring-default-keybindings))

(use-package avy
  :config 
  (define-key global-map (kbd "C-c s") 'avy-goto-char)
  (define-key global-map (kbd "C-c l") 'avy-goto-line))

(use-package swiper
  :ensure t)

(use-package counsel
  :ensure t)

(use-package ivy
    :diminish
    :config
    (setq ivy-use-virtual-buffers t)
    (setq enable-recursive-minibuffers t)
    (global-set-key "\C-s" 'swiper)
    (global-set-key (kbd "C-c C-r") 'ivy-resume)
    (global-set-key (kbd "<f6>") 'ivy-resume)
    (global-set-key (kbd "M-x") 'counsel-M-x)
    (global-set-key (kbd "C-x C-f") 'counsel-find-file)
    (global-set-key (kbd "<f1> f") 'counsel-describe-function)
    (global-set-key (kbd "<f1> v") 'counsel-describe-variable)
    (global-set-key (kbd "<f1> l") 'counsel-find-library)
    (global-set-key (kbd "<f2> i") 'counsel-info-lookup-symbol)
    (global-set-key (kbd "<f2> u") 'counsel-unicode-char)
    (global-set-key (kbd "C-c g") 'counsel-git)
    (global-set-key (kbd "C-c j") 'counsel-git-grep)
    (global-set-key (kbd "C-c k") 'counsel-ag)
    (global-set-key (kbd "C-x l") 'counsel-locate)
    (global-set-key (kbd "C-S-o") 'counsel-rhythmbox)
    (define-key minibuffer-local-map (kbd "C-r")
    'counsel-minibuffer-history)
    (ivy-mode 1))

(use-package pos-tip
  :ensure t)

(use-package company
  :diminish
  :custom
  (company-require-match nil)
  (company-minimum-prefix-length 1)
  (company-idle-delay 0)
  (company-tooltip-align-annotation t)
  :hook ((prog-mode . company-mode))
  :bind (:map company-active-map
	      ("C-n" . company-select-next)
	      ("C-p" . company-select-previous)))

(use-package company-quickhelp
  :after company pos-tip
  :config (company-quickhelp-mode))

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
	 ("M-g z" . dumb-jump-go-prefer-external-other-window)))

(use-package hydra)

;;; 80 column width limit highlighter
(use-package column-enforce-mode
  :ensure t
  :diminish
  :config
  (80-column-rule))

;;; Show pair for a parenthesis
(show-paren-mode)

;;; Input of pair delimiters
(electric-pair-mode)

;;; Change Move to end & beginning of the line behavior
(use-package mwim
  :ensure
  :config
  (global-set-key (kbd "C-a") 'mwim-beginning)
  (global-set-key (kbd "C-e") 'mwim-end))

;;; Delete trailing whitespace on save
(use-package whitespace-cleanup-mode
  :diminish
  :config (global-whitespace-cleanup-mode))

;;; Editor Config support
(use-package editorconfig
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

(use-package scheme-complete
  :after company)

(use-package geiser)

;; (use-package elpy
;;   :ensure t
;;   :init
;;   (elpy-enable)
;;   :config
;;   (setq elpy-rpc-python-command "python3"
;; 	python-shell-interpreter "python3"
;; 	;;python-shell-interpreter "ipython" elpy-modules
;; 	elpy-rpc-virtualenv-path 'current
;; 	pyvenv-mode-line-indicator t )
;;   :bind
;;   ("C-c p" . elpy-autopep8-fix-code)
;;   ("C-c b" . elpy-black-fix-code))

;; (use-package anaconda-mode
;;   :ensure
;;   :hook (python-mode . anaconda-mode)
;;   (python-mode . anaconda-eldoc-mode))

(use-package jinja2-mode
  :ensure t)

;; (use-package company-anaconda
;;   :ensure
;;   :after company
;;   :config
;;   (add-to-list 'company-backends '(company-anaconda :with company-capf)))

;;; Access python documentation
(use-package pydoc
  :commands pydoc
  :config (setq pydoc-command "python3 -m pydoc"))

;;; Javascript
(use-package js2-mode
  :ensure t
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
  :ensure
  :config (setq mmm-submode-decoration-level 0))

;;; Haskell
(use-package haskell-mode)

;;; Haskell support
(use-package intero
  :ensure
  :after haskell-mode
  :config (add-hook 'haskell-mode-hook 'intero-mode))

;;; Clojure REPL
(use-package cider)

(use-package slime
  :config

  (setq slime-contribs '(slime-fancy slime-repl slime-banner)))

(use-package fennel-mode
  :ensure
  :config
(define-key fennel-mode-map (kbd "C-c C-k")
     (defun pnh-fennel-hotswap ()
       (interactive)
       (comint-send-string
	(inferior-lisp-proc)
	(format "(lume.hotswap \"%s\")\n"
		(substring (file-name-nondirectory (buffer-file-name)) 0 -4))))))

(use-package emacsql)

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
  (setq org-default-notes-file (concat org-directory "~/Documents/life.org"))
  (global-set-key (kbd "C-c l") 'org-store-link)
  (global-set-key (kbd "C-c a") 'org-agenda)
  (global-set-key (kbd "C-c c") 'org-capture)

(setq org-capture-templates
      (quote (("t" "todo" entry (file "~/git/org/refile.org")
               "* TODO %?\n%U\n%a\n" :clock-in t :clock-resume t)
              ("r" "respond" entry (file "~/git/org/refile.org")
               "* NEXT Respond to %:from on %:subject\nSCHEDULED: %t\n%U\n%a\n" :clock-in t :clock-resume t :immediate-finish t)
              ("n" "note" entry (file "~/git/org/refile.org")
               "* %? :NOTE:\n%U\n%a\n" :clock-in t :clock-resume t)
              ("j" "Journal" entry (file+datetree "~/git/org/diary.org")
               "* %?\n%U\n" :clock-in t :clock-resume t)
              ("w" "org-protocol" entry (file "~/git/org/refile.org")
               "* TODO Review %c\n%U\n" :immediate-finish t)
              ("m" "Meeting" entry (file "~/git/org/refile.org")
               "* MEETING with %? :MEETING:\n%U" :clock-in t :clock-resume t)
              ("p" "Phone call" entry (file "~/git/org/refile.org")
               "* PHONE %? :PHONE:\n%U" :clock-in t :clock-resume t)
              ("h" "Habit" entry (file "~/git/org/refile.org")
               "* NEXT %?\n%U\n%a\nSCHEDULED: %(format-time-string \"%<<%Y-%m-%d %a .+1d/3d>>\")\n:PROPERTIES:\n:STYLE: habit\n:REPEAT_TO_STATE: NEXT\n:END:\n"))))

  (setq org-modules (quote (org-bbdb
                          org-bibtex
                          org-crypt
                          org-gnus
                          org-id
                          org-info
                          org-habit
                          org-inlinetask
                          org-irc
                          org-mhe
                          org-protocol
                          org-w3m)))
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
  :commands org-bullets-mode
  :hook (org-mode . org-bullets-mode))

;;; Org-mode Setup
(setq org-agenda-files (list
			"~/Documents/life.org"))

;;; Pomodoro technique tracking for org-mode
(use-package org-pomodoro)

;;; Journal
(use-package org-journal
  :ensure)

;;; Presentation
(use-package epresent
  :ensure t)

;;; Markdown preview
(use-package flymd
  :ensure)

;;; Lilypond
(progn
  (autoload 'lilypond "lilypond")
  (autoload 'lilypond-mode "lilypond-mode")
  (setq auto-mode-alist
	(cons '("\\.ly$" . LilyPond-mode) auto-mode-alist))
  (add-hook 'LilyPond-mode-hook (lambda () (turn-on-font-lock))))

;;; Flycheck lilypond
(use-package flycheck-lilypond
  :ensure
  :after flycheck)

;;; IRC
(use-package erc
  :ensure)

;;; Telegram client
(use-package telega
  :config (telega-mode-line-mode 1))

;;; convert org to html in gnus
(use-package org-mime
  :ensure)

;;; Dialog program for entering password
(use-package pinentry
  :config
  (setq epa-pinentry-mode 'loopback)
  (pinentry-start))

(use-package so-long
  :config (global-so-long-mode 1))

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

(blink-cursor-mode 1)

(use-package exec-path-from-shell
  :config
  (when (memq window-system '(mac ns x))
    (exec-path-from-shell-initialize)
    (exec-path-from-shell-copy-env "PATH")))

(setq create-lockfiles nil
 make-backup-files nil        ; disable backup files
 auto-save-list-file-name nil ; disable .saves files
 auto-save-default nil        ; disable auto saving)

(column-number-mode)

(use-package which-key
  :config
  (setq which-key-show-early-on-C-h t)
  (setq which-key-side-window-location 'bottom)
  (setq which-key-idle-delay 0.5)
  (setq which-key-popup-type 'side-window)
  (global-set-key (kbd "C-h C-k") 'which-key-show-major-mode)
  (setq which-key-sort-order 'which-key-prefix-then-key-order)
  (which-key-mode))

;;  (use-package guix-autoloads)

  (use-package edit-indirect)
  (use-package build-farm)
  (use-package dash)
  (use-package bui)

;;; Manage docker in emacs
(use-package docker
  :ensure-system-package docker
  :bind ("C-c d" . docker))

(use-package emms
  :config
 (emms-all)
 (emms-default-players)
 (setq emms-source-file-default-directory (expand-file-name "~/Music"))
 (setq emms-player-list '(emms-player-mpg321 emms-player-ogg123
		       emms-player-mplayer)))

;;; Bug-Tracker DebBugs
(use-package debbugs)

(use-package keycast
  :ensure)

;;; HTTP server
(use-package simple-httpd)

;;; Rest client
(use-package restclient)

;;; PDF Tools
(use-package pdf-tools
  :if window-system
  :config (pdf-tools-install))

(use-package whitespace
 :config (global-set-key (kbd "C-c w") 'whitespace-mode))

;;; Accounting
(use-package ledger-mode)

;;; hide some minor modes
(use-package diminish)
