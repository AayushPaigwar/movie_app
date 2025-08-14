# Movie Stream App

Minimal production Flutter app (OMDb API) with search, filters, favorites, rich detail view. Bloc + Clean Architecture.



## Screenshots

| Home Screen | Movie Detial Screen | Watchlist Screen | Search Screen |
|-------------|---------------------|--------------|-----------|
| <img width="300" height="650" alt="HomeScreen" src="https://github.com/user-attachments/assets/f48d95c8-acc8-4d99-bdfe-4438a14804f1" /> | <img width="300" height="650" alt="Search Screen" src="https://github.com/user-attachments/assets/dcea23df-b018-4485-be12-02210a9ab6d2" /> | <img width="300" height="650" alt="Movie Detail Screen" src="https://github.com/user-attachments/assets/7328a1e7-5c26-486c-8d13-8f1df7976109" /> | <img width="300" height="650" alt="Simulator Screenshot - iPhone 16 - 2025-08-14 at 15 11 32" src="https://github.com/user-attachments/assets/f84d7918-3e3c-46a4-bb47-b28243f4fcde" /> | |  |  |


## Features

- Search with type/year filters
- Infinite scroll (list / grid toggle)
- Detailed screen (ratings, metadata, watchlist)
- Favorites persisted locally
- Shimmer skeleton loading

## Tech Stack

- Flutter (Material 3, dark theme)
- Bloc state management
- Clean Architecture (domain / data / presentation)
- Local Storage for favorites
- http + dotenv (OMDb API)

## Structure (essentials)

```text
lib/
	main.dart            App wiring (providers, blocs)
	src/
		core/              constants, theme, misc core
		data/              models, datasources (remote/local), repositories impl
		domain/            entities, abstract repos, usecases
		logic/             blocs (movie_search, movie_detail, favorites, filter)
		presentation/      ui (home, search, detail, favorites, shared widgets)
```

## Environment

Create `.env`:

```env
OMDB_BASE_URL=https://www.omdbapi.com/
OMDB_API_KEY=YOUR_KEY_HERE
```

Never commit real keys (add `.env` to `.gitignore`).

## Setup

```bash
flutter pub get
```

## Run

```bash
flutter run -d <device-id>
```
