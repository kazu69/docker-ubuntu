FROM kazu69/ubuntu:base
MAINTAINER kazu69 "kazu.69.web+docker@gmail.com"

# Install phpbrew
RUN apt-get update && \
    apt-get -y install php5 \
                        php5-dev \
                        php5-cli \
                        php-pear \
                        php5-curl \
                        php5-mysql \
                        libmcrypt-dev \
                        libicu-dev \
                        libcurl4-openssl-dev \
                        bzip2 \
                        libbz2-dev \
                        autoconf \
                        automake \
                        libxslt1-dev \
                        bison \
                        libpcre3-dev \
                        libfreetype6-dev \
                        libmysqlclient-dev

RUN curl -sL https://github.com/phpbrew/phpbrew/raw/master/phpbrew -o /usr/local/bin/phpbrew
RUN chmod +x /usr/local/bin/phpbrew
RUN echo "source ~/.phpbrew/bashrc\nphpbrew use ${PHP_VERSION}" >> ~/.bashrc
RUN phpbrew init && phpbrew update --old
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install rbenv
ENV PATH /usr/local/rbenv/shims:/usr/local/rbenv/bin:$PATH
ENV RBENV_ROOT /usr/local/rbenv

RUN apt-get -y update
RUN apt-get -y install libqt4-dev \
                        libqtwebkit-dev \
                        dbus \
                        libffi-dev \
                        libgcrypt-dev \
                        libxslt-dev \
                        chrpath \
                        libfreetype6 \
                        libfreetype6-dev \
                        libfontconfig1 \
                        libfontconfig1-dev

RUN git clone git://github.com/sstephenson/rbenv.git ${RBENV_ROOT} && \
    git clone https://github.com/sstephenson/ruby-build.git ${RBENV_ROOT}/plugins/ruby-build && \
    git clone git://github.com/jf/rbenv-gemset.git ${RBENV_ROOT}/plugins/rbenv-gemset && \
    ${RBENV_ROOT}/plugins/ruby-build/install.sh

RUN echo 'eval "$(rbenv init -)"' >> /etc/profile.d/rbenv.sh && \
    echo 'eval "$(rbenv init -)"' >> /root/.bashrc

# Install php versions
ADD php-version /root/php-version
RUN /bin/bash -c 'for v in $(cat /root/php-version); do phpbrew install $v +default +mysql +mb; done'

# Install ruby versions
ADD ruby-version /root/ruby-version
RUN xargs -L 1 rbenv install < /root/ruby-version
RUN echo 'gem: --no-rdoc --no-ri' >> /.gemrc
RUN bash -c 'for v in $(cat /root/ruby-version); do rbenv global $v; gem install bundler; done'
