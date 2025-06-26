{ ... }:

{
  programs.git = {
    enable = true;
    lfs.enable = true;
    userEmail = "mikastiv@outlook.com";
    userName = "mikastiv";
    diff-so-fancy.enable = true;
    extraConfig = {
      init.defaultBranch = "main";
      branch.sort = "-commiterdate";
      tag.sort = "-taggerdate";
      blame.date = "relative";
      log = {
        abbrevCommit = true;
        graphColors = "blue,yellow,cyan,magenta,green,red";
      };
      "color \"decorate\"" = {
        HEAD = "red";
        branch = "blue";
        tag = "yellow";
        remoteBranch = "magenta";
      };
      "color \"branch\"" = {
        current = "magenta";
        local = "default";
        remote = "yellow";
        upstream = "green";
        plain = "blue";
      };
      pull = {
        rebase = true;
        default = "current";
      };
      push = {
        autoSetupRemote = true;
        default = "current";
        followTags = true;
      };
      rebase = {
        autoStash = true;
        missingCommitsCheck = "warn";
      };
      rerere.enable = true;
      commit.gpgsign = true;
      gpg.format = "ssh";
      user.signingKey = "~/.ssh/id_ed25519_sign.pub";
      core = {
        compression = 9;
        whitespace = "trailing-space,space-before-tab";
        preloadindex = true;
      };
      "url \"git@github.com:/\"".insteadOf = "gh:";
      status = {
        branch = true;
        showStash = true;
        showUntrackedFiles = "all";
      };
    };
    ignores = [
      "*.swp"
      ".direnv"
    ];
  };
}
