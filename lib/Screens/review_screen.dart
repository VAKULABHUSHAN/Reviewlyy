import 'package:flutter/material.dart';

import '../Themes/app_colors.dart';


// ─── Review Data Model ────────────────────────────────────────────────────────

class ReviewData {
  final int id;
  final String username;
  final String avatarUrl;
  final int rating;
  final String title;
  final String text;
  final DateTime date;

  const ReviewData({
    required this.id,
    required this.username,
    required this.avatarUrl,
    required this.rating,
    required this.title,
    required this.text,
    required this.date,
  });
}

// ─── Static Mock Reviews ──────────────────────────────────────────────────────

final _mockReviews = [
  ReviewData(
    id: 1,
    username: 'Alex Johnson',
    avatarUrl:
    'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&q=80&w=100',
    rating: 5,
    title: 'Absolutely worth every penny',
    text:
    'The sound quality on the Z1 is unmatched in this price range. I have been using it for over 2 months now for competitive gaming and the directional audio is precise. Comfortable enough for 8-hour sessions.',
    date: DateTime(2024, 5, 15),
  ),
  ReviewData(
    id: 2,
    username: 'Sarah Chen',
    avatarUrl:
    'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&q=80&w=100',
    rating: 4,
    title: 'Great mic, slightly bulky',
    text:
    'The noise cancellation on the microphone is fantastic. My friends say I sound crystal clear. The only downside is that it feels a bit heavy after a few hours, but the padding helps a lot.',
    date: DateTime(2024, 5, 10),
  ),
  ReviewData(
    id: 3,
    username: 'Marcus Wright',
    avatarUrl:
    'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&q=80&w=100',
    rating: 5,
    title: 'Exceptional Build Quality',
    text:
    'Feels very premium. The metal hinges are a nice touch. I dropped it once and not even a scratch. Software integration was easy too.',
    date: DateTime(2024, 5, 1),
  ),
];

// ─── Rating Distribution Data ─────────────────────────────────────────────────

const _ratingDist = [
  (stars: 5, percent: 0.75, label: '75%'),
  (stars: 4, percent: 0.15, label: '15%'),
  (stars: 3, percent: 0.05, label: '5%'),
  (stars: 2, percent: 0.03, label: '3%'),
  (stars: 1, percent: 0.02, label: '2%'),
];

// ─── Sort Options ─────────────────────────────────────────────────────────────

enum SortOption { latest, highest, lowest }

// ─── Reviews Screen ───────────────────────────────────────────────────────────

class ReviewsScreen extends StatefulWidget {
  const ReviewsScreen({super.key});

  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  bool _isDark = false;
  void _toggleTheme() => setState(() => _isDark = !_isDark);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: _isDark ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Manrope',
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.light,
          surface: AppColors.backgroundLight,
        ),
        scaffoldBackgroundColor: AppColors.backgroundLight,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Manrope',
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.dark,
          surface: AppColors.backgroundDark,
        ),
        scaffoldBackgroundColor: AppColors.backgroundDark,
      ),
      home: _ReviewsBody(isDark: _isDark, onToggleTheme: _toggleTheme),
    );
  }
}

// ─── Reviews Body ─────────────────────────────────────────────────────────────

class _ReviewsBody extends StatefulWidget {
  final bool isDark;
  final VoidCallback onToggleTheme;

  const _ReviewsBody({required this.isDark, required this.onToggleTheme});

  @override
  State<_ReviewsBody> createState() => _ReviewsBodyState();
}

class _ReviewsBodyState extends State<_ReviewsBody> {
  SortOption _sort = SortOption.latest;
  int _visibleCount = 3;

