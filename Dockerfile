ARG NET_IMAGE=5.0
FROM mcr.microsoft.com/dotnet/aspnet:${NET_IMAGE} AS base
WORKDIR /app

EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:${NET_IMAGE} AS build
WORKDIR /src

COPY ["AeroNaves.webApi/AeroNaves.webApi.csproj", "AeroNaves.webApi/"]
COPY ["Aeronave.Infraestructure/Aeronave.Infraestructure.csproj", "Aeronave.Infraestructure/"]
COPY ["Aeronaves.Aplication/Aeronaves.Aplication.csproj", "Aeronaves.Aplication/"]
COPY ["Aeronaves.Domain/Aeronaves.Domain.csproj", "Aeronaves.Domain/"]
COPY ["ShareKernel/ShareKernel.csproj", "ShareKernel/"]

#COPY ["AeroNaves.webApi", "./AeroNaves.webApi/"]
#COPY ["ShareKernel", "./ShareKernel/"]

RUN dotnet restore "AeroNaves.webApi/AeroNaves.webApi.csproj"
COPY . .
WORKDIR "/src/AeroNaves.webApi"
RUN dotnet build "AeroNaves.webApi.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "AeroNaves.webApi.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "AeroNaves.webApi.dll"]
