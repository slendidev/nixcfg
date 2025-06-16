{
	git = {
		enable = true;
		userName = "Slendi";
		userEmail = "slendi@socopon.com";
		extraConfig = {
			gpg.format = "ssh";
			user.signingkey = "~/.ssh/id_ed25519.pub";
		};
	};

	kitty = {
		enable = true;
		extraConfig = ''
		background_opacity 0.8
		mouse_hide_wait 0
		default_pointer_shape arrow
		pointer_shape_when_dragging arrow
		confirm_os_window_close 0
		window_padding_width 4
		map ctrl+shift+k clear_terminal scrollback
		cursor_trail 3
		map ctrl+shift+w none
		'';
	};
}
