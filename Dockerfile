FROM centos:7 AS build

ARG LICENSE=WTFPL \
  IMAGE_NAME=rhel7 \
  TIMEZONE=America/New_York \
  PORT=

ENV SHELL=/bin/bash \
  TERM=xterm-256color \
  HOSTNAME=${HOSTNAME:-casjaysdev-$IMAGE_NAME} \
  TZ=$TIMEZONE \
  RPM_SOURCE_DIR="/data/rpmbuild" \
  RPM_RELEASE_DIR="/data/release"

RUN mkdir -p /bin/ /config/ /data/ && \
  rm -Rf /bin/.gitkeep /config/.gitkeep /data/.gitkeep && \
  yum update -y && \
  yum install wget curl git -y && \
  yum clean all && \
  rm -Rf /etc/yum.repos.d/*
  wget -q "https://github.com/rpm-devel/casjay-release/raw/main/casjay.rh.repo" -O "/etc/yum.repos.d/casjay.repo" && \
  yum update -y && \
  yum groupinstall "Development Tools" "RPM Development Tools" -y && \
  yum clean all

COPY ./config/rpmmacros /root/.rpmmacros
COPY ./bin/. /usr/local/bin/
COPY ./config/. /config/
COPY ./data/. /data/

FROM scratch
ARG BUILD_DATE="$(date +'%Y-%m-%d %H:%M')"

LABEL org.label-schema.name="rhel7" \
  org.label-schema.description="Containerized version of rhel7" \
  org.label-schema.url="https://hub.docker.com/r/casjaysdevdocker/rhel7" \
  org.label-schema.vcs-url="https://github.com/casjaysdevdocker/rhel7" \
  org.label-schema.build-date=$BUILD_DATE \
  org.label-schema.version=$BUILD_DATE \
  org.label-schema.vcs-ref=$BUILD_DATE \
  org.label-schema.license="$LICENSE" \
  org.label-schema.vcs-type="Git" \
  org.label-schema.schema-version="latest" \
  org.label-schema.vendor="CasjaysDev" \
  maintainer="CasjaysDev <docker-admin@casjaysdev.com>"

ENV SHELL="/bin/bash" \
  TERM="xterm-256color" \
  HOSTNAME="casjaysdev-rhel7" \
  TZ="${TZ:-America/New_York}"

WORKDIR /root

VOLUME ["/root","/config","/data/rpmbuild","/data/release"]

EXPOSE $PORT

COPY --from=build /. /

ENTRYPOINT [ "tini", "--" ]
HEALTHCHECK --interval=15s --timeout=3s CMD [ "/usr/local/bin/entrypoint-rhel7.sh", "healthcheck" ]
CMD [ "/usr/local/bin/entrypoint-rhel7.sh" ]

