(setq epa-file-cache-passphrase-for-symmetric-encryption t)

(setq user-mail-address "w96k@posteo.net"
      user-full-name "Mikhail Kirillov")

(setq gnus-select-method
      '(nnimap "posteo"
               (nnimap-address "posteo.de")
               (nnimap-server-port "imaps")
               (nnimap-stream ssl)))

(setq smtpmail-smtp-server "posteo.de"
      smtpmail-smtp-service 587
      gnus-ignored-newsgroups "^to\\.\\|^[0-9. ]+\\( \\|$\\)\\|^[\"]\"[#'()]")

(add-hook 'message-setup-hook 'mml-secure-message-encrypt)
(add-hook 'message-setup-hook 'mml-secure-message-sign)
