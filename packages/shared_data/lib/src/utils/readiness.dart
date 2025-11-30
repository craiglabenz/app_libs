import 'dart:async';
import 'package:logging/logging.dart';

final _log = Logger('Readiness');

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
///
/// To use [ReadinessMixin], implement [performInitialization] and eventually
/// call [markReady], passing in the instance of [T] loaded by the resource.
///
/// [T] is the central object this resource produces once ready. If no such
/// resource exists, choose `void`.
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
  Future<T> get ready {
    assert(
      _hasCalledInitialize,
      'Warning: Awaiting $this.ready without first calling initialize() will '
      'hang infinitely. Call initialize() first.',
    );
    return _readinessCompleter.future;
  }

  var _hasCalledInitialize = false;

  /// Calls [performInitialization] with extra bookkeeping. Descendant classes
  /// should implement [performInitialization] but then invoke [initialize].
  Future<void> initialize() {
    _log.finest('Initializing readiness for $this');
    _hasCalledInitialize = true;
    performInitialization();
    return _readinessCompleter.future;
  }

  /// Wires up all necessary resources for this object to be ready for general
  /// use.
  ///
  /// The job of [initialize] is to set up any necessary resources and then call
  /// [markReady] or [markReadinessFailed].
  void performInitialization();

  /// Removes any established readiness, if for example a dependency of this
  /// object has also lost readiness.
  ///
  /// A common use case is anything that marks itself ready once a user session
  /// is established; after that user logs out.
  void resetReadiness() {
    _log.fine('Resetting readiness for $this');
    _readinessCompleter = Completer<T>();
    status = Readiness.loading;
  }

  /// Marks this object as ready.
  void markReady(T obj) {
    if (_readinessCompleter.isCompleted) {
      if (failed) {
        throw Exception(
          'Cannot mark an object as ready after previously marking it unready. '
          'Call resetReadiness() if you intended to do this.',
        );
      }
      _log.fine(
        'Redundantly marking $this ready when already ready. '
        'Not a bad tongue twister.',
      );
      return;
    }
    _log.fine('Marking $this as ready with $obj');
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
          'Cannot mark an object as unready after previously marking it ready. '
          'Call resetReadiness() if you intended to do this.',
        );
      }
      _log.fine(
        'Redundantly marking $this as failed when already marked as failed.',
      );
      return;
    }
    _log.fine('Marking $this as readiness: failed');
    status = Readiness.failed;
    _readinessCompleter.completeError(
      'Failed to complete readiness check for $runtimeType',
    );
  }
}
