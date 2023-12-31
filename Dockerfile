FROM alpine:latest as final

ARG UID=1337
RUN set -x && \
    adduser --disabled-password --uid ${UID} airconnect

COPY --chown=airconnect:airconnect airconnect-bin/aircast-linux-x86_64-static /usr/local/bin/aircast
COPY --chown=airconnect:airconnect airconnect-bin/airupnp-linux-x86_64-static /usr/local/bin/airupnp
COPY --chown=airconnect:airconnect docker/entrypoint.sh /usr/local/bin/entrypoint.sh
COPY --chown=airconnect:airconnect docker/airupnp.xml /etc/airupnp.xml

USER airconnect
RUN set -x && \
    chmod +x /usr/local/bin/aircast && \
    chmod +x /usr/local/bin/airupnp && \
    chmod +x /usr/local/bin/aircast

ENV AIRCONNECT_AIRUPNP_CONFIG="/etc/airupnp.xml"
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD []
