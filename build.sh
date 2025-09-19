#!/bin/bash
  export PATH="$PATH:/opt/flutter/bin"
  if ! command -v flutter &> /dev/null; then
    echo "Installing Flutter..."
    git clone https://github.com/flutter/flutter.git -b stable /opt/flutter
    export PATH="$PATH:/opt/flutter/bin"
    flutter doctor
  fi
  flutter pub get
  flutter build web --base-href /
