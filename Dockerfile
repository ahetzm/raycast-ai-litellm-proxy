FROM node:22-slim AS base
WORKDIR /app
COPY package*.json ./
ARG NPM_REGISTRY=https://registry.npmjs.org/
RUN npm config set registry ${NPM_REGISTRY} \
 && npm config set replace-registry-host always \
 && npm ci --no-audit --no-fund
COPY . .
RUN npm run build

FROM node:22-slim
WORKDIR /app
COPY package*.json ./
ARG NPM_REGISTRY=https://registry.npmjs.org/
ENV NODE_ENV=production
RUN npm config set registry ${NPM_REGISTRY} \
 && npm config set replace-registry-host always \
 && npm ci --omit=dev --no-audit --no-fund
COPY --from=base /app/dist ./dist
CMD ["npm", "start"]
