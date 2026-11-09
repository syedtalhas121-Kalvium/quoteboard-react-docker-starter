# Stage 1: install dependencies and build the Vite application.
FROM node:22-alpine AS build
WORKDIR /app

# Copy manifests first so Docker can cache dependency installation.
COPY package*.json ./
RUN npm ci

COPY . .
RUN npm run build

# Stage 2: serve only the compiled static assets with Nginx.
FROM nginx:alpine AS serve
COPY --from=build /app/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
