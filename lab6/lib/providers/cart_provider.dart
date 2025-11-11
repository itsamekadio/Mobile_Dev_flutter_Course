import 'package:flutter/foundation.dart';
import '../models/cart_item.dart';

class CartProvider extends ChangeNotifier {
  // Private map to store cart items by product ID.
  // This ensures each product ID is unique in the cart.
  final Map<String, CartItem> _items = {};

  // Getter to provide an unmodifiable view of the items.
  Map<String, CartItem> get items => Map.unmodifiable(_items);

  // Getter for the total count of individual items (sum of quantities).
  int get itemCount =>
      _items.values.fold(0, (sum, item) => sum + item.quantity);

  // Getter for the subtotal before any discounts.
  double get subtotal => _items.values.fold(
        0,
        (sum, item) => sum + item.lineTotal,
      );

  // Method to add an item to the cart.
  void addItem({
    required String productId,
    required String title,
    required double price,
  }) {
    if (_items.containsKey(productId)) {
      // If item exists, increment quantity.
      _items.update(
        productId,
        (existingItem) => CartItem(
          id: existingItem.id,
          title: existingItem.title,
          price: existingItem.price,
          quantity: existingItem.quantity + 1,
        ),
      );
    } else {
      // If item is new, add it with quantity 1.
      _items.putIfAbsent(
        productId,
        () => CartItem(id: productId, title: title, price: price, quantity: 1),
      );
    }
    // Notify all listeners that the state has changed.
    notifyListeners();
  }

  // Method to decrease the quantity of an item by one.
  // Removes the item if quantity becomes zero.
  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) return; // Item not in cart.

    final item = _items[productId]!;
    if (item.quantity > 1) {
      // If more than one, just decrease quantity.
      _items.update(
        productId,
        (existingItem) => CartItem(
          id: existingItem.id,
          title: existingItem.title,
          price: existingItem.price,
          quantity: existingItem.quantity - 1,
        ),
      );
    } else {
      // If quantity is 1, remove the item from the map.
      _items.remove(productId);
    }
    notifyListeners(); // Notify listeners of the change.
  }

  // Method to remove an item completely from the cart, regardless of quantity.
  void removeItemCompletely(String productId) {
    // The remove method returns the removed value, or null if not found.
    // We only notify if an item was actually removed.
    if (_items.remove(productId) != null) {
      notifyListeners(); // Notify listeners.
    }
  }

  // Method to clear all items from the cart.
  void clearCart() {
    _items.clear(); // Empty the internal map.
    notifyListeners(); // Notify listeners.
  }

  // Calculates the discount amount based on a threshold and rate.
  double discountAmount(double threshold, double discountRate) {
    // Only apply discount if subtotal meets or exceeds the threshold.
    if (subtotal >= threshold) {
      return subtotal * discountRate;
    }
    return 0; // No discount if threshold not met.
  }

  // Calculates the final total price, applying the discount if applicable.
  double totalWithDiscount({
    required double threshold,
    required double discountRate,
  }) {
    final discount = discountAmount(threshold, discountRate);
    return subtotal - discount; // Subtotal minus calculated discount.
  }
}