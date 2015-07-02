FROM ubuntu:14.04.2
MAINTAINER Konstantin Tushakov <tushakov70@bk.ru>

ENV DEBIAN_FRONTEND noninteractive
ENV HOME /root

ADD  https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb /tmp/

RUN mkdir -p /usr/share/icons/hicolor && \
    apt-get update \
    && apt-get install -y --force-yes --no-install-recommends supervisor \
        openssh-server pwgen sudo vim-tiny \
        net-tools \
        lxde x11vnc xvfb \
        gtk2-engines-murrine ttf-ubuntu-font-family \
        firefox \
        fonts-wqy-microhei \
        language-pack-zh-hant language-pack-gnome-zh-hant firefox-locale-zh-hant \
        nginx \
        python-pip python-dev build-essential \
	ca-certificates \
        gconf-service \
        hicolor-icon-theme \
        libappindicator1 \
        libasound2 \
        libcanberra-gtk-module \
        libcurl3 \
        libexif-dev \
        libgconf-2-4 \
        libgl1-mesa-dri \
        libgl1-mesa-glx \
        libnspr4 \
        libnss3 \
        libpango1.0-0 \
        libv4l-0 \
        libxss1 \
        libxtst6 \
        wget \
        xdg-utils \
    && dpkg -i '/tmp/google-chrome-stable_current_amd64.deb' \
    && apt-get autoclean \
    && apt-get autoremove \
    && rm -rf /var/lib/apt/lists/*

COPY local.conf /etc/fonts/local.conf

ADD https://dl.dropboxusercontent.com/u/23905041/x11vnc_0.9.14-1.1ubuntu1_amd64.deb /tmp/
ADD https://dl.dropboxusercontent.com/u/23905041/x11vnc-data_0.9.14-1.1ubuntu1_all.deb /tmp/
RUN dpkg -i /tmp/x11vnc*.deb

ADD web /web/
RUN pip install -r /web/requirements.txt

ADD noVNC /noVNC/
ADD nginx.conf /etc/nginx/sites-enabled/default
ADD startup.sh /
ADD supervisord.conf /etc/supervisor/conf.d/

EXPOSE 6080
WORKDIR /root
ENTRYPOINT ["/startup.sh"]
