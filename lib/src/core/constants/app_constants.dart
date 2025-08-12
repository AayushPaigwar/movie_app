class AppConstants {
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingExtraLarge = 32.0;
  
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;
  static const double radiusExtraLarge = 20.0;
  
  static const double iconSizeSmall = 16.0;
  static const double iconSizeMedium = 24.0;
  static const double iconSizeLarge = 32.0;
  
  static const double movieCardWidth = 140.0;
  static const double movieCardHeight = 200.0;
  static const double movieCardAspectRatio = 0.7;
  
  static const double carouselHeight = 240.0;
  static const double carouselAspectRatio = 1.6;
  
  static const Duration animationFast = Duration(milliseconds: 200);
  static const Duration animationMedium = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 500);
  
  static const Duration pageTransitionDuration = Duration(milliseconds: 300);
  static const Duration heroTransitionDuration = Duration(milliseconds: 400);
  static const Duration shimmerDuration = Duration(milliseconds: 1500);
  
  static const int moviesPerPage = 10;
  static const int cacheImageCount = 20;
  
  static const List<String> genres = [
    'All',
    'Action',
    'Adventure',
    'Animation',
    'Comedy',
    'Crime',
    'Documentary',
    'Drama',
    'Family',
    'Fantasy',
    'Horror',
    'Music',
    'Mystery',
    'Romance',
    'Sci-Fi',
    'Thriller',
    'War',
    'Western',
  ];
  
  static const List<String> movieTypes = [
    'movie',
    'series',
    'episode',
  ];
  
  static const List<String> years = [
    'All Years',
    '2024',
    '2023',
    '2022',
    '2021',
    '2020',
    '2019',
    '2018',
    '2017',
    '2016',
    '2015',
  ];
}