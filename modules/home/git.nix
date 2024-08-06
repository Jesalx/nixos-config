{ config, lib, ... }:

let
  homeDir = config.home.homeDirectory;
  sshKeyPath = "${homeDir}/.ssh/id_ed25519.pub";
  safeReadFile = path: if builtins.pathExists path then builtins.readFile path else "";
  gitEmail = "jesalx@users.noreply.github.com";
  createAllowedSigners =
    keyPath:
    let
      keyContent = safeReadFile keyPath;
      email = gitEmail;
    in
    if keyContent != "" then "${email} ${keyContent}" else "";
in
{
  config = {
    home.file.".ssh/allowed_signers".text = lib.mkDefault (createAllowedSigners sshKeyPath);
    programs.git = {
      enable = true;
      userName = "Jesal Patel";
      userEmail = gitEmail;
      extraConfig = {
        core.editor = "nvim";
        github.user = "jesalx";
        push.autoSetupRemote = true;

        # Sign commits using ssh key
        commit.gpgsign = true;
        gpg.format = "ssh";
        gpg.ssh.allowedSignersFile = "${homeDir}/.ssh/allowed_signers";
        user.signingkey = sshKeyPath;
      };
    };
  };
}
