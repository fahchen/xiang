## xiang (a simple markdown blog)
[live demo]t(http://xiang.herokuapp.com | Fah's blog )
> left life, non right. 

### Features
* support markdown √
* support [tooltip]t( | this is a tooltip ) √
* use Flickr as the photos hosting √
* backup to Dropbox, can restore from Dropbox
* auto client side draft save √
* code highlights √
* stream from social network(Twitter, weibo, instagram) with shape symbol #
* responsive design √
* support emoji
* admin
* SEO

### Install
* `mv database.yml.default database.yml`
* `mv thin.yml.default thin.yml`
* `mv settings.yml.default settings.yml`
* `bundle install`
* `rake db:migrate`
* `thin start -C config/thin.yml`