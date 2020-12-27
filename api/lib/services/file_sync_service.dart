import 'package:arrahma_shared/shared.dart';
import 'package:arrahma_web_api/api.dart';
import 'package:uuid/uuid.dart';

class FileSyncService<T> {
  static const idFilePath = 'data/mainId.txt';
  static final _fileService = FileService();
  static bool isMain;
  static String _mainId;
  static String _id;
  static Future<FileSyncService> init<T>(StreamController<T> valueStreamCtrl,
      ApplicationMessageHub messageHub, String taskName) async {
    _id ??= Uuid().v4();
    _mainId ??= await _fileService.read(idFilePath);
    if (_mainId == null) {
      _mainId = _id;
      await _fileService.write(idFilePath, _id);
    }
    isMain ??= _mainId == _id;
    return FileSyncService._internal(valueStreamCtrl, messageHub, taskName);
  }

  FileSyncService._internal(
      this.valueStreamCtrl, this.messageHub, this.taskName) {
    if (isMain) {
      valueStreamCtrl.stream.listen((event) {
        messageHub.add({'origin': _id, 'taskName': taskName, 'data': event});
      });
    } else {
      messageHub.listen((event) {
        if (event is Map &&
            event['origin'] != _id &&
            event['taskName'] == taskName) {
          valueStreamCtrl.add(event['data'] as T);
        }
      });
    }
  }

  final StreamController<T> valueStreamCtrl;
  final ApplicationMessageHub messageHub;
  final String taskName;
}
