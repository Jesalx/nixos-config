{
  pkgs,
  lib,
  config,
  userConfig,
  ...
}: let
  sshKeyPath = "${config.home.homeDirectory}/.ssh/id_ed25519.pub";
  safeReadFile = path:
    if builtins.pathExists path
    then builtins.readFile path
    else "";
  createAllowedSigners = keyPath: let
    keyContent = safeReadFile keyPath;
  in
    if keyContent != ""
    then "${userConfig.gitEmail} ${keyContent}"
    else "";
in {
  options = {
    jujutsu.enable = lib.mkEnableOption "enables custom jujutsu config";
  };
  config = lib.mkIf config.git.enable {
    home.file.".ssh/allowed_signers".text = lib.mkDefault (createAllowedSigners sshKeyPath);
    programs.jujutsu = {
      enable = true;
      settings = {
        user = {
          name = "Jesal Patel";
          email = userConfig.gitEmail;
        };

        aliases = {
          init = ["git" "init"];
        };

        ui = {
          editor = "nvim";
          paginate = "never";
          default-command = "log";
          diff-editor = ":builtin";
          # doing this weirdly to avoid delta returning exit code 1 and getting a warning
          diff-formatter = ["bash" "-c" "delta \"$left\" \"$right\" --file-transformation 's|.*/jj-diff-[^/]*/[^/]*/||' || true" "--"];
        };

        "--scope" = [
          {
            "--when" = {
              commands = ["diff"];
            };
            ui = {
              paginate = "auto";
            };
          }
        ];

        git = {
          private-commits = "description(glob:'private:*')";
        };

       remotes = {
          origin = {
            auto-track-bookmarks = "glob:*";
          };
        };

        signing = {
          behavior = "own";
          backend = "ssh";
          key = sshKeyPath;
          backends.ssh.allowedSigners = "${config.home.homeDirectory}/.ssh/allowed_signers";
        };
      };
    };

    home.packages = with pkgs; [
      jjui
      delta
    ];
  };
}
