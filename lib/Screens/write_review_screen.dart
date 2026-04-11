import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Themes/app_colors.dart';
import '../providers/app_provider.dart';


// ─── Write Review Screen ──────────────────────────────────────────────────────

class WriteReviewScreen extends StatelessWidget {
  const WriteReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return _WriteReviewBody(isDark: isDark, onToggleTheme: () {});
  }
}

// ─── Body ─────────────────────────────────────────────────────────────────────

class _WriteReviewBody extends StatefulWidget {
  final bool isDark;
  final VoidCallback onToggleTheme;

  const _WriteReviewBody(
      {required this.isDark, required this.onToggleTheme});

  @override
  State<_WriteReviewBody> createState() => _WriteReviewBodyState();
}

class _WriteReviewBodyState extends State<_WriteReviewBody> {
  int _selectedRating = 0;
  int _hoveredRating = 0;
  bool _ratingError = false;
  bool _submitted = false;

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    final formValid = _formKey.currentState?.validate() ?? false;
    if (_selectedRating == 0) setState(() => _ratingError = true);
    if (!formValid || _selectedRating == 0) return;

    // Add review to Provider
    context.read<AppReviewProvider>().addReview(
      username: _nameController.text.trim(),
      rating: _selectedRating,
      title: _titleController.text.trim(),
      body: _descController.text.trim(),
      productId: '',
    );

