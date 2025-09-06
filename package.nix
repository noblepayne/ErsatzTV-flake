{
  lib,
  buildDotnetModule,
  dotnetCorePackages,
  fetchFromGitHub,
  ffmpeg,
  fontconfig,
}:
buildDotnetModule rec {
  pname = "ersatztv";
  version = "25.5.0"; # sync with upstream release

  src = fetchFromGitHub {
    owner = "ErsatzTV";
    repo = "ErsatzTV";
    rev = "v${version}";
    hash = "sha256-Q9ugAqEjH6CWyOCmC2bxXsF460sb3eyzHwvvz8lm3Qk=";
  };

  nugetDeps = ./deps.json;

  dotnet-sdk = dotnetCorePackages.sdk_9_0;
  #dotnet-runtime = dotnetCorePackages.runtime_9_0;
  dotnet-runtime = dotnetCorePackages.aspnetcore_9_0;

  buildType = "Release";
  selfContainedBuild = false;
  projectFile = "${src}/ErsatzTV/ErsatzTV.csproj";
  dontConfigure = true;

  # don’t build tests or platform-specific projects
  postPatch = ''
    rm -rf .config
    #rm -rf ErsatzTV.*.Tests

    # remove test projects from solution
    #sed -i '/ErsatzTV.Core.Tests/d' ErsatzTV.sln
    #sed -i '/ErsatzTV.FFmpeg.Tests/d' ErsatzTV.sln
    #sed -i '/ErsatzTV.Infrastructure.Tests/d' ErsatzTV.sln
    #sed -i '/ErsatzTV.Scanner.Tests/d' ErsatzTV.sln
  '';

  buildPhase = ''
    runHook preBuild

    # restore offline
    #dotnet restore ErsatzTV/ErsatzTV.csproj --packages ./_nix/restore --runtime linux-x64
    #dotnet restore ErsatzTV.Scanner/ErsatzTV.Scanner.csproj --packages ./_nix/restore --runtime linux-x64

    # publish projects
    #dotnet publish ErsatzTV.Scanner/ErsatzTV.Scanner.csproj -c release -o build-out -r linux-x64 --self-contained false /p:DebugType=Embedded /p:InformationalVersion=${version}
    #sed -i '/Scanner/d' ErsatzTV/ErsatzTV.csproj
    dotnet publish ErsatzTV/ErsatzTV.csproj -c release -o build-out -r linux-x64 --self-contained false /p:DebugType=Embedded /p:InformationalVersion=${version}

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    cp -rT build-out $out
    mkdir -p $out/bin

    wrapDotnetProgram $out/ErsatzTV $out/bin/ErsatzTV
    wrapDotnetProgram $out/ErsatzTV.Scanner $out/bin/ErsatzTV.Scanner
    runHook postInstall
  '';

  runtimeDeps = [ffmpeg fontconfig];

  meta = with lib; {
    description = "ErsatzTV – stream media as live TV channels";
    homepage = "https://github.com/ErsatzTV/ErsatzTV";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; []; # add yourself
    platforms = platforms.linux;
    mainProgram = "ErsatzTV";
  };
}
