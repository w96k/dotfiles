(define-module (non-gnu packages lua-fennel)
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module (guix build-system trivial)
  #:use-module (guix build utils)
  #:use-module (guix gexp)
  #:use-module (gnu packages base)
  #:use-module (gnu packages bash)
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
    `(("lua" ,lua)
      ("bash" ,bash-minimal)))
   (propagated-inputs
    `(("lua" ,lua)))
   (arguments
    `(#:modules ((guix build utils))
      #:builder
      (begin
	(use-modules (guix build utils))

	(let ((out (assoc-ref %outputs "out"))
	      (coreutils (assoc-ref %build-inputs "coreutils"))
	      (bash (assoc-ref %build-inputs "bash"))
	      (source (assoc-ref %build-inputs "source")))

	  (mkdir out)
	  (copy-recursively source out)
	  (chdir out)

	  (substitute* "fennel"
		       (("#!/usr/bin/env lua") (string-append "")))

	  (mkdir "bin")
	  (call-with-output-file "bin/fennel"
	    (lambda (port)
	      (display (string-append "#!" bash "/bin/bash\n lua "
				      out "/fennel") port)))
	  (chmod (string-append out "/bin/fennel") #o755)))))
   (synopsis "Lua Lisp Language.")
   (description "Fennel is a lisp that compiles to Lua. It aims to be
easy to use, expressive, and has almost zero overhead compared to
handwritten Lua.")
   (home-page "https://fennel-lang.org")
   (license license:expat)))
