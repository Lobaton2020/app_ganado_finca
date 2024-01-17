import 'package:rxdart/rxdart.dart';

enum AppTabs { main, bovines, outputs }
enum InternetState { disconnected, connected }
final tabObserver = BehaviorSubject<int>();
final internetState = BehaviorSubject<InternetState>();
