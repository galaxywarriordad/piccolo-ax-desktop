config BR2_PACKAGE_GHEX
	bool "ghex"
	depends on BR2_PACKAGE_LIBGTK3
	depends on BR2_USE_WCHAR
	depends on BR2_TOOLCHAIN_HAS_THREADS
	help
	  Lightweight GTK3 hex and binary editor for inspecting ROM
	  headers, save states, and raw binary files.

	  https://gitlab.gnome.org/GNOME/ghex

comment "ghex needs a GTK3 backend and a toolchain w/ wchar, threads"
	depends on !BR2_PACKAGE_LIBGTK3 || !BR2_USE_WCHAR || !BR2_TOOLCHAIN_HAS_THREADS
