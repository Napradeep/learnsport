import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class SportsCacheManager {
  static final CacheManager instance = CacheManager(
    Config(
      "sportsBannerCache",
      stalePeriod: const Duration(days: 7),   
      maxNrOfCacheObjects: 200,              
    ),
  );
}
