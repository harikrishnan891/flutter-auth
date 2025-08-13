#!/bin/bash

echo "🛠️ Installing system dependencies for Flutter Linux desktop..."

sudo apt update && sudo apt install -y \
  git \
  cmake \
  clang \
  build-essential \
  ninja-build \
  pkg-config \
  libgtk-3-dev \
  unzip \
  curl \
  xz-utils \
  zip \
  libstdc++6

echo "✅ All Linux dependencies installed."
flutter doctor

