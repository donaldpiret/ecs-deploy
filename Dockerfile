FROM fabfuel/ecs-deploy:1.12.1

LABEL author="Donald Piret <@donaldpiret>"

WORKDIR /

RUN apk add jq

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]