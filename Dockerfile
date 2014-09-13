FROM michilu/fedora-rails

RUN yum install -y \
  gcc \
  make \
  nodejs \
  postgresql-devel \
  ruby-devel \
  rubygem-bcrypt \
  rubygem-eventmachine \
  rubygem-nokogiri \
  rubygem-unf_ext \
  && yum clean all

COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock
RUN \
  bundle config without test development doc &&\
  bundle install --jobs `grep processor /proc/cpuinfo|wc -l`

RUN mkdir /myapp
WORKDIR /myapp
COPY . /myapp
COPY config/database.yml.sample /myapp/config/database.yml
COPY config/omniauth.yml.sample /myapp/config/omniauth.yml

ENV RAILS_ENV development
EXPOSE 3000
CMD \
  RAILS_ENV=test bundle exec rake db:test:prepare &&\
  RAILS_ENV=test bundle exec rspec
