FROM jmcarbo/webhook

EXPOSE 9000

ENV LANGUAGE=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
ENV LANG=en_US.UTF-8

ENV IRC_NOTIFY_BRANCHES production

RUN apt-get update \
  && apt-get install -y locales-all ruby \
  && gem install puppet-ghostbuster --no-ri --no-rdoc \
  && rm -rf /var/lib/apt/lists/*

COPY puppet-ghostbuster.json /etc/webhook/puppet-ghostbuster.json
COPY puppet-ghostbuster.sh /puppet-ghostbuster.sh

VOLUME ["/var/lib/git/"]

COPY /docker-entrypoint.sh /
COPY /docker-entrypoint.d/* /docker-entrypoint.d/
ENTRYPOINT ["/docker-entrypoint.sh"]
