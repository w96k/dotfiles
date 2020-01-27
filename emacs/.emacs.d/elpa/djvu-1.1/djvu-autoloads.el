;;; djvu-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "djvu" "djvu.el" (0 0 0 0))
;;; Generated autoloads from djvu.el

(add-to-list 'auto-mode-alist '("\\.djvu\\'" . djvu-dummy-mode))

(autoload 'djvu-dummy-mode "djvu" "\
Djvu dummy mode for `auto-mode-alist'." nil nil)

(autoload 'djvu-find-file "djvu" "\
Read and edit Djvu FILE on PAGE.  Return Read buffer.
If VIEW is non-nil start external viewer.
If NOSELECT is non-nil visit FILE, but do not make it current.
If NOCONFIRM is non-nil don't ask for confirmation when reverting buffer
from file.

\(fn FILE &optional PAGE VIEW NOSELECT NOCONFIRM)" t nil)

(autoload 'djvu-inspect-file "djvu" "\
Inspect Djvu FILE on PAGE.
Call djvused with the same sequence of arguments that is used
by `djvu-init-page'.  Display the output in `djvu-script-buffer'.
This may come handy if `djvu-find-file' chokes on a Djvu file.

\(fn FILE &optional PAGE)" t nil)

(autoload 'djvu-bookmark-handler "djvu" "\
Handler to jump to a particular bookmark location in a djvu document.
BMK is a bookmark record, not a bookmark name (i.e., not a string).
Changes current buffer and point and returns nil, or signals a `file-error'.

\(fn BMK)" nil nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "djvu" '("djvu-")))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; djvu-autoloads.el ends here
