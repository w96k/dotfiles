(define-module (non-gnu packages lua-fennel)
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module (guix build-system trivial)
  #:use-module (guix build utils)
  #:use-module (guix gexp)
  #:use-module (gnu packages base)
  #:use-module (gnu packages lua)
  #:use-module ((guix licenses) #:prefix license:))

(define-public lua-fennel
  (package
   (name "lua-fennel")
   (version "0.3.2")
   (source (origin
	    (method git-fetch)
	    (uri (git-reference
		  (url "https://github.com/bakpakin/Fennel")
		  (commit (string-append version))))
	    (file-name (git-file-name name version))
	    (sha256
	     (base32
	      "1rw6hg5b596xq5dc0xqk5vapdizi9qv42lhyb9lgnw3mllg3hfv6"))))
   (build-system trivial-build-system)
   (inputs
    `(("lua" ,lua)))
   (native-inputs
    `(("make" ,gnu-make)))
   (arguments
    `(#:modules ((guix build utils))
      #:builder
      (begin
	(use-modules (guix build utils))

	(let ((out (assoc-ref %outputs "out"))
	      (coreutils (assoc-ref %build-inputs "coreutils"))
	      (make (assoc-ref %build-inputs "make"))
	      (source (assoc-ref %build-inputs "source")))

	  (mkdir out)
	  (mkdir (string-append out "/bin"))
	  (call-with-output-file (string-append out "/bin/fennel")
	    (lambda (port)
	      (display "#!/bin/sh\n../fennel" port)))
	  (invoke (string-append coreutils "/bin/chmod") "+x" (string-append out "/bin/fennel"))
	  ;;(invoke (string-append make "/bin/make") "-C" out)
	  (copy-recursively source out)))))
   (synopsis "Lua Lisp Language.")
   (description "Fennel is a lisp that compiles to Lua. It aims to be
easy to use, expressive, and has almost zero overhead compared to
handwritten Lua.")
   (home-page "https://fennel-lang.org")
   (license license:expat)))

lua-fennel
