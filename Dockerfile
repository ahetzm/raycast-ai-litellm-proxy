FROM node:24-slim AS build
WORKDIR /app
COPY package.json pnpm-lock.yaml ./
ARG NPM_REGISTRY=https://registry.npmjs.org/
RUN npm config set registry ${NPM_REGISTRY} \
 && npm install -g pnpm@10.33.0 \
 && pnpm config set registry ${NPM_REGISTRY} \
 && pnpm install --frozen-lockfile
COPY . .
RUN pnpm run build \
 && pnpm prune --prod

FROM node:24-slim
WORKDIR /app
ENV NODE_ENV=production
COPY --from=build /app/package.json ./package.json
COPY --from=build /app/node_modules ./node_modules
COPY --from=build /app/dist ./dist
EXPOSE 3000
CMD ["node", "dist/index.js"]
