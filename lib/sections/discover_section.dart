
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';

import '../models/movie.dart';

class DiscoverSection extends StatefulWidget {
  final List<Movie> movies;

  const DiscoverSection({
    super.key,
    required this.movies,
  });

  @override
  State<DiscoverSection> createState() => _DiscoverSectionState();
}

class _DiscoverSectionState extends State<DiscoverSection> {
  final CardSwiperController _controller = CardSwiperController();

  int _currentIndex = 0;

  bool _onSwipe(
    int previousIndex,
    int? currentIndex,
    CardSwiperDirection direction,
  ) {
    if (!mounted) return false;

    setState(() {
      _currentIndex = currentIndex ?? widget.movies.length;
    });

    return true;
  }

  void _restartDiscovery() {
    _controller.moveTo(0);

    setState(() {
      _currentIndex = 0;
    });
  }

  Widget _buildMovieCard(Movie movie) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // MOVIE POSTER
          Container(
            color: const Color(0xFF202020),
            child: Image.asset(
              movie.image,
              fit: BoxFit.cover,
              alignment: Alignment.center,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: const Color(0xFF202020),
                  alignment: Alignment.center,
                  child: const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.broken_image_outlined,
                        color: Colors.white38,
                        size: 55,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'POSTER NOT AVAILABLE',
                        style: TextStyle(
                          color: Colors.white38,
                          fontSize: 10,
                          letterSpacing: 1.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // CINEMATIC GRADIENT
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0x33000000),
                  Colors.transparent,
                  Color(0x66000000),
                  Color(0xF5000000),
                ],
                stops: [0.0, 0.35, 0.65, 1.0],
              ),
            ),
          ),

          // NOXVIA LABEL
          Positioned(
            top: 15,
            left: 15,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: const Color(0xE6000000),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: const Color(0xFFD6AD60),
                  width: 0.8,
                ),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.auto_awesome,
                    color: Color(0xFFD6AD60),
                    size: 12,
                  ),
                  SizedBox(width: 6),
                  Text(
                    'NOXVIA EXCLUSIVE',
                    style: TextStyle(
                      color: Color(0xFFD6AD60),
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // MOVIE INFORMATION
          Positioned(
            left: 18,
            right: 18,
            bottom: 18,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  movie.title.toUpperCase(),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.4,
                  ),
                ),

                const SizedBox(height: 9),

                Row(
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      color: Color(0xFFD6AD60),
                      size: 17,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      movie.rating.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Flexible(
                      child: Text(
                        '•  ${movie.year}  •  ${movie.genre}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 17),

                const Divider(
                  color: Colors.white24,
                  height: 1,
                ),

                const SizedBox(height: 12),

                const Row(
                  children: [
                    Icon(
                      Icons.swipe,
                      color: Color(0xFFD6AD60),
                      size: 15,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'SWIPE TO EXPLORE',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final movies = widget.movies;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 750;

        final cardWidth = isDesktop
            ? 700.0
            : constraints.maxWidth;

        final cardHeight = isDesktop ? 375.0 : 365.0;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // SECTION HEADER
            Row(
              children: [
                Container(
                  width: 3,
                  height: 27,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD6AD60),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),

                const SizedBox(width: 12),

                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'DISCOVER MOVIES',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 19,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.8,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Find your next cinematic experience.',
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),

                const Icon(
                  Icons.auto_awesome,
                  color: Color(0xFFD6AD60),
                  size: 20,
                ),
              ],
            ),

            const SizedBox(height: 24),

            // EMPTY MOVIE LIST
            if (movies.isEmpty)
              const Center(
                child: Text(
                  'No movies available.',
                  style: TextStyle(
                    color: Colors.white54,
                  ),
                ),
              )
            else
              Stack(
                alignment: Alignment.center,
                children: [
                  // MOVIE SWIPER
                  Center(
                    child: SizedBox(
                      width: cardWidth,
                      height: cardHeight,
                      child: CardSwiper(
                        controller: _controller,
                        cardsCount: movies.length,
                        numberOfCardsDisplayed: 1,
                        backCardOffset: Offset.zero,
                        padding: EdgeInsets.zero,
                        isLoop: false,
                        onSwipe: _onSwipe,
                        cardBuilder: (
                          context,
                          index,
                          horizontalOffsetPercentage,
                          verticalOffsetPercentage,
                        ) {
                          return _buildMovieCard(
                            movies[index],
                          );
                        },
                      ),
                    ),
                  ),

                  // DISCOVERY COMPLETED
                  if (_currentIndex >= movies.length)
                    Container(
                      width: double.infinity,
                      height: cardHeight,
                      decoration: BoxDecoration(
                        color: const Color(0xFF151515),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFFD6AD60)
                              .withValues(alpha: 0.4),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.movie_filter_outlined,
                            color: Color(0xFFD6AD60),
                            size: 55,
                          ),

                          const SizedBox(height: 15),

                          const Text(
                            'DISCOVERY COMPLETED',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),

                          const SizedBox(height: 8),

                          Text(
                            'You have explored all ${movies.length} movies.',
                            style: const TextStyle(
                              color: Colors.white54,
                              fontSize: 12,
                            ),
                          ),

                          const SizedBox(height: 18),

                          TextButton.icon(
                            onPressed: _restartDiscovery,
                            icon: const Icon(
                              Icons.refresh,
                              color: Color(0xFFD6AD60),
                            ),
                            label: const Text(
                              'DISCOVER AGAIN',
                              style: TextStyle(
                                color: Color(0xFFD6AD60),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),

            // MOVIE PROGRESS
            if (movies.isNotEmpty) ...[
              const SizedBox(height: 17),

              Center(
                child: Text(
                  '${_currentIndex > movies.length ? movies.length : _currentIndex} / ${movies.length} MOVIES EXPLORED',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white38,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}
