import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'src/core/theme/app_theme.dart';
import 'src/data/datasources/movie_local_data_source.dart';
import 'src/data/datasources/movie_remote_data_source.dart';
import 'src/data/repositories/movie_repository_impl.dart';
import 'src/domain/repositories/movie_repository.dart';
import 'src/domain/usecases/add_favorite_movie.dart';
import 'src/domain/usecases/get_favorite_movies.dart';
import 'src/domain/usecases/get_movie_detail.dart';
import 'src/domain/usecases/is_favorite_movie.dart';
import 'src/domain/usecases/remove_favorite_movie.dart';
import 'src/domain/usecases/search_movies.dart';
import 'src/logic/favorites/favorites_bloc.dart';
import 'src/logic/filter/filter_bloc.dart';
import 'src/logic/movie_detail/movie_detail_bloc.dart';
import 'src/logic/movie_search/movie_search_bloc.dart';
import 'src/presentation/main_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  // Initialize shared preferences if needed elsewhere
  await SharedPreferences.getInstance();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<MovieRepository>(
          create: (context) {
            final client = http.Client();
            final remote = MovieRemoteDataSourceImpl(client: client);
            final local = MovieLocalDataSourceImpl();
            return MovieRepositoryImpl(
              remoteDataSource: remote,
              localDataSource: local,
            );
          },
        ),
        RepositoryProvider<SearchMovies>(
          create: (context) => SearchMovies(context.read<MovieRepository>()),
        ),
        RepositoryProvider<GetMovieDetail>(
          create: (context) => GetMovieDetail(context.read<MovieRepository>()),
        ),
        RepositoryProvider<IsFavoriteMovie>(
          create: (context) => IsFavoriteMovie(context.read<MovieRepository>()),
        ),
        RepositoryProvider<AddFavoriteMovie>(
          create: (context) =>
              AddFavoriteMovie(context.read<MovieRepository>()),
        ),
        RepositoryProvider<RemoveFavoriteMovie>(
          create: (context) =>
              RemoveFavoriteMovie(context.read<MovieRepository>()),
        ),
        RepositoryProvider<GetFavoriteMovies>(
          create: (context) =>
              GetFavoriteMovies(context.read<MovieRepository>()),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<MovieSearchBloc>(
            create: (context) => MovieSearchBloc(context.read<SearchMovies>()),
          ),
          BlocProvider<MovieDetailBloc>(
            create: (context) => MovieDetailBloc(
              context.read<GetMovieDetail>(),
              context.read<IsFavoriteMovie>(),
              context.read<AddFavoriteMovie>(),
              context.read<RemoveFavoriteMovie>(),
            ),
          ),
          BlocProvider<FavoritesBloc>(
            create: (context) => FavoritesBloc(
              context.read<GetFavoriteMovies>(),
              context.read<RemoveFavoriteMovie>(),
            ),
          ),
          BlocProvider<FilterBloc>(create: (_) => FilterBloc()),
        ],
        child: MaterialApp(
          title: 'Movie Stream App',
          theme: AppTheme.darkTheme,
          home: const MainPage(),
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}
