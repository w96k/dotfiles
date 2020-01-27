;;; helm-fuzzier-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "helm-fuzzier" "helm-fuzzier.el" (0 0 0 0))
;;; Generated autoloads from helm-fuzzier.el

(defvar helm-fuzzier-mode nil "\
Non-nil if Helm-Fuzzier mode is enabled.
See the `helm-fuzzier-mode' command
for a description of this minor mode.
Setting this variable directly does not take effect;
either customize it (see the info node `Easy Customization')
or call the function `helm-fuzzier-mode'.")

(custom-autoload 'helm-fuzzier-mode "helm-fuzzier" nil)

(autoload 'helm-fuzzier-mode "helm-fuzzier" "\
helm-fuzzier minor mode

If called interactively, enable Helm-Fuzzier mode if ARG is
positive, and disable it if ARG is zero or negative.  If called
from Lisp, also enable the mode if ARG is omitted or nil, and
toggle it if ARG is `toggle'; disable the mode otherwise.

\(fn &optional ARG)" t nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "helm-fuzzier" '("helm-fuzzier-")))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; helm-fuzzier-autoloads.el ends here
