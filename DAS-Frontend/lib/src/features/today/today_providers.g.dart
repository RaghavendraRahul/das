// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'today_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$todayLogHash() => r'866dd184b4102ee1c25abf6acc04d9a7d3edf04e';

/// See also [todayLog].
@ProviderFor(todayLog)
final todayLogProvider = StreamProvider<DailyLogWithDetails?>.internal(
  todayLog,
  name: r'todayLogProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$todayLogHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef TodayLogRef = StreamProviderRef<DailyLogWithDetails?>;
String _$monthPlannedItemsHash() => r'c9e6b30ef4399c661be4dd0593030482b56f641f';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [monthPlannedItems].
@ProviderFor(monthPlannedItems)
const monthPlannedItemsProvider = MonthPlannedItemsFamily();

/// See also [monthPlannedItems].
class MonthPlannedItemsFamily
    extends Family<AsyncValue<Map<DateTime, List<PlannedItem>>>> {
  /// See also [monthPlannedItems].
  const MonthPlannedItemsFamily();

  /// See also [monthPlannedItems].
  MonthPlannedItemsProvider call(
    DateTime month,
  ) {
    return MonthPlannedItemsProvider(
      month,
    );
  }

  @override
  MonthPlannedItemsProvider getProviderOverride(
    covariant MonthPlannedItemsProvider provider,
  ) {
    return call(
      provider.month,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'monthPlannedItemsProvider';
}

/// See also [monthPlannedItems].
class MonthPlannedItemsProvider
    extends AutoDisposeStreamProvider<Map<DateTime, List<PlannedItem>>> {
  /// See also [monthPlannedItems].
  MonthPlannedItemsProvider(
    DateTime month,
  ) : this._internal(
          (ref) => monthPlannedItems(
            ref as MonthPlannedItemsRef,
            month,
          ),
          from: monthPlannedItemsProvider,
          name: r'monthPlannedItemsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$monthPlannedItemsHash,
          dependencies: MonthPlannedItemsFamily._dependencies,
          allTransitiveDependencies:
              MonthPlannedItemsFamily._allTransitiveDependencies,
          month: month,
        );

  MonthPlannedItemsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.month,
  }) : super.internal();

  final DateTime month;

  @override
  Override overrideWith(
    Stream<Map<DateTime, List<PlannedItem>>> Function(
            MonthPlannedItemsRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: MonthPlannedItemsProvider._internal(
        (ref) => create(ref as MonthPlannedItemsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        month: month,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<Map<DateTime, List<PlannedItem>>>
      createElement() {
    return _MonthPlannedItemsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MonthPlannedItemsProvider && other.month == month;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, month.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin MonthPlannedItemsRef
    on AutoDisposeStreamProviderRef<Map<DateTime, List<PlannedItem>>> {
  /// The parameter `month` of this provider.
  DateTime get month;
}

class _MonthPlannedItemsProviderElement
    extends AutoDisposeStreamProviderElement<Map<DateTime, List<PlannedItem>>>
    with MonthPlannedItemsRef {
  _MonthPlannedItemsProviderElement(super.provider);

  @override
  DateTime get month => (origin as MonthPlannedItemsProvider).month;
}

String _$weekPlannedItemsHash() => r'9e795dc41d2950a9490d870075e0f86a5357a998';

/// See also [weekPlannedItems].
@ProviderFor(weekPlannedItems)
const weekPlannedItemsProvider = WeekPlannedItemsFamily();

/// See also [weekPlannedItems].
class WeekPlannedItemsFamily
    extends Family<AsyncValue<Map<DateTime, List<PlannedItem>>>> {
  /// See also [weekPlannedItems].
  const WeekPlannedItemsFamily();

  /// See also [weekPlannedItems].
  WeekPlannedItemsProvider call(
    DateTime startOfWeek,
  ) {
    return WeekPlannedItemsProvider(
      startOfWeek,
    );
  }

  @override
  WeekPlannedItemsProvider getProviderOverride(
    covariant WeekPlannedItemsProvider provider,
  ) {
    return call(
      provider.startOfWeek,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'weekPlannedItemsProvider';
}

/// See also [weekPlannedItems].
class WeekPlannedItemsProvider
    extends AutoDisposeStreamProvider<Map<DateTime, List<PlannedItem>>> {
  /// See also [weekPlannedItems].
  WeekPlannedItemsProvider(
    DateTime startOfWeek,
  ) : this._internal(
          (ref) => weekPlannedItems(
            ref as WeekPlannedItemsRef,
            startOfWeek,
          ),
          from: weekPlannedItemsProvider,
          name: r'weekPlannedItemsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$weekPlannedItemsHash,
          dependencies: WeekPlannedItemsFamily._dependencies,
          allTransitiveDependencies:
              WeekPlannedItemsFamily._allTransitiveDependencies,
          startOfWeek: startOfWeek,
        );

  WeekPlannedItemsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.startOfWeek,
  }) : super.internal();

  final DateTime startOfWeek;

  @override
  Override overrideWith(
    Stream<Map<DateTime, List<PlannedItem>>> Function(
            WeekPlannedItemsRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: WeekPlannedItemsProvider._internal(
        (ref) => create(ref as WeekPlannedItemsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        startOfWeek: startOfWeek,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<Map<DateTime, List<PlannedItem>>>
      createElement() {
    return _WeekPlannedItemsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is WeekPlannedItemsProvider &&
        other.startOfWeek == startOfWeek;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, startOfWeek.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin WeekPlannedItemsRef
    on AutoDisposeStreamProviderRef<Map<DateTime, List<PlannedItem>>> {
  /// The parameter `startOfWeek` of this provider.
  DateTime get startOfWeek;
}

class _WeekPlannedItemsProviderElement
    extends AutoDisposeStreamProviderElement<Map<DateTime, List<PlannedItem>>>
    with WeekPlannedItemsRef {
  _WeekPlannedItemsProviderElement(super.provider);

  @override
  DateTime get startOfWeek => (origin as WeekPlannedItemsProvider).startOfWeek;
}

String _$selectedDateHash() => r'6c5aaff4ab7a60d19b71fad710e7ae68079b053d';

/// See also [SelectedDate].
@ProviderFor(SelectedDate)
final selectedDateProvider = NotifierProvider<SelectedDate, DateTime>.internal(
  SelectedDate.new,
  name: r'selectedDateProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$selectedDateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectedDate = Notifier<DateTime>;
String _$selectedQuadrantHash() => r'c58b56fdb5869b938cf2d07236c4378063d116b5';

/// See also [SelectedQuadrant].
@ProviderFor(SelectedQuadrant)
final selectedQuadrantProvider =
    NotifierProvider<SelectedQuadrant, String?>.internal(
  SelectedQuadrant.new,
  name: r'selectedQuadrantProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$selectedQuadrantHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectedQuadrant = Notifier<String?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
