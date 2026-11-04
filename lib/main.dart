
import 'package:flutter/material.dart';

import 'data/movies_data.dart';
import 'models/movie.dart';
import 'sections/now_playing_section.dart';
import 'sections/movie_section.dart';
import 'sections/discover_section.dart';
import 'widgets/movie_detail_dialog.dart';

void main() {
  runApp(const NoxviaApp());
}

class NoxviaApp extends StatelessWidget {
  const NoxviaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NOXVIA',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF080808),
        fontFamily: 'Roboto',
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFD6AD60),
          brightness: Brightness.dark,
        ),
      ),
      home: const NoxviaHomePage(),
    );
  }
}

class NoxviaHomePage extends StatefulWidget {
  const NoxviaHomePage({super.key});

  @override
  State<NoxviaHomePage> createState() => _NoxviaHomePageState();
}

class _NoxviaHomePageState extends State<NoxviaHomePage> {
  final TextEditingController _searchController =
      TextEditingController();

  static const Color _gold = Color(0xFFD6AD60);

  String _searchQuery = '';
  bool _mobileSearchExpanded = false;

  List<Movie> get _allMovies {
    final movies = [
      ...nowPlayingMovies,
      ...trendingMovies,
      ...popularMovies,
      ...topRatedMovies,
    ];

    final uniqueMovies = <String, Movie>{};

    for (final movie in movies) {
      uniqueMovies.putIfAbsent(movie.title, () => movie);
    }

    return uniqueMovies.values.toList();
  }

  List<Movie> get _searchResults {
    if (_searchQuery.trim().isEmpty) return [];

    final query = _searchQuery.trim().toLowerCase();

    return _allMovies.where((movie) {
      return movie.title.toLowerCase().contains(query) ||
          movie.genre.toLowerCase().contains(query);
    }).toList();
  }

  void _openMovieDetails(Movie movie) {
    showDialog(
      context: context,
      builder: (context) {
        return MovieDetailDialog(movie: movie);
      },
    );
  }

  void _clearSearch() {
    _searchController.clear();

    setState(() {
      _searchQuery = '';
    });
  }

  void _closeMobileSearch() {
    _searchController.clear();

    setState(() {
      _searchQuery = '';
      _mobileSearchExpanded = false;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // HEADER
  Widget _buildHeader(bool isDesktop, double availableWidth) {
    final searchWidth = isDesktop
        ? 270.0
        : (_mobileSearchExpanded
            ? (availableWidth * 0.36).clamp(112.0, 145.0)
            : 44.0);

    return Padding(
      padding: EdgeInsets.only(
        top: isDesktop ? 30 : 22,
        bottom: 34,
      ),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Container(
                  width: 43,
                  height: 43,
                  decoration: BoxDecoration(
                    color: _gold.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(13),
                    border: Border.all(
                      color: _gold.withValues(alpha: 0.3),
                    ),
                  ),
                  child: const Icon(
                    Icons.local_movies_rounded,
                    color: _gold,
                    size: 25,
                  ),
                ),
                const SizedBox(width: 10),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'NOXVIA',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: _gold,
                          fontSize: 25,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 3,
                        ),
                      ),
                      Text(
                        'YOUR CINEMATIC UNIVERSE',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 8,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            width: searchWidth,
            height: 44,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF171717),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.09),
              ),
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    if (!isDesktop) {
                      setState(() {
                        _mobileSearchExpanded =
                            !_mobileSearchExpanded;
                      });
                    }
                  },
                  child: const Icon(
                    Icons.search_rounded,
                    color: _gold,
                    size: 21,
                  ),
                ),
                if (isDesktop || _mobileSearchExpanded) ...[
                  const SizedBox(width: 7),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      autofocus: !isDesktop,
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Search...',
                        hintStyle: TextStyle(
                          color: Colors.white38,
                          fontSize: 11,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                  if (_searchQuery.isNotEmpty)
                    GestureDetector(
                      onTap: _clearSearch,
                      child: const Icon(
                        Icons.close_rounded,
                        size: 16,
                        color: Colors.white54,
                      ),
                    )
                  else if (!isDesktop)
                    GestureDetector(
                      onTap: _closeMobileSearch,
                      child: const Icon(
                        Icons.close_rounded,
                        size: 16,
                        color: Colors.white54,
                      ),
                    ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  // SEARCH CONTENT
  Widget _buildSearchContent() {
    if (_searchResults.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 55),
        child: Center(
          child: Column(
            children: [
              const Icon(
                Icons.movie_filter_outlined,
                color: Colors.white24,
                size: 48,
              ),
              const SizedBox(height: 14),
              const Text(
                'No movies found',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Try another movie title or genre.',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return MovieSection(
      title: 'Search Results',
      movies: _searchResults,
      onMovieTap: _openMovieDetails,
    );
  }

  // FOOTER - CENTERED
  Widget _buildFooter() {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(
          top: 45,
          bottom: 25,
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 45,
                height: 2,
                decoration: BoxDecoration(
                  color: _gold,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'NOXVIA',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _gold,
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 4,
                ),
              ),
              const SizedBox(height: 7),
              Text(
                'YOUR CINEMATIC UNIVERSE',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 9,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'BUILT WITH FLUTTER',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 9,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Dibuat oleh',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 10,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Muhamad Sholihuddin',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'NOXVIA © 2026 TUGAS Pemrograman Mobile II',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey.shade800,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF101010),
              Color(0xFF080808),
              Color(0xFF080808),
            ],
          ),
        ),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 1180,
                    ),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final isDesktop =
                            constraints.maxWidth >= 750;

                        final horizontalPadding =
                            isDesktop ? 30.0 : 18.0;

                        final contentWidth =
                            constraints.maxWidth -
                            (horizontalPadding * 2);

                        return Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: horizontalPadding,
                          ),
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              _buildHeader(
                                isDesktop,
                                contentWidth,
                              ),

                              if (_searchQuery.trim().isNotEmpty) ...[
                                _buildSearchContent(),
                              ] else ...[
                                const NowPlayingSection(),

                                const SizedBox(height: 38),

                                DiscoverSection(
                                  movies: _allMovies,
                                ),

                                const SizedBox(height: 45),

                                MovieSection(
                                  title: 'Trending Now',
                                  movies: trendingMovies,
                                  onMovieTap: _openMovieDetails,
                                ),

                                const SizedBox(height: 38),

                                MovieSection(
                                  title: 'Popular Movies',
                                  movies: popularMovies,
                                  onMovieTap: _openMovieDetails,
                                ),

                                const SizedBox(height: 38),

                                MovieSection(
                                  title: 'Top Rated',
                                  movies: topRatedMovies,
                                  onMovieTap: _openMovieDetails,
                                ),
                              ],

                              _buildFooter(),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
