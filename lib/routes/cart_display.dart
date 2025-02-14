import 'package:curve/api/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class CartDisplay extends StatelessWidget {
  const CartDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cart"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<CartProvider>(builder: (context, cart, _) {
          num subTotal = cart.itemsCart.isEmpty
              ? 0
              : cart.itemsCart
                  .map((item) => item.price) // Extract prices from the items
                  .reduce((value, element) => value + element);
          num total = cart.itemsCart.isEmpty ? 0 : subTotal + 10;
          return cart.itemsCart.isEmpty
              ? Center(
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    LottieBuilder.asset("assets/animation/empty_cart.json"),
                    const Text(
                      'Your Cart is Empty',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ))
              : Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Order Details Section
                    const Text(
                      'Order Details',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const Divider(height: 30, thickness: 5),
                    Expanded(
                      child: ListView.separated(
                        separatorBuilder: (context, i) {
                          return Divider();
                        },
                        itemBuilder: (ctx, i) {
                          final Item item = cart.itemsCart[i];
                          return Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Item:', style: TextStyle(fontSize: 16)),
                                  Text(item.name,
                                      style: TextStyle(fontSize: 16)),
                                ],
                              ),
                              // Row(
                              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //   children: const [
                              //     Text('Quantity:', style: TextStyle(fontSize: 16)),
                              //     Text(, style: TextStyle(fontSize: 16)),
                              //   ],
                              // ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Price:',
                                      style: TextStyle(fontSize: 16)),
                                  Text('\$${item.price}',
                                      style: TextStyle(fontSize: 16)),
                                ],
                              ),
                            ],
                          );
                        },
                        itemCount: cart.itemsCart.length,
                      ),
                    ),
                    const Divider(height: 30, thickness: 5),
                    // Order Summary Section
                    const Text(
                      'Order Summary',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Subtotal:', style: TextStyle(fontSize: 16)),
                        Text('\$$subTotal', style: TextStyle(fontSize: 16)),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text('Tax (5%):', style: TextStyle(fontSize: 16)),
                        Text('\$10', style: TextStyle(fontSize: 16)),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total:',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        Text('\$$total',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const Spacer(),

                    SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: OutlinedButton(
                          onPressed: () {
                            // Add place order logic here
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Order Placed'),
                                  content: const Text(
                                      'Your order has been successfully placed!'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('OK'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: const Text(
                              'Place Order',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
        }),
      ),
    );
  }
}
