import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newasync/meals/meals_screen.dart';
import 'package:newasync/serach/serach_provider.dart';
import 'package:newasync/meals/meals_api.dart' show Meals;

const _kBg = Color(0xFF111111);
const _kSurface = Color(0xFF1C1C1C);
const _kAccent = Color(0xFFFF6D00);

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _controller = TextEditingController();
  final _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    Future.microtask(() => _focus.requestFocus());
  }

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final data = ref.watch(searchProvider);

    return Scaffold(
      backgroundColor: _kBg,
      body: SafeArea(
        child: Column(
          children: [
            _buildSearchBar(context),
            Expanded(
              child: data.when(
                data: (meals) {
                  if (_controller.text.isEmpty) {
                    return _buildIdleState();
                  }
                  if (meals.isEmpty) {
                    return _buildEmptyState();
                  }
                  return _buildResultsGrid(context, meals);
                },
                error: (e, st) => Center(
                  child: Text(e.toString(), style: const TextStyle(color: Colors.white54)),
                ),
                loading: () => const Center(child: CircularProgressIndicator(color: _kAccent, strokeWidth: 2.5)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(color: _kSurface, borderRadius: BorderRadius.circular(12)),
              child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 18),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: _kSurface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.white.withValues(alpha: 0.07)),
              ),
              child: TextField(
                controller: _controller,
                focusNode: _focus,
                style: const TextStyle(color: Colors.white, fontSize: 15),
                onChanged: (value) {
                  setState(() {});
                  if (value.trim().isNotEmpty) {
                    ref.read(searchProvider.notifier).searchMeals(value.trim());
                  }
                },
                decoration: InputDecoration(
                  hintText: 'Search for a recipe...',
                  hintStyle: const TextStyle(color: Colors.white30, fontSize: 15),
                  prefixIcon: const Icon(Icons.search_rounded, color: _kAccent, size: 20),
                  suffixIcon: _controller.text.isNotEmpty
                      ? GestureDetector(
                          onTap: () {
                            _controller.clear();
                            setState(() {});
                          },
                          child: const Icon(Icons.close_rounded, color: Colors.white38, size: 20),
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIdleState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(color: _kSurface, borderRadius: BorderRadius.circular(24)),
            child: const Icon(Icons.search_rounded, color: _kAccent, size: 38),
          ),
          const SizedBox(height: 20),
          const Text(
            'Search for meals',
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Find recipes by name\nor cuisine type',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white38, fontSize: 14, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(color: _kSurface, borderRadius: BorderRadius.circular(24)),
            child: const Icon(Icons.no_meals_rounded, color: Colors.white30, size: 38),
          ),
          const SizedBox(height: 20),
          const Text(
            'No results found',
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text('Try a different keyword', style: TextStyle(color: Colors.white38, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildResultsGrid(BuildContext context, List<Meals> meals) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              '${meals.length} result${meals.length == 1 ? '' : 's'}',
              style: const TextStyle(color: Colors.white38, fontSize: 13),
            ),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 0.82,
              ),
              itemCount: meals.length,
              itemBuilder: (context, index) => _SearchMealCard(
                meal: meals[index],
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => MealsScreen(mealId: meals[index].idMeal)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchMealCard extends StatelessWidget {
  const _SearchMealCard({required this.meal, required this.onTap});

  final Meals meal;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Hero(
        tag: 'search_meal_${meal.idMeal}',
        child: Material(
          color: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(color: Colors.black.withValues(alpha: 0.4), blurRadius: 12, offset: const Offset(0, 5)),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    meal.strMealThumb,
                    fit: BoxFit.cover,
                    errorBuilder: (ctx, err, stack) => Container(
                      color: _kSurface,
                      child: const Icon(Icons.restaurant_menu, color: Colors.white30, size: 40),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black.withValues(alpha: 0.8)],
                        stops: const [0.45, 1.0],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 14,
                    left: 12,
                    right: 12,
                    child: Text(
                      meal.strMeal,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        shadows: [Shadow(color: Colors.black54, blurRadius: 6)],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
