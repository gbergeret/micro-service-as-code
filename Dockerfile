FROM node:8.12-alpine

USER node:node
COPY app.js package.json package-lock.json /home/node/

WORKDIR /home/node

RUN npm install

EXPOSE 3000
ENTRYPOINT ["node", "app.js"]
