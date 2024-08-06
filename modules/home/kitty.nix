{ ... }:

{
  config = {
    programs.kitty = {
      enable = true;
      font.name = "JetBrainsMono NF";
      font.size = 12;
      shellIntegration.enableZshIntegration = true;
      settings = {
        enable_audio_bell = false;
        confirm_os_window_close = -1;
      };
    };
  };
}
