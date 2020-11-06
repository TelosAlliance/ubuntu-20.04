# vim:syntax=dockerfile
FROM ubuntu:20.04

# Set this before `apt-get` so that it can be done non-interactively
ENV DEBIAN_FRONTEND noninteractive
ENV TZ America/New_York
ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8
ENV GOROOT /usr/local/go
ENV GOPATH $HOME/work/
ENV PATH $GOPATH/bin:$GOROOT/bin:$PATH

# KEEP PACKAGES SORTED ALPHABETICALY
# Do everything in one RUN command
RUN apt-get update \
  # Install packages needed to set up third-party repositories
  && apt-get install -y --no-install-recommends \
    apt-transport-https \
    build-essential \
    ca-certificates \
    curl \
    gnupg \
    python3 \
    python3-pip \
    software-properties-common \
    wget \
  # Install AWS cli
  && pip3 install awscli \
  # Use kitware's CMake repository for up-to-date version
  # NOTE: Probably don't need this in 20.04, stick with Ubuntu's version for now
  #&& curl -sL https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | apt-key add - \
  #&& apt-add-repository 'deb https://apt.kitware.com/ubuntu/ focal main' \
  # Use NodeSource's NodeJS 12.x repository
  && curl -sL https://deb.nodesource.com/setup_12.x | bash - \
  # Install nvm binary
  && curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.34.0/install.sh | bash \
  # Install nodejs/npm
  && apt-get update \
  && apt-get install -y --no-install-recommends \
    nodejs \
  # Install other javascript package managers
  && npm install -g yarn pnpm \
  # Install newer version of Go than is included with Ubuntu 20.04
  && wget -c https://dl.google.com/go/go1.14.9.linux-amd64.tar.gz -O - | tar -xz -C /usr/local/ \
  # Install everything else
  && apt-get install -y --no-install-recommends \
    autoconf \
    automake \
    bc \
    cmake \
    cpio \
    cppcheck \
    device-tree-compiler \
    elfutils \
    file \
    gawk \
    gdb \
    gettext \
    git \
    gosu \
    kmod \
    libasound2-dev \
    libavahi-compat-libdnssd-dev \
    libboost-all-dev \
    libncurses5-dev \
    libsndfile1-dev \
    libssl-dev \
    libtool \
    libwebsocketpp-dev \
    libwebsockets-dev \
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

COPY patch /
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/bin/bash"]
