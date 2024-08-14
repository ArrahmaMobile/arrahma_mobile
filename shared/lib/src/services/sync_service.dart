import 'dart:async';

abstract class SyncService {
  const SyncService(
      {required this.id, required this.isMain, required this.valueStreamCtrl, required this.taskName});
  final String id;
  final bool isMain;
  final StreamController<String> valueStreamCtrl;
  final String taskName;

  void log(String message);
}
