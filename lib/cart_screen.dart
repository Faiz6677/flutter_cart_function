import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'cart_model.dart';
import 'cart_provider.dart';
import 'db_helper.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    DBHelper? dbHelper = DBHelper();
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product List'),
        centerTitle: true,
        actions: [
          Padding(
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
        ],
      ),
      body: Column(
        children: [
          FutureBuilder(
              future: cart.getData(),
              builder: (context, AsyncSnapshot<List<Cart>> snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!.isEmpty) {
                    return Expanded(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.shopping_cart_outlined,
                                size: 200,
                                color: Colors.green.shade300,
                              ),
                              Text(
                                'cart is empty',
                                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                                  color: Colors.green.shade300,
                                ),
                              )
                            ],
                          ),
                        ));
                  } else {
                    return Expanded(
                        child: ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              return Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      IconButton(
                                          style: IconButton.styleFrom(),
                                          onPressed: () {
                                            dbHelper!.delete(
                                                snapshot.data![index].id!);
                                            cart.removerCounter();
                                            cart.removeTotalPrice(
                                                double.parse(
                                                    snapshot.data![index].productPrice.toString()));
                                          },
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Colors.green,
                                          )),
                                      Row(
                                        children: [
                                          //productImage
                                          Container(
                                            padding: const EdgeInsets.all(5),
                                            margin: const EdgeInsets.all(5),
                                            height: 100,
                                            width: 100,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                BorderRadius.circular(10.0),
                                                color: Colors.grey.shade300,
                                                image: DecorationImage(
                                                    image: NetworkImage(snapshot
                                                        .data![index].image
                                                        .toString()),
                                                    fit: BoxFit.cover)),
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  snapshot.data![index].productName.toString(),
                                                  overflow: TextOverflow.fade,
                                                  style: Theme.of(context).textTheme.titleLarge,
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  '${snapshot.data![index].unitTag} ${snapshot.data![index].productPrice}',
                                                  style: Theme.of(context).textTheme.titleMedium!
                                                      .copyWith(
                                                      fontWeight: FontWeight.normal),
                                                )
                                              ],
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: Container(
                                              height: 35,
                                              width: 100,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                BorderRadius.circular(5),
                                                color: Colors.green,
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .spaceBetween,
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      int quantity = snapshot.data![index].quantity!;
                                                      int price = snapshot.data![index].initialPrice!;
                                                      quantity--;
                                                      int? newPrice = price * quantity;
                                                      if (quantity > 0) {
                                                        dbHelper.updateQuantity(
                                                            Cart(
                                                                id: snapshot.data![index].id!,
                                                                productId: snapshot.data![index].id!.toString(),
                                                                productName: snapshot.data![index].productName!,
                                                                initialPrice: snapshot.data![index].initialPrice!,
                                                                productPrice: newPrice,
                                                                quantity: quantity,
                                                                unitTag: snapshot.data![index].unitTag!.toString(),
                                                                image: snapshot.data![index].image!.toString())).then((value) {
                                                          newPrice = 0;
                                                          quantity = 0;
                                                          cart.removeTotalPrice(
                                                              double.parse(snapshot.data![index].initialPrice.toString()));
                                                        }).onError((error,
                                                            stackTrace) {});
                                                      }
                                                    },
                                                    child: const Icon(
                                                      Icons.remove,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  Text(
                                                    snapshot.data![index].quantity.toString(),
                                                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      int quantity = snapshot.data![index].quantity!;
                                                      int price = snapshot.data![index].initialPrice!;
                                                      quantity++;
                                                      int? newPrice = price * quantity;
                                                      dbHelper.updateQuantity(
                                                          Cart(
                                                              id: snapshot.data![index].id!,
                                                              productId: snapshot.data![index].id!.toString(),
                                                              productName: snapshot.data![index].productName!,
                                                              initialPrice: snapshot.data![index].initialPrice!,
                                                              productPrice: newPrice,
                                                              quantity: quantity,
                                                              unitTag: snapshot.data![index].unitTag!.toString(),
                                                              image: snapshot.data![index].image!.toString())).then((value) {
                                                        newPrice = 0;
                                                        quantity = 0;
                                                        cart.addTotalPrice(
                                                            double.parse(
                                                                snapshot.data![index].initialPrice.toString()));
                                                      }).onError((error,
                                                          stackTrace) {});
                                                    },
                                                    child: const Icon(
                                                      Icons.add,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ));
                            }));
                  }
                } else {
                  return const Text('cart is empty');
                }
              }),
          Consumer<CartProvider>(builder: (context, value, child) {
            return Visibility(
              visible: value.getTotalPrice().toStringAsFixed(2) == "0.00" ? false : true,
              child: Column(
                children: [
                  ReusableWidget(
                      title: 'sub total',
                      value: '\$${value.getTotalPrice().toStringAsFixed(2)}'),
                  const ReusableWidget(title: 'Discount 5%', value: r'$' '20'),
                  ReusableWidget(
                      title: 'total',
                      value: '\$${value.getTotalPrice().toStringAsFixed(2)}'),
                ],
              ),
            );
          })
        ],
      ),
    );
  }
}

class ReusableWidget extends StatelessWidget {
  final String title, value;

  const ReusableWidget({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(fontWeight: FontWeight.normal),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ],
      ),
    );
  }
}
