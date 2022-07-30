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

COPY ["Pedidos.WebApi", "./Pedidos.WebApi/"]
COPY ["ShareKernel", "./ShareKernel/"]

RUN dotnet restore "Pedidos.WebApi/Pedidos.WebApi.csproj"
COPY . .
WORKDIR "/src/Pedidos.WebApi"
RUN dotnet build "Pedidos.WebApi.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "Pedidos.WebApi.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "Pedidos.WebApi.dll"]

