FROM kazu69/ubuntu:base
MAINTAINER kazu69

# Install phpbrew
RUN apt-get update && \
    apt-get -y install php5-cli \
                        php5-dev \
                        build-essential \
                        aptitude \
                        libmcrypt-dev \
                        libltdl-dev \
                        libreadline-dev \
                        libc-client2007e-dev \
                        libbz2-dev \
                        libkrb5-dev \
                        libfreetype6-dev \
                        libgmp3-dev \
                        libjpeg8-dev \
                        libpng12-dev \
                        libt1-dev \
                        libmhash-dev \
                        libexpat1-dev \
                        libicu-dev \
                        libtidy-dev \
                        libgmp-dev \
                        re2c \
                        lemon \
                        libldap2-dev \
                        libsasl2-dev \
                        libcurl4-openssl-dev \
                        bzip2 \
                        autoconf \
                        automake \
                        libxslt1-dev \
                        bison \
                        libpcre3-dev \
                        libstdc++6 \
                        libmysqlclient-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install phpenv
ENV PHPENV_ROOT $HOME/.phpenv

RUN git clone https://github.com/CHH/phpenv.git /tmp/phpenv && \
    ./tmp/phpenv/bin/phpenv-install.sh && \
    echo 'eval \"\$(phpenv init -)\"' >> /etc/profile.d/phpenv.sh && \
    echo 'eval "$(phpenv init -)"' >> /root/.bashrc

RUN git clone git://github.com/CHH/php-build.git ${PHPENV_ROOT}/plugins/php-build && \
    cp /tmp/phpenv/extensions/rbenv-config-* ${PHPENV_ROOT}/plugins/php-build/bin/ && \
    rm -rf /tmp/phpenv

ADD default_configure_options ${PHPENV_ROOT}/plugins/php-build/share/php-build/

ENV PATH $HOME/.phpenv/bin:$HOME/.phpenv/shims:$PATH

RUN cd $HOME && \
    wget http://getcomposer.org/composer.phar && \
    chmod +x composer.phar && \
    mv composer.phar /usr/local/bin/composer && \
    wget https://phar.phpunit.de/phpunit.phar && \
    chmod +x phpunit.phar && \
    mv phpunit.phar /usr/local/bin/phpunit

RUN ln -s /usr/lib/x86_64-linux-gnu/libldap.so /usr/lib/libldap.so && \
    ln -s /usr/lib/x86_64-linux-gnu/libpng.so /usr/lib/libpng.so && \
    ln -s /usr/lib/x86_64-linux-gnu/libkrb5.so /usr/lib/libkrb5.so && \
    ln -s /usr/lib/x86_64-linux-gnu/libjpeg.so /usr/lib/libjpeg.so && \
    ln -s /usr/lib/x86_64-linux-gnu//usr/lib/libstdc++.so.6 /usr/lib/libstdc++.so.6 && \
    ln -s /usr/lib/x86_64-linux-gnu/libmysqlclient_r.so /usr/lib/libmysqlclient_r.so && \
    mkdir -p /usr/include/freetype2/freetype/ && \
    ln -s /usr/include/freetype2/freetype.h /usr/include/freetype2/freetype/freetype.h && \
    ln -s /usr/include/x86_64-linux-gnu/gmp.h /usr/include/gmp.h

# Install rbenv
ENV PATH /usr/local/rbenv/shims:/usr/local/rbenv/bin:$PATH
ENV RBENV_ROOT /usr/local/rbenv

RUN apt-get -y update && \
    apt-get -y install libqt4-dev \
                        libqtwebkit-dev \
                        dbus \
                        libffi-dev \
                        libgcrypt-dev \
                        libxslt-dev \
                        chrpath \
                        libfreetype6 \
                        libfreetype6-dev \
                        libfontconfig1 \
                        libfontconfig1-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN git clone https://github.com/rbenv/rbenv.git ${RBENV_ROOT} && \
    git clone https://github.com/rbenv/ruby-build.git ${RBENV_ROOT}/plugins/ruby-build && \
    git clone git://github.com/jf/rbenv-gemset.git ${RBENV_ROOT}/plugins/rbenv-gemset && \
    ${RBENV_ROOT}/plugins/ruby-build/install.sh

RUN echo 'eval "$(rbenv init -)"' >> /etc/profile.d/rbenv.sh && \
    echo 'eval "$(rbenv init -)"' >> /root/.bashrc

# Install php versions
ADD php-version /root/php-version
RUN xargs -L 1 phpenv install < /root/php-version
RUN bash -c 'for v in $(cat /root/php-version); do phpenv global $v; done'

# Install ruby versions
ADD ruby-version /root/ruby-version
RUN xargs -L 1 rbenv install < /root/ruby-version
RUN echo 'gem: --no-rdoc --no-ri' >> /.gemrc
RUN bash -c 'for v in $(cat /root/ruby-version); do rbenv global $v; gem install bundler; done'

RUN rm /bin/sh && ln -s /bin/bash /bin/sh
