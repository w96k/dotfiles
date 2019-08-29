;; This is my pc at work

(use-modules (gnu) (gnu system nss)
	     (srfi srfi-1))

(use-service-modules xorg desktop networking desktop databases web docker)
(use-package-modules certs geo)

(operating-system
 (host-name "w96k")
 (timezone "Europe/Moscow")
 (locale "ru_RU.utf8")

 ;; Choose US English keyboard layout.  The "altgr-intl"
 ;; variant provides dead keys for accented characters.
 (keyboard-layout (keyboard-layout "us" "altgr-intl"))

 ;; Use the UEFI variant of GRUB with the EFI System
 ;; Partition mounted on /boot/efi.
 (bootloader (bootloader-configuration
              (bootloader grub-efi-bootloader)
              (target "/boot/efi")
              ;;                (target "/dev/sda")
              (keyboard-layout keyboard-layout)))

 (file-systems (cons*
                (file-system
                 (device (file-system-label "guix"))
                 (mount-point "/")
                 (type "ext4"))
		(file-system
                 (device (uuid "ACA8-6834" `fat))
                 (mount-point "/boot/efi")
                 (type "vfat"))
                %base-file-systems))

 (users (cons (user-account
               (name "w96k")
               (group "users")
               (supplementary-groups '("wheel" "netdev"
                                       "audio" "video"))
               (home-directory "/home/w96k"))
              %base-user-accounts))

 ;; This is where we specify system-wide packages.
 (packages (append (map specification->package
                        '(
                          "ratpoison"
                          "stumpwm"
                          "emacs-no-x-toolkit"
                          "font-dejavu"
                          "font-inconsolata"
                          "font-fira-code"
                          "font-terminus"
                          "fontconfig"
                          "nix"
                          "bundler"
                          "node"
                          "ruby"
                          "git"
                          "htop"
                          "rxvt-unicode"
                          "nss-certs"
                          "gvfs"))
                   %base-packages))

 (services (cons*
            (service slim-service-type)
            ;;                          (set-xorg-configuration
            ;;                           (xorg-configuration
            ;;                            (keyboard-layout keyboard-layout))))

            (remove (lambda (service)
                      (eq? (service-kind service) gdm-service-type))
                    %desktop-services)))

 ;; Allow resolution of '.local' host names with mDNS.
 (name-service-switch %mdns-host-lookup-nss))
