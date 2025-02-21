import 'package:cached_network_image/cached_network_image.dart';
import 'package:curve/services/cart_provider.dart';
import 'package:curve/services/colors_provider.dart';
import 'package:curve/routes/learn_details.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Gift extends StatelessWidget {
  const Gift({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Gifts"),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Stack(
              children: [
                IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (ctx) => CartDisplay(),
                    ),
                  ),
                  icon: Icon(CupertinoIcons.bag, size: 28),
                ),
                Consumer<CartProvider>(builder: (context, cart, _) {
                  return cart.itemsCart.isEmpty
                      ? const SizedBox.shrink()
                      : Positioned(
                          right: 2,
                          bottom: 2,
                          child: CircleAvatar(
                            radius: 10,
                            child: Center(
                              child: Text(
                                cart.itemsCart.length.toString(),
                                style: Theme.of(context).textTheme.labelSmall,
                              ),
                            ),
                          ),
                        );
                })
              ],
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer2<CartProvider, ColorsProvider>(
            builder: (context, cart, colorPro, _) {
          return ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (ctx, i) {
                final item = cart.items[i];
                bool itemPresent = cart.serchItem(item);
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical:  8.0),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.25,
                    decoration: BoxDecoration(
                      color: colorPro.placeHolders(),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height * 0.8,
                            width: MediaQuery.of(context).size.width * 0.4,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                image: DecorationImage(
                                  image: CachedNetworkImageProvider(
                                    item.productImg,
                                  ),
                                  fit: BoxFit.cover,
                                )),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.name,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall),
                                Text(item.price.toString(),
                                    style:
                                        Theme.of(context).textTheme.bodyLarge),
                                !itemPresent
                                    ? OutlinedButton(
                                        onPressed: () {
                                          cart.addItems(item);
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content:
                                                  Text('Item Added to Cart'),
                                              duration: Duration(
                                                  milliseconds:
                                                      50), // Snackbar duration
                                            ),
                                          );
                                        },
                                        child: Text('Add to cart'))
                                    : TextButton(
                                        onPressed: () {
                                          cart.removeItem(item);
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                  'Item Removed from Cart'),
                                              duration: Duration(
                                                  milliseconds:
                                                      50), // Snackbar duration
                                            ),
                                          );
                                        },
                                        child: Text("Reomve from cart")),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              });
        }),
      ),
    );
  }
}
