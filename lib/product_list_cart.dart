import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'cart_model.dart';
import 'cart_provider.dart';
import 'cart_screen.dart';
import 'db_helper.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({Key? key}) : super(key: key);

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  List<String> productName = [
    'Mango',
    'Orange',
    'Grapes',
    'Banana',
    'Chery',
    'Peach',
    'Mixed Fruit Basket',
  ];

  List<String> productUnit = [
    'KG',
    'Dozen',
    'KG',
    'Dozen',
    'KG',
    'KG',
    'KG',
  ];

  List<int> productPrice = [10, 20, 30, 40, 50, 60, 70];

  List<String> productImage = [
    'https://image.shutterstock.com/image-photo/mango-isolated-on-white-background-600w-610892249.jpg',
    'https://image.shutterstock.com/image-photo/orange-fruit-slices-leaves-isolated-600w-1386912362.jpg',
    'https://image.shutterstock.com/image-photo/green-grape-leaves-isolated-on-600w-533487490.jpg',
    'https://media.istockphoto.com/photos/banana-picture-id1184345169?s=612x612',
    'https://media.istockphoto.com/photos/cherry-trio-with-stem-and-leaf-picture-id157428769?s=612x612',
    'https://media.istockphoto.com/photos/single-whole-peach-fruit-with-leaf-and-slice-isolated-on-white-picture-id1151868959?s=612x612',
    'https://media.istockphoto.com/photos/fruit-background-picture-id529664572?s=612x612',
  ];

  DBHelper? dbHelper = DBHelper();

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product List'),
        centerTitle: true,
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context){
                return const CartScreen();
              }));
            },
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Badge(
                label: Consumer<CartProvider>(
                  builder: (context, value, child) {
                    return Text(
                      value.getCounter().toString(),
                      style: Theme.of(context).textTheme.titleMedium,
                    );
                  },
                ),
                largeSize: 18.0,
                textColor: Colors.white,
                backgroundColor: Colors.red,
                child: const Icon(
                  Icons.shopping_bag_outlined,
                  size: 30,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(8.0),
        color: Colors.white,
        height: double.infinity,
        width: double.infinity,
        child: ListView.builder(
            itemCount: productName.length,
            itemBuilder: (context, index) {
              return Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          //productImage
                          Container(
                            padding: const EdgeInsets.all(5),
                            margin: const EdgeInsets.all(5),
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Colors.grey.shade300,
                                image: DecorationImage(
                                    image: NetworkImage(productImage[index]),
                                    fit: BoxFit.cover)),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  productName[index],
                                  overflow: TextOverflow.fade,
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  '${productUnit[index]} ${productPrice[index]}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(fontWeight: FontWeight.normal),
                                )
                              ],
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        side: const BorderSide(
                                            color: Colors.greenAccent,
                                            width: 1,
                                            style: BorderStyle.solid,
                                            strokeAlign:
                                            BorderSide.strokeAlignInside))),
                                onPressed: () {
                                  dbHelper!
                                      .insert(Cart(
                                      id: index,
                                      productId: index.toString(),
                                      productName:
                                      productName[index].toString(),
                                      initialPrice: productPrice[index],
                                      productPrice: productPrice[index],
                                      quantity: 1,
                                      unitTag:
                                      productUnit[index].toString(),
                                      image:
                                      productImage[index].toString()))
                                      .then((value) {
                                    cart.addTotalPrice(double.parse(
                                        productPrice[index].toString()));
                                    cart.addCounter();
                                  }).onError((error, stackTrace) {
                                  });
                                },
                                child: const Text('Add to cart')),
                          ),
                        ],
                      ),

                    ],
                  ));
            }),
      ),
    );
  }
}


