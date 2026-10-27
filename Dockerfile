# Stage 1: Build the ASP.NET Core App using .NET SDK
FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /src

# Copy project file and restore dependencies
COPY ["RentLog.csproj", "./"]
RUN dotnet restore "RentLog.csproj"

# Copy remaining source code and publish
COPY . .
RUN dotnet publish "RentLog.csproj" -c Release -o /app/publish

# Stage 2: Run the app in a lightweight ASP.NET runtime
FROM mcr.microsoft.com/dotnet/aspnet:10.0 AS final
WORKDIR /app
COPY --from=build /app/publish .

# Render assigns dynamic ports via the PORT environment variable
ENV PORT=8080
EXPOSE 8080

ENTRYPOINT ["dotnet", "RentLog.dll"]