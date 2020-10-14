# Dog World

Welcome.

# Useful Commands

### Running the app locally: 

1. Make sure you are in the project (Dev/doggies) location in the terminal. Then specifically running flutter web server on google auth authorized port. COMMAND: 
flutter run -d chrome --web-hostname localhost --web-port 7357
2. - To run our cloud functions `npm run serve` or to get them on the emulator: `npm run serve` from within the functions directory.

- Then for devtools you need to go to `http://127.0.0.1:9101/#/`, and then manually connect by inputting something like: http://127.0.0.1:62426/ko7vgxcxxRs= The actual thing you input will be in your terminal.

### Testing:
- Run `npm run shell` to get an interactive command line interface where you can test your cloud functions. Just run the function name. Just remember that you need to pass in the data that it expects. 

### Deployment: 

- For web first run `flutter build web` then `firebase deploy`
- For Cloud Functions: `firebase deploy --only functions` for all functions for your functions/src/index.ts file to be compiled into our lib folder and deployed. 

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
