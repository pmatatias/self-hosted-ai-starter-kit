FROM n8nio/n8n:1.77.2

USER root

# Install Chromium and dependencies
RUN apk add --no-cache \
    chromium \
    nss \
    freetype \
    harfbuzz \
    ca-certificates \
    ttf-freefont \
    dumb-init

# Install Puppeteer
RUN yarn add puppeteer@19.11.1

# Add user to chrome-render group
RUN addgroup -S chrome-render \
    && adduser node chrome-render

# Create required directories and set permissions
RUN mkdir -p /home/node/.cache/puppeteer \
    && chown -R node:node /home/node/.cache \
    && chmod -R 777 /home/node/.cache

ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
    PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser \
    CHROME_BIN=/usr/bin/chromium-browser \
    CHROME_PATH=/usr/lib/chromium/ \
    PUPPETEER_ARGS="--no-sandbox,--disable-setuid-sandbox,--disable-dev-shm-usage"

USER node