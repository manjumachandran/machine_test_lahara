# Posts App

A Flutter app that lists posts from JSONPlaceholder, supports local
notifications, and opens the post details screen when a notification is tapped.

## Features
- Posts list: 15 posts initially, then 10 per page until all 100 are loaded
- Pull-to-refresh, loading indicators, API error handling with retry
- Offline and timeout handling with clear messages
- "Notify Me" button on each post showing a local notification
  (title = post title, payload = post ID)
- Notification permission requested at runtime
- Tapping a notification opens the Post Details screen when the app is in
  the foreground, in the background, or launched from a terminated state
- Post Details fetched from `/posts/{id}` (ID, user ID, title, body)

## Tech
- Flutter, Dart
- State management: flutter_bloc
- HTTP: http
- Notifications: flutter_local_notifications

## Architecture
Clean Architecture with BLoC:

    lib/
    ├── core/         network and utils (notification service, navigator key)
    └── features/posts/
        ├── data/          models, repository implementation
        ├── domain/        repository contract
        └── presentation/  blocs, pages

## Setup
1. Install Flutter and an Android device or emulator
2. Clone the repo
3. Run `flutter pub get`
4. Run `flutter run`

## Download APK
Debug APK: https://github.com/manjumachandran/machine_test_lahara/releases/tag/v1.0.0

## Notes and decisions
- Pagination uses `_start` / `_limit` instead of `_page`, to show 15 posts
  first and then load 10 per page. This resolves the "15 initially" versus
  `_limit=10` requirement.
- Notification taps are handled with `onDidReceiveNotificationResponse`
  (foreground and background) and `getNotificationAppLaunchDetails`
  (launched from a terminated state).
- Notifications are supported on Android and iOS only.