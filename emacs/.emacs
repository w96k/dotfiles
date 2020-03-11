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

;; (eval-when-compile
;;   (require 'use-package))

(require 'use-package)

(use-package use-package-ensure-system-package
  :ensure t)

(use-package exec-path-from-shell
  :config
  (when (memq window-system '(mac ns x))
    (exec-path-from-shell-copy-env "PATH")
    (exec-path-from-shell-copy-env "PYTHONPATH")
    (exec-path-from-shell-initialize)))

(require 'diminish)
(require 'bind-key)

(org-babel-load-file "~/.emacs-config.org")
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (keycast org-mime flycheck-lilypond flymd epresent org-journal intero vue-mode js2-mode jinja2-mode elpy mwim yasnippet-snippets column-enforce-mode pos-tip swiper ivy browse-kill-ring git-gutter+ magit-gitflow magit aggressive-indent mood-line color-theme-sanityinc-tomorrow auto-package-update use-package))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(highlight-indentation-face ((t (:inherit git-gutter+-unchanged)))))
