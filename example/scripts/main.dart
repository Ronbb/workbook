import 'package:workbook/workbook.dart';

@task
void printArguments() {
  print('arguments: $workBookArguments');
}

@task
Future<void> init() async {
  await Future.delayed(const Duration(seconds: 1));
  print('init after 1s');
}

@DefaultTask()
@Dependency(init)
@Dependency(printArguments)
void build() {
  print('build');
}
