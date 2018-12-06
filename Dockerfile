###
# Base Node
##
FROM node:8.12-alpine AS base

USER node:node
WORKDIR /home/node

###
# Dependencies
##
FROM base AS dependencies

COPY package.json package-lock.json ./
RUN npm install --only=production

###
# Release
##
FROM base

COPY --from=dependencies /home/node/node_modules ./node_modules/
COPY app.js ./

EXPOSE 3000
CMD ["node", "app.js"]
