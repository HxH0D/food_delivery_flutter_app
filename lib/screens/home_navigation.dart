import 'package:flutter/material.dart';
import 'package:food_delivery_flutter_app/cubits/home_cubit.dart';
import 'package:food_delivery_flutter_app/screens/detail_screen.dart';
import 'package:food_delivery_flutter_app/screens/favorite_screen.dart';
import 'package:food_delivery_flutter_app/screens/home_screen.dart';
import 'package:food_delivery_flutter_app/screens/order_details_screen.dart';
import 'package:food_delivery_flutter_app/utils/colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeNavigation extends StatefulWidget {
  const HomeNavigation({Key? key}) : super(key: key);

  @override
  State<HomeNavigation> createState() => _HomeNavigationState();
}

class _HomeNavigationState extends State<HomeNavigation> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(key: UniqueKey()),
    FavoriteScreen(key: UniqueKey()),
  ];

  void _onItemTapped(int index) {

      setState(() {
        _selectedIndex = index;
      });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.shopping_cart),

        onPressed: (){
          Navigator.push(
              context,
              MaterialPageRoute(
              builder: (context) => OrderDetailsScreen(),
          ));
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorite',
            backgroundColor: primaryColor,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        backgroundColor: primaryColor,
      ),

    );
  }
}
