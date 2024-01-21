import 'package:app_ganado_finca/src/application/services/getDaoInstanceDependsNetwork.dart';
import 'package:app_ganado_finca/src/infraestructure/db/adapter/sqliteAdapter.dart';
import 'package:app_ganado_finca/src/presentation/routes/main.dart';
import 'package:flutter/material.dart';
import 'package:app_ganado_finca/src/presentation/components/Layout.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await dotenv.load(fileName: '.env');
    await Supabase.initialize(
      url: dotenv.get('SUPABASE_URL'),
      anonKey: dotenv.get('SUPABASE_ANON_KEY'),
    );
    initObserverOffline();
    await DatabaseHelper.getInstance();
    runApp(MyApp());
  } catch (error) {
    print("CUSTOM_LOGGER: $error");
    runApp(MyApp(
      error: error.toString(),
    ));
  }
}

class MyApp extends StatelessWidget {
  final String? error;
  const MyApp({super.key, this.error});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Finca App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: error != null
          ? Center(
              child: Text("$error"),
            )
          : const TabBarApp(),
      routes: appRoutes,

    );
  }
}
