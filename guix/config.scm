(use-modules (gnu) (gnu system nss)
             (srfi srfi-1))

(use-service-modules xorg
                     networking
                     desktop
                     databases
                     web
                     docker)

(use-package-modules geo)

(operating-system
 (host-name "Libreboot")
 (timezone "Europe/Moscow")
 (locale "ru_RU.utf8")

 (bootloader (bootloader-configuration
              (bootloader grub-bootloader)
              (target "/dev/sda")))

 (file-systems (cons* (file-system
                       (device (file-system-label "root"))
                       (mount-point "/")
                       (type "ext4"))
                      %base-file-systems))

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
          "ratpoison"
          "stumpwm"
          "i3-wm"
          "inputattach"
          "font-dejavu"
          "mailutils"
          "font-terminus"
          "emacs-no-x-toolkit"
          "fontconfig"
          "git"
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
          "docker"
          "docker-cli"
          "nix"
          "postgresql"
          "php"))
   %base-packages))

 ;; Use the "desktop" services, which include the X11
 ;; log-in service, networking with NetworkManager, and more.
 
 (services
  (cons*
   (service slim-service-type)
   (service inputattach-service-type
            (inputattach-configuration
              (device "/dev/ttyS4")
              (device-type "wacom")))
   (postgresql-service #:extension-packages (list postgis))
   (service docker-service-type)
   (service tor-service-type)
   (console-keymap-service "ru")

   (remove (lambda (service)
             (eq? (service-kind service) gdm-service-type))
           %desktop-services)))

 ;; Allow resolution of '.local' host names with mDNS.
 (name-service-switch %mdns-host-lookup-nss))
