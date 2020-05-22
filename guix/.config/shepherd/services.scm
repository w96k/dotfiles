(define emacs
  (make <service>
    #:provides '(emacs)
    #:requires '()
    #:start (make-system-constructor "emacs --daemon")
    #:stop (make-system-destructor
            "emacsclient --eval \"(kill-emacs)\"")))

(define ssh-agent
  (make <service>
    #:provides '(ssh-agent)
    #:requires '()
    #:start (make-system-constructor "eval $(ssh-agent)")))
