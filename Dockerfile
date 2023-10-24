FROM node:alpine
WORKDIR /usr/src/app

COPY package*.json ./
RUN npm install

COPY . .

ARG APP_PORT=8000

EXPOSE ${APP_PORT}
CMD [ "npm", "start" ]
