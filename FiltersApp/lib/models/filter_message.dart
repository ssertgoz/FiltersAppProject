// Message to be sent to isolate
import 'dart:isolate';

import 'filter.dart';

class FilterMessage {
  final String inputPath;
  final Filter filter;
  final SendPort responsePort;

  FilterMessage(this.inputPath, this.filter, this.responsePort);
}
