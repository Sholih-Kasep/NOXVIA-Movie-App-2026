
import 'package:flutter/material.dart';

import '../models/movie.dart';

class MovieDetailDialog extends StatelessWidget {
  final Movie movie;

  const MovieDetailDialog({
    super.key,
    required this.movie,
  });

  static const Color gold = Color(0xFFD6AD60);
  static const Color panel = Color(0xFF151515);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isWide = screenWidth >= 650;

    return Dialog(
      backgroundColor: panel,
      insetPadding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 24,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
        side: BorderSide(
          color: gold.withValues(alpha: 0.35),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 760,
          maxHeight: 650,
        ),
        child: SingleChildScrollView(
          child: isWide
              ? _buildDesktopLayout(context)
              : _buildMobileLayout(context),
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 260,
          height: 430,
          child: _buildPoster(),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(25, 25, 25, 22),
            child: _buildInformation(context),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 245,
          child: Stack(
            fit: StackFit.expand,
            children: [
              _buildPoster(),
              Positioned(
                top: 12,
                right: 12,
                child: _buildCloseButton(context),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 22),
          child: _buildInformation(
            context,
            showCloseButton: false,
          ),
        ),
      ],
    );
  }

  Widget _buildPoster() {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          movie.image,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: const Color(0xFF242424),
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
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0x22000000),
                Colors.transparent,
                Color(0x55000000),
              ],
            ),
          ),
        ),
        Positioned(
          left: 14,
          top: 14,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 7,
            ),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: gold.withValues(alpha: 0.7),
              ),
            ),
            child: const Text(
              'NOXVIA FILM',
              style: TextStyle(
                color: gold,
                fontSize: 9,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.2,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInformation(
    BuildContext context, {
    bool showCloseButton = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'MOVIE DETAILS',
                style: TextStyle(
                  color: gold,
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                ),
              ),
            ),
            if (showCloseButton) _buildCloseButton(context),
          ],
        ),
        const SizedBox(height: 17),
        Text(
          movie.title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 25,
            height: 1.15,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 18),
        Wrap(
          spacing: 8,
          runSpacing: 9,
          children: [
            _buildMetadata(
              Icons.star_rounded,
              movie.rating.toString(),
              gold,
            ),
            _buildMetadata(
              Icons.calendar_today_rounded,
              movie.year,
              Colors.white70,
            ),
            _buildMetadata(
              Icons.movie_filter_rounded,
              movie.genre,
              Colors.white70,
            ),
          ],
        ),
        const SizedBox(height: 24),
        Container(
          width: 45,
          height: 3,
          decoration: BoxDecoration(
            color: gold,
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        const SizedBox(height: 18),
        const Text(
          'ABOUT THIS FILM',
          style: TextStyle(
            color: Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.4,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Explore this cinematic title through NOXVIA. '
          'Discover its genre, release year, and rating '
          'in one place.',
          style: TextStyle(
            color: Colors.white60,
            fontSize: 12,
            height: 1.8,
          ),
        ),
        const SizedBox(height: 25),
        SizedBox(
          width: double.infinity,
          height: 46,
          child: ElevatedButton.icon(
            onPressed: () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: gold,
              foregroundColor: Colors.black,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(
              Icons.check_circle_outline_rounded,
              size: 18,
            ),
            label: const Text(
              'CLOSE DETAILS',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w900,
                letterSpacing: 1,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMetadata(
    IconData icon,
    String value,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(9),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.08),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 14),
          const SizedBox(width: 6),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCloseButton(BuildContext context) {
    return IconButton(
      onPressed: () => Navigator.of(context).pop(),
      tooltip: 'Close',
      style: IconButton.styleFrom(
        backgroundColor: Colors.white.withValues(alpha: 0.08),
        foregroundColor: Colors.white,
      ),
      icon: const Icon(
        Icons.close_rounded,
        size: 19,
      ),
    );
  }
}
