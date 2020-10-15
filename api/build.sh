cd ../shared
pub get
pub run build_runner build --delete-conflicting-outputs
cd ../scraper
pub get
cd ../scraper_service
pub get
cd ../api
pub upgrade
pub get
dart bin/main.dart
