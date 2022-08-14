FROM debian:stable-slim as get
WORKDIR /bun

RUN apt-get update
RUN apt-get install curl unzip -y
RUN curl --fail --location --progress-bar --output "/bun/bun.zip" "https://github.com/Jarred-Sumner/bun/releases/download/bun-v0.1.8/bun-linux-x64.zip"
RUN unzip -d /bun -q -o "/bun/bun.zip"
RUN mv /bun/bun-linux-x64/bun /usr/local/bin/bun
RUN chmod 777 /usr/local/bin/bun

COPY package.json package.json
COPY bun.lockb bun.lockb
RUN bun install
ADD index.ts index.ts
RUN bun bun .

FROM gcr.io/distroless/base-debian11
LABEL maintainer="Erick Amorim <github.com/ericklima-ca>"
WORKDIR /app
COPY --from=get /usr/local/bin/bun /bin/bun
COPY --from=get /bun/node_modules ./node_modules
COPY --from=get /bun/node_modules.bun ./node_modules.bun
ADD index.ts /app/index.ts
EXPOSE 3000

ENTRYPOINT ["bun", "run", "/app/index.ts"]
