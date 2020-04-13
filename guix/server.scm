;; This is an operating system configuration template
;; for a "bare bones" setup, with no X11 display server

(use-modules (gnu) (gnu system nss)
             (srfi srfi-1))
(use-service-modules base networking ssh databases monitoring)
(use-package-modules bootloaders certs geo)

(operating-system
 (host-name "w96k")
 (timezone "Europe/Moscow")
 (locale "en_US.utf8")

 ;; Boot in "legacy" BIOS mode, assuming /dev/sdX is the
 ;; target hard disk, and "my-root" is the label of the target
 ;; root file system.
 (bootloader (bootloader-configuration
              (bootloader grub-bootloader)
              (target "/dev/sda")))
 (file-systems (cons (file-system
                      (device (file-system-label "root"))
                      (mount-point "/")
                      (type "ext4"))
                     %base-file-systems))

 ;; This is where user accounts are specified.  The "root"
 ;; account is implicit, and is initially created with the
 ;; empty password.
 (users (cons (user-account
               (name "w96k")
               (group "users")

               ;; Adding the account to the "wheel" group
               ;; makes it a sudoer.  Adding it to "audio"
               ;; and "video" allows the user to play sound
               ;; and access the webcam.
               (supplementary-groups '("wheel" "netdev"
                                       "audio" "video"))
               (home-directory "/home/w96k"))
              %base-user-accounts))

 ;; Globally-installed packages.

 (packages
  (append
   (map specification->package
        '(
          "curl"
          "stow"
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
          "xf86-video-intel"
          "x86-energy-perf-policy"
          "rxvt-unicode"
          "node"
          "ruby"
          "bundler"
          "nix"
          "postgresql"))
   %base-packages))

 ;; Use the "desktop" services, which include the X11
 ;; log-in service, networking with NetworkManager, and more.
 (services
  (cons*
   (postgresql-service #:extension-packages (list postgis))
   (service openssh-service-type)
   ;;   (service dhcpd-service-type 
   ;;	(dhcpd-configuration
   ;;		(interfaces '("enp0s25"))))

   ;;   (service dhcp-client-service-type)
   ;;(service zabbix-server-service-type)
   %base-services))

 ;; Allow resolution of '.local' host names with mDNS.
 (name-service-switch %mdns-host-lookup-nss))
