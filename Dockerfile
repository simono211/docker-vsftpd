FROM debian:stretch

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update \
  && apt-get upgrade -y \
  && apt-get dist-upgrade -y \
  && apt-get install -y --no-install-recommends \
    apt-utils \
    vsftpd \
    db5.3-util \
    procps \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/run/vsftpd/empty \
  && mkdir -p /etc/vsftpd \
  && mkdir -p /var/www \
  && mkdir -p /var/ftp \
  && chown -R www-data:www-data /var/www \
  && cp /etc/vsftpd.conf /etc/vsftpd.orig

COPY vsftpd.conf /etc/
COPY vsftpd.virtual /etc/pam.d/
COPY scripts/* /

VOLUME ["/var/ftp"]
EXPOSE 21 20
EXPOSE 12020 12021 12022 12023 12024 12025

ENV DEBIAN_FRONTEND teletype

ENTRYPOINT ["/init"]
CMD ["vsftpd"]
