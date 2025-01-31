pkill dart
git reset --hard HEAD
git pull
cd ../shared
dart pub get
dart pub run build_runner build --delete-conflicting-outputs
cd ../scraper
dart pub get
cd ../scraper_service
dart pub get
cd ../api
dart pub upgrade
dart pub get
./restart.sh