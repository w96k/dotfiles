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

(package-refresh-contents)

(package-initialize)

;; Bootstrap use-package
(when (not (package-installed-p 'use-package))
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))

(require 'diminish)
(require 'bind-key)

(use-package exec-path-from-shell
  :config
  (when (memq window-system '(mac ns x))
    (exec-path-from-shell-copy-env "PATH")
    (exec-path-from-shell-copy-env "PYTHONPATH")
    (exec-path-from-shell-initialize)))

(setq python-shell-interpreter "/home/w96k/.guix-profile/bin/python3")

(org-babel-load-file "~/.emacs-config.org")
(delete-file "~/.emacs-config.el")
