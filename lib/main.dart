import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/player_controller.dart';
import 'pages/main_page.dart';
import 'pages/player_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Spotify Clone',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      initialBinding: BindingsBuilder(() {
        Get.put(PlayerController());
      }),
      getPages: [
        GetPage(name: '/', page: () => const MainPage()),
        GetPage(name: '/player', page: () => const PlayerPage()),
      ],
      initialRoute: '/',
    );
  }
}