  List<ReviewData> get _sortedReviews {
    final list = [..._mockReviews];
    switch (_sort) {
      case SortOption.latest:
        list.sort((a, b) => b.date.compareTo(a.date));
      case SortOption.highest:
        list.sort((a, b) => b.rating.compareTo(a.rating));
      case SortOption.lowest:
        list.sort((a, b) => a.rating.compareTo(b.rating));
    }
    return list.take(_visibleCount).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    final isWide = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      appBar: _buildAppBar(context, isDark),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isWide ? 80 : 16,
                vertical: 32,
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1000),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Breadcrumb
                    _Breadcrumb(isDark: isDark),
                    const SizedBox(height: 24),
                    // Page header + CTA
                    _PageHeader(isDark: isDark),
                    const SizedBox(height: 32),
                    // Main layout: sidebar + reviews
                    isWide
                        ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 280,
                          child: _RatingSidebar(isDark: isDark),
                        ),
                        const SizedBox(width: 32),
                        Expanded(
                          child: _ReviewsColumn(
                            isDark: isDark,
                            sort: _sort,
                            reviews: _sortedReviews,
                            totalCount: _mockReviews.length,
                            visibleCount: _visibleCount,
                            onSortChanged: (s) =>
                                setState(() => _sort = s),
                            onLoadMore: () => setState(
                                    () => _visibleCount += 3),
                          ),
                        ),
                      ],
                    )
                        : Column(
                      children: [
                        _RatingSidebar(isDark: isDark),
                        const SizedBox(height: 24),
                        _ReviewsColumn(
                          isDark: isDark,
                          sort: _sort,
                          reviews: _sortedReviews,
                          totalCount: _mockReviews.length,
                          visibleCount: _visibleCount,
                          onSortChanged: (s) =>
                              setState(() => _sort = s),
                          onLoadMore: () =>
                              setState(() => _visibleCount += 3),
                        ),
                      ],
                    ),
                    const SizedBox(height: 48),
                  ],
                ),
              ),
            ),
            _Footer(isDark: isDark),
          ],
        ),
      ),
    );
  }

  // ── AppBar ──────────────────────────────────────────────────────────────────

  PreferredSizeWidget _buildAppBar(BuildContext context, bool isDark) {
    final isWide = MediaQuery.of(context).size.width > 700;
    return PreferredSize(
      preferredSize: const Size.fromHeight(64),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1A2236) : Colors.white,
          border: Border(
            bottom: BorderSide(
              color: isDark
                  ? AppColors.cardBorderDark
                  : AppColors.cardBorderLight,
            ),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: isWide ? 80 : 16, vertical: 12),
            child: Row(
              children: [
                // Logo
                const Icon(Icons.star_half_rounded,
                    color: AppColors.primary, size: 28),
                const SizedBox(width: 8),
                Text(
                  'ReviewPulse',
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                if (isWide) ...[
                  const SizedBox(width: 32),
                  for (final label in ['Home', 'Products', 'Categories', 'About'])
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: GestureDetector(
                        onTap: () {},
                        child: Text(
                          label,
                          style: const TextStyle(
                            fontFamily: 'Manrope',
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ),
                    ),
                ],
                const Spacer(),
                // Search bar
                if (isWide)
                  Container(
                    width: 220,
                    height: 38,
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF1E293B)
                          : const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isDark
                            ? AppColors.cardBorderDark
                            : AppColors.cardBorderLight,
                      ),
                    ),
                    child: const Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Icon(Icons.search,
                              size: 16, color: AppColors.textMuted),
                        ),
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Search reviews...',
                              border: InputBorder.none,
                              hintStyle: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textMuted,
                                  fontFamily: 'Manrope'),
                              contentPadding: EdgeInsets.zero,
                              isDense: true,
                            ),
                            style: TextStyle(
                                fontSize: 12, fontFamily: 'Manrope'),
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(width: 10),
                // Icon buttons
                _IconBtn(
                    icon: Icons.notifications_outlined,
                    isDark: isDark,
                    onTap: () {}),
                const SizedBox(width: 6),
                _IconBtn(
                    icon: Icons.account_circle_outlined,
                    isDark: isDark,
                    onTap: () {}),
                const SizedBox(width: 10),
                CircleAvatar(
                  radius: 18,
                  backgroundImage: const NetworkImage(
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuB3-mNfcWiqAKgzH4WgYjzhK-o-uaycG_xg759xrbPlHSodccS7mlgseNjjupr4qSKT1RdH9GTYBsjs71F2Gzp1FaY4ERGCImsLwPrQ3P717aMAU4TwlIJ4WY2BDEkDbM6kXQZzhzJB_Pvq_5glz7xYdyZRkfpwdW6cTiICwRHNCzw4XztlZarv3XXxPQKeQaO1JfwW_4WhDrNUERDuiMsusisyLqRToG4RiIMiT_rnEEBwTWGJ-x44oDF-xOXwHzTasii7UH90SCY',
                  ),
                  onBackgroundImageError: (_, __) {},
                ),
                const SizedBox(width: 6),
                IconButton(
                  onPressed: widget.onToggleTheme,
                  icon: Icon(
                    widget.isDark
                        ? Icons.light_mode_outlined
                        : Icons.dark_mode_outlined,
                    size: 18,
                    color: AppColors.textMuted,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Icon Button ──────────────────────────────────────────────────────────────

class _IconBtn extends StatelessWidget {
  final IconData icon;
  final bool isDark;
  final VoidCallback onTap;

  const _IconBtn(
      {required this.icon, required this.isDark, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: isDark
              ? const Color(0xFF1E293B)
              : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon,
            size: 20,
            color: isDark ? Colors.white70 : AppColors.textMuted),
      ),
    );
  }
}

