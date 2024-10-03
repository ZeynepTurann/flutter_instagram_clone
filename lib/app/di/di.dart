//dependecny injection will be applied in this folder

import 'package:get_it/get_it.dart';
import 'package:shared/shared.dart';

final getIt = GetIt.instance;

void setUpDi({required AppFlavor appFlavor}) {
  getIt.registerSingleton(appFlavor);
}
