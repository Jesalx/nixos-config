{
  pkgs,
  lib,
  config,
  ...
}:
{
  options = {
    wofi.enable = lib.mkEnableOption "enables custom wofi config";
  };
  config = lib.mkIf config.wofi.enable {
    programs.wofi = {
      enable = true;
      settings = {
        show = "drun";
        width = 700;
        lines = 8;
        dynamic_lines = false;
        always_parse_args = true;
        print_command = true;
        layer = "overlay";
        insensitive = true;
        prompt = "Search...";
        allow_images = true;
        matching = "multi-contains";
      };
      style = # css
        ''
          @define-color background #0d0e0d;
          @define-color foreground #e5e0dc;

          * {
            background: transparent;
            border: none;
            outline: none;
            box-shadow: none;
          }

          window {
            font-size: 20px;
            font-family: "JetBrainsMono NF";
            background-color: alpha(@background, 0.8);
            color: alpha(@foreground, 1.0);
            border-radius: 8;
          }

          #entry {
            padding: 1rem;
          }

          #entry:selected {
            background-color: alpha(@foreground, 1.0);
            border-radius: 8;
          }


          #text:selected {
            color: @background;
          }

          #input {
            background-color: transparent;
            color: alpha(@foreground, 1.0);
            padding: 1rem;
            border-radius: 8;
          }

          image {
            margin: 0 1rem;
          }
        '';
    };
  };
}
