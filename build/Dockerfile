FROM postgis/postgis
# RUN echo OUCH! > /dev/full

RUN apt update
RUN apt -y install apache2-utils

# ligthhttpd requirements
RUN apt -y install lighttpd lighttpd-doc
RUN lighty-enable-mod cgi
COPY lighttpd.conf /etc/lighttpd/lighttpd.conf
RUN lighttpd -tt -f /etc/lighttpd/lighttpd.conf

# tinyOWS requirements
RUN apt -y install git autoconf make flex libxml2-dev libpq-dev postgis

WORKDIR /build
RUN git clone https://github.com/MapServer/tinyows.git

WORKDIR /build/tinyows
RUN autoconf
RUN ./configure
RUN make
RUN make install
RUN cp tinyows /var/www/tinyows

WORKDIR /
RUN chmod o+w /var/log/
COPY start.sh .
# ENTRYPOINT [ "/build/uwsgi/uwsgi-${UWSGI_VERSION}/uwsgi" ]
ENTRYPOINT [ "./start.sh" ]