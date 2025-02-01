pkill dart
export PORT="8443"
export KEY_PATH="/etc/letsencrypt/live/arrahmah.sasid.me/privkey.pem"
export CERT_PATH="/etc/letsencrypt/live/arrahmah.sasid.me/fullchain.pem"
dart pub get
dart bin/server.dart &> run.log &
