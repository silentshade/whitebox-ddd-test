FROM ruby:3.1.2

ENV LANG C.UTF-8

RUN curl -sL https://deb.nodesource.com/setup_16.x | bash -\
  && apt-get update -qq && apt-get install -qq --no-install-recommends \
    nodejs \
  && apt-get upgrade -qq \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*\
  && npm install -g yarn@1

RUN useradd -ms /bin/bash dockeruser && usermod -aG sudo dockeruser
USER dockeruser
WORKDIR /home/dockeruser/project

COPY . .

RUN gem install bundler

COPY docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]
