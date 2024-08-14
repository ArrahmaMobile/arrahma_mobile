import 'package:arrahma_shared/shared.dart';
import 'package:arrahma_web_api/api.dart';
import 'package:conduit_core/conduit_core.dart';
import 'package:uuid/uuid.dart';

class DataSyncService implements SyncService {
  static const idFilePath = 'data/mainId.txt';
  static final _fileService = FileService();
  static late ApplicationMessageHub messageHub;
  static bool? _isMain;
  static String? _mainId;
  static String? _id;
  static String get instanceId => _id!;
  static Future<DataSyncService> init(String taskName) async {
    _id ??= Uuid().v4();
    _mainId ??= await _fileService.read(idFilePath);
    if (_mainId == null) {
      _mainId = _id;
      await _fileService.write(idFilePath, _id!);
    }
    _isMain ??= _mainId == _id;
    return DataSyncService._internal(
        _id!, _isMain!, StreamController<String>.broadcast(), taskName);
  }

  DataSyncService._internal(
      this.id, this.isMain, this.valueStreamCtrl, this.taskName) {
    log('Initialized.');

    if (isMain) {
      valueStreamCtrl.stream.listen(
        (data) {
          messageHub.add({'origin': _id, 'taskName': taskName, 'data': data});
          log('Sent data.');
        },
        onError: (err) => log(err),
      );
    } else {
      messageHub.listen(
        (event) {
          if (event is Map &&
              event['origin'] != _id &&
              event['taskName'] == taskName) {
            final data = event['data'].toString();
            valueStreamCtrl.add(data);
            log('Recieved data.');
          }
        },
        onError: (err) => log(err),
      );
    }
  }

  @override
  void log(String message) {
    print('${isMain ? '[MAIN] ' : ''}[$id] | $taskName | $message');
  }

  @override
  final String id;
  @override
  final bool isMain;
  @override
  final StreamController<String> valueStreamCtrl;
  @override
  final String taskName;
}
