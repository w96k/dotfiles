(setq user-mail-address "w96k@posteo.net"
      user-full-name "Mikhail Kirillov")

(setq gnus-select-method
      '(nnimap "gmail"
	       (nnimap-address "posteo.de")  ; it could also be imap.googlemail.com if that's your server.
	       (nnimap-server-port "imaps")
	       (nnimap-stream ssl)))

(setq smtpmail-smtp-server "posteo.de"
      smtpmail-smtp-service 587
      gnus-ignored-newsgroups "^to\\.\\|^[0-9. ]+\\( \\|$\\)\\|^[\"]\"[#'()]")
