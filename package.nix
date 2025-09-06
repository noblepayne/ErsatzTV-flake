{
  lib,
  buildDotnetModule,
  dotnetCorePackages,
  fetchFromGitHub,
  ffmpeg-full,
  ffmpeg-pkg ? ffmpeg-full,
  fontconfig,
  version ? "25.5.0",
}:
buildDotnetModule {
  pname = "ersatztv";
  inherit version;

  src = fetchFromGitHub {
    owner = "ErsatzTV";
    repo = "ErsatzTV";
    rev = "v${version}";
    hash = "sha256-Q9ugAqEjH6CWyOCmC2bxXsF460sb3eyzHwvvz8lm3Qk=";
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

  # ffmpeg is required at runtime
  makeWrapperArgs = ["--prefix" "PATH" ":" "${lib.makeBinPath [ffmpeg-pkg]}"];

  executables = ["ErsatzTV" "ErsatzTV.Scanner"];

  meta = with lib; {
    description = "Stream custom live channels using your own media";
    homepage = "https://github.com/ErsatzTV/ErsatzTV";
    license = licenses.zlib;
    platforms = platforms.linux;
    mainProgram = "ErsatzTV";
  };
}
