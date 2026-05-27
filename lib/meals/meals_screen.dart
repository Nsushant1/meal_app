import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newasync/meals/meals_api.dart';
import 'package:newasync/meals/meals_provder.dart';

const _kBg = Color(0xFF111111);
const _kSurface = Color(0xFF1C1C1C);
const _kCard = Color(0xFF222222);
const _kAccent = Color(0xFFFF6D00);

class MealsScreen extends ConsumerWidget {
  final String mealId;
  const MealsScreen({super.key, required this.mealId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(mealsProvider.notifier).fetchReceipe(mealId);
    final data = ref.watch(mealsProvider);

    return Scaffold(
      backgroundColor: _kBg,
      body: data.when(
        data: (recipes) {
          final meal = recipes[0];
          return _MealDetail(meal: meal);
        },
        error: (e, st) => Scaffold(
          backgroundColor: _kBg,
          appBar: AppBar(backgroundColor: _kBg, elevation: 0),
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline_rounded,
                    color: Colors.white30, size: 52),
                const SizedBox(height: 12),
                const Text(
                  'Failed to load recipe',
                  style: TextStyle(color: Colors.white54, fontSize: 16),
                ),
              ],
            ),
          ),
        ),
        loading: () => Scaffold(
          backgroundColor: _kBg,
          body: const Center(
            child: CircularProgressIndicator(color: _kAccent, strokeWidth: 2.5),
          ),
        ),
      ),
    );
  }
}

class _MealDetail extends StatelessWidget {
  const _MealDetail({required this.meal});

  final Meals meal;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeroImage(context),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoChips(),
                    const SizedBox(height: 28),
                    _buildIngredientsSection(),
                    const SizedBox(height: 28),
                    _buildInstructionsSection(),
                    const SizedBox(height: 28),
                    _buildWatchVideoButton(),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ),
        _buildBackButton(context),
      ],
    );
  }

  Widget _buildHeroImage(BuildContext context) {
    return SizedBox(
      height: 340,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            meal.strMealThumb,
            fit: BoxFit.cover,
            errorBuilder: (ctx, err, stack) => Container(
              color: _kSurface,
              child: const Icon(Icons.restaurant_menu,
                  color: Colors.white30, size: 60),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.3),
                  Colors.transparent,
                  _kBg.withValues(alpha: 0.7),
                  _kBg,
                ],
                stops: const [0.0, 0.35, 0.75, 1.0],
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Text(
              meal.strMeal,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
                height: 1.2,
                shadows: [Shadow(color: Colors.black54, blurRadius: 8)],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.55),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
              size: 18,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChips() {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        _Chip(label: meal.strCategory, icon: Icons.category_rounded, accent: true),
        _Chip(label: meal.strArea, icon: Icons.public_rounded, accent: false),
        if (meal.strTags != null && meal.strTags!.isNotEmpty)
          ...meal.strTags!
              .split(',')
              .take(2)
              .map((t) => _Chip(label: t.trim(), icon: Icons.tag_rounded, accent: false)),
      ],
    );
  }

  Widget _buildIngredientsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 20,
              decoration: BoxDecoration(
                color: _kAccent,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'Ingredients',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: _kAccent.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${meal.ingredients.length}',
                style: const TextStyle(
                  color: _kAccent,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Container(
          decoration: BoxDecoration(
            color: _kCard,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              for (int i = 0; i < meal.ingredients.length; i++)
                _IngredientRow(
                  ingredient: meal.ingredients[i],
                  isLast: i == meal.ingredients.length - 1,
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInstructionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 20,
              decoration: BoxDecoration(
                color: _kAccent,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'Instructions',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: _kCard,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            meal.strInstructions,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 15,
              height: 1.65,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWatchVideoButton() {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.play_circle_fill_rounded, size: 22),
        label: const Text(
          'Watch Video',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: _kAccent,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label, required this.icon, required this.accent});

  final String label;
  final IconData icon;
  final bool accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: accent
            ? _kAccent.withValues(alpha: 0.15)
            : _kSurface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: accent
              ? _kAccent.withValues(alpha: 0.4)
              : Colors.white.withValues(alpha: 0.08),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: accent ? _kAccent : Colors.white54),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: accent ? _kAccent : Colors.white70,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _IngredientRow extends StatelessWidget {
  const _IngredientRow({required this.ingredient, required this.isLast});

  final Ingredient ingredient;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: _kAccent,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  ingredient.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Text(
                ingredient.measure,
                style: const TextStyle(
                  color: _kAccent,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        if (!isLast)
          Divider(
            height: 1,
            indent: 38,
            color: Colors.white.withValues(alpha: 0.06),
          ),
      ],
    );
  }
}
