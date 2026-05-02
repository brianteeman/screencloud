# Debian base image with the correct Python version
FROM python:3.9-trixie

ENV PYTHONQT_COMMIT=18d4c24

# Prevent interactive prompts during install
ENV DEBIAN_FRONTEND=noninteractive

# System dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential \
        cmake \
        git \
        curl \
        wget \
        ca-certificates \
        pkg-config \
        ninja-build \
        qt5-qmake \
        qtbase5-dev \
        qttools5-dev \
        qtmultimedia5-dev \
        qtdeclarative5-dev \
        libqt5svg5-dev \
        libqt5x11extras5-dev \
        libqt5opengl5-dev \
        libqt5xmlpatterns5-dev \
        qtbase5-private-dev \
        libssl-dev \
        zlib1g-dev \
        libx11-dev libxcb1-dev libxext-dev libxfixes-dev libxi-dev \
        libxrender-dev libxcb-cursor-dev libxcb-image0-dev libxcb-keysyms1-dev \
        libxcb-randr0-dev libxcb-render-util0-dev libxcb-shape0-dev \
        libxcb-sync-dev libxcb-util-dev libxcb-xfixes0-dev libxcb-xinerama0-dev \
        libxcb-xkb-dev libxkbcommon-dev libxkbcommon-x11-dev \
        mesa-common-dev libgl1-mesa-dev libglu1-mesa-dev \
        libfuse2 \
    && rm -rf /var/lib/apt/lists/*

# Install Python packages
RUN python3 -m pip install --upgrade pip && python3 -m pip install ssh2-python

# Build QuaZip v1.4
# Mirrors the "Build QuaZip" step in the GitHub workflow
RUN git clone https://github.com/stachenov/quazip.git /tmp/quazip \
    && cd /tmp/quazip \
    && git checkout v1.4 \
    && mkdir build && cd build \
    && cmake .. \
        -GNinja \
        -DCMAKE_BUILD_TYPE=Release \
        -DBUILD_SHARED_LIBS=ON \
    && ninja install \
    && rm -rf /tmp/quazip

# Build PythonQt
# Mirrors the "Build PythonQt" step in the GitHub workflow
RUN git clone https://github.com/Orochimarufan/PythonQt /tmp/pythonqt \
    && cd /tmp/pythonqt \
    && git checkout ${PYTHONQT_COMMIT} \
    && cd build \
    && cmake .. \
        -GNinja \
        -DCMAKE_BUILD_TYPE=Release \
        -DPythonQt_Python3=ON \
        -DPYTHONQT_WITH_WEBKIT=OFF \
        -DBUILD_SHARED_LIBS=ON \
    && ninja install \
    && rm -rf /tmp/pythonqt

# Add non-root user
RUN useradd -m -s /bin/bash vscode
USER vscode
WORKDIR /home/vscode/work
