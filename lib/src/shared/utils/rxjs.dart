import 'package:rxdart/rxdart.dart';

enum AppTabs { main, bovines, outputs }

final tabObserver = BehaviorSubject<int>();
