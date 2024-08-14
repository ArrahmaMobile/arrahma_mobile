import 'dart:async';
import 'dart:collection';

import 'package:scraper/src/utc_exception.dart';

abstract class Worker<TJob, TResult> {
  Worker({
    required this.maxSimultaneousJobCount,
  });

  final int maxSimultaneousJobCount;

  // ignore: prefer_collection_literals
  final _inQueue = LinkedHashMap<TJob, Completer<TResult?>>();
  // ignore: prefer_collection_literals
  final _inProgress = LinkedHashMap<TJob, Completer<TResult?>>();

  Future<TResult?> performWork(TJob job);

  Future<TResult?> add(TJob job) {
    return process(job);
  }

  Future<TResult?> process(TJob job) {
    if (_inProgress.length >= maxSimultaneousJobCount) {
      return queue(job);
    }
    return start(job);
  }

  Future<TResult?> queue(TJob job) {
    if (_inQueue.containsKey(job)) return _inQueue[job]!.future;
    final completer = Completer<TResult?>();
    _inQueue[job] = completer;
    return completer.future;
  }

  Future<TResult?> start(TJob job) async {
    if (_inProgress.containsKey(job)) return _inProgress[job]!.future;
    final inQueueJob = _inQueue[job];
    if (inQueueJob != null) _inQueue.remove(job);
    final completer = inQueueJob ?? Completer<TResult?>();
    _inProgress[job] = completer;

    try {
      final result = await performWork(job);
      completer.complete(result);
      return result;
    } catch (err) {
      if (err is UnableToContinueException) {
        throw err;
      }
      completer.completeError(err);
    } finally {
      _inProgress.remove(job);
      startNextInQueue();
    }
    return null;
  }

  void startNextInQueue() {
    if (_inQueue.isEmpty) return;
    process(_inQueue.keys.last);
  }
}
