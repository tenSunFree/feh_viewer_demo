import 'package:get/get_core/src/get_main.dart';
import 'package:logger/logger.dart';

final Logger log = Logger(
  filter: EHLogFilter(),
  printer: PrettyPrinter(
    // lineLength: 1,
    colors: false,
    methodCount: 1,
  ),
);

final Logger logger = Logger(
  filter: EHLogFilter(),
  printer: PrettyPrinter(
    // lineLength: 1,
    colors: false,
    methodCount: 1,
  ),
);

final Logger logger5 = Logger(
  filter: EHLogFilter(),
  printer: PrettyPrinter(
    // lineLength: 100,
    methodCount: 5,
    colors: false,
  ),
);

final Logger loggerNoStack = Logger(
  filter: EHLogFilter(),
  printer: PrettyPrinter(
    // lineLength: 100,
    methodCount: 0,
    colors: false,
  ),
);

final Logger loggerNoStackTime = Logger(
  printer: PrettyPrinter(
    methodCount: 0,
    colors: false,
    printTime: true,
  ),
);

class EHLogFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    if (event.level.index >= level!.index) {
      return true;
    }
    return false;
  }
}

final Logger loggerForGetx = Logger(
  printer: GetxPrinter(),
  filter: EHLogFilter(),
);

void loggerGetx(String text, {bool isError = false}) {
  if (isError) {
    loggerNoStack.e('[GETX] ==> $text');
  } else if (Get.isLogEnable) {
    loggerForGetx.d('[GETX] ==> $text');
  }
}

class GetxPrinter extends LogPrinter {
  @override
  List<String> log(LogEvent event) {
    return <String>[event.message];
  }
}
