FROM michilu/fedora-rails

RUN mkdir /myapp
WORKDIR /myapp

COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock
#RUN bundle config without test development doc
RUN yum install -y \
  gcc \
  make \
  nodejs \
  ruby-devel \
  rubygem-bcrypt \
  rubygem-eventmachine \
  rubygem-mysql2 \
  rubygem-nokogiri \
  rubygem-unf_ext \
  && yum clean all
RUN bundle install --jobs `grep processor /proc/cpuinfo|wc -l`

COPY . /myapp
COPY config/database.yml.sample /myapp/config/database.yml
COPY config/omniauth.yml.sample /myapp/config/omniauth.yml

#ENV RAILS_ENV production
RUN bundle exec rake assets:precompile RAILS_ENV=production

CMD bundle exec rake db:setup
