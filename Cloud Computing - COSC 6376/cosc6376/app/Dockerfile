FROM node:18 as builder
WORKDIR /app
COPY . .
RUN yarn install --frozen-lockfile
RUN yarn build

FROM node:18 as production_modules
WORKDIR /app
COPY --from=builder /app/package.json .
COPY --from=builder /app/yarn.lock .
RUN yarn install --frozen-lockfile --production

FROM node:18
WORKDIR /app
COPY --from=builder /app/build ./build
COPY --from=production_modules /app/node_modules ./node_modules
CMD ["node", "build/index.js"]
ENV PORT 80
EXPOSE 80
