FROM node:14.7.0-alpine3.10 AS node

ARG ENV=prod
ARG APP=my-app

ENV ENV ${ENV}
ENV APP ${APP}

RUN npm install -g npm

WORKDIR /app
COPY ./ /app/

RUN npm ci
RUN npm run build --prod
RUN mv /app/dist/${APP}/* /app/dist/


COPY . ./
RUN node_modules/.bin/ng build --prod

FROM nginx:1.13.8-alpine

COPY --from=node /app/dist/ /usr/share/nginx/html
COPY nginx.conf /etc/nginx/nginx.conf