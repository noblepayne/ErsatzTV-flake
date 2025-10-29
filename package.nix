{
  buildDotnetModule,
  dotnetCorePackages,
  extraRuntimeDeps ? [],
  fetchFromGitHub,
  ffmpeg-full,
  ffmpeg-pkg ? ffmpeg-full,
  fontconfig,
  hash ? "sha256-tCMUjfdk1TEnRD5yjc3GDStoV6uCGhw6e30wNYS8F90=",
  lib,
  libva-utils,
  version ? "25.7.1",
  which,
  withVAAPI ? true,
  ...
}: let
  runtimeDeps = lib.flatten [
    ffmpeg-pkg
    which
    (lib.optional withVAAPI libva-utils)
    extraRuntimeDeps
  ];
  binaryPath = lib.makeBinPath runtimeDeps;
in
  buildDotnetModule {
    pname = "ersatztv";
    inherit version;
    src = fetchFromGitHub {
      owner = "ErsatzTV";
      repo = "ErsatzTV";
      rev = "v${version}";
      inherit hash;
    };
    nugetDeps = ./deps.json;
    projectFile = "./ErsatzTV/ErsatzTV.csproj";
    buildType = "Release";
    dotnet-sdk = dotnetCorePackages.sdk_9_0;
    dotnet-runtime = dotnetCorePackages.aspnetcore_9_0;
    # remove dotnet-tools (jetbrains.resharper.globaltools); not needed at runtime as of v25.5.0
    postPatch = ''
      rm -rf .config/dotnet-tools.json
    '';
    # ffmpeg and which are required at runtime
    makeWrapperArgs = ["--prefix" "PATH" ":" binaryPath];
    executables = ["ErsatzTV" "ErsatzTV.Scanner"];
    meta = with lib; {
      description = "Stream custom live channels using your own media";
      homepage = "https://github.com/ErsatzTV/ErsatzTV";
      license = licenses.zlib;
      platforms = platforms.linux;
      mainProgram = "ErsatzTV";
    };
  }
