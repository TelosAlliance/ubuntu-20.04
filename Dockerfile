# vim:syntax=dockerfile
FROM ubuntu:20.04

# KEEP PACKAGES SORTED ALPHABETICALY
# Do everything in one RUN command
RUN dpkg --add-architecture i386 \
  # Install packages needed to set up third-party repositories
  && apt-get update \
  && apt-get install -y --no-install-recommends \
    apt-transport-https \
    build-essential \
    ca-certificates \
    curl \
    gnupg \
    python3 \
    python3-pip \
    software-properties-common \
  # Install AWS cli
  #&& pip3 install awscli \
  # Use kitware's CMake repository for up-to-date version
  #&& curl -sL https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | apt-key add - \
  #&& apt-add-repository 'deb https://apt.kitware.com/ubuntu/ bionic main' \
  # Use NodeSource's NodeJS 12.x repository
  #&& curl -sL https://deb.nodesource.com/setup_12.x | bash - \
  # Install nvm binary
  #&& curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.34.0/install.sh | bash \
  # Install nodejs/npm
  #&& apt-get update \
  #&& apt-get install -y --no-install-recommends \
  #  cmake \
  #  nodejs \
  # Install other javascript package managers
  #&& npm install -g yarn pnpm \
  # Install everything else
  && apt-get install -y --no-install-recommends \
    autoconf \
    automake \
    bc \
    cpio \
    device-tree-compiler \
    elfutils \
    file \
    gawk \
    gdb \
    gettext \
    git \
    golang \
    gosu \
    kmod \
    libasound2-dev \
    libavahi-compat-libdnssd-dev \
    libboost-all-dev \
    libsndfile1-dev \
    libssl-dev \
    libtool \
    libwebsocketpp-dev \
    locales-all \
    lzop \
    ncurses-dev \
    rsync \
    shellcheck \
    swig \
    unzip \
    uuid-dev \
    valgrind \
    vim \
    zip \
    zlib1g-dev \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8

COPY patch /
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/bin/bash"]
