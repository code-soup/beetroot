# Use official Ubuntu 24.04 LTS base image
FROM ubuntu:24.04

# Set non-interactive mode for apt
ENV DEBIAN_FRONTEND=noninteractive

# Update and install necessary packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    wget \
    unzip \
    zip \
    git \
    software-properties-common \
    lsb-release \
    python3 \
    python3-pip \
    python3-requests \
    python3-aiohttp \
    php \
    php-cli \
    php-xml \
    php-curl \
    openssh-client && \
    rm -rf /var/lib/apt/lists/*

# Ensure Python and Composer are accessible system-wide
RUN ln -sf /usr/bin/python3 /usr/bin/python && \
    ln -sf /usr/bin/pip3 /usr/bin/pip && \
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && \
    echo 'export PATH="/usr/local/bin:/usr/bin:$PATH"' >> /etc/profile && \
    echo 'export PATH="/usr/local/bin:/usr/bin:$PATH"' >> /etc/environment

# Install Node.js 23
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y --no-install-recommends nodejs && \
    rm -rf /var/lib/apt/lists/*

# Install Yarn
RUN curl -fsSL https://dl.yarnpkg.com/debian/pubkey.gpg | gpg --dearmor -o /usr/share/keyrings/yarn.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/yarn.gpg] https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update && apt-get install -y --no-install-recommends yarn && \
    rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app