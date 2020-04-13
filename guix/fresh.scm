;; This is an operating system configuration generated
;; by the graphical installer.

(use-modules (gnu))
(use-service-modules desktop networking ssh xorg)

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
   (list (specification->package "ratpoison")
	 (specification->package "xterm")
	 (specification->package "nss-certs"))
   %base-packages))
 (services
  (append
   (list (service xfce-desktop-service-type)
	 (service openssh-service-type)
	 (service tor-service-type)
	 (set-xorg-configuration
	  (xorg-configuration
	   (keyboard-layout keyboard-layout))))
   %desktop-services))
 (bootloader
  (bootloader-configuration
   (bootloader grub-bootloader)
   (target "/dev/sda")
   (keyboard-layout keyboard-layout)))
 (mapped-devices
  (list (mapped-device
	 (source
	  (uuid "84d2acc1-048c-4bae-b776-1f888c364a66"))
	 (target "cryptroot")
	 (type luks-device-mapping))))
 (file-systems
  (cons* (file-system
	  (mount-point "/")
	  (device "/dev/mapper/cryptroot")
	  (type "ext4")
	  (dependencies mapped-devices))
	 %base-file-systems)))
