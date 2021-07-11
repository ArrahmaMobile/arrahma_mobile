pkill dart
git reset --hard HEAD
git pull
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
./restart.sh