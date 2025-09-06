# TODO...
{
  fonts.fontconfig.enable = true;
  fonts.packages = with pkgs; [
    # These match what the Docker image uses
    noto-fonts
    noto-fonts-cjk
  ];
}
