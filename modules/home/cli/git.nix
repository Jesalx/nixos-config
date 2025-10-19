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
    git.enable = lib.mkEnableOption "enables custom git config";
    lazygit.enable = lib.mkEnableOption "enables custom lazygit config";
  };
  config = lib.mkIf config.git.enable {
    home.file.".ssh/allowed_signers".text = lib.mkDefault (createAllowedSigners sshKeyPath);
    programs.git = {
      enable = true;
      settings = {
        user.name = "Jesal Patel";
        user.email = userConfig.gitEmail;
        user.signingkey = sshKeyPath;
        core.editor = "nvim";
        github.user = "jesalx";
        push.autoSetupRemote = true;
        color.ui = "auto";
        init.defaultBranch = "main";

        # Sign commits using ssh key
        commit.gpgsign = true;
        gpg.format = "ssh";
        gpg.ssh.allowedSignersFile = "${config.home.homeDirectory}/.ssh/allowed_signers";
      };
    };

    programs.lazygit = lib.mkIf config.lazygit.enable {
      enable = true;
      settings = {
        promptToReturnFromSubprocess = false;
      };
    };
  };
}
