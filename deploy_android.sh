#!/bin/bash

DEVICE_ID="R39M6000J7F"
APK_PATH="build/app/outputs/flutter-apk/app-release.apk"

echo "📦 Android 빌드 시작..."
flutter build apk --release

if [ $? -ne 0 ]; then
  echo "❌ 빌드 실패"
  exit 1
fi

echo "📲 Android 기기에 설치 중..."
adb -s "$DEVICE_ID" install -r "$APK_PATH"

if [ $? -eq 0 ]; then
  echo "✅ 설치 완료! Android 기기에서 앱을 실행하세요."
else
  echo "❌ 설치 실패. Android 기기가 연결되어 있는지 확인하세요."
fi
