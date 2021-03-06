FROM ruby:2.7.0

ENV APP_ROOT /usr/src/bg_match_app

WORKDIR $APP_ROOT

RUN apt-get update && \
    apt-get install -y nodejs \
                       mariadb-client \
                       --no-install-recommends && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY Gemfile $APP_ROOT
COPY Gemfile.lock $APP_ROOT

RUN \
  echo 'gem: --no-document' >> ~/.gemrc && \
  cp ~/.gemrc /etc/gemrc && \
  chmod uog+r /etc/gemrc && \
  bundle config --global build.nokogiri --use-system-libraries && \
  bundle config --global jobs 4 && \
  bundle install && \
  rm -rf ~/.gem

COPY . $APP_ROOT

EXPOSE  3000
CMD ["rails", "server", "-b", "0.0.0.0"]