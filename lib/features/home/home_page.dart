import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monex/core/theme/app_colors.dart';
import 'package:go_router/go_router.dart';

class HomePage extends ConsumerWidget {
  final StatefulNavigationShell navigationShell;
  const HomePage({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int currentIndex = navigationShell.currentIndex;
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: AppColors.gradient02,
        ),
        child: Icon(Icons.add, color: Colors.white),
      ),
      body: navigationShell,

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,

        showSelectedLabels: false,
        showUnselectedLabels: false,

        backgroundColor: AppColors.neutralsWhite,
        selectedItemColor: AppColors.primaryBrand,
        unselectedItemColor: AppColors.neutralsGrey1,

        onTap: (index) {
          navigationShell.goBranch(index);
        },
        items: [
          // ignore: deprecated_member_use
          BottomNavigationBarItem(
            label: "dashboard",
            icon: Icon(CupertinoIcons.house_fill),
          ),
          BottomNavigationBarItem(
            label: "savings",
            icon: Icon(CupertinoIcons.doc_text),
          ),
          BottomNavigationBarItem(
            label: "reminders",
            icon: Icon(CupertinoIcons.bell_fill),
          ),
          BottomNavigationBarItem(
            label: "notifications",
            icon: Icon(CupertinoIcons.gear_alt_fill),
          ),
        ],
      ),
    );
  }
}
