import 'package:flutter/cupertino.dart';

class CartProvider extends ChangeNotifier {
  List<Item> itemsCart = [];
  List<Item> items = [
    Item(
      name: "Holiday Gift Basket",
      price: 80.00,
      productImg:
          "https://images.pexels.com/photos/27393960/pexels-photo-27393960/free-photo-of-present-basket-with-a-ribbon-champagne-and-chocolate-sweets-on-a-dark-background.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
    ),
    Item(
      name: "Luxury Gift Set",
      price: 150.00,
      productImg:
          "https://images.pexels.com/photos/6832992/pexels-photo-6832992.jpeg?auto=compress&cs=tinysrgb&w=600",
    ),
    Item(
      name: "Birthday Gift Box",
      price: 40.00,
      productImg:
          "https://images.pexels.com/photos/931176/pexels-photo-931176.jpeg?auto=compress&cs=tinysrgb&w=600",
    ),
    Item(
      name: "Wedding Gift Set",
      price: 200.00,
      productImg:
          "https://images.pexels.com/photos/11952736/pexels-photo-11952736.jpeg?auto=compress&cs=tinysrgb&w=600",
    ),
    Item(
      name: "Anniversary Gift Box",
      price: 120.00,
      productImg:
          "https://images.pexels.com/photos/1927260/pexels-photo-1927260.jpeg?auto=compress&cs=tinysrgb&w=600",
    ),
    Item(
      name: "Valentine's Day Gift Set",
      price: 90.00,
      productImg:
          "https://images.pexels.com/photos/20192810/pexels-photo-20192810/free-photo-of-miniature-pink-car.jpeg?auto=compress&cs=tinysrgb&w=600",
    ),
    Item(
      name: "Mother's Day Gift Box",
      price: 70.00,
      productImg:
          "https://images.pexels.com/photos/7763944/pexels-photo-7763944.jpeg?auto=compress&cs=tinysrgb&w=600",
    ),
  ];

  void addItems(Item item) {
    itemsCart.add(item);
    notifyListeners();
  }

  bool serchItem(Item item) {
    return itemsCart.contains(item);
  }

  void removeItem(Item item) {
    itemsCart.remove(item);
    notifyListeners();
  }
}

class Item {
  final String name;
  final num price;
  final String productImg;

  Item({required this.name, required this.price, required this.productImg});
}
