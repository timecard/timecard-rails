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
    $ git clone git@github.com:mindia/timecard.git
    $ cd timecard/
    $ bundle install
    $ rake db:migrate RAILS_ENV=production
    $ rake assets:precompile RAILS_ENV=production
    $ cp config/omniauth.yml.sample config/omniauth.yml # setup Github Client ID and Client Secret
      (callback URL is project root ex: http:/yoursite.example.com/)
