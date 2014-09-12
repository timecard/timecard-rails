[![Stories in Ready](https://badge.waffle.io/ruffnote/timecard-rails.png?label=ready&title=Ready)](https://waffle.io/ruffnote/timecard-rails)
[![Code Climate](https://codeclimate.com/github/ruffnote/timecard-rails/badges/gpa.svg)](https://codeclimate.com/github/ruffnote/timecard-rails)
[![Build Status](https://travis-ci.org/ruffnote/timecard-rails.svg?branch=master)](https://travis-ci.org/ruffnote/timecard-rails)
[![Coverage Status](https://coveralls.io/repos/ruffnote/timecard-rails/badge.png)](https://coveralls.io/r/ruffnote/timecard-rails)
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
    $ git clone git@github.com:mindia/timecard-rails.git
    $ cd timecard-rails/
    $ bundle install
    $ cp config/database.yml.sample config/database.yml
    $ rake db:setup
    $ rake assets:precompile RAILS_ENV=production
    $ cp config/omniauth.yml.sample config/omniauth.yml # setup Client ID and Client Secret of GitHub and Ruffnote
      (callback URL is project root ex: http:/yoursite.example.com/)  
      https://github.com/settings/applications, https://ruffnote.com/oauth/applications

Docker
------

* Installing Fig: http://www.fig.sh/install.html

    $ sudo pip install -U fig

* deploy

    $ fig up -d web
    $ fig run --rm web bundle exec rake assets:precompile
    $ fig run --rm web bundle exec rake db:setup

* test

    $ fig up --no-recreate test

* shutdown

    $ fig kill
    $ fig rm
