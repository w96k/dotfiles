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
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (pos-tip yasnippet-snippets vue-mode use-package swiper org-mime org-journal mwim mood-line magit-gitflow keycast js2-mode intero git-gutter+ flymd flycheck-lilypond epresent company-anaconda column-enforce-mode color-theme-sanityinc-tomorrow browse-kill-ring auto-package-update aggressive-indent))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
