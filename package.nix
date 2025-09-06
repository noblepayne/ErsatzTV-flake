{
  lib,
  buildDotnetModule,
  dotnetCorePackages,
  fetchFromGitHub,
  ffmpeg-full,
  ffmpeg-pkg ? ffmpeg-full,
  fontconfig,
}:
buildDotnetModule rec {
  pname = "ErsatzTV";
  version = "25.5.0";

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

  # Only installs jetbrains.resharper.globaltools which is not needed at runtime.
  postPatch = ''
    rm -rf .config/dotnet-tools.json
  '';

  makeWrapperArgs = ["--prefix" "PATH" ":" "${lib.makeBinPath [ffmpeg-pkg]}"];

  executables = ["ErsatzTV"];

  meta = with lib; {
    description = "ErsatzTV – Stream custom live channels using your own media";
    homepage = "https://github.com/ErsatzTV/ErsatzTV";
    license = licenses.zlib;
    platforms = platforms.linux;
    mainProgram = "ErsatzTV";
  };
}
