FROM microsoft/dotnet:2.2-aspnetcore-runtime AS base
WORKDIR /app

FROM microsoft/dotnet:2.2-sdk AS build
WORKDIR /src
COPY userService.csproj userService/
RUN dotnet restore userService/userService.csproj
WORKDIR /src/userService
COPY . .
RUN dotnet build userService.csproj -c Release -o /app

FROM build AS publish
RUN dotnet publish userService.csproj -c Release -o /app

FROM base AS final
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "userService.dll"]