// ─── Breadcrumb ───────────────────────────────────────────────────────────────

class _Breadcrumb extends StatelessWidget {
  final bool isDark;
  const _Breadcrumb({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final crumb in ['Home', 'Products'])
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () {},
                child: Text(crumb,
                    style: const TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 13,
                        color: AppColors.textMuted)),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4),
                child: Icon(Icons.chevron_right_rounded,
                    size: 14, color: AppColors.textMuted),
              ),
            ],
          ),
        Text(
          'Gaming Headset Z1',
          style: TextStyle(
            fontFamily: 'Manrope',
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
      ],
    );
  }
}

// ─── Page Header ──────────────────────────────────────────────────────────────

class _PageHeader extends StatelessWidget {
  final bool isDark;
  const _PageHeader({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 600;
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Customer Reviews',
          style: TextStyle(
            fontFamily: 'Manrope',
            fontSize: 34,
            fontWeight: FontWeight.w900,
            color: isDark ? Colors.white : Colors.black,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Explore authentic feedback from our verified community members.',
          style: TextStyle(
              fontFamily: 'Manrope', fontSize: 15, color: AppColors.textMuted),
        ),
      ],
    );

    final writeBtn = ElevatedButton.icon(
      onPressed: () {},
      icon: const Icon(Icons.rate_review_rounded, size: 18),
      label: const Text('Write a Review'),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding:
        const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
        elevation: 2,
        shadowColor: AppColors.primary.withOpacity(0.3),
        textStyle: const TextStyle(
            fontFamily: 'Manrope', fontSize: 14, fontWeight: FontWeight.w700),
      ),
    );

    return isWide
        ? Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(child: content),
        const SizedBox(width: 24),
        writeBtn,
      ],
    )
        : Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        content,
        const SizedBox(height: 16),
        writeBtn,
      ],
    );
  }
}

// ─── Rating Sidebar ───────────────────────────────────────────────────────────

