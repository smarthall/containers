ARG BUILD_FROM
FROM ${BUILD_FROM}

ENV LANG C.UTF-8
LABEL org.opencontainers.image.source = "https://github.com/smarthall/containers"

# Install and build Ecowitt2MQTT
RUN apk add --no-cache --virtual .build-dependencies \
        gcc \
        python3-dev \
        libc-dev \
        musl-dev \
    && python3 -m ensurepip \
    && pip3 install --no-cache --upgrade pip setuptools \
    && pip install ecowitt2mqtt==1.3.0 \
    && apk del .build-dependencies

# Copy data for add-on
COPY run.sh /
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]
