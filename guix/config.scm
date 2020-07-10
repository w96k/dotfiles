;; This is GUIX system that I use on day-to-day basis.
;; I use it on my libreboot'ed thinkpad X200T
;;
;; Wayland + Sway setup for development (Python, Haskell, Lisp, C)
;;
;; Feel free to use it
;; https://w96k.ru

(use-modules (gnu) (gnu system nss)
             (guix build emacs-utils)
             (srfi srfi-1))

(use-service-modules
 xorg
 shepherd
 dbus
 admin
 networking
 desktop
 databases
 web
 virtualization
 nix
 sound
 docker)

(use-package-modules
 
 hurd
 geo
 linux
 bash
 python
 gnome
 shells)

;; Run powertop --autotune on boot
(define %powertop-service
  (simple-service 'powertop activation-service-type
                  #~(zero? (system* #$(file-append powertop "/sbin/powertop")
                                    "--auto-tune"))))

;; My modification of %desktop-services
(define %my-services
  (cons*

   ;; (service libvirt-service-type
   ;;  	    (libvirt-configuration
   ;; 	     (unix-sock-group "libvirt")))

   (service nix-service-type)

   ;;Wacom tablet support
   (service inputattach-service-type
            (inputattach-configuration
   	     (device "/dev/ttyS4")
   	     (device-type "wacom")))
   
   ;;(postgresql-service #:extension-packages (list postgis))
   ;;(service docker-service-type)
   (service alsa-service-type)
   
   (service tor-service-type)

   ;;(service cleanup-service-type #t)
   ;; Fix unavailable /usr/bin/env
   ;; It's needed by many shell scripts
   (extra-special-file "/usr/bin/env"
                       (file-append coreutils "/bin/env"))
   (extra-special-file "/bin/zsh"
                       (file-append zsh "/bin/zsh"))
   (extra-special-file "/bin/python"
                       (file-append python "/bin/python"))
   
   ;;(service rottlog-service-type)
   ;;%powertop-service

   x11-socket-directory-service
   (service network-manager-service-type)
   (service wpa-supplicant-service-type)
   (service dbus-root-service-type)
   polkit-wheel-service
   ;;fontconfig-file-system-service
   (service elogind-service-type)
   ;; (simple-service 'network-manager-applet
   ;; 		   profile-service-type
   ;; 		   (list network-manager-applet))

   (modify-services %base-services
		    (guix-service-type config =>
				       (guix-configuration (inherit config)
							   (substitute-urls '("http://ci.guix.gnu.org"
									      "https://berlin.guixsd.org")))))))

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
	 "emacs-no-x-toolkit"
	 "emacs-with-editor"
	 "emacs-use-package"
	 ;;"emacs-auto-package-update"
	 ;;"emacs-color-theme-sanityinc-tomorrow"
	 ;;"emacs-mood-line"
	 ;;"emacs-agressive-indent"
	 "emacs-guix"
	 "emacs-edit-indirect"
	 "emacs-build-farm"
	 "guile-gcrypt"
	 "emacs-dash"
	 "emacs-bui"
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
	 ;;"emacs-djvu"
	 "emacs-htmlize"
	 "emacs-ledger-mode"
	 "emacs-diminish"
	 ;;"emacs-smooth-scrolling"
	 "emacs-so-long"
	 "emacs-hydra"
	 "emacs-geiser"
	 "emacs-scheme-complete"
	 "emacs-build-farm"
	 "emacs-clojure-mode"
	 "emacs-cider"
	 "emacs-slime"
	 "emacs-slime-company"
	 "emacs-parinfer-mode"
	 "emacs-lispy"
	 "emacs-emms"
	 "emacs-which-key"
	 "emacs-emacsql"
	 "emacs-slime"
	 "emacs-slime-company"
	 )))

(operating-system
 (host-name "Libreboot")
 (timezone "Europe/Moscow")
 (locale "ru_RU.utf8")
 ;; Waiting for hurd ready to run
 ;;(kernel hurd)
 ;; Stick to stable kernel because intel gpu problems
 (kernel linux-libre)
 (kernel-arguments '("processor.max_cstate=0"  ; Disable power savings
		     "intel_idle.max_cstate=1" ; (cstate 3-4 provides
 					; high freq cpu noice)
		     "consoleblank=0"
		     "ahci.mobile_lpm_policy=1"
		     ;;"console=ttyS0"    ; Redirect logs to different
 					; tty, so system doesn't show
 					; any logs while booting
		     "KVM" ;enable KVM
		     "i915.enable_guc=-1"
		     "i915.enable_dc=0" ; Disable cstate for gpu

		     "intremap=off"     ; Fix for failed to map dmar2

		     "logo.nologo"
		     "loglevel=4"
		     
		     ;;"intel_iommu=on"
		     ;;"iommu=pt"
		     ))
 (initrd-modules (append '("i915") %base-initrd-modules)) 
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
				       "kvm" ;;"docker"
				       ))
	       ;;(shell (file-append zsh "/bin/zsh"))
	       (home-directory "/home/w96k"))
	      %base-user-accounts))
 (packages
  (append
   %emacs
   %base-packages
   (map specification->package
	'(
	  ;; "bash"
	  ;; "bash-completion"
	  "zsh"
	  "zsh-autosuggestions"
	  "curl"
	  ;;"xf86-video-intel"
	  ;;"xorg-server"
	  "libva"
	  "mesa"
	  "mesa-utils"
	  "intel-vaapi-driver"
	  "patchelf"
	  "binutils"
	  "gcc-toolchain"
	  "make"
	  "stow"
	  "icecat"
	  ;;"next"
	  "ratpoison"
	  "stumpwm"
	  "i3-wm"
	  "inputattach"
	  "imagemagick"
	  "font-dejavu"
	  "mailutils"
	  "font-terminus"
	  "lilypond"
	  "fontconfig"
	  "rlwrap"
	  "git"
	  "darcs"
	  "htop"
	  "netcat"
	  "nss-certs"
	  "openssh"
	  "vim"
	  "rxvt-unicode"
	  "st"
	  "node"
	  "perl"
	  "ruby"
	  "python"
	  "python-virtualenv"
	  "python-jedi"
	  "python-ipython"
	  "python-autopep8"
	  "python-black"
	  "neofetch"
	  "mpv"
	  ;;"openjdk@12"
	  "icedtea"
	  "clojure"
	  "clojure-tools-cli"
	  "bundler"
	  "sbcl"
	  ;;"docker"
	  ;;"docker-cli"
	  "nix"
	  "postgresql"
	  "ghc"
	  "nim"
	  "rust"
	  "cabal-install"
	  "php"
	  "lua"
	  "alsa-utils"
	  "mc"
	  "qemu-minimal"
	  "aspell"
	  "aspell-dict-en"
	  "dmidecode"
	  "wayland"
	  "sway"
	  "rofi"
	  "inotify-tools"
	  "mako"
	  ;;"tor"
	  "i3status"
	  "i3blocks"
	  ;;"waybar"
	  ;;"gnunet"
	  "adwaita-icon-theme"
	  ;;"font-awesome"
	  "p7zip"
	  "glibc-utf8-locales"
	  ;;"gvfs"
	  ))))

 (services  %my-services)
 
 ;; Allow resolution of '.local' host names with mDNS.
 (name-service-switch %mdns-host-lookup-nss))
