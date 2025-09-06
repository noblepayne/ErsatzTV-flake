#!/usr/bin/env sh

# TODO: upstraem docker does all this, but do we need any of this? Can we restore just from regular directory? What about all the tests?
mkdir -p ./ErsatzTV/
mkdir -p ./ErsatzTV.Application/
mkdir -p ./ErsatzTV.Core/
mkdir -p ./ErsatzTV.FFmpeg/
mkdir -p ./ErsatzTV.Infrastructure/
mkdir -p ./ErsatzTV.Infrastructure.Sqlite/
mkdir -p ./ErsatzTV.Infrastructure.MySql/
mkdir -p ./ErsatzTV.Scanner/

cp ../ErsatzTV/*.csproj ./ErsatzTV/
cp ../ErsatzTV.Application/*.csproj ./ErsatzTV.Application/
cp ../ErsatzTV.Core/*.csproj ./ErsatzTV.Core/
cp ../ErsatzTV.FFmpeg/*.csproj ./ErsatzTV.FFmpeg/
cp ../ErsatzTV.Infrastructure/*.csproj ./ErsatzTV.Infrastructure/
cp ../ErsatzTV.Infrastructure.Sqlite/*.csproj ./ErsatzTV.Infrastructure.Sqlite/
cp ../ErsatzTV.Infrastructure.MySql/*.csproj ./ErsatzTV.Infrastructure.MySql/
cp ../ErsatzTV.Scanner/*.csproj ./ErsatzTV.Scanner/
