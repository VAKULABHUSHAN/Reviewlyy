import 'package:flutter/material.dart';


class AppColors {
  static const primary = Color(0xFF2469EB);
  static const backgroundLight = Color(0xFFF6F6F8);
  static const backgroundDark = Color(0xFF111621);
  static const surfaceDark = Color(0xFF1E2433);
  static const cardDark = Color(0xFF1A2236);
  static const cardBorderLight = Color(0xFFE2E8F0);
  static const cardBorderDark = Color(0xFF1E293B);
  static const textMuted = Color(0xFF64748B);
  static const starYellow = Color(0xFFF59E0B);
  static const bgSubtle = Color(0xFFF8FAFC);
}


class ReviewItem {
  final String initials;
  final String name;
  final String timeAgo;
  final double rating;
  final String title;
  final String body;
  final int helpfulCount;

  const ReviewItem({
    required this.initials,
    required this.name,
    required this.timeAgo,
    required this.rating,
    required this.title,
    required this.body,
    required this.helpfulCount,
  });
}


const _reviews = [
  ReviewItem(
    initials: 'JD',
    name: 'John Doe',
    timeAgo: 'Reviewed 2 days ago',
    rating: 5,
    title: 'Exceeded my expectations!',
    body:
    "I've used several high-end headphones over the years, but these are truly in a league of their own. The sound profile is balanced and the comfort for long sessions is unmatched.",
    helpfulCount: 24,
  ),
  ReviewItem(
    initials: 'SA',
    name: 'Sarah Adams',
    timeAgo: 'Reviewed 1 week ago',
    rating: 4,
    title: 'Great but pricey',
    body:
    'The noise cancellation is perfect for flights. My only gripe is the price point, but you definitely get what you pay for in terms of quality and durability.',
    helpfulCount: 12,
  ),
];

const _ratingDistribution = [
  (stars: 5, percent: 0.65, label: '65%'),
  (stars: 4, percent: 0.20, label: '20%'),
  (stars: 3, percent: 0.08, label: '8%'),
  (stars: 2, percent: 0.04, label: '4%'),
  (stars: 1, percent: 0.03, label: '3%'),
];

const _thumbnailUrls = [
  'https://lh3.googleusercontent.com/aida-public/AB6AXuBYWu0L4mkb0ZuFeBhHwAh_3EhCGPIvZN5k6nm_47f6E4LG9soJtyYDnbyk0sVD_zXI6iip4J7cvi_4r6XBhcyDsEhe9x_cPxY6YNxvuVOeeO6hCay-1JzoWWF02nyw5bzCklLwd7Ra6qnDtY0WLZQlIzcDwFFafCNp1yCbcW686a3O0ClCy7zdOkj4lGVDujR7rRQJxDoP2eYDay1DSGE4kmUUN_sw4ZYxNV8YYorTcxfHL3kzwDStk4xc3qult-PLUE-l2yJE6kA',
  'https://lh3.googleusercontent.com/aida-public/AB6AXuBp3Qr-4gSupq-tMCHEBuBO-qS3AZlsizQ_g5WdTKDtUhgtJOVofiMlqDUrbL6Dvq5GiyVVcXYGxNAS3qqBon8782mulLaUk84mm6doZHy0eZXm3juyoZhsOP8NrHq_sU09ZMGvfG7kvacoq-AMWr8Uln5HL-LvrVAmObpXViw-6EADd4jLPVCWM9K4q033ayCogZj3viheW8mptAeKBRM3ICGPLvOzKMXMsnTPe2XkR5qlnL-iMfnz_molCWSRK2PvNDfk6JUSJBk',
  'https://lh3.googleusercontent.com/aida-public/AB6AXuAJ9_KbjskTNrGP6t0veSe3Dy7UbagJOtBaCAJ--tEil8OWnYgJxSSgw5ZaKwNr-OtqWuWwX1GhhXFRpaRsUOwmYItxwpJtBgMhtbfZBQ0sOXCmxms9oVtWHHS5ryuUIM7mBQa5cOGDd3l1GYnpJFQzviMZnioixGOnN8VdxGwlgGcBis01gxWbxWKySth9YWYFPCXhVgE7d69fO21MaM_pGBplikNyUDhlkeUZlDSLvvLMk3sGny-7OvaKRsjiwiyaFVkqNgAnyGU',
];


