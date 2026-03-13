import 'package:flutter/material.dart';

// ─── Shared Constants (import from app_theme.dart in full project) ────────────

class AppColors {
  static const primary = Color(0xFF2469EB);
  static const backgroundLight = Color(0xFFF6F6F8);
  static const backgroundDark = Color(0xFF111621);
  static const surfaceDark = Color(0xFF1E2433);
  static const cardBorderLight = Color(0xFFE2E8F0);
  static const cardBorderDark = Color(0xFF1E293B);
  static const textMuted = Color(0xFF64748B);
  static const starYellow = Color(0xFFFACC15);
}

// ─── Product Data Model ───────────────────────────────────────────────────────

class ProductData {
  final String title;
  final String category;
  final String description;
  final String price;
  final double rating;
  final String imageUrl;

  const ProductData({
    required this.title,
    required this.category,
    required this.description,
    required this.price,
    required this.rating,
    required this.imageUrl,
  });
}

// ─── Static Product List ──────────────────────────────────────────────────────

const _allProducts = [
  ProductData(
    title: 'Pro Audio Gen-2',
    category: 'Electronics',
    description:
    'Noise-cancelling wireless headphones with 40-hour battery life and spatial audio support.',
    price: '\$299.00',
    rating: 4.8,
    imageUrl:
    'https://lh3.googleusercontent.com/aida-public/AB6AXuBnh6NNvw0ublTnYkUqAsA-pT27xv1RXAn9JSe2ncgXuhoH-Z2wksSVzYmqrjsfResSfzcYL-T5mSsizKB_JyK9XjTWXSW5WFmXy1MiaKcPijZHNS-oM8yi-Y15i-Z90AuM9PVLznDIlATuhIxjBcMpPWm1xzNIHeY6Cnh0QXxKSW-rK3ta49yaWi36ihtoR8RorwZNbDbXg0IgIxwS6jBh_CYuCqDb3hJi1fk61SenTDCsO7o7EFYpo-UjrgsXVxFtD9Kf3i9uh2s',
  ),
  ProductData(
    title: 'Lunar Minimalist Watch',
    category: 'Accessories',
    description:
    'A timeless piece featuring a sapphire glass and Italian leather strap for everyday elegance.',
    price: '\$185.00',
    rating: 4.5,
    imageUrl:
    'https://lh3.googleusercontent.com/aida-public/AB6AXuBV2eiSjxRs4HEkLnKWr3z4nDULdGDHijArCK1cWRWWfExFeirRAWeiJFxIkqHns4QjydJWRxNW6tGYW2tNdOuvw-3ZOmgZ9Zflohz4UkbTO0EyCpdO_Y1xRKeQvVVb5AIFc8kcSkK6I8VdmmWSRV-szCFQNImgIygqkfk172PpzcAnK88wp4rnYkotzlheDhBLzXqxRtUQQljqTu9W4Q-3jlxHIkJ-JfCIgwakuUYOc9my9jyfDmTghfkTHBvQkJPkP_0dbwDa550',
  ),
  ProductData(
    title: 'Velo Sprint Trainers',
    category: 'Footwear',
    description:
    'Ultra-lightweight performance shoes designed for both professional athletes and daily runners.',
    price: '\$140.00',
    rating: 4.9,
    imageUrl:
    'https://lh3.googleusercontent.com/aida-public/AB6AXuCmmoCLCY-P6NdCLmRMBK83dCmo8CSjgW76Lbqne9c6b1yKXmOswCZDRvtYvsbfjuwpFiblN2q8cVpa8_ze1zUD51khonT5qGbR2-lEGwAyKkZKSjo5_49URYTOTFJ26MTwAapYE6GzhiaBzmTI3HX-_PZqHeTVmQUwMB5Sd_6Toakv7zfcDTLYiP26cLTixIZiWAMswRfgSdWfAiXGbV2QHbFVi7ssI_AwQJYRcXL8dnPaEklX8FpgDJo9-9yelenDSmSDRdtQCOY',
  ),
  ProductData(
    title: 'Apex Ergo Pro',
    category: 'Furniture',
    description:
    'Premium lumbar support and breathable mesh for the ultimate work-from-home comfort.',
    price: '\$450.00',
    rating: 4.7,
    imageUrl:
    'https://lh3.googleusercontent.com/aida-public/AB6AXuAJpbZeDTwgUiipCxC2kracPLvEZ4kCAml1784mzF70SWgjZbv9Pbo5PdonInK-xqRAxQMyNKOL3S3Qq2XfLndXpM0QI91Pz3YXS7tWTXnL4d1prqmNGXGx-PgaQtPI5wwdgoHy4YnLfzCS2rtbwsG05FZxXfcO8VYNNKTsjwf25BVXGycG4C_ErEpiEAxb1BZwtb19ocG3RFFlOLTcAhWp0m0Uzb8pdybr7Nu--hL1DGLXRXFTp1Q_Xnu282v9KjkinD9zKlbpaR4',
  ),
  ProductData(
    title: 'NovaBook 14 Air',
    category: 'Tech',
    description:
    'Ultra-portable laptop with 4K OLED display and the latest high-efficiency processor.',
    price: '\$1,199.00',
    rating: 4.6,
    imageUrl:
    'https://lh3.googleusercontent.com/aida-public/AB6AXuAxVvzSRjUcjYH25z4Glihf5ZZgmkcgtmf7Mglc84cu40wJwHbbVA8IeqXG0z_IXJN46DNZ6pqIA1lGAdpoEHXo-vE-60V-G_JwlztbP6X2Opz21adsQrIKrGXPopoKdx-EAoZ1cfQ_0dN8lmhzra_kVcqCTjCbJJcPAQSevPqIdASIoj5rRH1PfEG1_ckX6DdZcXg4v02f5zVHlQm9NTakbhbLjYzmM3OIexrfeipWqLdedmfxdWlWP5BODJfePv3_qtj3CxOt4Ng',
  ),
  ProductData(
    title: 'RetroSnap Instant',
    category: 'Photography',
    description:
    'The classic instant camera experience with modern auto-focus and built-in flash.',
    price: '\$89.00',
    rating: 4.2,
    imageUrl:
    'https://lh3.googleusercontent.com/aida-public/AB6AXuB5kZoq2ozwems5mZiVGwMMmTKZ3zGPYx03Hy4fFQs3bya0rQ1SaH-GJXx0pTUA9peSjbAiLkCU5Stx_7JdtEcdZFRk382aurPLjXUPXjR8FTmrFSHHxBc1v-9rnHcTxVgAD_Ei7GawTszXZiZq_vjA0LGC66LpTTe1yOr_R4qZIrkbf33lxNjEkqD8OE-53hXg6uWEXxkFtVKxcXlM18plKjq8lfLfyflce-yjqNqNw2FacOTyBdysHTtqGFTlagneKpOxfmtwMtk',
  ),
  ProductData(
    title: 'Sol Ray Aviators',
    category: 'Fashion',
    description:
    'Handcrafted polarising lenses with lightweight titanium frames for maximum durability.',
    price: '\$125.00',
    rating: 4.4,
    imageUrl:
    'https://lh3.googleusercontent.com/aida-public/AB6AXuAtLkQOn9hWLD2f3jM_7RaQ5m-6sGBExiqwrXluErPEszAxsCeGniPVJJUqwRfKjT0CUTsaGvFwh7etpkuSu3d59-aYtiharJO1jZ0jSbdhmcEI9LsEPsVH_lT6JQpA6_-rEc-UoyKaDLArqKU8-3qf2o8s-yuz0AP6o6ixtb7azWyMXOm5obKiaqhdcKwHuyClzDiS0orFawNfjiIQTy8dcLtAhsP9ZqotK0i7zl-jZ1Af73dFKcM1FYJosiDR1rFc_5SNa8BfuZc',
  ),
  ProductData(
    title: 'TrailBrew Espresso',
    category: 'Outdoor',
    description:
    'Lightweight, portable espresso maker for campers who refuse to compromise on coffee.',
    price: '\$65.00',
    rating: 4.9,
    imageUrl:
    'https://lh3.googleusercontent.com/aida-public/AB6AXuC6fyHBh90NWhc8im7FIzyitwK9bSgJu0YcAIOIrXBO5WNlLqU3UqcsXslC2KQXCUpH10PhWgLz03lOZjK5Lcc-JR6ZlbSFtVvTYIIos6rv_6O68IP6DcoOPMUJtj9sxJIkLGZLbMrlMjlBc5cHM70djiwWQTxjVnpNwVGRXBnhEY2iQmVheqnCrsP8tjXisIka1KodP31RuglzY1_d7WTkN3bqHaVQUVHCuO7gXG21Lo8LvW2lG4RHrA0trneTwFV0wfMdPMJLnKQ',
  ),
];

