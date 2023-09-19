import 'package:emergency_call/domain/model/ErrorType.dart';

class SaveLocationResponse {
  bool wasLocationSaved;
  ErrorType errorType;

  SaveLocationResponse({
    this.wasLocationSaved = false,
    this.errorType = const None(""),
  });
}


