FROM node:lts-alpine as dev
WORKDIR /app
COPY package.json ./
RUN yarn install
CMD ["yarn","start:dev"]

FROM node:lts-alpine as dev-deps
WORKDIR /app
COPY package.json package.json
RUN yarn install --frozen-lockfile --network-timeout 100000


FROM node:lts-alpine as builder
WORKDIR /app
COPY --from=dev-deps /app/node_modules ./node_modules
COPY . .
# RUN yarn test
RUN yarn build

FROM node:lts-alpine as prod-deps
WORKDIR /app
COPY package.json package.json
RUN yarn install --prod --frozen-lockfile --network-timeout 100000


FROM node:lts-alpine as prod
EXPOSE 3000
WORKDIR /app
COPY --from=prod-deps /app/node_modules ./node_modules
COPY --from=builder /app/dist ./dist

CMD [ "node","dist/src/main.js"]