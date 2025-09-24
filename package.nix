{
  buildDotnetModule,
  dotnetCorePackages,
  fetchFromGitHub,
  ffmpeg-full,
  ffmpeg-pkg ? ffmpeg-full,
  fontconfig,
  lib,
  version ? "25.6.0",
  which,
  ...
}:
buildDotnetModule {
  pname = "ersatztv";
  inherit version;

  src = fetchFromGitHub {
    owner = "ErsatzTV";
    repo = "ErsatzTV";
    rev = "v${version}";
    hash = "sha256-pxo+RGpXVQUwYwp/POje4en6c9vfMYBO1ZNnZwt2DVM=";
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
  makeWrapperArgs = ["--prefix" "PATH" ":" "${lib.makeBinPath [ffmpeg-pkg which]}"];

  executables = ["ErsatzTV" "ErsatzTV.Scanner"];

  meta = with lib; {
    description = "Stream custom live channels using your own media";
    homepage = "https://github.com/ErsatzTV/ErsatzTV";
    license = licenses.zlib;
    platforms = platforms.linux;
    mainProgram = "ErsatzTV";
  };
}
