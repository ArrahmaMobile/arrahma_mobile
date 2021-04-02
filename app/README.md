## TODO
- Dedupe same scraped pages in menu and home screen quran course content pages
- Only send updated diff data to app
- Fix chat webview top status bar color
- Fix share file extension and name.
- Add feedback capture and send to discord

## App Build Setup 
- App relies on a private git repo. To setup access, the ssh agent on the machine needs to have the private key setup and the public key on the git provider user.
    - For CodeMagic CI, an environment variable needs to be setup for it to include the SSH private key on the SSH agent. Any env variable with the suffix `_SSH_KEY` will be added automatically.
    - For GitHub, the public key can be added to a user that has access to the private repo. The key can be added here: https://github.com/settings/keys


