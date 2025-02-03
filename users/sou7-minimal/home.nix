{pkgs, ...}: {
  programs.home-manager.enable = true;

  home = {
    username = "sou7";
    homeDirectory = "/home/sou7";
    stateVersion = "24.11";
    packages = with pkgs; [
      vim
      git
      bottom
    ];
  };

  programs.bash = {
    enable = true;
    sessionVariables = {
      HISTSIZE = 100000;
    };
    shellAliases = {
      ll = "ls -lhv --color=auto '--time-style=+%Y-%m-%d %H-%M-%S'";
      l = "ls -1shv";
      g = "git";
      s = "git st";
      d = "git diff";
      a = "git add";
      c = "git commit";
      l1 = "git l1";
    };
  };

  programs.git = {
    enable = true;
    userName = "sou7";
    userEmail = "soukouki0@yahoo.co.jp";
    aliases = {
      st = "status -s";
      br = "branch";
      me = "merge";
      co = "checkout";
      nb = "checkout -b";
      cp = "cherry-pick";
      l1 = "log --graph --date=short --decorate=short --pretty=format:'%Cgreen%h %Creset%cd %Cblue%cn %Cred%d %Creset%s'";
      ac = "!f(){ git status -s; git add .; git commit -m \"$1\"; }; f";
    };
  };
}
