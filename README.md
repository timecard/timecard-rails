[![Stories in Ready](https://badge.waffle.io/timecard/timecard-rails.png?label=ready&title=Ready)](https://waffle.io/timecard/timecard-rails)
[![Code Climate](https://codeclimate.com/github/timecard/timecard-rails/badges/gpa.svg)](https://codeclimate.com/github/timecard/timecard-rails)
[![Build Status](https://travis-ci.org/timecard/timecard-rails.svg?branch=master)](https://travis-ci.org/timecard/timecard-rails)
[![Coverage Status](https://coveralls.io/repos/timecard/timecard-rails/badge.png)](https://coveralls.io/r/timecard/timecard-rails)
Timecard
========
Timecardとはクリエイターが好きな時に好きなだけ働ける環境をサポートする仕組みです。

Feature
-------
* プロジェクト機能
* Github Issueとの同期
* Issue単位の作業時間の記録

Setup
-----
    $ git clone git@github.com:timecard/timecard-rails.git
    $ cd timecard-rails/
    $ bundle install
    $ cp config/database.yml.sample config/database.yml
    $ rake db:setup
    $ rake assets:precompile RAILS_ENV=production
    $ vi config/settings/production.yml # setup Client ID and Client Secret of GitHub and Ruffnote
      (callback URL is project root ex: http:/yoursite.example.com/)
      https://github.com/settings/applications, https://ruffnote.com/oauth/applications
      https://github.com/railsconfig/rails_config

Setup with Heroku
------
    $ git clone git@github.com:timecard/timecard-rails.git
    $ cd timecard-rails/
    $ heroku create (APP_NAME)
    $ heroku addons:add heroku-postgresql
    $ heroku config:set HEROKU=true "Settings.services.github.client_id"=CLIENT_ID "Settings.services.github.client_secret"=CLIENT_SECRET "Settings.services.ruffnote.key"=KEY "Settings.services.ruffnote.secret"=SECRET
    $ git push heroku master
    $ heroku run rake db:migrate
    $ heroku open

Dependencies
------------

* Ruby 2.1.0+
