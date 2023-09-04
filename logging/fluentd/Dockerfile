FROM fluent/fluentd:v1.16.2-1.0

USER root

RUN gem install fluent-plugin-elasticsearch  --no-document --version 5.3.0
RUN gem install fluent-plugin-grok-parser  --no-document --version 2.6.2

USER fluent

ADD fluent.conf /fluentd/etc
