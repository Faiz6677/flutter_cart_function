import 'package:flutter/material.dart';
import 'package:flutter_cart_function/product_list_cart.dart';
import 'package:provider/provider.dart';

import 'cart_provider.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CartProvider(),
      child: Builder(builder: (BuildContext context) {
        return MaterialApp(
          theme: ThemeData(primarySwatch: Colors.lightGreen),
          debugShowCheckedModeBanner: false,
          title: 'add to cart',
          home: const ProductListScreen(),
        );
      }),
    );
  }
}
