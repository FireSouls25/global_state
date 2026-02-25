import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/player_controller.dart';
import '../widgets/mini_player.dart';
import 'home_page.dart';
import 'library_page.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PlayerController>();
    final RxInt currentIndex = 0.obs;

    final pages = [const HomePage(), const LibraryPage()];

    return Obx(
      () => Scaffold(
        body: Stack(
          children: [
            Obx(() => IndexedStack(index: currentIndex.value, children: pages)),
            Positioned(
              left: 0,
              right: 0,
              bottom: controller.hasSong ? 64 : 0,
              child: const MiniPlayer(),
            ),
          ],
        ),
        bottomNavigationBar: Obx(
          () => BottomNavigationBar(
            currentIndex: currentIndex.value,
            onTap: (index) => currentIndex.value = index,
            backgroundColor: Colors.black,
            selectedItemColor: Colors.green,
            unselectedItemColor: Colors.grey,
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
              BottomNavigationBarItem(
                icon: Icon(Icons.library_music),
                label: 'Biblioteca',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
