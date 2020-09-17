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
RUN mkdir -p /js-ipfs
WORKDIR /js-ipfs
RUN npm install --save ipfs-http-client
COPY --from=build-stage /app /image
RUN mkdir -p /out/x86_64
COPY rootfs.cid /out/x86_64/rootfs.cid
COPY kernel.cid /out/x86_64/kernel.cid
COPY upload.js /js-ipfs
RUN mksquashfs /image /out/x86_64/app.img -reproducible -comp gzip
RUN node upload.js > /out.cid

FROM scratch AS export-stage
COPY --from=image-stage /out.cid /
COPY --from=image-stage /out/ /