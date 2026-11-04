
import 'package:flutter/material.dart';

import '../models/movie.dart';

class MovieSection extends StatelessWidget {
  final String title;
  final List<Movie> movies;
  final ValueChanged<Movie> onMovieTap;

  const MovieSection({
    super.key,
    required this.title,
    required this.movies,
    required this.onMovieTap,
  });

  static const Color gold = Color(0xFFD6AD60);

  @override
  Widget build(BuildContext context) {
    if (movies.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 23,
              decoration: BoxDecoration(
                color: gold,
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            const SizedBox(width: 11),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 19,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.3,
                ),
              ),
            ),
            Text(
              '${movies.length} FILMS',
              style: const TextStyle(
                color: Colors.white38,
                fontSize: 9,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.3,
              ),
            ),
          ],
        ),
        const SizedBox(height: 19),
        LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final columns = width >= 1050
                ? 5
                : width >= 750
                    ? 4
                    : width >= 500
                        ? 3
                        : 2;

            const spacing = 15.0;
            final cardWidth =
                (width - spacing * (columns - 1)) / columns;

            return Wrap(
              spacing: spacing,
              runSpacing: 22,
              children: movies.map((movie) {
                return SizedBox(
                  width: cardWidth,
                  child: _MoviePosterCard(
                    movie: movie,
                    onTap: () => onMovieTap(movie),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }
}

class _MoviePosterCard extends StatefulWidget {
  final Movie movie;
  final VoidCallback onTap;

  const _MoviePosterCard({
    required this.movie,
    required this.onTap,
  });

  @override
  State<_MoviePosterCard> createState() =>
      _MoviePosterCardState();
}

class _MoviePosterCardState extends State<_MoviePosterCard> {
  bool _hovered = false;
  bool _pressed = false;

  static const Color gold = Color(0xFFD6AD60);

  @override
  Widget build(BuildContext context) {
    final highlighted = _hovered || _pressed;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() {
        _hovered = false;
        _pressed = false;
      }),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        transform: Matrix4.identity()
                  ..translateByDouble(
                    0.0,
                    highlighted ? -5.0 : 0.0,
                    0.0,
                    1.0,
                ),
        decoration: BoxDecoration(
          color: const Color(0xFF151515),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: highlighted
                ? gold.withValues(alpha: 0.65)
                : Colors.white.withValues(alpha: 0.07),
          ),
          boxShadow: [
            BoxShadow(
              color: highlighted
                  ? gold.withValues(alpha: 0.12)
                  : Colors.black.withValues(alpha: 0.25),
              blurRadius: highlighted ? 20 : 10,
              offset: const Offset(0, 7),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(15),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: widget.onTap,
            onHighlightChanged: (value) {
              setState(() => _pressed = value);
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: 0.70,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        widget.movie.image,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: const Color(0xFF242424),
                            alignment: Alignment.center,
                            child: const Icon(
                              Icons.movie_outlined,
                              color: Colors.white38,
                              size: 38,
                            ),
                          );
                        },
                      ),
                      const DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color(0x22000000),
                              Colors.transparent,
                              Color(0x88000000),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 9,
                        right: 9,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.78),
                            borderRadius: BorderRadius.circular(7),
                            border: Border.all(
                              color: gold.withValues(alpha: 0.45),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.star_rounded,
                                color: gold,
                                size: 12,
                              ),
                              const SizedBox(width: 3),
                              Text(
                                widget.movie.rating.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 9,
                        left: 9,
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 180),
                          opacity: highlighted ? 1 : 0.75,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: gold,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'VIEW DETAILS',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 8,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.6,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(11, 11, 11, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.movie.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          height: 1.25,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 7),
                      Text(
                        '${widget.movie.year}  •  ${widget.movie.genre}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 9,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
