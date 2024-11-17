# photos_personalized_gemini

A next generation chat application using Google Photo as context information.

web page: https://photos-personalized-gemini.web.app/

# design
this demo app is designed by using following APIs and tools:
- firebase
  - hosting, vertex ai, app check
- photo library api
  - album list, mediaItems:search
- google cloud
  - for billing: pub/sub, functions
  - for photo api cors: functions, hosting
    - https://issuetracker.google.com/issues/118662029?pli=1
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
