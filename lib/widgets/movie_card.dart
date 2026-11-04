
import 'package:flutter/material.dart';

import '../models/movie.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;
  final double? width;
  final bool landscape;
  final VoidCallback? onTap;

  const MovieCard({
    super.key,
    required this.movie,
    this.width,
    this.landscape = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (landscape) {
      return SizedBox(
        width: width,
        child: _buildLandscapeCard(),
      );
    }

    return SizedBox(
      width: width,
      child: _buildPortraitCard(),
    );
  }

  Widget _buildPortraitCard() {
    return Material(
      color: const Color(0xFF151515),
      borderRadius: BorderRadius.circular(13),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final imageHeight = constraints.maxHeight * 0.70;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // POSTER
                SizedBox(
                  width: double.infinity,
                  height: imageHeight,
                  child: _buildPoster(),
                ),

                // MOVIE INFORMATION
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(9, 6, 9, 6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: Text(
                            movie.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),

                        Row(
                          children: [
                            const Icon(
                              Icons.star_rounded,
                              color: Color(0xFFD6AD60),
                              size: 14,
                            ),
                            const SizedBox(width: 3),
                            Text(
                              '${movie.rating}',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 7),
                            Expanded(
                              child: Text(
                                '${movie.year} • ${movie.genre}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white54,
                                  fontSize: 9,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildLandscapeCard() {
    return Material(
      color: const Color(0xFF151515),
      borderRadius: BorderRadius.circular(13),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            SizedBox(
              width: 105,
              height: double.infinity,
              child: _buildPoster(),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      '${movie.genre} • ${movie.year}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 10,
                      ),
                    ),
                    const SizedBox(height: 7),
                    _buildRating(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPoster() {
    return Image.asset(
      movie.image,
      width: double.infinity,
      height: double.infinity,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: const Color(0xFF202020),
          alignment: Alignment.center,
          child: const Icon(
            Icons.movie_outlined,
            color: Colors.white38,
            size: 35,
          ),
        );
      },
    );
  }

  Widget _buildRating() {
    return Row(
      children: [
        const Icon(
          Icons.star_rounded,
          color: Color(0xFFD6AD60),
          size: 15,
        ),
        const SizedBox(width: 4),
        Text(
          '${movie.rating}',
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