class _RatingSidebar extends StatelessWidget {
  final bool isDark;
  const _RatingSidebar({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Overall score
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '4.8',
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 48,
                  fontWeight: FontWeight.w900,
                  color: isDark ? Colors.white : Colors.black,
                  height: 1,
                ),
              ),
              const SizedBox(width: 6),
              const Text(
                '/ 5.0',
                style: TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 14,
                    color: AppColors.textMuted),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Stars
          Row(
            children: [
              ...List.generate(
                  4,
                      (_) => const Icon(Icons.star_rounded,
                      color: AppColors.starYellow, size: 20)),
              const Icon(Icons.star_half_rounded,
                  color: AppColors.starYellow, size: 20),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'Based on 1,248 reviews',
            style: TextStyle(
                fontFamily: 'Manrope',
                fontSize: 13,
                color: AppColors.textMuted),
          ),
          const SizedBox(height: 20),
          // Rating bars
          ..._ratingDist.map((r) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              children: [
                SizedBox(
                  width: 16,
                  child: Text(
                    '${r.stars}',
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white70 : const Color(0xFF374151),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Stack(
                      children: [
                        Container(
                          height: 10,
                          color: isDark
                              ? AppColors.cardBorderDark
                              : const Color(0xFFF1F5F9),
                        ),
                        FractionallySizedBox(
                          widthFactor: r.percent,
                          child: Container(
                            height: 10,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: 32,
                  child: Text(
                    r.label,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textMuted,
                    ),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}

// ─── Reviews Column ───────────────────────────────────────────────────────────

class _ReviewsColumn extends StatelessWidget {
  final bool isDark;
  final SortOption sort;
  final List<ReviewData> reviews;
  final int totalCount;
  final int visibleCount;
  final ValueChanged<SortOption> onSortChanged;
  final VoidCallback onLoadMore;

  const _ReviewsColumn({
    required this.isDark,
    required this.sort,
    required this.reviews,
    required this.totalCount,
    required this.visibleCount,
    required this.onSortChanged,
    required this.onLoadMore,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Sort bar + count
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _SortChip(
                            label: 'Latest',
                            icon: Icons.schedule_rounded,
                            isActive: sort == SortOption.latest,
                            isDark: isDark,
                            onTap: () => onSortChanged(SortOption.latest),
                          ),
                          const SizedBox(width: 8),
                          _SortChip(
                            label: 'Highest',
                            icon: Icons.arrow_upward_rounded,
                            isActive: sort == SortOption.highest,
                            isDark: isDark,
                            onTap: () => onSortChanged(SortOption.highest),
                          ),
                          const SizedBox(width: 8),
                          _SortChip(
                            label: 'Lowest',
                            icon: Icons.arrow_downward_rounded,
                            isActive: sort == SortOption.lowest,
                            isDark: isDark,
                            onTap: () => onSortChanged(SortOption.lowest),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 13,
                      color: AppColors.textMuted),
                  children: [
                    const TextSpan(text: 'Showing '),
                    TextSpan(
                      text: '${reviews.length}',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                    const TextSpan(text: ' reviews'),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Divider(
                color: isDark
                    ? AppColors.cardBorderDark
                    : AppColors.cardBorderLight,
                height: 1,
              ),
            ],
          ),
        ),

        // Reviews list or empty state
        reviews.isEmpty
            ? _EmptyState(isDark: isDark)
            : Column(
          children: [
            ...reviews.map((r) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: ReviewCard(review: r, isDark: isDark),
            )),
            const SizedBox(height: 8),
            // Load More
            if (visibleCount < totalCount)
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: onLoadMore,
                  style: OutlinedButton.styleFrom(
                    foregroundColor:
                    isDark ? Colors.white70 : AppColors.textMuted,
                    side: BorderSide(
                      color: isDark
                          ? AppColors.cardBorderDark
                          : AppColors.cardBorderLight,
                      width: 2,
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    padding:
                    const EdgeInsets.symmetric(vertical: 14),
                    textStyle: const TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 14,
                        fontWeight: FontWeight.w700),
                  ),
                  child: const Text('Load More Reviews'),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

// ─── Sort Chip ────────────────────────────────────────────────────────────────

class _SortChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isActive;
  final bool isDark;
  final VoidCallback onTap;

  const _SortChip({
    required this.label,
    required this.icon,
    required this.isActive,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.primary
              : (isDark
              ? const Color(0xFF1E293B)
              : const Color(0xFFF1F5F9)),
          borderRadius: BorderRadius.circular(100),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isActive
                  ? Colors.white
                  : (isDark ? Colors.white60 : AppColors.textMuted),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Manrope',
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: isActive
                    ? Colors.white
                    : (isDark ? Colors.white60 : AppColors.textMuted),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Empty State ──────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  final bool isDark;
  const _EmptyState({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 64),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xFF1E293B)
                  : const Color(0xFFF1F5F9),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(Icons.rate_review_rounded,
                  size: 36, color: AppColors.textMuted),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'No reviews yet',
            style: TextStyle(
              fontFamily: 'Manrope',
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Be the first to review this product and share your experience with the community.',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: 'Manrope',
                fontSize: 14,
                color: AppColors.textMuted),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () {},
            child: const Text(
              'Write the first review',
              style: TextStyle(
                fontFamily: 'Manrope',
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Reusable Review Card ─────────────────────────────────────────────────────

class ReviewCard extends StatefulWidget {
  final ReviewData review;
  final bool isDark;

  const ReviewCard({super.key, required this.review, required this.isDark});

  @override
  State<ReviewCard> createState() => _ReviewCardState();
}

class _ReviewCardState extends State<ReviewCard> {
  bool _helpful = false;

  String _formatDate(DateTime date) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final r = widget.review;
    final isDark = widget.isDark;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: avatar + name + date
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(r.avatarUrl),
                      onBackgroundImageError: (_, __) {},
                      backgroundColor: isDark
                          ? const Color(0xFF1E293B)
                          : const Color(0xFFF1F5F9),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          r.username,
                          style: TextStyle(
                            fontFamily: 'Manrope',
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: isDark ? Colors.white : Colors.black,
                          ),
                        ),
                        const Text(
                          'Verified Purchase',
                          style: TextStyle(
                            fontFamily: 'Manrope',
                            fontSize: 11,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Text(
                  _formatDate(r.date),
                  style: const TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 11,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            // Stars
            Row(
              children: List.generate(
                5,
                    (i) => Icon(
                  i < r.rating
                      ? Icons.star_rounded
                      : Icons.star_outline_rounded,
                  color: i < r.rating
                      ? AppColors.starYellow
                      : AppColors.starEmpty,
                  size: 18,
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Title
            Text(
              r.title,
              style: TextStyle(
                fontFamily: 'Manrope',
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 6),
            // Body
            Text(
              r.text,
              style: const TextStyle(
                fontFamily: 'Manrope',
                fontSize: 13,
                color: AppColors.textMuted,
                height: 1.55,
              ),
            ),
            const SizedBox(height: 16),
            Divider(
              color: isDark
                  ? AppColors.cardBorderDark
                  : const Color(0xFFF1F5F9),
              height: 1,
            ),
            const SizedBox(height: 12),
            // Footer actions
            Row(
              children: [
                GestureDetector(
                  onTap: () => setState(() => _helpful = !_helpful),
                  child: Row(
                    children: [
                      Icon(
                        _helpful
                            ? Icons.thumb_up_rounded
                            : Icons.thumb_up_outlined,
                        size: 15,
                        color: _helpful
                            ? AppColors.primary
                            : AppColors.textMuted,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        'Helpful',
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: _helpful
                              ? AppColors.primary
                              : AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                GestureDetector(
                  onTap: () {},
                  child: const Text(
                    'Report',
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textMuted,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Footer ───────────────────────────────────────────────────────────────────

class _Footer extends StatelessWidget {
  final bool isDark;
  const _Footer({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 600;

    return Container(
      color: isDark ? const Color(0xFF1A2236) : Colors.white,
      padding: EdgeInsets.symmetric(
          horizontal: isWide ? 80 : 16, vertical: 32),
      child: Column(
        children: [
          Divider(
            color: isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight,
            height: 1,
          ),
          const SizedBox(height: 24),
          isWide
              ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.star_half_rounded,
                      color: AppColors.textMuted, size: 18),
                  const SizedBox(width: 6),
                  Text(
                    'ReviewPulse © 2024',
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white54 : AppColors.textMuted,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  for (final link in [
                    'Privacy Policy',
                    'Terms of Service',
                    'Cookie Settings'
                  ])
                    Padding(
                      padding: const EdgeInsets.only(left: 24),
                      child: GestureDetector(
                        onTap: () {},
                        child: Text(
                          link,
                          style: const TextStyle(
                            fontFamily: 'Manrope',
                            fontSize: 13,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.leaderboard_outlined,
                      color: isDark ? Colors.white38 : AppColors.textMuted,
                      size: 20),
                  const SizedBox(width: 12),
                  Icon(Icons.public_outlined,
                      color: isDark ? Colors.white38 : AppColors.textMuted,
                      size: 20),
                ],
              ),
            ],
          )
              : Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.star_half_rounded,
                      color: AppColors.textMuted, size: 16),
                  const SizedBox(width: 6),
                  Text(
                    'ReviewPulse © 2024',
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white54 : AppColors.textMuted,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 20,
                children: [
                  for (final link in [
                    'Privacy Policy',
                    'Terms of Service',
                    'Cookie Settings'
                  ])
                    GestureDetector(
                      onTap: () {},
                      child: Text(link,
                          style: const TextStyle(
                              fontFamily: 'Manrope',
                              fontSize: 12,
                              color: AppColors.textMuted)),
                    ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
