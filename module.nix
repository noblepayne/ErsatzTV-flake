{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  options = {
    services.ersatztv = {
      enable = mkEnableOption "ersatztv, stream custom live channels using your own media library";
      package = mkOption {
        type = types.package;
      };
      enableFonts = mkOption {
        type = types.bool;
        default = true;
        description = "Whether to install subtitle fonts for ErsatzTV (required for ffmpeg subtitle rendering).";
      };
      user = mkOption {
        type = types.str;
        default = "ersatztv";
        description = "User account under which the ErsatzTV service runs.";
      };
      group = mkOption {
        type = types.str;
        default = "ersatztv";
        description = "Group under which the ErsatzTV service runs.";
      };
      uiPort = mkOption {
        type = types.port;
        default = 8409;
        description = "Port to listen for UI connections. Default: 8409.";
      };
      streamingPort = mkOption {
        type = types.port;
        default = 8409;
        description = "Port to listen for streaming connections. Default: 8409. Note: defaults to same as uiPort.";
      };
      bindReadOnlyPaths = mkOption {
        type = types.listOf types.str;
        default = [];
        description = ''
          List of read-only bind mount paths in systemd format (source:target:options with target and options optional).

          See https://www.freedesktop.org/software/systemd/man/latest/systemd.exec.html#BindPaths=
        '';
        example = literalExpression ''
          [
            "/home/user/Videos:/media/userVideos"
            "/mnt/archive/tv:/media/tv"
          ]
        '';
      };
      extraEnvironment = lib.mkOption {
        description = ''
          Environment variables to pass to ErsatzTV.

          See https://github.com/ErsatzTV/ErsatzTV/blob/main/ErsatzTV.Core/SystemEnvironment.cs
        '';
        type = types.attrsOf lib.types.str;
        default = {};
        example = literalExpression ''
          {
            ETV_BASE_URL = "/myCustomErsatz";
          }
        '';
      };
    };
  };
  cfg = config.services.ersatztv;
  env = mkMerge [
    {
      HOME = "/var/lib/ersatztv";
      ETV_CONFIG_FOLDER = "/var/lib/ersatztv";
      ETV_UI_PORT = toString cfg.uiPort;
      ETV_STREAMING_PORT = toString cfg.streamingPort;
    }
    cfg.extraEnvironment
  ];
in {
  inherit options;

  config = mkIf cfg.enable {
    # For subtitles with ffmpeg
    fonts = mkIf cfg.enableFonts {
      fontconfig.enable = true;
      packages = [
        # These match what the Docker image uses
        pkgs.noto-fonts
        pkgs.noto-fonts-cjk-sans
      ];
    };
    users.groups.${cfg.group} = {};
    users.users.${cfg.user} = {
      isSystemUser = true;
      group = cfg.group;
    };

    systemd.services.ersatztv = {
      description = "ErsatzTV";
      wantedBy = ["multi-user.target"];
      after = ["network.target"];
      environment = env;
      serviceConfig = {
        ExecStart = "${getExe cfg.package}";
        User = cfg.user;
        Group = cfg.group;
        Restart = "on-failure";
        RestartSec = 10;
        StateDirectory = "ersatztv";
        WorkingDirectory = "/var/lib/ersatztv";
        LockPersonality = true;
        NoNewPrivileges = true;
        BindReadOnlyPaths = cfg.bindReadOnlyPaths;
      };
    };
  };
}
