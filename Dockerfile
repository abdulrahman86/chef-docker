FROM austenito/ruby:2.1.2

RUN apt-get update

RUN mkdir /apache
ADD Berksfile /apache/Berksfile
ADD solo.json /apache/solo.json
ADD solo.rb /apache/solo.rb
ADD ./cookbooks ./cookbooks

WORKDIR /apache

COPY ./cookbooks ./tmp/cookbooks

RUN bash -c 'source /usr/local/share/chruby/chruby.sh; chruby 2.1.2'
RUN berks vendor ./cookbooks
RUN chef-solo -c solo.rb -j solo.json