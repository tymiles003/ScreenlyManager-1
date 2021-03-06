# Get build image
FROM mcr.microsoft.com/dotnet/core/sdk:2.2 AS build-stage
WORKDIR /app

# Copy source
COPY . ./

# Publish
RUN dotnet publish -c Release -o "/app/publish/"

# Get runtime image
FROM mcr.microsoft.com/dotnet/core/runtime:2.2 AS publish-stage
WORKDIR /app

# Bring in metadata via --build-arg
ARG BRANCH=unknown
ARG IMAGE_CREATED=unknown
ARG IMAGE_REVISION=unknown
ARG IMAGE_VERSION=unknown

# Configure image labels
LABEL branch=$branch \
    maintainer="Maricopa County Library District developers <development@mcldaz.org>" \
    org.opencontainers.image.authors="Maricopa County Library District developers <development@mcldaz.org>" \
    org.opencontainers.image.created=$IMAGE_CREATED \
    org.opencontainers.image.description="ScreenlyManager provides a command-line interface for working with the Screenly OSE API." \
    org.opencontainers.image.documentation="https://github.com/mcld/ScreenlyManager/" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.revision=$IMAGE_REVISION \
    org.opencontainers.image.source="https://github.com/mcld/ScreenlyManager/" \
    org.opencontainers.image.title="ScreenlyManager" \
    org.opencontainers.image.url="https://github.com/mcld/ScreenlyManager/" \
    org.opencontainers.image.vendor="Maricopa County Library District" \
    org.opencontainers.image.version=$IMAGE_VERSION

# Default image environment variable settings
ENV org.opencontainers.image.created=$IMAGE_CREATED \
    org.opencontainers.image.revision=$IMAGE_REVISION \
    org.opencontainers.image.version=$IMAGE_VERSION

# Copy source
COPY --from=build-stage "/app/publish/" .

# Set entrypoint
ENTRYPOINT ["dotnet", "ScreenlyManager.dll"]
