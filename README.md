# movie_stream_app

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Project structure (canonical paths)

This app uses a feature-first, production-grade Bloc architecture. Use these canonical paths when adding or referencing UI:

- Pages: `lib/src/features/movies/presentation/pages/*`
- Widgets: `lib/src/features/movies/presentation/widgets/*`

Legacy shims under `lib/src/presentation/screens` and `lib/src/presentation/widgets` have been removed. Keep `MainPage` and `ProfileScreen` under `lib/src/presentation/screens/` for app shell/navigation only.

Bloc state management (events/states/Bloc only) lives under:

- `lib/src/features/movies/logic/bloc/<feature>/`
 	- Barrel files: `movie_search.dart`, `movie_detail.dart`, `favorites.dart`, `filter.dart`

Repositories, use cases, and data sources follow Clean Architecture in `src/data` and `src/domain`.
