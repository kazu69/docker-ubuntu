# !/bin/bash

for v in $(cat /root/php-version); do
    phpenv install $v && phpenv global $v
    PHP_ETC_PATH=$(php --ini | grep "Configuration File (php.ini) Path" | sed -e 's/ //g' | awk -F: '{print $NF}')
    PHP_INI=$(php --ini | grep "Loaded Configuration File" | sed -e 's/ //g' | awk -F: '{print $NF}')
    PHP_EXTENTION_DIR=$(php-config --extension-dir)
    cp -r /tmp/php-idnkit/idnkit $PHP_ETC_PATH
    cd ${PHP_ETC_PATH}/idnkit && \
        patch -lp 0 < php-idnkit.patch && \
        phpize && \
        ./configure && \
        make && make install
    echo "extension=${PHP_EXTENTION_DIR}/idnkit.so" >> $PHP_INI
done
