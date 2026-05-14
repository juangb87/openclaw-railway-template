FROM node:24-bookworm

ARG OPENCLAW_VERSION=2026.5.12
ENV PORT=8080
ENV OPENCLAW_ENTRY=/usr/local/lib/node_modules/openclaw/openclaw.mjs

RUN apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    git \
    gosu \
    procps \
    python3 \
    build-essential \
    zip \
  && rm -rf /var/lib/apt/lists/*

RUN npm install -g "openclaw@${OPENCLAW_VERSION}"

WORKDIR /app

COPY package.json pnpm-lock.yaml ./
RUN corepack enable \
  && pnpm install --frozen-lockfile --prod

COPY src ./src
COPY --chmod=755 entrypoint.sh ./entrypoint.sh

RUN useradd -m -s /bin/bash openclaw \
  && chown -R openclaw:openclaw /app \
  && mkdir -p /data \
  && chown -R openclaw:openclaw /data

EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=5s --start-period=30s \
  CMD curl -f http://localhost:8080/setup/healthz || exit 1

ENTRYPOINT ["./entrypoint.sh"]
