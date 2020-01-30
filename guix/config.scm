;; This is GUIX system that I use on day-to-day basis.
;; I use it on my libreboot'ed thinkpad X200T
;;
;; Feel free to use it
;; https://w96k.com

(use-modules (gnu) (gnu system nss)             
             (srfi srfi-1))

(use-service-modules xorg
                     networking
                     desktop
                     databases
                     web
                     docker)

(use-package-modules geo linux bash python)

;; Run powertop --autotune on boot
(define %powertop-service
  (simple-service 'powertop activation-service-type
                  #~(zero? (system* #$(file-append powertop "/sbin/powertop")
                                    "--auto-tune"))))

;; My modification of %desktop-services
(define %my-services
  (cons*
   (service slim-service-type)

   ;; Wacom tablet support
   (service inputattach-service-type
            (inputattach-configuration
             (device "/dev/ttyS4")
             (device-type "wacom")))
   
   (postgresql-service #:extension-packages (list postgis))
   (service docker-service-type)
   (service tor-service-type)
   ;; Fix unavailable /usr/bin/env
   ;; It's needed by many bash scripts
   (extra-special-file "/usr/bin/env"
                       (file-append coreutils "/bin/env"))
   (extra-special-file "/bin/bash"
                       (file-append bash "/bin/bash"))
   (extra-special-file "/bin/python"
                       (file-append python "/bin/python"))
   ;;%powertop-service
   %desktop-services))

;; Remove gdm (gdm is default in guix)
(set! %my-services
  (remove (lambda (service)
            (eq? (service-kind service) gdm-service-type))
          %my-services))

;; Emacs + emacs packages
;; Commented packages are missed in guix
(define %emacs
  (map specification->package
       '(;;"emacs-next"
	 "emacs"
	 "emacs-with-editor"
	 "emacs-use-package"
	 ;;"emacs-auto-package-update"
	 ;;"emacs-color-theme-sanityinc-tomorrow"
	 ;;"emacs-mood-line"
	 ;;"emacs-agressive-indent"
	 "emacs-guix"
	 "emacs-pdf-tools"
	 "emacs-magit"
	 ;;"emacs-magit-gitflow"
	 "emacs-undo-tree"
	 "emacs-magit-todos"
	 ;;"emacs-git-gutter+"
	 "emacs-ace-jump-mode"
	 "emacs-ido-vertical-mode"
	 "emacs-ido-completing-read+"
	 "emacs-ido-ubiquitous"
	 "emacs-amx"
	 "emacs-company"
	 "emacs-company-quickhelp"
	 "emacs-ivy"
	 ;;"emacs-swiper"
	 "emacs-projectile"
	 "emacs-dumb-jump"
	 "emacs-yasnippet"
	 "emacs-yasnippet-snippets"
	 "emacs-whitespace-cleanup-mode"
	 ;;"emacs-column-enforce-mode"
	 "emacs-editorconfig"
	 "emacs-sudo-edit"
	 "emacs-rainbow-delimiters"
	 "emacs-paredit"
	 "emacs-s"
	 "emacs-company-jedi"
	 "emacs-nodejs-repl"
	 "emacs-typescript-mode"
	 ;;"emacs-mwim"
	 ;;"emacs-vue-mode"
	 "emacs-haskell-mode"
	 ;;"emacs-intero"
	 "emacs-cider"
	 "emacs-org-bullets"
	 "emacs-org-pomodoro"
	 ;;"emacs-org-journal"
	 ;;"emacs-epresent"
	 ;;"emacs-flymd"
	 ;;"emacs-flycheck-lilypond"
	 ;;"emacs-erc"
	 "emacs-telega"
	 ;;"emacs-org-mime"
	 "emacs-pinentry"
	 "emacs-exec-path-from-shell"
	 "emacs-docker"
	 "emacs-debbugs"
	 ;;"emacs-keycast"
	 ;;"emacs-pos-tip"
	 "emacs-simple-httpd"
	 "emacs-js2-mode"
	 "emacs-web-mode"
	 "emacs-restclient"
	 "emacs-djvu"
	 "emacs-htmlize"
	 "emacs-ledger-mode"
	 "emacs-diminish"
	 ;;"emacs-smooth-scrolling"
	 "emacs-so-long"
	 "emacs-hydra"
	 "emacs-geiser"
	 "emacs-scheme-complete")))

(operating-system
 (host-name "Libreboot")
 (timezone "Europe/Moscow")
 (locale "ru_RU.utf8")
 (kernel-arguments '("processor.max_cstate=1"  ;Disable power savings
		     "intel_idle.max_cstate=0" ;(cstate 3-4 provides
                                        ;high freq cpu noice)
		     "intremap=off" ;Fix for failed to map dmar2
		     "acpi=strict"
		     "splash"
		     "intel_iommu=on"
		     "i915.enable_dc=0"
		     "i915.modeset=1"
		     "i915.enable_psr=0"
		     "i915.enable_fbc=0"
		     "i915.fastboot=1"
		     "intel_agp"))
 (initrd-modules (append '("i915")
			 %base-initrd-modules))
 (bootloader (bootloader-configuration
	      (bootloader grub-bootloader)
	      (target "/dev/sda")))

 (file-systems (cons* (file-system
		       (device (file-system-label "root"))
		       (mount-point "/")
		       (type "ext4"))
		      %base-file-systems))

 (swap-devices `("/dev/sda5"))

 (users (cons (user-account
	       (name "w96k")
	       (group "users")
	       (supplementary-groups '("wheel" "netdev"
				       "audio" "video"
				       "docker"))
	       (home-directory "/home/w96k"))
	      %base-user-accounts))

 (packages
  (append
   %emacs
   (map specification->package
	'(
	  "bash"
	  "bash-completion"
	  "libva"
	  "libva-utils"
	  "intel-vaapi-driver"
	  "curl"
	  "mesa"
	  "mesa-headers"
	  "xorg-server"
	  "xf86-video-intel"
	  "libdrm"
	  "patchelf"
	  "binutils"
	  "gcc-toolchain"
	  "glibc"
	  "stow"
	  "icecat"
	  "next"
	  "ratpoison"
	  "stumpwm"
	  "i3-wm"
	  "inputattach"
	  "font-dejavu"
	  "mailutils"
	  "font-terminus"
	  "lilypond"
	  "fontconfig"
	  "git"
	  "darcs"
	  "htop"
	  "netcat"
	  "nss-certs"
	  "openssh"
	  "vim"
	  "xinit"
	  "xterm"
	  "xinit"
	  "rxvt-unicode"
	  "node"
	  "ruby"
	  "python"
	  "python-virtualenv"
	  "python-jedi"
	  "python-ipython"
	  "bundler"
	  "sbcl"
	  "docker"
	  "docker-cli"
	  "nix"
	  "postgresql"
	  "ghc"
	  "cabal-install"
	  "php"
	  "alsa-utils"
	  "mc"
	  "dmidecode"
	  "wayland"
	  "gnunet"
	  "adwaita-icon-theme"
	  "glibc-utf8-locales"))
   %base-packages))

 ;; Use the "desktop" services, which include the X11
 ;; log-in service, networking with NetworkManager, and more.

 (services  %my-services)

 ;; Allow resolution of '.local' host names with mDNS.
 (name-service-switch %mdns-host-lookup-nss))
