# Movie Stream App

Minimal production Flutter app (OMDb API) with search, filters, favorites, rich detail view. Bloc + Clean Architecture.

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
- Shared Preferences for favorites
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
