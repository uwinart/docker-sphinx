# Version 0.0.1
FROM uwinart/base:latest

MAINTAINER Yurii Khmelevskii <y@uwinart.com>

# Set noninteractive mode for apt-get
ENV DEBIAN_FRONTEND noninteractive

RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ wheezy-pgdg main" >> /etc/apt/sources.list.d/pgdg.list && \
  wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - && \
  apt-get update && \
  apt-get install -qy libpq-dev && \
  cd /usr/local/src && \
  wget http://sphinxsearch.com/files/sphinx-2.2.6-release.tar.gz && \
  tar xzf sphinx-2.2.6-release.tar.gz && \
  rm -f sphinx-2.2.6-release.tar.gz && \
  cd sphinx-2.2.6-release && \
  ./configure --with-pgsql --without-mysql && \
  make install clean && \
  apt-get clean

RUN cd /usr/local/share && \
  mkdir -p sphinx/dicts && \
  cd sphinx/dicts && \
  sed -i -e "s/# lemmatizer_base\s*=.*/lemmatizer_base = \/usr\/local\/share\/sphinx\/dicts/g" /usr/local/etc/sphinx.conf.dist && \
  wget http://sphinxsearch.com/files/dicts/ru.pak && \
  wget http://sphinxsearch.com/files/dicts/en.pak && \
  wget http://sphinxsearch.com/files/dicts/de.pak

RUN mkdir -p /data/sphinx && \
  mkdir -p /var/run/sphinxsearch && \
  mkdir -p /var/log/sphinxsearch

ADD indexer-rotate-all /etc/cron.hourly/indexer-rotate-all

VOLUME ["/data/sphinx", "/var/log/sphinxsearch", "/var/run/sphinxsearch"]

EXPOSE 9312
