{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    development.enable = lib.mkEnableOption "enables additional development tools";
  };
  config = lib.mkIf config.development.enable {
    home.packages = with pkgs; [
      tmux
      docker
      podman
      opencode
      lua54Packages.luarocks
      rustc
      cargo
      tokei
      gh
      tldr
      rust-analyzer
      rustfmt
      clippy
      lld
      act
      lsof
      hyperfine
      nodejs_22
      pyenv
      python3
      uv
      go
      gopls
      gofumpt
      golangci-lint
      crystal
      shards
      crystalline
      gcc
      gnumake
      unzip
      wget
      curl
      ripgrep
      go-task
      fd
      fzf
      alejandra
      jq
      bat
      vscode
      zig
      zls
      terraform
      qmk
      via
      cockroachdb
      keymapp
      hyprshot
      xh
      httpie-desktop
      eza
      mprocs
      claude-code
      nethack
    ];

    # Global golangci-lint configuration
    home.file.".config/golangci-lint/config.yml".text = ''
      version: "2"

      run:
        timeout: 5m
        tests: true
        modules-download-mode: readonly

      linters:
        enable:
          - gosec          # Security vulnerability scanner
          - errorlint      # Error wrapping best practices
          - bodyclose      # HTTP response body closure
          - sqlclosecheck  # SQL connection closure
          - nilerr         # nil error return bugs
          - rowserrcheck   # SQL Rows.Err() checking
          
          - gocritic       # 100+ checks for bugs, performance, style
          - exhaustive     # Switch exhaustiveness for enums
          - unconvert      # Unnecessary type conversions
          - unparam        # Unused function parameters
          - misspell       # Spell checking
          - revive         # Comprehensive Go linter
          - noctx          # Missing context.Context usage
          - makezero       # Slice declaration bugs
          - modernize      # Modern Go code practices
          
          - dupword        # Duplicate word detection
          - goconst        # Repeated constant strings

        disable:
          - unused         # gopls already detects unused code

        settings:
          gosec:
            excludes:
              - G104  # Duplicates errcheck
          
          revive:
            rules:
              - name: blank-imports
              - name: context-as-argument
              - name: context-keys-type
              - name: dot-imports
              - name: error-return
              - name: error-strings
              - name: error-naming
              - name: exported
              - name: increment-decrement
              - name: var-naming
              - name: range
              - name: receiver-naming
              - name: time-naming
              - name: unexported-return
              - name: indent-error-flow
              - name: errorf
              - name: empty-block
              - name: superfluous-else
              - name: unreachable-code
              - name: redefines-builtin-id
              - name: atomic
              - name: defer

          gocritic:
            enabled-tags:
              - diagnostic
              - style
              - performance
              - opinionated

          modernize:
            disable:
              - any
              - rangeint
              - stringsbuilder

        exclusions:
          rules:
            - path: _test\.go
              linters:
                - gosec
                - noctx

      issues:
        max-issues-per-linter: 0
        max-same-issues: 0
    '';

  };
}
