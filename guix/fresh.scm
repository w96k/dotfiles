;; This is an operating system configuration generated
;; by the graphical installer.

(use-modules (gnu)
	     (srfi srfi-1))

;;(use-modules (non-gnu packages lua-fennel))
(use-service-modules
 desktop
 networking
 ssh
 xorg
 sound
 dbus
 nix)
(use-package-modules wm lisp bash fonts)

(operating-system
 (locale "ru_RU.utf8")
 (timezone "Europe/Moscow")
 (keyboard-layout
  (keyboard-layout
   "us,ru"
   #:options
   '("grp:win_space_toggle"
     "caps:ctrl_modifier"
     )))
 (host-name "libreboot-x200t")
 (users (cons* (user-account
		(name "w96k")
		(comment "Mikhail Kirillov")
		(group "users")
		(home-directory "/home/w96k")
		(supplementary-groups
		 '("wheel" "netdev" "audio" "video")))
	       %base-user-accounts))
 (packages
  (append
   (map specification->package
	'("ratpoison"
	  "xterm"
	  "stumpwm"
	  "nix"
	  "nss-certs"
	  "glibc-utf8-locales"
	  "font-dejavu"
	  "font-terminus"
	  "font-fira-code"
	  "font-fira-mono"))
   (list sbcl stumpwm `(,stumpwm "lib"))
   %base-packages))

 (services (cons*
	    (service openssh-service-type)
	    (service tor-service-type)

	       ;;Wacom tablet support
	    (service inputattach-service-type
		     (inputattach-configuration
		      (device "/dev/ttyS4")
		      (device-type "wacom")))

	    (extra-special-file "/bin/bash"
				(file-append bash "/bin/bash"))

	    (service nix-service-type)
	    (set-xorg-configuration
              (xorg-configuration
                (keyboard-layout keyboard-layout)))
	    %desktop-services))

 (bootloader
  (bootloader-configuration
   (bootloader grub-bootloader)
   (target "/dev/sda")
   (keyboard-layout keyboard-layout)))
 (swap-devices (list "/dev/sda1"))
 (file-systems
    (cons* (file-system
             (mount-point "/")
             (device
               (uuid "c184f446-df67-4103-b28e-465ac8776f10"
                     'ext4))
             (type "ext4"))
	   (file-system
             (mount-point "/media/hdd/")
             (device
               (uuid "71cb0818-baf3-4f7f-8bc2-7e2b0cca3488"
                     'ext4))
             (type "ext4"))
	   
           %base-file-systems)))
