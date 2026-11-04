
import 'dart:async';

import 'package:flutter/material.dart';

import '../data/movies_data.dart';
import '../models/movie.dart';

class NowPlayingSection extends StatefulWidget {
  const NowPlayingSection({super.key});

  @override
  State<NowPlayingSection> createState() => _NowPlayingSectionState();
}

class _NowPlayingSectionState extends State<NowPlayingSection> {
  static const Color gold = Color(0xFFD6AD60);

  late final PageController _pageController;
  Timer? _autoPlayTimer;

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();

    _pageController = PageController();

    if (nowPlayingMovies.length > 1) {
      _autoPlayTimer = Timer.periodic(
        const Duration(seconds: 5),
        (_) {
          if (!mounted || !_pageController.hasClients) return;

          final nextIndex =
              (_currentIndex + 1) % nowPlayingMovies.length;

          _pageController.animateToPage(
            nextIndex,
            duration: const Duration(milliseconds: 900),
            curve: Curves.easeInOutCubic,
          );
        },
      );
    }
  }

  @override
  void dispose() {
    _autoPlayTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final movies = nowPlayingMovies;

    if (movies.isEmpty) {
      return const SizedBox.shrink();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 750;
        final height = isDesktop ? 410.0 : 430.0;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(
                  Icons.movie_filter_rounded,
                  color: gold,
                  size: 19,
                ),
                SizedBox(width: 9),
                Text(
                  'NOW SHOWING',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Divider(color: Colors.white12),
                ),
              ],
            ),
            const SizedBox(height: 17),

            SizedBox(
              height: height,
              width: double.infinity,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: movies.length,
                  physics: const BouncingScrollPhysics(),
                  onPageChanged: (index) {
                    if (!mounted) return;

                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    return _HeroMovieCard(
                      movie: movies[index],
                    );
                  },
                ),
              ),
            ),

            if (movies.length > 1) ...[
              const SizedBox(height: 13),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  movies.length,
                  (index) {
                    final isActive = index == _currentIndex;

                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: const EdgeInsets.symmetric(
                        horizontal: 3,
                      ),
                      width: isActive ? 23 : 7,
                      height: 5,
                      decoration: BoxDecoration(
                        color: isActive
                            ? gold
                            : Colors.white24,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    );
                  },
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}

class _HeroMovieCard extends StatelessWidget {
  final Movie movie;

  const _HeroMovieCard({
    required this.movie,
  });

  static const Color gold = Color(0xFFD6AD60);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            movie.image,
            fit: BoxFit.cover,
            alignment: Alignment.center,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: const Color(0xFF202020),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.movie_outlined,
                  color: Colors.white38,
                  size: 60,
                ),
              );
            },
          ),

          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerRight,
                end: Alignment.centerLeft,
                colors: [
                  Color(0x22000000),
                  Color(0x88000000),
                  Color(0xF5000000),
                ],
                stops: [0.0, 0.48, 1.0],
              ),
            ),
          ),

          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0x33000000),
                  Colors.transparent,
                  Color(0x99000000),
                ],
              ),
            ),
          ),

          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: gold.withValues(alpha: 0.35),
                  width: 1,
                ),
              ),
            ),
          ),

          Positioned(
            left: 25,
            right: 25,
            bottom: 27,
            top: 25,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final compact = constraints.maxWidth < 450;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: gold.withValues(alpha: 0.13),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: gold.withValues(alpha: 0.65),
                        ),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.auto_awesome,
                            color: gold,
                            size: 13,
                          ),
                          SizedBox(width: 7),
                          Text(
                            'FEATURED PREMIERE',
                            style: TextStyle(
                              color: gold,
                              fontSize: 9,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 17),

                    Text(
                      movie.title.toUpperCase(),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: compact ? 27 : 39,
                        height: 1.05,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.5,
                        shadows: const [
                          Shadow(
                            color: Colors.black87,
                            blurRadius: 15,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 13),

                    Wrap(
                      spacing: 15,
                      runSpacing: 8,
                      crossAxisAlignment:
                          WrapCrossAlignment.center,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.star_rounded,
                              color: gold,
                              size: 19,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              movie.rating.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        _metadata(movie.year),
                        _metadata(movie.genre),
                      ],
                    ),

                    const SizedBox(height: 20),

                    Container(
                      width: 48,
                      height: 3,
                      decoration: BoxDecoration(
                        color: gold,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),

                    const SizedBox(height: 12),

                    const Text(
                      'EXPERIENCE THE CINEMA',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _metadata(String value) {
    return Text(
      value,
      style: const TextStyle(
        color: Colors.white70,
        fontSize: 11,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
