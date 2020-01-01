(use-modules (gnu) (gnu system nss)             
             (srfi srfi-1))

(use-service-modules xorg
                     networking
                     desktop
                     databases
                     web
                     docker)

(use-package-modules geo
                     linux)

;; Run powertop --autotune on boot
(define %powertop-service
  (simple-service 'powertop activation-service-type
                  #~(zero? (system* #$(file-append powertop "/sbin/powertop")
                                    "--auto-tune"))))

;; My modification of %desktop-services
(define %my-services
  (cons*
   (service slim-service-type)

   (service inputattach-service-type
            (inputattach-configuration
             (device "/dev/ttyS4")
             (device-type "wacom")))
   (postgresql-service #:extension-packages (list postgis))
   (service docker-service-type)
   (service tor-service-type)
   (extra-special-file "/usr/bin/env"
                       (file-append coreutils "/bin/env"))
   %powertop-service
   %desktop-services))

;; Remove gdm
(set! %my-services
(remove (lambda (service)
          (eq? (service-kind service) gdm-service-type))
%my-services))

(operating-system
 (host-name "Libreboot")
 (timezone "Europe/Moscow")
 (locale "ru_RU.utf8")
 (kernel-arguments '("processor.max_cstate=2"))
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
          "xf86-video-intel"
          "x86-energy-perf-policy"
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
          "xorg-server"
          "xorg-server-xwayland"
          "wayland"
          "gnunet"
          "adwaita-icon-theme"
          "mesa"
          "glibc-utf8-locales"))
   %base-packages))

 ;; Use the "desktop" services, which include the X11
 ;; log-in service, networking with NetworkManager, and more.

 (services  %my-services)

 ;; Allow resolution of '.local' host names with mDNS.
 (name-service-switch %mdns-host-lookup-nss))
