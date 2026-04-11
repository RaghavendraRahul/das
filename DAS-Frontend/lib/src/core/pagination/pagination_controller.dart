import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/paginated_response.dart';

class PaginationState<T> {
  final List<T> items;
  final int page;
  final int totalItems;
  final bool hasNext;
  final bool hasPrevious;
  final bool isLoading;
  final String? error;

  const PaginationState({
    this.items = const [],
    this.page = 1,
    this.totalItems = 0,
    this.hasNext = false,
    this.hasPrevious = false,
    this.isLoading = false,
    this.error,
  });

  factory PaginationState.initial() => const PaginationState();

  PaginationState<T> copyWith({
    List<T>? items,
    int? page,
    int? totalItems,
    bool? hasNext,
    bool? hasPrevious,
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) {
    return PaginationState<T>(
      items: items ?? this.items,
      page: page ?? this.page,
      totalItems: totalItems ?? this.totalItems,
      hasNext: hasNext ?? this.hasNext,
      hasPrevious: hasPrevious ?? this.hasPrevious,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

typedef PaginatedFetcher<T> = Future<PaginatedResponse<T>> Function(
    int page, Map<String, dynamic>? params);

class PaginationController<T> extends StateNotifier<PaginationState<T>> {
  final PaginatedFetcher<T> _fetcher;
  Map<String, dynamic>? _currentFilters;

  PaginationController(this._fetcher, [this._currentFilters])
      : super(PaginationState.initial());

  Future<void> fetchPage(int page, {Map<String, dynamic>? extraParams}) async {
    // Merge filters if provided, or use existing
    final params = {...?_currentFilters, ...?extraParams};

    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final response = await _fetcher(page, params);

      state = PaginationState(
        items: response.results,
        page: page, // Use requested page
        totalItems: response.count,
        hasNext: response.next != null,
        hasPrevious: response.previous != null,
        isLoading: false,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> nextPage() async {
    if (state.hasNext && !state.isLoading) {
      await fetchPage(state.page + 1);
    }
  }

  Future<void> previousPage() async {
    if (state.hasPrevious && !state.isLoading && state.page > 1) {
      await fetchPage(state.page - 1);
    }
  }

  Future<void> refresh() async {
    await fetchPage(1);
  }

  void updateFilters(Map<String, dynamic> newFilters) {
    _currentFilters = newFilters;
    fetchPage(1);
  }
}
