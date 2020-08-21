FROM mcr.microsoft.com/dotnet/core/aspnet:3.0-buster-slim AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/core/sdk:3.0-buster AS build
WORKDIR /app
COPY ["app/aspnet-k8s.csproj", "aspnet-k8s/"]
RUN dotnet restore "aspnet-k8s/aspnet-k8s.csproj"
COPY . .
WORKDIR /app
RUN dotnet build "aspnet-k8s.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "aspnet-k8s.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "aspnet-k8s.dll"]