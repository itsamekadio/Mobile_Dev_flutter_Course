class CartItem {
  CartItem({
    required this.id,
    required this.title,
    required this.price,
    this.quantity = 1,
  });

  final String id;
  final String title;
  final double price;
  int quantity;

  double get lineTotal => price * quantity;
}