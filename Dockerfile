# fluentd/Dockerfile
FROM fluent/fluentd:stable


# ENV http_proxy http://10.0.2.2:3128
# ENV https_proxy https://10.0.2.2:3128
ENV no_proxy localhost,my-elasticsearch-cluster

WORKDIR /fluentd/etc/

COPY fluent.conf fluent.conf
COPY config.d/ config.d

# Use root account to use apk
USER root

# below RUN includes plugin as examples elasticsearch is not required
# you may customize including plugins as you wish
RUN apk add --no-cache --update --virtual .build-deps \
        sudo build-base ruby-dev \
 		&& sudo gem install \
        fluent-plugin-elasticsearch \
        fluent-plugin-grok-parser \
 		&& sudo gem sources --clear-all \
 		&& apk del .build-deps \
 		&& rm -rf /home/fluent/.gem/ruby/2.5.0/cache/*.gem


#USER fluent

EXPOSE 24224
EXPOSE 24230