// ─── Products Screen ──────────────────────────────────────────────────────────

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
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
      home: _ProductsBody(isDark: _isDark, onToggleTheme: _toggleTheme),
    );
  }
}

class _ProductsBody extends StatefulWidget {
  final bool isDark;
  final VoidCallback onToggleTheme;

  const _ProductsBody({required this.isDark, required this.onToggleTheme});

  @override
  State<_ProductsBody> createState() => _ProductsBodyState();
}

class _ProductsBodyState extends State<_ProductsBody> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  int _selectedSort = 0; // 0=Newest, 1=Rating, 2=Popular
  int _currentPage = 1;
  String? _activeFilter;

  static const _sortLabels = ['Newest', 'Rating', 'Popular'];
  static const _quickFilters = ['4+ Stars', 'Tech', 'Lifestyle', 'Home Office'];

  List<ProductData> get _filteredProducts {
    var list = _allProducts.where((p) {
      final q = _searchQuery.toLowerCase();
      final matchesSearch = q.isEmpty ||
          p.title.toLowerCase().contains(q) ||
          p.category.toLowerCase().contains(q) ||
          p.description.toLowerCase().contains(q);

      bool matchesFilter = true;
      if (_activeFilter == '4+ Stars') {
        matchesFilter = p.rating >= 4.0;
      } else if (_activeFilter == 'Tech') {
        matchesFilter = p.category.toLowerCase() == 'tech' ||
            p.category.toLowerCase() == 'electronics';
      }
      return matchesSearch && matchesFilter;
    }).toList();

    if (_selectedSort == 1) {
      list.sort((a, b) => b.rating.compareTo(a.rating));
    }
    return list;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;

    return Scaffold(
      appBar: _buildAppBar(context, isDark),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: _horizontalPadding(context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 32),
                  _buildPageHeader(),
                  const SizedBox(height: 24),
                  _buildSearchFilterBar(context, isDark),
                  const SizedBox(height: 24),
                  _buildProductGrid(context),
                  const SizedBox(height: 8),
                  _buildPagination(isDark),
                  const SizedBox(height: 32),
                ],
              ),
            ),
            _FooterSection(isDark: isDark),
          ],
        ),
      ),
    );
  }

  EdgeInsets _horizontalPadding(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = w > 900 ? 80.0 : 16.0;
    return EdgeInsets.symmetric(horizontal: h);
  }

  // ── AppBar ──────────────────────────────────────────────────────────────────

  PreferredSizeWidget _buildAppBar(BuildContext context, bool isDark) {
    final isWide = MediaQuery.of(context).size.width > 700;
    return PreferredSize(
      preferredSize: const Size.fromHeight(60),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E2433) : Colors.white,
          border: Border(
            bottom: BorderSide(
              color: isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight,
            ),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isWide ? 80 : 16,
              vertical: 10,
            ),
            child: Row(
              children: [
                const Icon(Icons.reviews_outlined,
                    color: AppColors.primary, size: 26),
                const SizedBox(width: 8),
                Text(
                  'ReviewHub',
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                if (isWide) ...[
                  const SizedBox(width: 32),
                  _AppNavLink(label: 'Home', isDark: isDark),
                  _AppNavLink(
                      label: 'Products', isDark: isDark, isActive: true),
                  _AppNavLink(label: 'Categories', isDark: isDark),
                  _AppNavLink(label: 'About', isDark: isDark),
                ],
                const Spacer(),
                if (isWide)
                  _SearchBar(isDark: isDark, hint: 'Quick search...', compact: true),
                const SizedBox(width: 12),
                CircleAvatar(
                  radius: 18,
                  backgroundImage: const NetworkImage(
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuDcvB02LhB3WOOr0EhbR0H9NiNqSI3BWA5B6ZDwCzBgRV1MPanXFVB75Wtnwivgf2t-gB7U7pWrUqIlCUArMXy7M8-Pe82kT_JOLzNiK3hCTTf3gvKeSlSDfDWOtkvXzD_RyjUtatKuvTOwteU7AMbahZtIdhPt_F4U5FoIgmPeGcssuBlhzKKs-Bmd6KF6cs4hBChK5RthQBmyNNIMBRFSFlIIFk-4QUHnLD_5Tr_w0WsBO_2lg8KMRjb9NPapsFO5FLYsVbSlzR0',
                  ),
                  onBackgroundImageError: (_, __) {},
                ),
                const SizedBox(width: 6),
                IconButton(
                  onPressed: widget.onToggleTheme,
                  icon: Icon(
                    isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
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

  // ── Page Header ─────────────────────────────────────────────────────────────

  Widget _buildPageHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Explore Products',
          style: TextStyle(
            fontFamily: 'Manrope',
            fontSize: 36,
            fontWeight: FontWeight.w900,
            color: widget.isDark ? Colors.white : Colors.black,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Find and compare the best-rated products in our community.',
          style: TextStyle(
            fontFamily: 'Manrope',
            fontSize: 16,
            color: AppColors.textMuted,
          ),
        ),
      ],
    );
  }

  // ── Search + Filter Bar ──────────────────────────────────────────────────────

  Widget _buildSearchFilterBar(BuildContext context, bool isDark) {
    final isWide = MediaQuery.of(context).size.width > 700;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E2433) : Colors.white,
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
        children: [
          // Row: search + sort controls
          isWide
              ? Row(
            children: [
              Expanded(
                  child: _SearchBar(
                      isDark: isDark,
                      hint: 'Search products by name, brand, or category...',
                      controller: _searchController,
                      onChanged: (v) =>
                          setState(() => _searchQuery = v))),
              const SizedBox(width: 12),
              _RatingsDropdown(isDark: isDark),
              const SizedBox(width: 12),
              _SortToggle(
                labels: _sortLabels,
                selected: _selectedSort,
                isDark: isDark,
                onSelect: (i) => setState(() => _selectedSort = i),
              ),
            ],
          )
              : Column(
            children: [
              _SearchBar(
                  isDark: isDark,
                  hint: 'Search products...',
                  controller: _searchController,
                  onChanged: (v) =>
                      setState(() => _searchQuery = v)),
              const SizedBox(height: 10),
              Row(
                children: [
                  _RatingsDropdown(isDark: isDark),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _SortToggle(
                      labels: _sortLabels,
                      selected: _selectedSort,
                      isDark: isDark,
                      onSelect: (i) => setState(() => _selectedSort = i),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Divider + quick filters
          Divider(
            color: isDark
                ? AppColors.cardBorderDark
                : const Color(0xFFF1F5F9),
            height: 1,
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              const Text(
                'QUICK FILTERS:',
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textMuted,
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _quickFilters
                        .map((f) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: _FilterChip(
                        label: f,
                        isActive: _activeFilter == f,
                        isDark: isDark,
                        onTap: () => setState(() =>
                        _activeFilter =
                        _activeFilter == f ? null : f),
                      ),
                    ))
                        .toList(),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Product Grid ─────────────────────────────────────────────────────────────

  Widget _buildProductGrid(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final cols = w > 1100 ? 4 : (w > 700 ? 3 : (w > 480 ? 2 : 1));
    final products = _filteredProducts;

    if (products.isEmpty) {
      return const SizedBox(
        height: 200,
        child: Center(
          child: Text(
            'No products match your search.',
            style: TextStyle(
              fontFamily: 'Manrope',
              fontSize: 15,
              color: AppColors.textMuted,
            ),
          ),
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: cols,
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
        childAspectRatio: 0.68,
      ),
      itemCount: products.length,
      itemBuilder: (context, i) =>
          _ProductCard(product: products[i], isDark: widget.isDark),
    );
  }

  // ── Pagination ───────────────────────────────────────────────────────────────

  Widget _buildPagination(bool isDark) {
    final pages = [1, 2, 3, 12];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _PageButton(
            isDark: isDark,
            child: const Icon(Icons.chevron_left_rounded, size: 20),
            onTap: () {
              if (_currentPage > 1) setState(() => _currentPage--);
            },
          ),
          ...pages.map((p) {
            if (p == 3 && pages.indexOf(3) == 2) {
              // Insert ellipsis after page 3
              return Row(
                children: [
                  _PageButton(
                    isDark: isDark,
                    isActive: _currentPage == p,
                    onTap: () => setState(() => _currentPage = p),
                    child: Text('$p',
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: _currentPage == p
                              ? Colors.white
                              : (isDark ? Colors.white70 : AppColors.textMuted),
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text('...',
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          color: isDark ? Colors.white38 : AppColors.textMuted,
                        )),
                  ),
                ],
              );
            }
            return _PageButton(
              isDark: isDark,
              isActive: _currentPage == p,
              onTap: () => setState(() => _currentPage = p),
              child: Text(
                '$p',
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: _currentPage == p
                      ? Colors.white
                      : (isDark ? Colors.white70 : AppColors.textMuted),
                ),
              ),
            );
          }),
          _PageButton(
            isDark: isDark,
            child: const Icon(Icons.chevron_right_rounded, size: 20),
            onTap: () => setState(() => _currentPage++),
          ),
        ],
      ),
    );
  }
}

// ─── Reusable: AppBar Nav Link ────────────────────────────────────────────────

class _AppNavLink extends StatelessWidget {
  final String label;
  final bool isActive;
  final bool isDark;

  const _AppNavLink(
      {required this.label, required this.isDark, this.isActive = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: GestureDetector(
        onTap: () {},
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Manrope',
            fontSize: 13,
            fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
            color: isActive
                ? AppColors.primary
                : (isDark ? Colors.white60 : AppColors.textMuted),
          ),
        ),
      ),
    );
  }
}

// ─── Reusable: Search Bar ─────────────────────────────────────────────────────

class _SearchBar extends StatelessWidget {
  final bool isDark;
  final String hint;
  final bool compact;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;

  const _SearchBar({
    required this.isDark,
    required this.hint,
    this.compact = false,
    this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: compact ? 220 : null,
      height: 46,
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight,
          ),
        ),
        child: Row(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Icon(Icons.search, size: 18, color: AppColors.textMuted),
            ),
            Expanded(
              child: TextField(
                controller: controller,
                onChanged: onChanged,
                decoration: InputDecoration(
                  hintText: hint,
                  border: InputBorder.none,
                  hintStyle: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textMuted,
                    fontFamily: 'Manrope',
                  ),
                  contentPadding: EdgeInsets.zero,
                  isDense: true,
                ),
                style: TextStyle(
                  fontSize: 13,
                  fontFamily: 'Manrope',
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Reusable: Ratings Dropdown ───────────────────────────────────────────────

class _RatingsDropdown extends StatelessWidget {
  final bool isDark;

  const _RatingsDropdown({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'All Ratings',
            style: TextStyle(
              fontFamily: 'Manrope',
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(width: 6),
          Icon(Icons.expand_more_rounded,
              size: 18,
              color: isDark ? Colors.white54 : AppColors.textMuted),
        ],
      ),
    );
  }
}

// ─── Reusable: Sort Toggle ────────────────────────────────────────────────────

class _SortToggle extends StatelessWidget {
  final List<String> labels;
  final int selected;
  final bool isDark;
  final ValueChanged<int> onSelect;

  const _SortToggle({
    required this.labels,
    required this.selected,
    required this.isDark,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: labels.asMap().entries.map((e) {
          final isActive = e.key == selected;
          return GestureDetector(
            onTap: () => onSelect(e.key),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: isActive
                    ? (isDark ? const Color(0xFF2D3748) : Colors.white)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(7),
                boxShadow: isActive
                    ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 4,
                  )
                ]
                    : [],
              ),
              child: Text(
                e.value,
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 12,
                  fontWeight:
                  isActive ? FontWeight.w700 : FontWeight.w500,
                  color: isActive
                      ? AppColors.primary
                      : (isDark ? Colors.white54 : AppColors.textMuted),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ─── Reusable: Filter Chip ────────────────────────────────────────────────────

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isActive;
  final bool isDark;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isActive,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.primary.withOpacity(0.12)
              : (isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9)),
          borderRadius: BorderRadius.circular(100),
          border: Border.all(
            color: isActive
                ? AppColors.primary.withOpacity(0.3)
                : (isDark
                ? AppColors.cardBorderDark
                : AppColors.cardBorderLight),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Manrope',
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isActive
                ? AppColors.primary
                : (isDark ? Colors.white60 : AppColors.textMuted),
          ),
        ),
      ),
    );
  }
}

// ─── Reusable: Product Card ───────────────────────────────────────────────────

class _ProductCard extends StatefulWidget {
  final ProductData product;
  final bool isDark;

  const _ProductCard({required this.product, required this.isDark});

  @override
  State<_ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<_ProductCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    final isDark = widget.isDark;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E2433) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight,
          ),
          boxShadow: [
            BoxShadow(
              color:
              Colors.black.withOpacity(_hovered ? 0.10 : 0.04),
              blurRadius: _hovered ? 16 : 4,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image with rating badge overlay
              Expanded(
                flex: 5,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    AnimatedScale(
                      scale: _hovered ? 1.05 : 1.0,
                      duration: const Duration(milliseconds: 400),
                      child: Image.network(
                        p.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            Container(color: Colors.grey.shade200),
                      ),
                    ),
                    // Rating badge
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: isDark
                              ? Colors.black.withOpacity(0.75)
                              : Colors.white.withOpacity(0.92),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 4,
                            )
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.star_rounded,
                                color: Color(0xFFFACC15), size: 13),
                            const SizedBox(width: 3),
                            Text(
                              p.rating.toStringAsFixed(1),
                              style: TextStyle(
                                fontFamily: 'Manrope',
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                color: isDark ? Colors.white : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Content
              Expanded(
                flex: 6,
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        p.category.toUpperCase(),
                        style: const TextStyle(
                          fontFamily: 'Manrope',
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        p.title,
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: isDark ? Colors.white : Colors.black,
                          height: 1.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        p.description,
                        style: const TextStyle(
                          fontFamily: 'Manrope',
                          fontSize: 12,
                          color: AppColors.textMuted,
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Starting at',
                                style: TextStyle(
                                  fontFamily: 'Manrope',
                                  fontSize: 10,
                                  color: AppColors.textMuted,
                                ),
                              ),
                              Text(
                                p.price,
                                style: TextStyle(
                                  fontFamily: 'Manrope',
                                  fontSize: 17,
                                  fontWeight: FontWeight.w900,
                                  color: isDark ? Colors.white : Colors.black,
                                ),
                              ),
                            ],
                          ),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 10),
                              elevation: 0,
                              textStyle: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Manrope',
                              ),
                            ),
                            child: const Text('Details'),
                          ),
                        ],
                      ),
                    ],
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

