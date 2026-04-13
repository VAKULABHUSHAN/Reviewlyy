import 'package:flutter/material.dart';

class TopRatedScreen extends StatelessWidget {
  const TopRatedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const TopRatedPage();
  }
}


const kPrimary = Color(0xFF2469EB);

const _podiumProducts = [
  _PodiumProduct(
    rank: 2,
    name: 'SoundMax Pro ANC',
    rating: 4.8,
    reviewCount: '2.4k',
    badge: null,
    imageUrl:
    'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&w=600&q=80',
  ),
  _PodiumProduct(
    rank: 1,
    name: 'UltraPhone Pro Max',
    rating: 4.9,
    reviewCount: '5.1k',
    badge: 'BEST OVERALL',
    imageUrl:
    'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?auto=format&fit=crop&w=600&q=80',
  ),
  _PodiumProduct(
    rank: 3,
    name: 'TimePiece Chrono 5',
    rating: 4.7,
    reviewCount: '1.2k',
    badge: null,
    imageUrl:
    'https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=600&q=80',
  ),
];

const _listProducts = [
  _ListProduct(
    name: 'SmartCam AI v2',
    category: 'Security & Home',
    rating: 4.6,
    imageUrl:
    'https://images.unsplash.com/photo-1542491595-3015c1c8c529?auto=format&fit=crop&w=200&q=80',
  ),
  _ListProduct(
    name: 'KeyFlow Mechanical TKL',
    category: 'Accessories',
    rating: 4.5,
    imageUrl:
    'https://images.unsplash.com/photo-1527443224154-c4a3942d3acf?auto=format&fit=crop&w=200&q=80',
  ),
  _ListProduct(
    name: 'TabAir Pro 11"',
    category: 'Mobile Computing',
    rating: 4.4,
    imageUrl:
    'https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?auto=format&fit=crop&w=200&q=80',
  ),
];


class _PodiumProduct {
  final int rank;
  final String name;
  final double rating;
  final String reviewCount;
  final String? badge;
  final String imageUrl;

  const _PodiumProduct({
    required this.rank,
    required this.name,
    required this.rating,
    required this.reviewCount,
    required this.badge,
    required this.imageUrl,
  });
}

class _ListProduct {
  final String name;
  final String category;
  final double rating;
  final String imageUrl;

  const _ListProduct({
    required this.name,
    required this.category,
    required this.rating,
    required this.imageUrl,
  });
}


class TopRatedPage extends StatefulWidget {
  const TopRatedPage({super.key});

  @override
  State<TopRatedPage> createState() => _TopRatedPageState();
}

