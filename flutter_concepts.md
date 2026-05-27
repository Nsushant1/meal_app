# Flutter Concepts Used in Meal App

## 1. App Entry Point & Initialization

- `WidgetsFlutterBinding.ensureInitialized()` — ensures the Flutter engine is ready before running any platform-specific code
- `runApp()` — mounts the root widget onto the screen
- `ProviderScope` — wraps the entire app to enable Riverpod; all providers are scoped to this

**Example from `main.dart`:**
```dart
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MyApp()));
}
```

---

## 2. Widget Types

### StatelessWidget
Used for widgets that never change once built. `MyApp`, `_CategoryCard`, `_MealCard`, `_SearchMealCard`, `_MealDetail`, `_Chip`, `_IngredientRow` are all `StatelessWidget`s.

### StatefulWidget
Used when local mutable state is needed. Not used directly here — replaced by `ConsumerStatefulWidget`.

### ConsumerWidget (Riverpod)
A `StatelessWidget` that has access to a `WidgetRef`. Used in `HomeScreen` and `MealsScreen`.
```dart
class HomeScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) { ... }
}
```

### ConsumerStatefulWidget (Riverpod)
A `StatefulWidget` that has access to `ref` inside its `ConsumerState`. Used in `DetailScreen` and `SearchScreen` so they can both manage local state (e.g., `TextEditingController`) and watch providers.
```dart
class SearchScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}
class _SearchScreenState extends ConsumerState<SearchScreen> { ... }
```

---

## 3. State Management — Flutter Riverpod

### AsyncNotifierProvider
Creates a provider whose state is `AsyncValue<T>`. Used for all four feature providers.
```dart
final mealProvider = AsyncNotifierProvider<MealNotifier, List<ApiModel>>(
  MealNotifier.new,
);
```

### AsyncNotifier
A notifier that holds `AsyncValue<T>`. The `build()` method is the initial state resolver — returning a `Future` or plain value.
```dart
class MealNotifier extends AsyncNotifier<List<ApiModel>> {
  @override
  FutureOr<List<ApiModel>> build() => ApiService().getMeal();
}
```

### AsyncValue & `.when()`
`AsyncValue` has three states: `loading`, `data`, and `error`. The `.when()` method pattern-matches all three:
```dart
data.when(
  data: (meals) => ...,
  loading: () => CircularProgressIndicator(),
  error: (e, _) => Text(e.toString()),
)
```

### ref.watch() vs ref.read()
- `ref.watch()` — subscribes to a provider; rebuilds the widget when the value changes
- `ref.read()` — reads a provider once without subscribing; used to call notifier methods

### Manual state mutation in AsyncNotifier
`SearchNotifier` mutates `state` directly to push new async results:
```dart
state = AsyncData(mealdata.cast<Meals>());
state = AsyncError(e, StackTrace.current);
```

---

## 4. Theming

- `ThemeData` — root theme configuration
- `brightness: Brightness.dark` — sets the overall dark theme
- `ColorScheme.dark()` — defines semantic colors (primary, surface, etc.)
- `AppBarTheme` — global AppBar styling without repeating it per screen

```dart
ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: const Color(0xFF111111),
  colorScheme: const ColorScheme.dark(
    primary: Color(0xFFFF6D00),
    surface: Color(0xFF1C1C1C),
  ),
)
```

---

## 5. System UI

- `SystemChrome.setSystemUIOverlayStyle()` — customizes the status bar color and icon brightness
- `SystemUiOverlayStyle` — data class for overlay appearance

```dart
SystemChrome.setSystemUIOverlayStyle(
  const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ),
);
```

---

## 6. Navigation

### Stack-based navigation with `Navigator`
- `Navigator.push()` + `MaterialPageRoute` — pushes a new route onto the stack
- `Navigator.pop()` — returns to the previous screen

```dart
Navigator.push(context, MaterialPageRoute(builder: (_) => DetailScreen(category: ...)));
Navigator.pop(context);
```

### Passing data between screens
Arguments are passed as constructor parameters:
```dart
DetailScreen(category: meals[index].strCategory)
MealsScreen(mealId: meals[index].idMeal)
```

