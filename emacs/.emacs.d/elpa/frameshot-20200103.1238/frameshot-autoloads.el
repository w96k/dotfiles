;;; frameshot-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "frameshot" "frameshot.el" (0 0 0 0))
;;; Generated autoloads from frameshot.el

(defvar frameshot-mode nil "\
Non-nil if Frameshot mode is enabled.
See the `frameshot-mode' command
for a description of this minor mode.")

(custom-autoload 'frameshot-mode "frameshot" nil)

(autoload 'frameshot-mode "frameshot" "\
Take screenshots of a frame.

If called interactively, enable Frameshot mode if ARG is
positive, and disable it if ARG is zero or negative.  If called
from Lisp, also enable the mode if ARG is omitted or nil, and
toggle it if ARG is `toggle'; disable the mode otherwise.

\(fn &optional ARG)" t nil)

(autoload 'frameshot-setup "frameshot" "\
Setup the selected frame using CONFIG and call `frameshot-setup-hook'.

Set variable `frameshot-config' to CONFIG, resize the selected
frame according to CONFIG, and call `frameshot-setup-hook'.  If
CONFIG is nil, then use the value of `frameshot-config' instead.
See `frameshot-config' for the format of CONFIG.

Also run `frameshot-setup-hook' and `frameshot-clear'.

When called interactively, then reload the previously loaded
configuration if any.

\(fn &optional CONFIG)" t nil)

(autoload 'frameshot-default-setup "frameshot" "\
Setup the selected frame using `frame-default-config'." t nil)

(autoload 'frameshot-clear "frameshot" "\
Remove some artifacts, preparing to take a screenshot." t nil)

(autoload 'frameshot-take "frameshot" "\
Take a screenshot of the selected frame." t nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "frameshot" '("frameshot-")))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; frameshot-autoloads.el ends here
