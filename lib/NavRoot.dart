
import 'package:flutter/material.dart';

import 'Pages/Cart_Page.dart';
import 'Pages/CommandsPage.dart';
import 'Pages/HomeScreen.dart';
import 'Pages/ProfilePage.dart';
import 'Pages/search_page.dart';

class NavRoot extends StatefulWidget {
  const NavRoot({super.key});

  @override
  _NavRootState createState() => _NavRootState();
}

class _NavRootState extends State<NavRoot> {
  final PageController _pageController = PageController();

  int _currentIndex = 0;

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
      body: PageView(
        controller: _pageController,
        children:  [HomeScreen(), SearchPage(), CommandsPage(),ProfilePage()],
        onPageChanged: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        fixedColor: Color.fromARGB(200, 0, 98, 51),
        backgroundColor: Colors.white,
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
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle_rounded),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'Account',
          )
        ],
      ),
    );
  }
}
