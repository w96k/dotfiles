;;;; Emacs --- My config for Emacs that I use in day-to-day work
;;;;
;;;; https://w96k.com/
;;;; 2018-2020 (c) Mikhail w96k Kirillov

;;;; INIT

;; Show errors
;; (setq debug-on-error t)
;; (setq debug-on-quit nil)

(setq package-archives
      '(("gnu" . "https://elpa.gnu.org/packages/")
	("melpa" . "https://melpa.org/packages/")
	("melpa-stable" . "https://stable.melpa.org/packages/")))

(require 'package)

(package-initialize)

;; Dont ask when following symlinks
(setq vc-follow-symlinks t)

;; Add path for guix machines
(add-to-list 'load-path "~/.guix-profile/share/emacs/site-lisp/")
(add-to-list 'load-path "/run/current-system/profile/share/emacs/site-lisp/")

;; "Bootstrap" use-package
(when (not (package-installed-p 'use-package))
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))

(use-package use-package-ensure-system-package
  :ensure t)

(use-package exec-path-from-shell
  :config
  (when (memq window-system '(mac ns x))
    (exec-path-from-shell-copy-env "GUILE_LOAD_PATH")
    (exec-path-from-shell-initialize)))

(require 'diminish)
(require 'bind-key)

(setq custom-file "~/.emacs.d/custom-settings.el")
(load custom-file t)

;; Org File
(org-babel-load-file "~/.emacs-config.org")
