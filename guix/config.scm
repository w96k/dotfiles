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

(use-package-modules geo linux)

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
   %powertop-service
   %desktop-services))

;; Remove gdm (gdm is default in guix)
(set! %my-services
  (remove (lambda (service)
            (eq? (service-kind service) gdm-service-type))
          %my-services))

(operating-system
 (host-name "Libreboot")
 (timezone "Europe/Moscow")
 (locale "ru_RU.utf8")
 (kernel-arguments '("processor.max_cstate=1"  ;Disable power savings
                     "intel_idle.max_cstate=0" ;(cstate 3-4 provides
                                               ;high freq cpu noice)
                     "intremap=off" ;Fix for failed to map dmar2
                     "acpi=strict" 
                     "i915"
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
   (map specification->package
        '(
          "libva"
          "libva-utils"
          "intel-vaapi-driver"
          "curl"
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
          "emacs-no-x-toolkit"
          "emacs-use-package"
          "emacs-guix"
          "emacs-pdf-tools"
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
