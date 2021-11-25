import 'package:workbook/workbook.dart';

@task
void printArguments() {
  print(workBookArguments);
}

@task
void init() {
  print('init');
}

@DefaultTask()
@Dependency(init)
@Dependency(printArguments)
void build() {
  print('build');
}
