FROM node:22.8.0-slim

RUN apt update && \
    apt install openssl procps -y && \
    npm install -g @nestjs/cli

USER node

WORKDIR /home/node/app

CMD ["tail", "-f", "/dev/null"]