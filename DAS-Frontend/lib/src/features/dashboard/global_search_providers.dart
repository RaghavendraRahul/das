import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider for the currently selected index in the global search overlay.
final globalSearchIndexProvider = StateProvider<int>((ref) => 0);

/// Provider to manage the visibility of the global search overlay.
/// This allows external widgets like AppHeader to control the overlay state.
final globalSearchVisibleProvider = StateProvider<bool>((ref) => false);

/// Current flattened results list (history or search matching)
/// This allows both the Header and Overlay to stay in sync during keyboard navigation.
final globalSearchItemsProvider = StateProvider<List<dynamic>>((ref) => []);
