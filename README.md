# photos_personalized_gemini

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

# design
this demo app is designed by using following features:
- firebase
  - hosting, vertex ai, app check
- photo library api
  - album list, mediaItems:search
- google cloud
  - billing pub/sub, functions
- flutter
  - web

# local developments
- run 
```
flutter run -d chrome --web-hostname localhost --web-port 65496 --web-browser-flag "--disable-web-security"
```
- settings recaptha debug token
  - https://console.firebase.google.com/u/0/project/photos-personalized-gemini/appcheck/apps

# references
- vertex ai for firebase
  - https://firebase.google.com/docs/vertex-ai/get-started?platform=flutter
- photo library api
  - https://developers.google.com/photos/library/reference/rest?hl=ja
- recapcha:
  - https://www.google.com/recaptcha/admin/site/707214203/setup?hl=ja
  - https://firebase.google.com/docs/app-check/flutter/default-providers?authuser=0&hl=ja&_gl=1*1crima0*_up*MQ..*_ga*NDExNjU5ODY4LjE3MjM2NDI5NTc.*_ga_CW55HF8NVT*MTcyMzY4MzMwMy4zLjEuMTcyMzY4ODY4NS4xNy4wLjA.
  - https://firebase.google.com/docs/app-check/flutter/debug-provider?authuser=0&hl=ja&_gl=1*1gq6km6*_up*MQ..*_ga*NDExNjU5ODY4LjE3MjM2NDI5NTc.*_ga_CW55HF8NVT*MTcyMzY4MzMwMy4zLjEuMTcyMzY4ODY4NS4xNy4wLjA.
- cost limit  
  - https://cloud.google.com/billing/docs/how-to/notify