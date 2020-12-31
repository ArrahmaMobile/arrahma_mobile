import 'dart:async';

abstract class SyncService {
  const SyncService(
      {this.id, this.isMain, this.valueStreamCtrl, this.taskName});
  final String id;
  final bool isMain;
  final StreamController<String> valueStreamCtrl;
  final String taskName;

  void log(String message);
}
