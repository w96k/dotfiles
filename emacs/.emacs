;;;; Emacs --- My config for Emacs that I use in day-to-day work
;;;;
;;;; https://w96k.com/
;;;; 2018-2019 (c) Mikhail w96k Kirillov

;;;; INIT

;; increase GC-limit up to 100M for boot speedup
(setq gc-cons-threshold 500000000)
(setq max-specpdl-size 2000000)
(setq max-lisp-eval-depth 10000)

;; Straight.el package manager
;; (defvar bootstrap-version)
;; (let ((bootstrap-file
;;        (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
;;       (bootstrap-version 5))
;;   (unless (file-exists-p bootstrap-file)
;;     (with-current-buffer
;;         (url-retrieve-synchronously
;;          "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
;;          'silent 'inhibit-cookies)
;;       (goto-char (point-max))
;;       (eval-print-last-sexp)))
;;   (load bootstrap-file nil 'nomessage))

;; (setq straight-use-package-by-default t)

;; (straight-use-package '(org :type built-in))

;; Show errors
(setq debug-on-error t)
(setq debug-on-quit nil)

(setq package-archives
        '(("gnu" . "https://elpa.gnu.org/packages/")
          ("melpa" . "https://melpa.org/packages/")
	  ("melpa-stable" . "https://stable.melpa.org/packages/")))

(require 'package)

(package-initialize)

;; restore GC-limit after timeout
;;(run-with-idle-timer
;;30 nil
;;(lambda ()
;;(setq gc-cons-threshold 100000)))

;; Bootstrap use-package
(when (not (package-installed-p 'use-package))
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  ;;(setq load-path "~/.emacs.d/elpa/")
  ;;(add-to-list 'load-path "~/.guix-profile/share/emacs/site-lisp")
  ;;(add-to-list 'load-path (concat "~/.guix-profile/share/emacs/" emacs-version "/site-lisp"))
  ;;(add-to-list 'load-path "/run/current-system/profile/share/emacs/site-lisp")
  ;;(add-to-list 'load-path (concat "/run/current-system/profile/share/emacs/" emacs-version "/site-lisp"))
  (require 'use-package))

(require 'diminish)
(require 'bind-key)

 (use-package exec-path-from-shell
   :config
   (when (memq window-system '(mac ns x))
     (exec-path-from-shell-initialize)
     (exec-path-from-shell-copy-env "PATH")))

(org-babel-load-file "~/.emacs-config.org")
(delete-file "~/.emacs-config.el")