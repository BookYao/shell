
#!/bin/sh

if [ -f /usr/bin/openssl ];then
    mv /usr/bin/openssl /usr/bin/openssl_bak
fi

if [ -f /usr/local/openssl/bin/openssl ];then
    ln -s /usr/local/openssl/bin/openssl /usr/bin/openssl
    echo "openssl binary link ok!"
else
    echo "Not find bin openssl"
    cp /usr/bin/openssl_bak /usr/bin/openssl
fi

if [ -d /usr/include/openssl ];then
    mv /usr/include/openssl /usr/include/openssl_src_bak
    if [ -d /usr/local/openssl/include ];then
        ln -s /usr/local/openssl/include/openssl /usr/include/openssl
        echo "openssl include path link ok."
    else
        echo  "Not Find Openssl include dir in usr local openssl."
    fi
fi

if ! cat /etc/ld.so.conf | grep -q "/usr/local/openssl/lib";then
    echo "/usr/local/openssl/lib" >> /etc/ld.so.conf
    ldconfig -v >> /dev/null
fi

if ! cat /etc/profile | grep -q "/usr/local/openssl/bin";then
    echo "export PATH=$PATH:/usr/local/openssl/bin/" >> /etc/profile
    source /etc/profile
fi

if [ -f /usr/lib64/libssl.so ];then
    rm /usr/lib64/libssl.so
    if [ -f /usr/lib64/libssl.so.1.0.0 ];then
        rm /usr/lib64/libssl.so.1.0.0
    fi
    cp /usr/local/openssl/lib/libssl.so.1.0.0 /usr/lib64/
    ln -s /usr/lib64/libssl.so.1.0.0 /usr/lib64/libssl.so
    echo "libssl link ok!"
fi

if [ -f /usr/lib64/libcrypto.so ];then
    rm /usr/lib64/libcrypto.so
    if [ -f /usr/lib64/libcrypto.so.1.0.0 ];then
        rm /usr/lib64/libcrypto.so.1.0.0
    fi
    cp /usr/local/openssl/lib/libcrypto.so.1.0.0 /usr/lib64/
    ln -s /usr/lib64/libcrypto.so.1.0.0 /usr/lib64/libcrypto.so
    echo "libcrypto link ok!"
fi

echo "update success!"
