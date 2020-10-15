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
export PORT="8443"
export KEY_PATH="/etc/letsencrypt/live/arrahmah.sasid.me/privkey.pem"
export CERT_PATH="/etc/letsencrypt/live/arrahmah.sasid.me/fullchain.pem"
pkill dart
dart bin/server.dart &
