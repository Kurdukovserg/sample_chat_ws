
Sample Websocket chat app 

Run this script to generate all dart files.
```bash
dart run build_runner build --delete-conflicting-outputs
```
For start the server run:
```bash
cd cjs/
npm install
node index.js
```
after that just run the app on emulator with params:
```bash
fvm flutter run --dart-define-from-file env_ios.json #for ios
fvm flutter run --dart-define-from-file env_android.json #for android
```
