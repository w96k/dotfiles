;;; mood-line-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "mood-line" "mood-line.el" (0 0 0 0))
;;; Generated autoloads from mood-line.el

(defvar mood-line-mode nil "\
Non-nil if Mood-Line mode is enabled.
See the `mood-line-mode' command
for a description of this minor mode.
Setting this variable directly does not take effect;
either customize it (see the info node `Easy Customization')
or call the function `mood-line-mode'.")

(custom-autoload 'mood-line-mode "mood-line" nil)

(autoload 'mood-line-mode "mood-line" "\
Toggle mood-line on or off.

If called interactively, enable Mood-Line mode if ARG is
positive, and disable it if ARG is zero or negative.  If called
from Lisp, also enable the mode if ARG is omitted or nil, and
toggle it if ARG is `toggle'; disable the mode otherwise.

\(fn &optional ARG)" t nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "mood-line" '("--" "mood-line-")))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; mood-line-autoloads.el ends here