---

## 7. Layouts

### Scaffold
The top-level structure providing `body`, `appBar`, `floatingActionButton`, etc.

### SafeArea
Insets content away from OS intrusions (notch, status bar, home indicator).

### CustomScrollView + Slivers
Used in `HomeScreen` for a scrollable area with heterogeneous sections:
- `SliverToBoxAdapter` — embeds a normal widget in a sliver list
- `SliverPadding` — adds padding around a sliver
- `SliverGrid` + `SliverChildBuilderDelegate` — lazily-built grid inside a sliver
- `SliverFillRemaining` — fills the remaining viewport (used for loading/error states)

### GridView.builder
Used in `DetailScreen` and `SearchScreen` for scrollable grids with lazy construction.
```dart
GridView.builder(
  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
    crossAxisSpacing: 14,
    mainAxisSpacing: 14,
    childAspectRatio: 0.82,
  ),
  itemCount: meals.length,
  itemBuilder: (context, index) => ...,
)
```

### SliverGridDelegateWithFixedCrossAxisCount
Defines a grid layout by number of columns, spacing, and aspect ratio.

### Stack & Positioned
`Stack` layers widgets on top of each other. `Positioned` places a child at an exact offset within a `Stack`.

### SingleChildScrollView
Used in `MealsScreen` detail view to make a long column scrollable.

### Column, Row
Core flex-direction layout widgets. `CrossAxisAlignment` and `MainAxisAlignment` control alignment.

### Expanded
Makes a child fill available space along the main axis inside a `Row` or `Column`.

### Wrap
Like `Row` but wraps to the next line when it runs out of space — used for ingredient/tag chips.

---

## 8. UI Widgets

| Widget | Usage |
|---|---|
| `AppBar` | Top navigation bar with `leading`, `title`, `centerTitle` |
| `Text` | Basic text display |
| `RichText` + `TextSpan` | Multi-styled text in a single widget |
| `Icon` | Material icons |
| `Image.network` | Load images from a URL with `errorBuilder` fallback |
| `TextField` | Text input with `controller`, `focusNode`, `onChanged`, `decoration` |
| `ElevatedButton.icon` | Button with icon + label |
| `GestureDetector` | Detects taps/gestures without visual feedback |
| `Container` | Box model widget with `decoration`, `padding`, `margin` |
| `SizedBox` | Fixed-size space or explicit width/height wrapper |
| `Padding` | Adds padding around a single child |
| `CircularProgressIndicator` | Spinning loading indicator |
| `Divider` | Horizontal rule line |

---

## 9. Decoration & Styling

### BoxDecoration
The primary decoration class for `Container`:
- `color` — background color
- `borderRadius` — rounded corners via `BorderRadius.circular()`
- `boxShadow` — list of `BoxShadow` (color, blurRadius, offset)
- `gradient` — `LinearGradient` with `begin`, `end`, `colors`, `stops`
- `border` — `Border.all()` for outlines
- `shape: BoxShape.circle` — circular shape (used for dot indicators)

### LinearGradient
Used as image overlays to ensure text readability over photos:
```dart
LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [Colors.transparent, Colors.black.withValues(alpha: 0.8)],
  stops: const [0.45, 1.0],
)
```

### ClipRRect
Clips its child to rounded corners, used to round card images.

### `withValues(alpha:)`
New API (Flutter 3.x+) for creating a color with a specific opacity value (0.0–1.0), replacing the older `.withOpacity()`.

### TextStyle
- `fontSize`, `fontWeight`, `color`, `height` (line height multiplier)
- `shadows` — list of `Shadow` for text drop shadows
- `overflow: TextOverflow.ellipsis` — truncates long text with "..."
- `maxLines` — constrains number of visible lines

---

## 10. Animations

### Hero
Shared-element transition between routes. A widget tagged with `Hero(tag: ...)` on screen A animates to the matching tag on screen B:
```dart
Hero(
  tag: 'category_${meal.strCategory}',
  child: Material(
    color: Colors.transparent,
    child: ...,
  ),
)
```
`Material` is wrapped around the hero child to prevent ink/theme artifacts during the transition.

