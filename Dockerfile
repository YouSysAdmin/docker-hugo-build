ARG NODE_VERSION="alpine3.11"
FROM node:${NODE_VERSION}

ARG HUGO_VERSION="0.80.0"
ARG MINIFY_VERSION="2.9.10"
ARG GLIBC_VERSION="2.31-r0"

LABEL maintainer "YouSysAdmin <work@sysalex.com>"

COPY entrypoint /opt/hugo-build/
ENV PATH=/opt/hugo-build:$PATH
RUN chmod +x /opt/hugo-build/entrypoint && \
    mkdir /source && \
    chown 1000:1000 /source

RUN set -x && \
    apk add --update --no-cache wget ca-certificates libstdc++ openssl git 
  
# Install glibc: This is required for HUGO-extended (including SASS) to work.
RUN wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub \
  &&  wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-${GLIBC_VERSION}.apk \
  &&  apk --no-cache add glibc-${GLIBC_VERSION}.apk \
  &&  rm glibc-${GLIBC_VERSION}.apk \
  &&  wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-bin-${GLIBC_VERSION}.apk \
  &&  apk --no-cache add glibc-bin-${GLIBC_VERSION}.apk \
  &&  rm glibc-bin-${GLIBC_VERSION}.apk \
  &&  wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-i18n-${GLIBC_VERSION}.apk \
  &&  apk --no-cache add glibc-i18n-${GLIBC_VERSION}.apk \
  &&  rm glibc-i18n-${GLIBC_VERSION}.apk

# Install Hugo and Minify
RUN set -eux && \
  npm i -g postcss postcss-cli && \
  wget -O ${HUGO_VERSION}.tar.gz https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_extended_${HUGO_VERSION}_Linux-64bit.tar.gz && \
  wget -O ${MINIFY_VERSION}.tar.gz https://github.com/tdewolff/minify/releases/download/v${MINIFY_VERSION}/minify_linux_amd64.tar.gz && \
  tar xz -f ${HUGO_VERSION}.tar.gz -C /usr/bin/ hugo && \
  tar xz -f ${MINIFY_VERSION}.tar.gz -C /usr/bin/ minify && \
  rm -rf  ${HUGO_VERSION}.tar.gz && \
  rm -rf  ${MINIFY_VERSION}.tar.gz && \
  rm -rf /tmp/* /var/cache/apk/*

USER 1000
WORKDIR /source
ENTRYPOINT ["entrypoint"]
CMD ["--help"]
