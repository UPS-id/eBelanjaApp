import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mysample/pages/cart_screen.dart';
import 'package:mysample/pages/home_screen.dart';
import 'package:mysample/pages/mall_screen.dart';
import 'package:mysample/pages/feeds_screen.dart';
import 'package:mysample/pages/profile_screen.dart';
import 'package:mysample/pages/login_screen.dart';
import 'package:mysample/pages/register_screen.dart';
import 'package:mysample/pages/splash_screen.dart';
import 'package:mysample/pages/transaction_screen.dart';

/// Flutter code sample for [NavigationBar].

void main() => runApp(const NavigationBarApp());

class NavigationBarApp extends StatelessWidget {
  const NavigationBarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      initialRoute: '/splash',
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/home': (context) => const NavigationExample(),
        '/splash': (context) => const SplashScreen(),
        '/cart': (context) => const CartScreen(),
      },
    );
  }
}

class NavigationExample extends StatefulWidget {
  const NavigationExample({super.key});

  @override
  State<NavigationExample> createState() => _NavigationExampleState();
}

class _NavigationExampleState extends State<NavigationExample> {
  int currentPageIndex = 0;

  List<Widget> get pages => [
    // halaman yang tampil
    HomeScreen(),
    FeedsScreen(),
    MallScreen(),
    TransactionScreen(),
    ProfileScreen(),
  ];

  //konfirmasi navbar tampil atau tidak
  bool _showNavBar = true;

  void _handleScroll(ScrollNotification notification) {
    // jika scroll ke bawah, sembunyikan navbar
    if (notification is UserScrollNotification) {
      if (notification.direction == ScrollDirection.reverse) {
        setState(() {
          _showNavBar = false;
        });
      } else if (notification.direction == ScrollDirection.forward) {
        setState(() {
          _showNavBar = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // menampilkan halaman sesuai index
          NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              _handleScroll(notification);
              return false;
            },
            child: pages[currentPageIndex],
          ),
          //set posisi dan menampilkan navigation bar
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.fastOutSlowIn,
            left: 10,
            right: 10,
            bottom: _showNavBar ? 12 : -100,
            child: _navBar(),
          ),
        ],
      ),
    );
  }

  Widget _navBar() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(25)),
      ),
      clipBehavior: Clip.antiAlias,

      child: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Colors.indigo,

        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home, color: Colors.white),
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.feed, color: Colors.white),
            icon: Icon(Icons.feed),
            label: 'Feeds',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.local_mall, color: Colors.white),
            icon: Badge(label: Text('2'), child: Icon(Icons.local_mall)),
            label: 'Mall',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.wallet, color: Colors.white),
            icon: Badge(label: Text('2'), child: Icon(Icons.wallet)),
            label: 'Transaction',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.person, color: Colors.white),
            icon: Badge(label: Text('2'), child: Icon(Icons.person)),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