class _TopRatedPageState extends State<TopRatedPage> {
  int _selectedTab = 0;
  final List<String> _tabs = [
    'All Top Products',
    'Tech',
    'Lifestyle',
    'Home Office',
    'Software',
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isWide = MediaQuery.of(context).size.width >= 768;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF111621) : const Color(0xFFF6F6F8),
      body: Column(
        children: [
          _TopNav(isDark: isDark, isWide: isWide),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isWide ? 80 : 16,
                  vertical: 32,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1120),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _PageHeader(isDark: isDark, isWide: isWide),
                      const SizedBox(height: 48),
                      _PodiumSection(isDark: isDark, isWide: isWide),
                      const SizedBox(height: 48),
                      _TabBar(
                        tabs: _tabs,
                        selected: _selectedTab,
                        isDark: isDark,
                        onTabSelected: (i) => setState(() => _selectedTab = i),
                      ),
                      const SizedBox(height: 24),
                      _ProductList(isDark: isDark),
                      const SizedBox(height: 32),
                      _LoadMoreButton(isDark: isDark),
                      const SizedBox(height: 80),
                      _Footer(isDark: isDark, isWide: isWide),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class _TopNav extends StatelessWidget {
  final bool isDark;
  final bool isWide;

  const _TopNav({required this.isDark, required this.isWide});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isWide ? 80 : 16,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.black.withOpacity(0.8)
            : Colors.white.withOpacity(0.85),
        border: Border(
          bottom: BorderSide(
            color: isDark
                ? Colors.white.withOpacity(0.08)
                : Colors.black.withOpacity(0.08),
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
          )
        ],
      ),
      child: Row(
        children: [
          // Logo
          Row(
            children: [
              const Icon(Icons.star_rate_rounded, color: kPrimary, size: 28),
              const SizedBox(width: 6),
              Text(
                'ReviewHub',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                  letterSpacing: -0.5,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          if (isWide) ...[
            const SizedBox(width: 40),
            _NavLink(label: 'Home', isActive: false, isDark: isDark),
            const SizedBox(width: 24),
            _NavLink(label: 'Categories', isActive: false, isDark: isDark),
            const SizedBox(width: 24),
            _NavLink(label: 'Top Rated', isActive: true, isDark: isDark),
            const SizedBox(width: 24),
            _NavLink(label: 'Compare', isActive: false, isDark: isDark),
          ],
          const Spacer(),
          if (isWide) ...[
            Container(
              width: 220,
              height: 40,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 12),
                  Icon(Icons.search, size: 18,
                      color: isDark ? Colors.white38 : Colors.black38),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search products...',
                        hintStyle: TextStyle(
                          fontSize: 13,
                          color: isDark ? Colors.white38 : Colors.black38,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                      ),
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
          ],
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: kPrimary,
              foregroundColor: Colors.white,
              padding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 4,
              shadowColor: kPrimary.withOpacity(0.4),
            ),
            child: const Text('Profile',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
          ),
          const SizedBox(width: 12),
          CircleAvatar(
            radius: 18,
            backgroundColor: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
            child: ClipOval(
              child: Image.network(
                'https://lh3.googleusercontent.com/aida-public/AB6AXuAlJpPlSYcVlrdgSneXXU-fXXaxf1UjPEQb8nwWE6tZPNz-dIeesPQV8Gr4FVUy7vSQpgWAFmmDJL_erKxliPZv3rbtRJG-tGTAlZSdLdESSJ2ntJGcAi3mqI5_ajyCtuk6WxsyEfTWeiu97jOMIKKGHfqpcULlxHaCuCJcPNrMakuFuk9bhVBoy1SPk50uJZAiN15IAQO1Xczrx5vctyG9dGqdIF1tGvWJg06HTUVUrD8oRgKe193Mp1fLixxfjY5ZscTgYAPxBLY',
                fit: BoxFit.cover,
                width: 36,
                height: 36,
                errorBuilder: (_, __, ___) => const Icon(Icons.person, size: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavLink extends StatelessWidget {
  final String label;
  final bool isActive;
  final bool isDark;

  const _NavLink(
      {required this.label, required this.isActive, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (isActive) return;
        switch (label) {
          case 'Home': Navigator.pushNamed(context, '/');
          case 'Categories': Navigator.pushNamed(context, '/products');
          case 'Top Rated': break;
          case 'Compare': break;
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              color: isActive
                  ? kPrimary
                  : isDark
                  ? const Color(0xFF94A3B8)
                  : const Color(0xFF475569),
              fontWeight: isActive ? FontWeight.w700 : FontWeight.w600,
              fontSize: 13,
            ),
          ),
          if (isActive)
            Container(
              margin: const EdgeInsets.only(top: 4),
              height: 2,
              width: 36,
              decoration: BoxDecoration(
                color: kPrimary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
        ],
      ),
    );
  }
}


class _PageHeader extends StatelessWidget {
  final bool isDark;
  final bool isWide;

  const _PageHeader({required this.isDark, required this.isWide});

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: isWide ? Axis.horizontal : Axis.vertical,
      crossAxisAlignment: isWide
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Flexible(
          flex: isWide ? 3 : 0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: kPrimary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.verified_rounded, color: kPrimary, size: 14),
                    SizedBox(width: 6),
                    Text(
                      'COMMUNITY VERIFIED',
                      style: TextStyle(
                        color: kPrimary,
                        fontWeight: FontWeight.w800,
                        fontSize: 11,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Top Rated\nProducts',
                style: TextStyle(
                  fontSize: isWide ? 44 : 32,
                  fontWeight: FontWeight.w900,
                  height: 1.1,
                  letterSpacing: -1.5,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Discover the elite selection of products that have set the gold standard. Ranked and reviewed by thousands of users worldwide.',
                style: TextStyle(
                  fontSize: 15,
                  height: 1.6,
                  color: isDark
                      ? const Color(0xFF94A3B8)
                      : const Color(0xFF475569),
                ),
              ),
            ],
          ),
        ),
        if (isWide) const SizedBox(width: 32),
        Padding(
          padding: EdgeInsets.only(top: isWide ? 0 : 24),
          child: Row(
            children: [
              _OutlineButton(
                icon: Icons.filter_list_rounded,
                label: 'Filter',
                isDark: isDark,
              ),
              const SizedBox(width: 12),
              _OutlineButton(
                icon: Icons.refresh_rounded,
                label: 'Refresh',
                isDark: isDark,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _OutlineButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isDark;

  const _OutlineButton(
      {required this.icon, required this.label, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () {},
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        foregroundColor: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569),
        side: BorderSide(
          color: isDark
              ? const Color(0xFF334155)
              : const Color(0xFFE2E8F0),
        ),
        backgroundColor:
        isDark ? const Color(0xFF1E293B) : Colors.white,
        padding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        textStyle:
        const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
      ),
    );
  }
}


class _PodiumSection extends StatelessWidget {
  final bool isDark;
  final bool isWide;

  const _PodiumSection({required this.isDark, required this.isWide});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.military_tech_rounded, color: kPrimary, size: 24),
            const SizedBox(width: 8),
            Text(
              'The Elite Podium',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        isWide
            ? Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 32),
                child: _PodiumCard(
                  product: _podiumProducts[0],
                  isDark: isDark,
                  isWinner: false,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _PodiumCard(
                product: _podiumProducts[1],
                isDark: isDark,
                isWinner: true,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 48),
                child: _PodiumCard(
                  product: _podiumProducts[2],
                  isDark: isDark,
                  isWinner: false,
                ),
              ),
            ),
          ],
        )
            : Column(
          children: _podiumProducts
              .map((p) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _PodiumCard(
              product: p,
              isDark: isDark,
              isWinner: p.rank == 1,
            ),
          ))
              .toList(),
        ),
      ],
    );
  }
}

class _PodiumCard extends StatelessWidget {
  final _PodiumProduct product;
  final bool isDark;
  final bool isWinner;

  const _PodiumCard(
      {required this.product, required this.isDark, required this.isWinner});

  Color get _rankBgColor {
    if (isWinner) return kPrimary;
    if (product.rank == 2) return const Color(0xFFE2E8F0);
    return const Color(0xFFFEF3C7);
  }

  Color get _rankTextColor {
    if (isWinner) return Colors.white;
    if (product.rank == 2) return const Color(0xFF1E293B);
    return const Color(0xFF92400E);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isWinner
              ? kPrimary
              : isDark
              ? const Color(0xFF334155)
              : const Color(0xFFE2E8F0),
          width: isWinner ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isWinner
                ? kPrimary.withOpacity(0.15)
                : Colors.black.withOpacity(0.06),
            blurRadius: isWinner ? 24 : 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          Stack(
            children: [
              ClipRRect(
                borderRadius:
                const BorderRadius.vertical(top: Radius.circular(11)),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.network(
                    product.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: isDark
                          ? const Color(0xFF334155)
                          : const Color(0xFFF1F5F9),
                      child: const Icon(Icons.image_not_supported, size: 40),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _rankBgColor,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '#${product.rank}',
                    style: TextStyle(
                      color: _rankTextColor,
                      fontWeight: FontWeight.w900,
                      fontSize: isWinner ? 16 : 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Content
          Padding(
            padding: EdgeInsets.all(isWinner ? 20 : 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        product.name,
                        style: TextStyle(
                          fontSize: isWinner ? 18 : 16,
                          fontWeight: FontWeight.w800,
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                        ),
                      ),
                    ),
                    if (product.badge != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: kPrimary.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          product.badge!,
                          style: const TextStyle(
                            color: kPrimary,
                            fontWeight: FontWeight.w800,
                            fontSize: 9,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _StarRating(rating: product.rating, size: 16),
                    const SizedBox(width: 6),
                    Text(
                      '${product.rating} (${product.reviewCount})',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: isDark
                            ? const Color(0xFF94A3B8)
                            : const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isWinner
                          ? kPrimary
                          : isDark
                          ? const Color(0xFF334155)
                          : const Color(0xFFF1F5F9),
                      foregroundColor: isWinner
                          ? Colors.white
                          : isDark
                          ? Colors.white
                          : const Color(0xFF0F172A),
                      elevation: isWinner ? 8 : 0,
                      shadowColor:
                      isWinner ? kPrimary.withOpacity(0.4) : null,
                      padding: EdgeInsets.symmetric(
                          vertical: isWinner ? 14 : 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text(
                      isWinner ? 'Shop Winner' : 'View Details',
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


class _TabBar extends StatelessWidget {
  final List<String> tabs;
  final int selected;
  final bool isDark;
  final ValueChanged<int> onTabSelected;

  const _TabBar({
    required this.tabs,
    required this.selected,
    required this.isDark,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(tabs.length, (i) {
              final isActive = i == selected;
              return GestureDetector(
                onTap: () => onTabSelected(i),
                child: Container(
                  margin: const EdgeInsets.only(right: 32),
                  padding: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: isActive ? kPrimary : Colors.transparent,
                        width: 2,
                      ),
                    ),
                  ),
                  child: Text(
                    tabs[i],
                    style: TextStyle(
                      color: isActive
                          ? kPrimary
                          : isDark
                          ? const Color(0xFF94A3B8)
                          : const Color(0xFF64748B),
                      fontWeight:
                      isActive ? FontWeight.w700 : FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
        Divider(
          height: 1,
          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
        ),
      ],
    );
  }
}


class _ProductList extends StatelessWidget {
  final bool isDark;

  const _ProductList({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _listProducts
          .map((p) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: _ProductRow(product: p, isDark: isDark),
      ))
          .toList(),
    );
  }
}

class _ProductRow extends StatelessWidget {
  final _ListProduct product;
  final bool isDark;

  const _ProductRow({required this.product, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= 600;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark
              ? const Color(0xFF334155)
              : const Color(0xFFE2E8F0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
          )
        ],
      ),
      child: isWide
          ? Row(
        children: [
          _ProductImage(imageUrl: product.imageUrl),
          const SizedBox(width: 20),
          Expanded(child: _ProductInfo(product: product, isDark: isDark)),
          const SizedBox(width: 16),
          _RatingBadge(rating: product.rating, isDark: isDark),
          const SizedBox(width: 16),
          _ProductActions(isDark: isDark),
        ],
      )
          : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ProductImage(imageUrl: product.imageUrl, fullWidth: true),
          const SizedBox(height: 12),
          _ProductInfo(product: product, isDark: isDark),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _RatingBadge(rating: product.rating, isDark: isDark),
              _ProductActions(isDark: isDark),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProductImage extends StatelessWidget {
  final String imageUrl;
  final bool fullWidth;

  const _ProductImage({required this.imageUrl, this.fullWidth = false});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        width: fullWidth ? double.infinity : 120,
        height: fullWidth ? 160 : 80,
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            color: const Color(0xFFF1F5F9),
            child: const Icon(Icons.image_not_supported),
          ),
        ),
      ),
    );
  }
}

class _ProductInfo extends StatelessWidget {
  final _ListProduct product;
  final bool isDark;

  const _ProductInfo({required this.product, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          product.name,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: isDark ? Colors.white : const Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Category: ${product.category}',
          style: TextStyle(
            fontSize: 13,
            color: isDark
                ? const Color(0xFF94A3B8)
                : const Color(0xFF64748B),
          ),
        ),
      ],
    );
  }
}

class _RatingBadge extends StatelessWidget {
  final double rating;
  final bool isDark;

  const _RatingBadge({required this.rating, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          rating.toString(),
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w900,
            color: isDark ? Colors.white : const Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 4),
        _StarRating(rating: rating, size: 14),
      ],
    );
  }
}

class _ProductActions extends StatelessWidget {
  final bool isDark;

  const _ProductActions({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _SmallButton(
          label: 'Compare',
          isPrimary: true,
          isDark: isDark,
        ),
        const SizedBox(width: 8),
        _SmallButton(
          label: 'Full Review',
          isPrimary: false,
          isDark: isDark,
        ),
      ],
    );
  }
}

class _SmallButton extends StatelessWidget {
  final String label;
  final bool isPrimary;
  final bool isDark;

  const _SmallButton(
      {required this.label, required this.isPrimary, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: isPrimary
            ? kPrimary.withOpacity(0.1)
            : isDark
            ? const Color(0xFF334155)
            : const Color(0xFFF1F5F9),
        foregroundColor: isPrimary
            ? kPrimary
            : isDark
            ? Colors.white
            : const Color(0xFF0F172A),
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        textStyle:
        const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
      ),
      child: Text(label),
    );
  }
}


class _LoadMoreButton extends StatelessWidget {
  final bool isDark;

  const _LoadMoreButton({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: OutlinedButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.expand_more_rounded),
        label: const Text('Load More Products'),
        style: OutlinedButton.styleFrom(
          foregroundColor:
          isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569),
          side: BorderSide(
            color:
            isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
            width: 2,
          ),
          padding:
          const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
        ),
      ),
    );
  }
}


class _Footer extends StatelessWidget {
  final bool isDark;
  final bool isWide;

  const _Footer({required this.isDark, required this.isWide});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        children: [
          isWide
              ? Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 2, child: _FooterBrand(isDark: isDark)),
              const SizedBox(width: 32),
              Expanded(child: _FooterNav(isDark: isDark)),
              const SizedBox(width: 32),
              Expanded(child: _FooterConnect(isDark: isDark)),
            ],
          )
              : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _FooterBrand(isDark: isDark),
              const SizedBox(height: 32),
              _FooterNav(isDark: isDark),
              const SizedBox(height: 32),
              _FooterConnect(isDark: isDark),
            ],
          ),
          const SizedBox(height: 24),
          Divider(
            color: isDark
                ? const Color(0xFF1E293B)
                : const Color(0xFFF1F5F9),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '© 2024 ReviewHub. All rights reserved.',
                style: TextStyle(
                  fontSize: 11,
                  color: isDark
                      ? const Color(0xFF64748B)
                      : const Color(0xFF94A3B8),
                ),
              ),
              Row(
                children: [
                  _FooterLink(label: 'Privacy Policy', isDark: isDark),
                  const SizedBox(width: 16),
                  _FooterLink(label: 'Terms of Service', isDark: isDark),
                ],
              ),
            ],
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
        Row(children: [
          const Icon(Icons.star_rate_rounded, color: kPrimary, size: 22),
          const SizedBox(width: 6),
          Text(
            'ReviewHub',
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 16,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
          ),
        ]),
        const SizedBox(height: 12),
        Text(
          'Empowering consumers through honest, transparent, and data-driven reviews.',
          style: TextStyle(
            fontSize: 13,
            height: 1.6,
            color:
            isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
          ),
        ),
      ],
    );
  }
}