    setState(() {
      _ratingError = false;
      _submitted = true;
    });
  }

  void _resetForm() {
    setState(() {
      _selectedRating = 0;
      _hoveredRating = 0;
      _ratingError = false;
      _submitted = false;
    });
    _nameController.clear();
    _emailController.clear();
    _titleController.clear();
    _descController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    final isWide = MediaQuery.of(context).size.width > 700;

    return Scaffold(
      appBar: _buildAppBar(context, isDark),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isWide ? 40 : 16,
                    vertical: 32,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _Breadcrumb(isDark: isDark),
                      const SizedBox(height: 24),
                      _PageHeader(isDark: isDark),
                      const SizedBox(height: 32),
                      _ProductPreviewCard(isDark: isDark),
                      const SizedBox(height: 24),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 350),
                        switchInCurve: Curves.easeOut,
                        switchOutCurve: Curves.easeIn,
                        child: _submitted
                            ? _SuccessMessage(
                          key: const ValueKey('success'),
                          isDark: isDark,
                          onWriteAnother: _resetForm,
                        )
                            : _ReviewFormWidget(
                          key: const ValueKey('form'),
                          isDark: isDark,
                          formKey: _formKey,
                          selectedRating: _selectedRating,
                          hoveredRating: _hoveredRating,
                          ratingError: _ratingError,
                          nameController: _nameController,
                          emailController: _emailController,
                          titleController: _titleController,
                          descController: _descController,
                          onRatingHover: (v) =>
                              setState(() => _hoveredRating = v),
                          onRatingSelect: (v) => setState(() {
                            _selectedRating = v;
                            _ratingError = false;
                          }),
                          onSubmit: _handleSubmit,
                        ),
                      ),
                      const SizedBox(height: 48),
                    ],
                  ),
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
      preferredSize: const Size.fromHeight(60),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.backgroundDark : Colors.white,
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
                horizontal: isWide ? 40 : 16, vertical: 10),
            child: Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.rate_review_rounded,
                      color: Colors.white, size: 18),
                ),
                const SizedBox(width: 10),
                Text(
                  'ReviewIt',
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                if (isWide) ...[
                  const SizedBox(width: 32),
                  for (final label in [
                    'Home',
                    'Products',
                    'Categories',
                    'About'
                  ])
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: GestureDetector(
                        onTap: () {
                          switch (label) {
                            case 'Home': Navigator.pushNamed(context, '/');
                            case 'Products': Navigator.pushNamed(context, '/products');
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
                CircleAvatar(
                  radius: 18,
                  backgroundImage: const NetworkImage(
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuDpCa-1MyG55ONNyvj9ysmltVwb7V63eYgQgqJ2uw6VAt1Gcookfgy-TMqGU1P6VyDWnNoSj7_C-s_Mgz7wdrdS_l5EjNAff3O03qtqCNpD2CIJVgKjtWbhIpevARB97W8izDx1MGwzn73iNUrUVMzPtIBH4_67B7t4KuUQwAfrJlRwf-lLQv6nTimLyU_YjMO7aHbGlGWIBtwJlmjzSlULEV4EuSeYkZwgKqpHQvBqr2cJZgJesRC9vSLKTTbV5VvSkZbSQlU-FkE',
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
          'Write a Review',
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Write a Review',
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
          'Share your experience with the community and help others make better choices.',
          style: TextStyle(
            fontFamily: 'Manrope',
            fontSize: 15,
            color: AppColors.textMuted,
          ),
        ),
      ],
    );
  }
}

// ─── Product Preview Card ─────────────────────────────────────────────────────

class _ProductPreviewCard extends StatelessWidget {
  final bool isDark;
  const _ProductPreviewCard({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
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
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              width: 100,
              height: 100,
              child: Image.network(
                'https://lh3.googleusercontent.com/aida-public/AB6AXuCzAnFc35xrVS4w-890LGEPU3Kfwz3C6AgtK78-FU2jpU9_cSu0hZe2VXg2BogZcigocKDorm2yRhAWbIRrR_SNS8K4q15LJOZEI4Dx0DyqpTqXFehY1lz_YIoDrzeqGvtnVO0e02llKSD7S9yXGgVrVHIJGF6OhIQiucaJVqp04YaKrhJ2ccp0XAuEfPp528ybbkNosCjJ3d0WUdWYcoTvO5O02NIq0A3lj5xTiRkiN-pCefalXYYuVtkNW9Pi5NujfGzALMFcgWU',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    Container(color: Colors.grey.shade200),
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'CURRENTLY REVIEWING',
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Premium Wireless Noise-Cancelling Headphones',
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : Colors.black,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Model: PX-700 Ultra (2024 Edition)',
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 13,
                    color: AppColors.textMuted,
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

// ─── Review Form Widget ───────────────────────────────────────────────────────

class _ReviewFormWidget extends StatelessWidget {
  final bool isDark;
  final GlobalKey<FormState> formKey;
  final int selectedRating;
  final int hoveredRating;
  final bool ratingError;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController titleController;
  final TextEditingController descController;
  final ValueChanged<int> onRatingHover;
  final ValueChanged<int> onRatingSelect;
  final VoidCallback onSubmit;

  const _ReviewFormWidget({
    super.key,
    required this.isDark,
    required this.formKey,
    required this.selectedRating,
    required this.hoveredRating,
    required this.ratingError,
    required this.nameController,
    required this.emailController,
    required this.titleController,
    required this.descController,
    required this.onRatingHover,
    required this.onRatingSelect,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 600;

    return Container(
      padding: EdgeInsets.all(isWide ? 36 : 20),
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
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Overall Rating ───────────────────────────────────────────────
            _FieldLabel(label: 'Overall Rating', isDark: isDark),
            const SizedBox(height: 12),
            StarSelector(
              selectedRating: selectedRating,
              hoveredRating: hoveredRating,
              onHover: onRatingHover,
              onSelect: onRatingSelect,
            ),
            if (ratingError) ...[
              const SizedBox(height: 6),
              const Text(
                'Please select a rating.',
                style: TextStyle(
                    fontFamily: 'Manrope', fontSize: 12, color: Colors.red),
              ),
            ],
            const SizedBox(height: 28),

            // ── Name + Email row ─────────────────────────────────────────────
            isWide
                ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ReviewTextField(
                    isDark: isDark,
                    label: 'Your Name',
                    hint: 'e.g. Alex Johnson',
                    controller: nameController,
                    validator: (v) =>
                    (v == null || v.trim().isEmpty)
                        ? 'Name is required'
                        : null,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: ReviewTextField(
                    isDark: isDark,
                    label: 'Email Address (Optional)',
                    hint: 'alex@example.com',
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    footnote: 'Your email will not be published.',
                  ),
                ),
              ],
            )
                : Column(
              children: [
                ReviewTextField(
                  isDark: isDark,
                  label: 'Your Name',
                  hint: 'e.g. Alex Johnson',
                  controller: nameController,
                  validator: (v) =>
                  (v == null || v.trim().isEmpty)
                      ? 'Name is required'
                      : null,
                ),
                const SizedBox(height: 20),
                ReviewTextField(
                  isDark: isDark,
                  label: 'Email Address (Optional)',
                  hint: 'alex@example.com',
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  footnote: 'Your email will not be published.',
                ),
              ],
            ),
            const SizedBox(height: 24),

            // ── Review Title ─────────────────────────────────────────────────
            ReviewTextField(
              isDark: isDark,
              label: 'Review Title',
              hint: 'Summarize your experience',
              controller: titleController,
              validator: (v) =>
              (v == null || v.trim().isEmpty)
                  ? 'Review title is required'
                  : null,
            ),
            const SizedBox(height: 24),

            // ── Review Body ──────────────────────────────────────────────────
            _FieldLabel(label: 'Your Review', isDark: isDark),
            const SizedBox(height: 8),
            ReviewTextArea(
              isDark: isDark,
              hint: 'What did you like or dislike? How was the quality?',
              controller: descController,
              validator: (v) =>
              (v == null || v.trim().isEmpty)
                  ? 'Please write your review'
                  : null,
            ),
            const SizedBox(height: 32),

            // ── Submit ───────────────────────────────────────────────────────
            ElevatedButton.icon(
              onPressed: onSubmit,
              icon: const Icon(Icons.send_rounded, size: 18),
              label: const Text('Submit Review'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(
                    horizontal: 32, vertical: 16),
                elevation: 2,
                shadowColor: AppColors.primary.withOpacity(0.3),
                textStyle: const TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Reusable: Star Selector ──────────────────────────────────────────────────

class StarSelector extends StatelessWidget {
  final int selectedRating;
  final int hoveredRating;
  final ValueChanged<int> onHover;
  final ValueChanged<int> onSelect;

  const StarSelector({
    super.key,
    required this.selectedRating,
    required this.hoveredRating,
    required this.onHover,
    required this.onSelect,
  });

  static const _labels = ['Terrible', 'Poor', 'Average', 'Good', 'Excellent'];

  @override
  Widget build(BuildContext context) {
    final activeRating = hoveredRating > 0 ? hoveredRating : selectedRating;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(5, (i) {
            final starIndex = i + 1;
            final isLit = starIndex <= activeRating;
            return MouseRegion(
              onEnter: (_) => onHover(starIndex),
              onExit: (_) => onHover(0),
              child: GestureDetector(
                onTap: () => onSelect(starIndex),
                child: Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 100),
                    child: Icon(
                      isLit
                          ? Icons.star_rounded
                          : Icons.star_outline_rounded,
                      key: ValueKey('star-$starIndex-$isLit'),
                      color: isLit
                          ? AppColors.starYellow
                          : AppColors.starEmpty,
                      size: 40,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
        if (activeRating > 0) ...[
          const SizedBox(height: 6),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 120),
            child: Text(
              _labels[activeRating - 1],
              key: ValueKey('label-$activeRating'),
              style: const TextStyle(
                fontFamily: 'Manrope',
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.starYellow,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

// ─── Reusable: Field Label ────────────────────────────────────────────────────

class _FieldLabel extends StatelessWidget {
  final String label;
  final bool isDark;

  const _FieldLabel({required this.label, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        fontFamily: 'Manrope',
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF374151),
      ),
    );
  }
}

// ─── Reusable: Text Field ─────────────────────────────────────────────────────

class ReviewTextField extends StatelessWidget {
  final bool isDark;
  final String label;
  final String hint;
  final TextEditingController controller;
  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType;
  final String? footnote;

  const ReviewTextField({
    super.key,
    required this.isDark,
    required this.label,
    required this.hint,
    required this.controller,
    this.validator,
    this.keyboardType,
    this.footnote,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldLabel(label: label, isDark: isDark),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          style: TextStyle(
            fontFamily: 'Manrope',
            fontSize: 14,
            color: isDark ? Colors.white : Colors.black,
          ),
          decoration: _buildInputDecoration(isDark, hint),
        ),
        if (footnote != null) ...[
          const SizedBox(height: 5),
          Text(
            footnote!,
            style: const TextStyle(
              fontFamily: 'Manrope',
              fontSize: 11,
              fontStyle: FontStyle.italic,
              color: AppColors.starEmpty,
            ),
          ),
        ],
      ],
    );
  }
}

// ─── Reusable: Text Area ──────────────────────────────────────────────────────

class ReviewTextArea extends StatelessWidget {
  final bool isDark;
  final String hint;
  final TextEditingController controller;
  final FormFieldValidator<String>? validator;

  const ReviewTextArea({
    super.key,
    required this.isDark,
    required this.hint,
    required this.controller,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      maxLines: 6,
      minLines: 6,
      style: TextStyle(
        fontFamily: 'Manrope',
        fontSize: 14,
        color: isDark ? Colors.white : Colors.black,
      ),
      decoration: _buildInputDecoration(isDark, hint),
    );
  }
}

// ─── Shared Input Decoration ──────────────────────────────────────────────────

InputDecoration _buildInputDecoration(bool isDark, String hint) {
  final borderColor =
  isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight;
  final fillColor =
  isDark ? AppColors.inputBgDark : AppColors.inputBg;

  return InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(
        fontFamily: 'Manrope', fontSize: 13, color: AppColors.textMuted),
    filled: true,
    fillColor: fillColor,
    contentPadding:
    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: borderColor)),
    enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: borderColor)),
    focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.primary, width: 2)),
    errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.red)),
    focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.red, width: 2)),
    errorStyle: const TextStyle(fontFamily: 'Manrope', fontSize: 11),
  );
}

// ─── Success Message ──────────────────────────────────────────────────────────

class _SuccessMessage extends StatelessWidget {
  final bool isDark;
  final VoidCallback onWriteAnother;

  const _SuccessMessage(
      {super.key, required this.isDark, required this.onWriteAnother});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.successGreen.withOpacity(0.08)
            : AppColors.successBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? AppColors.successGreen.withOpacity(0.3)
              : AppColors.successBorder,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.successGreen.withOpacity(0.2)
                  : const Color(0xFFD1FAE5),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(Icons.check_circle_rounded,
                  color: AppColors.successGreen, size: 36),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Thank you for your review!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Manrope',
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Your feedback has been successfully submitted and saved. It will help others in the community.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Manrope',
              fontSize: 14,
              color: AppColors.textMuted,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 28),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 12),
                  elevation: 0,
                  textStyle: const TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 14,
                      fontWeight: FontWeight.w700),
                ),
                child: const Text('Back to Products'),
              ),
              OutlinedButton(
                onPressed: onWriteAnother,
                style: OutlinedButton.styleFrom(
                  foregroundColor: isDark ? Colors.white : Colors.black,
                  side: BorderSide(
                      color: isDark
                          ? AppColors.cardBorderDark
                          : AppColors.cardBorderLight),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 12),
                  textStyle: const TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 14,
                      fontWeight: FontWeight.w700),
                ),
                child: const Text('Write Another'),
              ),
            ],
          ),
        ],
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
    return Container(
      color: isDark ? AppColors.backgroundDark : Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 32),
      width: double.infinity,
      child: const Center(
        child: Text(
          '© 2024 ReviewIt Inc. All rights reserved.',
          style: TextStyle(
              fontFamily: 'Manrope',
              fontSize: 13,
              color: AppColors.textMuted),
        ),
      ),
    );
  }
}
