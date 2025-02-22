import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mihfadati/screens/document_page.dart';
import 'package:mihfadati/screens/emergency_screen.dart';
import 'package:mihfadati/screens/home_screen.dart';
import 'package:mihfadati/screens/transport_screen.dart';
import '../cubit/bottom_navigation_cubit.dart';

class HomeScreen extends StatelessWidget {
  final List<Widget> _pages = [
    MainHomeScreen(),
    DocumentsPage(),
    TransportScreen(),
    EmergencyScreen(),
  ];

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<BottomNavigationCubit, int>(
        builder: (context, state) {
          return _pages[state];
        },
      ),
      bottomNavigationBar: BlocBuilder<BottomNavigationCubit, int>(
        builder: (context, state) {
          return BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: state,
            onTap: (index) {
              context.read<BottomNavigationCubit>().changeTab(index);
            },
            selectedItemColor: Colors.black,
            unselectedItemColor: Colors.grey,
            items: [
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.home_outlined,
                  color: state == 0 ? Colors.black : Colors.grey,
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.file_open_outlined,
                  color: state == 1 ? Colors.black : Colors.grey,
                ),
                label: 'Documents',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.maps_ugc_outlined,
                  color: state == 2 ? Colors.black : Colors.grey,
                ),
                label: 'Transport',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.emergency_outlined,
                  color: state == 3 ? Colors.black : Colors.grey,
                ),
                label: 'Emergency',
              ),
            ],
          );
        },
      ),
    );
  }
}
