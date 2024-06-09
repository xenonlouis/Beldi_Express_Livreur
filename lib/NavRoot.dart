
import 'package:dish_list/pages/CommandAvailablePage.dart';
import 'package:dish_list/pages/CommandpendingPage.dart';
import 'package:dish_list/pages/CommandshippedPage.dart';
import 'package:dish_list/pages/UserInfoPage.dart';
import 'package:dish_list/services/FirebaseServices.dart';
import 'package:dish_list/services/FirestoreService.dart';
import 'package:flutter/material.dart';


class NavRoot extends StatefulWidget {
  const NavRoot({super.key});

  @override
  _NavRootState createState() => _NavRootState();
}

class _NavRootState extends State<NavRoot> {
  final PageController _pageController = PageController();
  final FirebaseServices _firebaseServices = FirebaseServices();
    final FirestoreService _firestoreService = FirestoreService();
  int _currentIndex = 0;

  List titles = [
    "Available commands",
    "Pending Commands",
    "Shipped Commands",
    "User Information"
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(titles[_currentIndex]),
        actions: [
          IconButton(
            onPressed: () => _firebaseServices.signOut(),
            icon: const Icon(Icons.logout),
          ),
        ],
        backgroundColor: Colors.blueGrey,
      ),
      body: PageView(
        controller: _pageController,
        children: [
          CommandAvailablePage(firestoreService: _firestoreService),
          CommandpendingPage(firestoreService: _firestoreService),
          CommandshippedPage(firestoreService: _firestoreService),
          UserInfoPage(firestoreService: _firestoreService),
        ],
        onPageChanged: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
          _pageController.jumpToPage(index);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle),
            label: 'Availabe',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.access_time_filled),
            label: 'Pending',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle_rounded),
            label: 'Acomplished',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'Info',
          )
        ],
      ),
    );
  }
}
