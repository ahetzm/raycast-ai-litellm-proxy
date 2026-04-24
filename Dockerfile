FROM node:22-slim AS base
WORKDIR /app
RUN corepack enable
COPY package.json pnpm-lock.yaml ./
ARG NPM_REGISTRY=https://registry.npmjs.org/
RUN pnpm config set registry ${NPM_REGISTRY} \
 && pnpm install --frozen-lockfile
COPY . .
RUN pnpm run build

FROM node:22-slim
WORKDIR /app
RUN corepack enable
COPY package.json pnpm-lock.yaml ./
ARG NPM_REGISTRY=https://registry.npmjs.org/
ENV NODE_ENV=production
RUN pnpm config set registry ${NPM_REGISTRY} \
 && pnpm install --frozen-lockfile --prod
COPY --from=base /app/dist ./dist
CMD ["pnpm", "start"]
