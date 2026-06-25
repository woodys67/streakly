#!/bin/bash

DEVICE_ID="00008120-0009752C3EE0C01E"
APP_PATH="build/ios/iphoneos/Runner.app"

echo "📦 iOS 빌드 시작..."
flutter build ios --release

if [ $? -ne 0 ]; then
  echo "❌ 빌드 실패"
  exit 1
fi

echo "📲 iPhone에 설치 중..."
/usr/bin/arch -arm64e xcrun devicectl device install app \
  --device "$DEVICE_ID" \
  "$APP_PATH"

if [ $? -eq 0 ]; then
  echo "✅ 설치 완료! iPhone에서 앱을 실행하세요."
else
  echo "❌ 설치 실패. iPhone이 연결되어 있는지 확인하세요."
fi