// ─── Reusable: Pagination Button ──────────────────────────────────────────────

class _PageButton extends StatelessWidget {
  final Widget child;
  final bool isActive;
  final bool isDark;
  final VoidCallback? onTap;

  const _PageButton({
    required this.child,
    required this.isDark,
    this.isActive = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        margin: const EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.primary
              : (isDark ? const Color(0xFF1E2433) : Colors.white),
          borderRadius: BorderRadius.circular(10),
          border: isActive
              ? null
              : Border.all(
            color: isDark
                ? AppColors.cardBorderDark
                : AppColors.cardBorderLight,
          ),
        ),
        child: Center(child: child),
      ),
    );
  }
}

// ─── Footer Section ───────────────────────────────────────────────────────────

class _FooterSection extends StatelessWidget {
  final bool isDark;

  const _FooterSection({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 700;

    return Container(
      color: isDark ? const Color(0xFF1E2433) : Colors.white,
      padding: EdgeInsets.symmetric(
        horizontal: isWide ? 80 : 16,
        vertical: 48,
      ),
      child: Column(
        children: [
          isWide
              ? Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 2, child: _FooterBrand(isDark: isDark)),
              Expanded(
                  child: _FooterCol(
                      title: 'Explore',
                      links: const [
                        'Top Products',
                        'New Arrivals',
                        'Popular Brands'
                      ])),
              Expanded(
                  child: _FooterCol(
                      title: 'Community',
                      links: const [
                        'Review Guidelines',
                        'Top Reviewers',
                        'Blog'
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
                          title: 'Explore',
                          links: const [
                            'Top Products',
                            'New Arrivals',
                            'Popular Brands'
                          ])),
                  Expanded(
                      child: _FooterCol(
                          title: 'Community',
                          links: const [
                            'Review Guidelines',
                            'Top Reviewers',
                            'Blog'
                          ])),
                ],
              ),
              const SizedBox(height: 28),
              _FooterNewsletter(isDark: isDark),
            ],
          ),
          const SizedBox(height: 40),
          Divider(
            color: isDark ? AppColors.cardBorderDark : const Color(0xFFF1F5F9),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '© 2024 ReviewHub Inc. All rights reserved.',
                style: TextStyle(
                    fontSize: 11,
                    color: AppColors.textMuted,
                    fontFamily: 'Manrope'),
              ),
              if (MediaQuery.of(context).size.width > 500)
                Row(
                  children: ['Privacy Policy', 'Terms of Service', 'Contact']
                      .map((l) => Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: GestureDetector(
                      onTap: () {},
                      child: Text(l,
                          style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textMuted,
                              fontFamily: 'Manrope')),
                    ),
                  ))
                      .toList(),
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
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.reviews_outlined,
                color: AppColors.primary, size: 22),
            const SizedBox(width: 6),
            Text(
              'ReviewHub',
              style: TextStyle(
                fontFamily: 'Manrope',
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        const Text(
          "The world's most trusted platform for real user reviews and transparent product ratings.",
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
        const SizedBox(height: 12),
        ...links.map((l) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
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
        const Text('Join Our Newsletter',
            style: TextStyle(
                fontFamily: 'Manrope',
                fontSize: 13,
                fontWeight: FontWeight.w700)),
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
                      bottomLeft: Radius.circular(8),
                    ),
                    borderSide: BorderSide(
                      color: isDark
                          ? AppColors.cardBorderDark
                          : AppColors.cardBorderLight,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8),
                      bottomLeft: Radius.circular(8),
                    ),
                    borderSide: BorderSide(
                      color: isDark
                          ? AppColors.cardBorderDark
                          : AppColors.cardBorderLight,
                    ),
                  ),
                  contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  isDense: true,
                ),
                style: const TextStyle(fontSize: 13, fontFamily: 'Manrope'),
              ),
            ),
            Container(
              height: 42,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: const BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
              ),
              child: const Center(
                child: Text('Join',
                    style: TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Colors.white)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        const Text(
          'By subscribing, you agree to our privacy policy.',
          style: TextStyle(
              fontFamily: 'Manrope',
              fontSize: 10,
              color: AppColors.textMuted),
        ),
      ],
    );
  }
}

// ─── Entry Point ──────────────────────────────────────────────────────────────

