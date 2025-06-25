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

  wezterm = {
    enable = true;
    extraConfig = ''
                  return {
                  	enable_scroll_bar = false,
                  	window_background_opacity = 0.8,
                  	hide_mouse_cursor_when_typing = true,
      							enable_tab_bar = false,
                  	window_padding = {
                  		left = 4,
                  		right = 4,
                  		top = 4,
                  		bottom = 4,
                  	},
                  	cursor_blink_rate = 500,
                  	disable_default_key_bindings = false,
                  	keys = {
                  		{ key = "K", mods = "CTRL|SHIFT", action = wezterm.action.ClearScrollback("ScrollbackAndViewport") },
                  		{ key = "W", mods = "CTRL|SHIFT", action = "DisableDefaultAssignment" },
                  	},
                  }
                  		'';
  };
}
