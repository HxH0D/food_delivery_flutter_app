import 'package:flutter/material.dart';
import 'package:food_delivery_flutter_app/cubits/detail_cubit.dart';
import 'package:food_delivery_flutter_app/cubits/home_cubit.dart';
import 'package:food_delivery_flutter_app/cubits/order_cubit.dart';
import 'package:food_delivery_flutter_app/cubits/sign_in_cubit.dart';
import 'package:food_delivery_flutter_app/cubits/sign_up_cubit.dart';
import 'package:food_delivery_flutter_app/screens/home_navigation.dart';
import 'package:food_delivery_flutter_app/screens/home_screen.dart';
import 'package:food_delivery_flutter_app/screens/sign_up_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_delivery_flutter_app/utils/shared_preferences_util.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await SharedPreferencesUtil.init();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => SignInCubit(),),
        BlocProvider(create: (context) => SignUpCubit(),),
        BlocProvider(create: (context) => HomeCubit(),),
        BlocProvider(create: (context) => OrderCubit(),),
        BlocProvider(create: (context) => DetailCubit(),),

      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: SharedPreferencesUtil.getLogin() ?  HomeNavigation() :SignUpScreen(),
      ),
    );
  }
}
