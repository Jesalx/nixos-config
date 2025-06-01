{
  pkgs,
  lib,
  config,
  userConfig,
  ...
}:

let
  sshKeyPath = "${config.home.homeDirectory}/.ssh/id_ed25519.pub";
  safeReadFile = path: if builtins.pathExists path then builtins.readFile path else "";
  createAllowedSigners =
    keyPath:
    let
      keyContent = safeReadFile keyPath;
    in
    if keyContent != "" then "${userConfig.gitEmail} ${keyContent}" else "";
in
{
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

        ui = {
          editor = "nvim";
          paginate = "never";
          default-command = "log";
          diff-editor = ":builtin";
        };

        git = {
          private-commits = "description(glob:'private:*')";
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
      lazyjj
    ];
  };
}