class _FooterNav extends StatelessWidget {
  final bool isDark;

  const _FooterNav({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final items = ['Home', 'Categories', 'Top Rated', 'Compare'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Navigation',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 14,
            color: isDark ? Colors.white : const Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 16),
        ...items.map((item) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _FooterLink(label: item, isDark: isDark),
        )),
      ],
    );
  }
}

class _FooterConnect extends StatelessWidget {
  final bool isDark;

  const _FooterConnect({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Connect',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 14,
            color: isDark ? Colors.white : const Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            _SocialIcon(icon: Icons.share_rounded, isDark: isDark),
            const SizedBox(width: 12),
            _SocialIcon(icon: Icons.alternate_email_rounded, isDark: isDark),
          ],
        ),
      ],
    );
  }
}

class _SocialIcon extends StatelessWidget {
  final IconData icon;
  final bool isDark;

  const _SocialIcon({required this.icon, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        icon,
        size: 18,
        color:
        isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569),
      ),
    );
  }
}

class _FooterLink extends StatelessWidget {
  final String label;
  final bool isDark;

  const _FooterLink({required this.label, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 13,
        color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
      ),
    );
  }
}


class _StarRating extends StatelessWidget {
  final double rating;
  final double size;

  const _StarRating({required this.rating, required this.size});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        final filled = rating >= (i + 1);
        final half = !filled && rating >= (i + 0.5);
        return Icon(
          filled
              ? Icons.star_rounded
              : half
              ? Icons.star_half_rounded
              : Icons.star_outline_rounded,
          color: const Color(0xFFF59E0B),
          size: size,
        );
      }),
    );
  }
}