class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return _DetailsBody(isDark: isDark, onToggleTheme: () {});
  }
}

class _DetailsBody extends StatefulWidget {
  final bool isDark;
  final VoidCallback onToggleTheme;

  const _DetailsBody({required this.isDark, required this.onToggleTheme});

  @override
  State<_DetailsBody> createState() => _DetailsBodyState();
}

class _DetailsBodyState extends State<_DetailsBody> {
  int _selectedThumb = 0;

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    final isWide = MediaQuery.of(context).size.width > 900;

    return Scaffold(
      appBar: _buildAppBar(context, isDark),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isWide ? 80 : 16,
                vertical: 24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Breadcrumb
                  _Breadcrumb(isDark: isDark),
                  const SizedBox(height: 24),
                  // Main product card
                  _ProductMainCard(
                    isDark: isDark,
                    isWide: isWide,
                    selectedThumb: _selectedThumb,
                    onThumbSelected: (i) =>
                        setState(() => _selectedThumb = i),
                  ),
                  const SizedBox(height: 32),
                  // Rating + Reviews section
                  isWide
                      ? _ReviewsSection(isDark: isDark)
                      : _ReviewsSectionMobile(isDark: isDark),
                  const SizedBox(height: 48),
                ],
              ),
            ),
            _FooterSection(isDark: isDark),
          ],
        ),
      ),
    );
  }


  PreferredSizeWidget _buildAppBar(BuildContext context, bool isDark) {
    final isWide = MediaQuery.of(context).size.width > 700;
    return PreferredSize(
      preferredSize: const Size.fromHeight(60),
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
                horizontal: isWide ? 80 : 16, vertical: 10),
            child: Row(
              children: [
                const Icon(Icons.reviews_outlined,
                    color: AppColors.primary, size: 24),
                const SizedBox(width: 8),
                Text(
                  'ReviewHub',
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                if (isWide) ...[
                  const SizedBox(width: 32),
                  for (final label in ['Home', 'Categories', 'About'])
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: GestureDetector(
                        onTap: () {
                          switch (label) {
                            case 'Home': Navigator.pushNamed(context, '/');
                            case 'Categories': Navigator.pushNamed(context, '/products');
                          }
                        },
                        child: Text(
                          label,
                          style: const TextStyle(
                            fontFamily: 'Manrope',
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ),
                    ),
                ],
                const Spacer(),
                if (isWide)
                  Container(
                    width: 200,
                    height: 38,
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF1E293B)
                          : const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(10),
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
                              hintText: 'Search products...',
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
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 8),
                    elevation: 0,
                    textStyle: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Manrope'),
                  ),
                  child: const Text('Login'),
                ),
                const SizedBox(width: 10),
                CircleAvatar(
                  radius: 18,
                  backgroundImage: const NetworkImage(
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuCvaU1WcitFl5aq9EEiVzxBOraZj1lT2aeCWHuATXtsb9-rjTJS7yVYGLGZAX7tvQ2hm9V8Mutxkv-RGgxI3xpdNX6vo1uK0NPEeHaykHpTgeeGbHZWIwFInpdP9Pctk5nzefz9AUt4Zk8FnZmnJm0NFUBA1lkkbKEZc-fyEBHnTtjbAZLB06hln1klRRVRpjsrHdNEK5jw2TyHWDCQ8NAdKvqzVNmc_QoljTJG_Le5YtPHq69O8Ll0twz1hvw_LFApsMCrVxd_P4s',
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


class _Breadcrumb extends StatelessWidget {
  final bool isDark;
  const _Breadcrumb({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final crumbs = ['Home', 'Electronics'];
    return Row(
      children: [
        ...crumbs.map((c) => Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () {},
              child: Text(c,
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
        )),
        Text(
          'SonicPro Wireless Headphones',
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


class _ProductMainCard extends StatelessWidget {
  final bool isDark;
  final bool isWide;
  final int selectedThumb;
  final ValueChanged<int> onThumbSelected;

  const _ProductMainCard({
    required this.isDark,
    required this.isWide,
    required this.selectedThumb,
    required this.onThumbSelected,
  });

  @override
  Widget build(BuildContext context) {
    final content = isWide
        ? Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _ImageGallery(isDark: isDark, selected: selectedThumb, onSelect: onThumbSelected)),
        const SizedBox(width: 48),
        Expanded(child: _ProductInfo(isDark: isDark)),
      ],
    )
        : Column(
      children: [
        _ImageGallery(isDark: isDark, selected: selectedThumb, onSelect: onThumbSelected),
        const SizedBox(height: 24),
        _ProductInfo(isDark: isDark),
      ],
    );

    return Container(
      padding: EdgeInsets.all(isWide ? 40 : 20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A2236) : Colors.white,
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
      child: content,
    );
  }
}


class _ImageGallery extends StatelessWidget {
  final bool isDark;
  final int selected;
  final ValueChanged<int> onSelect;

  const _ImageGallery(
      {required this.isDark, required this.selected, required this.onSelect});

  static const _mainImage =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuB2OToAN8Fnf73dd1RdGpYYdk-OTsQP2wQNHDlDiZhPwRU5ffg1Zhd6B3A6I6nxAf6ZDqfwEmq-eNf7xnrVbXOpqrhFsW2Qv5i9GtqnwFGk2Iq-zej275qzWGfDObI9HUbob2Pe_sUKwPNWEoDG1vgyv9hqZ1K_uC8EjKKeKG7dctcLqDJ3tGDxTp2BM2CRrYYIvhwqYwjfUU7TBa_sRaw8hL4SKuGhiTkJeiJ-ohgmKSeatedHO1Kng5XMtv-3UzJyPeHLM9PBR_8';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Main image
        ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: AspectRatio(
            aspectRatio: 1,
            child: Image.network(
              selected < _thumbnailUrls.length
                  ? _thumbnailUrls[selected]
                  : _mainImage,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
                  Container(color: Colors.grey.shade200),
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Thumbnail row
        Row(
          children: [
            ...List.generate(_thumbnailUrls.length, (i) {
              final isActive = selected == i;
              return Expanded(
                child: GestureDetector(
                  onTap: () => onSelect(i),
                  child: Container(
                    margin: EdgeInsets.only(right: i < _thumbnailUrls.length - 1 ? 10 : 0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isActive
                            ? AppColors.primary
                            : (isDark
                            ? AppColors.cardBorderDark
                            : AppColors.cardBorderLight),
                        width: isActive ? 2 : 1,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(9),
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: Image.network(
                          _thumbnailUrls[i],
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              Container(color: Colors.grey.shade200),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
            // Add photo placeholder
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(left: 0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isDark
                        ? AppColors.cardBorderDark
                        : AppColors.cardBorderLight,
                  ),
                  color: isDark
                      ? const Color(0xFF1E293B)
                      : const Color(0xFFF8FAFC),
                ),
                child: const AspectRatio(
                  aspectRatio: 1,
                  child: Center(
                    child: Icon(Icons.add_a_photo_outlined,
                        color: AppColors.textMuted, size: 20),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}


class _ProductInfo extends StatelessWidget {
  final bool isDark;
  const _ProductInfo({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Badge + category
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                'TOP RATED',
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'Category: Electronics / Audio',
              style: TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 13,
                  color: AppColors.textMuted),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Product title
        Text(
          'SonicPro Wireless Headphones',
          style: TextStyle(
            fontFamily: 'Manrope',
            fontSize: 32,
            fontWeight: FontWeight.w900,
            color: isDark ? Colors.white : Colors.black,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 16),
        // Rating row
        Row(
          children: [
            ...List.generate(5, (i) => Icon(
              i < 4 ? Icons.star_rounded : Icons.star_half_rounded,
              color: AppColors.starYellow,
              size: 22,
            )),
            const SizedBox(width: 8),
            Text(
              '4.5',
              style: TextStyle(
                fontFamily: 'Manrope',
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        const Text(
          'Based on 1,248 global ratings',
          style: TextStyle(
              fontFamily: 'Manrope', fontSize: 13, color: AppColors.textMuted),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Divider(
            color: isDark ? AppColors.cardBorderDark : const Color(0xFFF1F5F9),
            height: 1,
          ),
        ),
        // Description
        Text(
          'Product Description',
          style: TextStyle(
            fontFamily: 'Manrope',
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Experience industry-leading noise cancellation with the SonicPro Wireless Headphones. Engineered for pure sound, these headphones feature Dual Noise Sensor technology and an Integrated Processor V1 for an immersive listening experience. Up to 30 hours of battery life with quick charging keeps the music going all day.',
          style: TextStyle(
            fontFamily: 'Manrope',
            fontSize: 14,
            color: AppColors.textMuted,
            height: 1.65,
          ),
        ),
        const SizedBox(height: 20),
        // Spec cards
        Row(
          children: [
            Expanded(
              child: _SpecCard(
                isDark: isDark,
                icon: Icons.battery_charging_full_rounded,
                label: 'Battery Life',
                value: '30 Hours',
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _SpecCard(
                isDark: isDark,
                icon: Icons.noise_control_off_rounded,
                label: 'Noise Control',
                value: 'Active ANC',
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        // CTA buttons
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pushNamed(context, '/write-review'),
                icon: const Icon(Icons.edit_note_rounded, size: 18),
                label: const Text('Write a Review'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  elevation: 0,
                  textStyle: const TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 14,
                      fontWeight: FontWeight.w700),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => Navigator.pushNamed(context, '/reviews'),
                icon: const Icon(Icons.forum_outlined, size: 18),
                label: const Text('View All Reviews'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: isDark ? Colors.white : Colors.black,
                  side: BorderSide(
                    color: isDark
                        ? AppColors.cardBorderDark
                        : AppColors.cardBorderLight,
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 14,
                      fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}


class _SpecCard extends StatelessWidget {
  final bool isDark;
  final IconData icon;
  final String label;
  final String value;

  const _SpecCard({
    required this.isDark,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF1E293B)
            : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primary, size: 22),
          const SizedBox(height: 6),
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              fontFamily: 'Manrope',
              fontSize: 9,
              fontWeight: FontWeight.w800,
              color: AppColors.textMuted,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Manrope',
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}


class _ReviewsSection extends StatelessWidget {
  final bool isDark;
  const _ReviewsSection({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 300,
          child: _RatingDistributionCard(isDark: isDark),
        ),
        const SizedBox(width: 32),
        Expanded(child: _ReviewsList(isDark: isDark)),
      ],
    );
  }
}


class _ReviewsSectionMobile extends StatelessWidget {
  final bool isDark;
  const _ReviewsSectionMobile({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _RatingDistributionCard(isDark: isDark),
        const SizedBox(height: 24),
        _ReviewsList(isDark: isDark),
      ],
    );
  }
}


class _RatingDistributionCard extends StatelessWidget {
  final bool isDark;
  const _RatingDistributionCard({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A2236) : Colors.white,
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
          Text(
            'Rating Distribution',
            style: TextStyle(
              fontFamily: 'Manrope',
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 20),
          ..._ratingDistribution.map((r) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                SizedBox(
                  width: 16,
                  child: Text(
                    '${r.stars}',
                    style: const TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
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
                              ? const Color(0xFF1E293B)
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
                  width: 36,
                  child: Text(
                    r.label,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 12,
                      color: AppColors.textMuted,
                    ),
                  ),
                ),
              ],
            ),
          )),
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Divider(
              color:
              isDark ? AppColors.cardBorderDark : const Color(0xFFF1F5F9),
              height: 1,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '"The active noise cancellation is absolutely game changing for my daily commute."',
            style: TextStyle(
              fontFamily: 'Manrope',
              fontSize: 13,
              fontStyle: FontStyle.italic,
              color: isDark ? Colors.white70 : AppColors.textMuted,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '— Featured Review',
            style: TextStyle(
              fontFamily: 'Manrope',
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}


class _ReviewsList extends StatefulWidget {
  final bool isDark;
  const _ReviewsList({required this.isDark});

  @override
  State<_ReviewsList> createState() => _ReviewsListState();
}

class _ReviewsListState extends State<_ReviewsList> {
  String _sortBy = 'Most Recent';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Reviews',
              style: TextStyle(
                fontFamily: 'Manrope',
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: widget.isDark ? Colors.white : Colors.black,
              ),
            ),
            Row(
              children: [
                const Text(
                  'Sort by: ',
                  style: TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 13,
                      color: AppColors.textMuted),
                ),
                DropdownButton<String>(
                  value: _sortBy,
                  underline: const SizedBox(),
                  style: const TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                  dropdownColor:
                  widget.isDark ? const Color(0xFF1A2236) : Colors.white,
                  items: ['Most Recent', 'Highest Rating', 'Most Helpful']
                      .map((s) => DropdownMenuItem(
                    value: s,
                    child: Text(s),
                  ))
                      .toList(),
                  onChanged: (v) => setState(() => _sortBy = v ?? _sortBy),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        ..._reviews.map((r) => Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: ReviewCard(review: r, isDark: widget.isDark),
        )),
        // View more button
        GestureDetector(
          onTap: () {},
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: widget.isDark
                    ? AppColors.cardBorderDark
                    : AppColors.cardBorderLight,
                style: BorderStyle.solid,
                width: 2,
              ),
            ),
            child: const Center(
              child: Text(
                'View 1,246 more reviews',
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textMuted,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}


class ReviewCard extends StatefulWidget {
  final ReviewItem review;
  final bool isDark;

  const ReviewCard({super.key, required this.review, required this.isDark});

  @override
  State<ReviewCard> createState() => _ReviewCardState();
}

class _ReviewCardState extends State<ReviewCard> {
  bool _helpful = false;

  @override
  Widget build(BuildContext context) {
    final r = widget.review;
    final isDark = widget.isDark;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A2236) : Colors.white,
        borderRadius: BorderRadius.circular(14),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  // Avatar circle with initials
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF1E293B)
                          : const Color(0xFFF1F5F9),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isDark
                            ? AppColors.cardBorderDark
                            : AppColors.cardBorderLight,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        r.initials,
                        style: const TextStyle(
                          fontFamily: 'Manrope',
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        r.name,
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                      Text(
                        r.timeAgo,
                        style: const TextStyle(
                          fontFamily: 'Manrope',
                          fontSize: 11,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              // Stars
              Row(
                children: List.generate(
                  5,
                      (i) => Icon(
                    i < r.rating ? Icons.star_rounded : Icons.star_outline_rounded,
                    color: AppColors.starYellow,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Review title
          Text(
            r.title,
            style: TextStyle(
              fontFamily: 'Manrope',
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 6),
          // Review body
          Text(
            r.body,
            style: const TextStyle(
              fontFamily: 'Manrope',
              fontSize: 13,
              color: AppColors.textMuted,
              height: 1.55,
            ),
          ),
          const SizedBox(height: 14),
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
                      size: 14,
                      color: _helpful ? AppColors.primary : AppColors.textMuted,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Helpful (${_helpful ? r.helpfulCount + 1 : r.helpfulCount})',
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 12,
                        color: _helpful ? AppColors.primary : AppColors.textMuted,
                        fontWeight: _helpful ? FontWeight.w700 : FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              GestureDetector(
                onTap: () {},
                child: const Row(
                  children: [
                    Icon(Icons.share_outlined,
                        size: 14, color: AppColors.textMuted),
                    SizedBox(width: 4),
                    Text(
                      'Share',
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 12,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


class _FooterSection extends StatelessWidget {
  final bool isDark;
  const _FooterSection({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 700;

    return Container(
      color: isDark ? const Color(0xFF1A2236) : Colors.white,
      padding: EdgeInsets.symmetric(
          horizontal: isWide ? 80 : 16, vertical: 48),
      child: Column(
        children: [
          isWide
              ? Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 2, child: _FooterBrand(isDark: isDark)),
              Expanded(
                  child: _FooterCol(
                      title: 'Quick Links',
                      links: const [
                        'Home',
                        'All Categories',
                        'Featured Brands',
                        'Community Guidelines'
                      ])),
              Expanded(
                  child: _FooterCol(
                      title: 'Support',
                      links: const [
                        'Help Center',
                        'Contact Us',
                        'Privacy Policy',
                        'Terms of Service'
                      ])),
              Expanded(child: _FooterNewsletter(isDark: isDark)),
            ],
          )
              : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _FooterBrand(isDark: isDark),
              const SizedBox(height: 28),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      child: _FooterCol(
                          title: 'Quick Links',
                          links: const [
                            'Home',
                            'All Categories',
                            'Featured Brands',
                            'Community Guidelines'
                          ])),
                  Expanded(
                      child: _FooterCol(
                          title: 'Support',
                          links: const [
                            'Help Center',
                            'Contact Us',
                            'Privacy Policy',
                            'Terms of Service'
                          ])),
                ],
              ),
              const SizedBox(height: 28),
              _FooterNewsletter(isDark: isDark),
            ],
          ),
          const SizedBox(height: 40),
          Divider(
              color: isDark
                  ? AppColors.cardBorderDark
                  : const Color(0xFFF1F5F9),
              height: 1),
          const SizedBox(height: 20),
          const Text(
            '© 2024 ReviewHub Inc. All rights reserved. Built with modern design principles.',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: 'Manrope',
                fontSize: 11,
                color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }
}

class _FooterBrand extends StatelessWidget {
  final bool isDark;
  const _FooterBrand({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.reviews_outlined,
                color: AppColors.primary, size: 20),
            const SizedBox(width: 6),
            Text('ReviewHub',
                style: TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : Colors.black)),
          ],
        ),
        const SizedBox(height: 10),
        const Text(
          'Helping millions of consumers make better buying decisions through authentic reviews and ratings since 2024.',
          style: TextStyle(
              fontFamily: 'Manrope',
              fontSize: 13,
              color: AppColors.textMuted,
              height: 1.6),
        ),
      ],
    );
  }
}

class _FooterCol extends StatelessWidget {
  final String title;
  final List<String> links;
  const _FooterCol({required this.title, required this.links});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(
                fontFamily: 'Manrope',
                fontSize: 13,
                fontWeight: FontWeight.w700)),
        const SizedBox(height: 16),
        ...links.map((l) => Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: GestureDetector(
            onTap: () {},
            child: Text(l,
                style: const TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 13,
                    color: AppColors.textMuted)),
          ),
        )),
      ],
    );
  }
}

class _FooterNewsletter extends StatelessWidget {
  final bool isDark;
  const _FooterNewsletter({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Newsletter',
            style: TextStyle(
                fontFamily: 'Manrope',
                fontSize: 13,
                fontWeight: FontWeight.w700)),
        const SizedBox(height: 10),
        const Text(
          'Get the latest reviews delivered to your inbox.',
          style: TextStyle(
              fontFamily: 'Manrope', fontSize: 13, color: AppColors.textMuted),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Email address',
                  hintStyle: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textMuted,
                      fontFamily: 'Manrope'),
                  border: OutlineInputBorder(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(8),
                        bottomLeft: Radius.circular(8)),
                    borderSide: BorderSide(
                        color: isDark
                            ? AppColors.cardBorderDark
                            : AppColors.cardBorderLight),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(8),
                        bottomLeft: Radius.circular(8)),
                    borderSide: BorderSide(
                        color: isDark
                            ? AppColors.cardBorderDark
                            : AppColors.cardBorderLight),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 10),
                  isDense: true,
                ),
                style: const TextStyle(fontSize: 13, fontFamily: 'Manrope'),
              ),
            ),
            Container(
              height: 42,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: const BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(8),
                    bottomRight: Radius.circular(8)),
              ),
              child: const Center(
                child: Icon(Icons.send_rounded, color: Colors.white, size: 18),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