---

## 11. HTTP Networking — Dio

- `Dio()` — HTTP client instance
- `dio.get(url, options: Options(...))` — makes a GET request
- `Options(headers: {...})` — sets request headers
- `queryParameters` — appends query string params
- `response.data` — the parsed response body (auto-decoded JSON)
- `DioException` — typed exception for all Dio errors (network, timeout, status code)

```dart
final response = await dio.get(
  'https://www.themealdb.com/api/json/v1/1/categories.php',
  options: Options(headers: {"Accept": "application/json"}),
);
final data = response.data['categories'] as List;
```

---

## 12. Data Modeling

### Model classes with `factory fromJson`
Each API response is mapped to a Dart class:
```dart
class ApiModel {
  final String idCategory;
  final String strCategory;
  // ...

  factory ApiModel.fromJson(Map<String, dynamic> json) {
    return ApiModel(
      idCategory: json['idCategory'],
      strCategory: json['strCategory'],
      // ...
    );
  }
}
```

### List parsing
```dart
final data = response.data['categories'] as List;
return data.map((e) => ApiModel.fromJson(e)).toList();
```

---

## 13. Async / Dart Concurrency

- `async` / `await` — marks a function as async and suspends at `await`
- `Future<T>` — represents a value available in the future
- `FutureOr<T>` — can be either `T` or `Future<T>`; used in Riverpod's `build()`
- `Future.microtask()` — schedules a callback after the current frame, before the next one; used to call provider methods safely from `initState()`
- `try / catch` — handles exceptions from async operations

```dart
@override
void initState() {
  super.initState();
  Future.microtask(
    () => ref.read(categoryProvider.notifier).fetchMeals(widget.category),
  );
}
```

---

## 14. Widget Lifecycle

| Method | When it runs |
|---|---|
| `initState()` | Once, when the widget is first inserted into the tree |
| `build()` | Every time the widget needs to re-render |
| `dispose()` | Once, when the widget is removed from the tree — used to clean up controllers |

---

## 15. Input & Focus Management

- `TextEditingController` — controls and reads text from a `TextField`; must be disposed
- `FocusNode` — programmatically manages keyboard focus; must be disposed
- `_focus.requestFocus()` — opens the keyboard when the screen appears
- `_controller.clear()` — clears the text field

```dart
final _controller = TextEditingController();
final _focus = FocusNode();

@override
void dispose() {
  _controller.dispose();
  _focus.dispose();
  super.dispose();
}
```

---

## 16. Null Safety

- `String?` — nullable type; may hold `null`
- `?.` — null-aware member access; skips if null
- `??` — null coalescing; returns right-hand value if left is null
- `!` — null assertion; throws if null at runtime
- `required` keyword — named parameter that must be provided

---

## 17. Service Layer Architecture

The app follows a clean three-layer pattern:

```
UI Screen
   ↓ ref.watch / ref.read
Provider (AsyncNotifier)
   ↓ calls
Service class
   ↓ calls
API Model (JSON parsing)
```

Each feature has its own folder with: `_api.dart` (model), `_service.dart` (Dio logic), `_provider.dart` (Riverpod state), and `_screen.dart` (UI).

---

## 18. Dart Language Features Used

- `const` constructors — compile-time constants for widgets
- `final` fields — immutable after assignment
- Named parameters with `required` — explicit, self-documenting APIs
- `VoidCallback` — `typedef void Function()` for tap callbacks
- Spread operator `...` — spreads an iterable into a list (used for dynamic chip lists)
- `.take(n)` — limits an iterable to n elements
- `.split()`, `.trim()` — string manipulation
- String interpolation `'${expression}'`
- Conditional expressions (`condition ? a : b`)
- `if` inside collection literals — conditionally adds elements to a list

---

## 19. Testing

- `flutter_test` package — testing utilities
- `testWidgets()` — runs a test in a simulated widget environment
- `WidgetTester` — pumps frames and interacts with widgets
- `find.text()`, `expect()` — assertions on widget state
