FROM node:alpine AS builder
RUN mkdir -p /app
WORKDIR /app
COPY package.json package-lock.json /app
RUN apk add g++ gcc make python
RUN npm install

FROM node:alpine AS build-stage
COPY --from=builder /app/node_modules /app/node_modules
COPY *.mjs /app/
COPY start /app/start
RUN chmod +x /app/start
FROM node:alpine AS image-stage
RUN apk add squashfs-tools
COPY --from=build-stage /app /image
RUN mkdir -p /out/x86_64
COPY rootfs.cid /out/x86_64/rootfs.cid
COPY kernel.cid /out/x86_64/kernel.cid
RUN mksquashfs /image /out/x86_64/app.img -reproducible -comp gzip
FROM scratch AS export-stage
COPY --from=image-stage /out/ /