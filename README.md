# photos_personalized_gemini

A next generation chat application using Google Photo as context information.

web page: https://photos-personalized-gemini.web.app/

# Design
This demo app is designed by using the following APIs and tools:
- Firebase
  - Hosting, Vertex AI, App Check
- Photo Library API
  - Album list, mediaItems:search
- Google Cloud
  - For billing: Pub/Sub, Functions
  - For photo API CORS: Functions, Hosting
    - https://issuetracker.google.com/issues/118662029?pli=1
- Flutter
  - Web

# Local Development
- Run the following command to start the project locally:
```
flutter run -d chrome --web-hostname localhost --web-port 65496 --web-browser-flag "--disable-web-security"
```
- Set up reCAPTCHA debug token:
  - https://console.firebase.google.com/u/0/project/photos-personalized-gemini/appcheck/apps

# References
- Vertex AI for Firebase:
  - https://firebase.google.com/docs/vertex-ai/get-started?platform=flutter
- Photo Library API:
  - https://developers.google.com/photos/library/reference/rest?hl=ja
- reCAPTCHA:
  - https://www.google.com/recaptcha/admin/site/707214203/setup?hl=ja
  - https://firebase.google.com/docs/app-check/flutter/default-providers?authuser=0&hl=ja&_gl=1*1crima0*_up*MQ..*_ga*NDExNjU5ODY4LjE3MjM2NDI5NTc.*_ga_CW55HF8NVT*MTcyMzY4MzMwMy4zLjEuMTcyMzY4ODY4NS4xNy4wLjA.
  - https://firebase.google.com/docs/app-check/flutter/debug-provider?authuser=0&hl=ja&_gl=1*1gq6km6*_up*MQ..*_ga*NDExNjU5ODY4LjE3MjM2NDI5NTc.*_ga_CW55HF8NVT*MTcyMzY4MzMwMy4zLjEuMTcyMzY4ODY4NS4xNy4wLjA.
- Cost limit:
  - https://cloud.google.com/billing/docs/how-to/notify
