// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_performance_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$dailyPerformanceHash() => r'ed88c073fd7d6bc7d1a0f36ce985471aaf399e28';

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

/// See also [dailyPerformance].
@ProviderFor(dailyPerformance)
const dailyPerformanceProvider = DailyPerformanceFamily();

/// See also [dailyPerformance].
class DailyPerformanceFamily extends Family<AsyncValue<DailyPerformanceData>> {
  /// See also [dailyPerformance].
  const DailyPerformanceFamily();

  /// See also [dailyPerformance].
  DailyPerformanceProvider call({
    String? date,
  }) {
    return DailyPerformanceProvider(
      date: date,
    );
  }

  @override
  DailyPerformanceProvider getProviderOverride(
    covariant DailyPerformanceProvider provider,
  ) {
    return call(
      date: provider.date,
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
  String? get name => r'dailyPerformanceProvider';
}

/// See also [dailyPerformance].
class DailyPerformanceProvider
    extends AutoDisposeFutureProvider<DailyPerformanceData> {
  /// See also [dailyPerformance].
  DailyPerformanceProvider({
    String? date,
  }) : this._internal(
          (ref) => dailyPerformance(
            ref as DailyPerformanceRef,
            date: date,
          ),
          from: dailyPerformanceProvider,
          name: r'dailyPerformanceProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$dailyPerformanceHash,
          dependencies: DailyPerformanceFamily._dependencies,
          allTransitiveDependencies:
              DailyPerformanceFamily._allTransitiveDependencies,
          date: date,
        );

  DailyPerformanceProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.date,
  }) : super.internal();

  final String? date;

  @override
  Override overrideWith(
    FutureOr<DailyPerformanceData> Function(DailyPerformanceRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DailyPerformanceProvider._internal(
        (ref) => create(ref as DailyPerformanceRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        date: date,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<DailyPerformanceData> createElement() {
    return _DailyPerformanceProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DailyPerformanceProvider && other.date == date;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, date.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin DailyPerformanceRef
    on AutoDisposeFutureProviderRef<DailyPerformanceData> {
  /// The parameter `date` of this provider.
  String? get date;
}

class _DailyPerformanceProviderElement
    extends AutoDisposeFutureProviderElement<DailyPerformanceData>
    with DailyPerformanceRef {
  _DailyPerformanceProviderElement(super.provider);

  @override
  String? get date => (origin as DailyPerformanceProvider).date;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
