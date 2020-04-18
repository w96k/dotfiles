(define-module (non-gnu packages taisei-project)
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module (guix build-system meson)
  #:use-module (guix build utils)
  #:use-module (guix gexp)
  #:use-module (gnu packages sdl)
  #:use-module (gnu packages fontutils)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages xiph)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages gnome)
  #:use-module (gnu packages image)
  #:use-module ((guix licenses) #:prefix license:))

(define-public taisei-project
  (package
   (name "taisei-project")
   (version "1.3.1")
   (source (origin
	    (method git-fetch)
	    (uri (git-reference
		  (url "https://github.com/taisei-project/taisei")
		  (commit (string-append "v" version))
		  (recursive? #t)
		  (modules '((guix build utils)))
		  (snippet
		   '(begin
		      ;; Allow builds with Guile 3.0.
		      (invoke "git" "-v")
		      #t))))))
   (file-name (git-file-name name version))
   (sha256
    (base32
     "0mpw81avg4lmwv0i34xrg58frc6q3jkdkihf9yy8ja1npqm07l18"))))
  (build-system meson-build-system)
  (inputs
   `(("sdl2" ,sdl2)
     ("sdl2" ,sdl2-mixer)
     ("freetype" ,freetype)
     ("zlib" ,zlib)
     ("opusfile" ,opusfile)
     ("pkg-config" ,pkg-config)
     ("libwebp" ,libwebp)
     ("libwebp" ,libpng)
     ("libzip" ,libzip)
     ("hicolor-icon-theme" ,hicolor-icon-theme)
     ))
  (synopsis "A free and open-source Touhou Project clone and fangame")
  (description "A free and open-source Touhou Project clone and fangame")
  (home-page "https://taisei-project.org/")
  (license license:expat)))

taisei-project
