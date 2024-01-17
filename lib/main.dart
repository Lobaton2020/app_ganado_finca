import 'package:app_ganado_finca/src/application/services/getDaoInstanceDependsNetwork.dart';
import 'package:app_ganado_finca/src/presentation/routes/main.dart';
import 'package:flutter/material.dart';
import 'package:app_ganado_finca/src/presentation/components/Layout.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await Supabase.initialize(
    url: dotenv.get('SUPABASE_URL'),
    anonKey: dotenv.get('SUPABASE_ANON_KEY'),
  );
  
  initObserverOffline();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Finca App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const TabBarApp(),
      routes: appRoutes,

    );
  }
}
