// ignore_for_file: use_if_null_to_convert_nulls_to_bools

import 'dart:async';

/// Possible statuses for the readiness check flow.
enum Readiness {
  /// Fully ready. All dependencies cleared.
  ready,

  /// Striving for readiness. Some or all dependencies not yet cleared.
  loading,

  /// Failed to achieve readiness. This is potentially fatal.
  failed,
}

/// Adds functionality to check and verify readiness. This usually constitutes
/// completing some asynchronous setup operation, but could also involve
/// depending on another object's readiness and then taking an action.
mixin ReadinessMixin<T> {
  /// Cache of whether this object is ready. Set by the completer.
  Readiness status = Readiness.loading;

  /// Returns `true` if this object has successfully achieved readiness.
  bool get isReady => status == Readiness.ready;

  /// Returns `true` if this object has not yet successfully achieved readiness,
  /// or if this object has failed.
  bool get isNotReady => status != Readiness.ready;

  /// Returns `true` if this object has failed to achieve readiness.
  bool get failed => status == Readiness.failed;

  /// Returns `true` if this object has either achieved readiness or died
  /// trying.
  bool get isResolved => status != Readiness.loading;

  /// Returns `true` if this object is still trying to achieve readiness.
  bool get isNotResolved => status == Readiness.loading;

  // That which flips the readiness bit.
  var _readinessCompleter = Completer<T>();

  /// Resolves when readiness is achieved, or immediately if it has already been
  /// achieved.
  Future<T> get ready => _readinessCompleter.future;

  /// Wires up all necessary resources for this object to be ready for general
  /// use.
  Future<T> initialize();

  /// Removes any established readiness, if for example a dependency of this
  /// object has also lost readiness.
  ///
  /// A common use case is anything that marks itself ready once a user session
  /// is established; after that user logs out.
  void resetReadiness() {
    _readinessCompleter = Completer<T>();
    status = Readiness.loading;
  }

  /// Marks this object as ready.
  void markReady(T obj) {
    if (_readinessCompleter.isCompleted) {
      if (failed) {
        throw Exception(
          'Cannot mark an object as ready after previously marking it unready',
        );
      }
      return;
    }
    status = Readiness.ready;
    _readinessCompleter.complete(obj);
  }

  /// Mark this object is having failed to achieve readiness. This is different
  /// than the time spent acquiring readiness, which does not indicate a
  /// catastrophic failure as this likely does.
  void markReadinessFailed() {
    if (_readinessCompleter.isCompleted) {
      if (isReady) {
        throw Exception(
          'Cannot mark an object as unready after previously marking it ready',
        );
      }
      return;
    }
    status = Readiness.failed;
    _readinessCompleter.completeError(
      'Failed to complete readiness check for $runtimeType',
    );
  }
}
