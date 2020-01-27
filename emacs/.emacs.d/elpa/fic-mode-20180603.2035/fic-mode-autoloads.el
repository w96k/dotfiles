;;; fic-mode-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "fic-mode" "fic-mode.el" (0 0 0 0))
;;; Generated autoloads from fic-mode.el

(autoload 'fic-mode "fic-mode" "\
Fic mode -- minor mode for highlighting FIXME/TODO in comments

If called interactively, enable Fic mode if ARG is positive, and
disable it if ARG is zero or negative.  If called from Lisp, also
enable the mode if ARG is omitted or nil, and toggle it if ARG is
`toggle'; disable the mode otherwise.

\(fn &optional ARG)" t nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "fic-mode" '("fic-")))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; fic-mode-autoloads.el ends here
