import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // The 'watch' here means this entire widget tree will rebuild
    // whenever CartProvider calls notifyListeners().
    final cart = context.watch<CartProvider>();

    // Mock products for display in the product list.
    final mockProducts = [
      {'id': 'p1', 'title': 'Wireless Headphones', 'price': 59.99},
      {'id': 'p2', 'title': 'Smart Watch', 'price': 129.50},
      {'id': 'p3', 'title': 'Portable Charger', 'price': 24.00},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Provider Cart Demo'),
      ),
      body: Column(
        children: [
          // Product List Area
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: mockProducts.map((product) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    title: Text(product['title'] as String),
                    subtitle: Text('\$${(product['price'] as double).toStringAsFixed(2)}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.add_shopping_cart),
                      // Using 'read' here because we only want to call a method
                      // and don't need this specific ListTile to rebuild when
                      // the cart state changes elsewhere.
                      onPressed: () {
                        context.read<CartProvider>().addItem(
                          productId: product['id'] as String,
                          title: product['title'] as String,
                          price: product['price'] as double,
                        );
                        // Provide user feedback for adding an item.
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${product['title']} added to cart'),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          // Cart Summary Area
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceVariant,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Dynamically display cart items or an empty message
                if (cart.items.isEmpty)
                  const Text('Your cart is feeling light. Add something!')
                else
                  ...cart.items.values.map((item) {
                    return ListTile(
                      contentPadding: EdgeInsets.zero, // Remove default padding for tighter layout
                      title: Text(item.title),
                      subtitle: Text('Quantity: ${item.quantity}'),
                      trailing: Wrap( // Use Wrap to keep buttons on the same line if space allows
                        spacing: 4, // Space between buttons
                        children: [
                          // Button to decrease quantity by one
                          IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: () => context.read<CartProvider>().removeSingleItem(item.id),
                          ),
                          // Button to remove the item completely
                          IconButton(
                            icon: const Icon(Icons.delete_outline),
                            onPressed: () => context.read<CartProvider>().removeItemCompletely(item.id),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                const SizedBox(height: 12),
                // Display Subtotal
                Text('Subtotal: \$${cart.subtotal.toStringAsFixed(2)}'),
                const SizedBox(height: 4),
                // Display Discount and Total
                Builder( // Builder is used here to get a new BuildContext
                  builder: (context) {
                    // Define discount parameters
                    const double discountThreshold = 150.0;
                    const double discountRate = 0.10; // 10%

                    final double discount = cart.discountAmount(discountThreshold, discountRate);
                    final double total = cart.totalWithDiscount(
                      threshold: discountThreshold,
                      discountRate: discountRate,
                    );

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Show discount message or how much more to spend
                        Text(
                          discount > 0
                              ? 'Discount (10% off orders \$150+): -\$${discount.toStringAsFixed(2)}'
                              : 'Spend \$${(discountThreshold - cart.subtotal).clamp(0, discountThreshold).toStringAsFixed(2)} more for 10% off',
                        ),
                        const SizedBox(height: 4),
                        // Display the final total price
                        Text(
                          'Total: \$${total.toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 12),
                // Clear Cart Button
                FilledButton(
                  // Disable button if the cart is empty for better UX.
                  onPressed: cart.items.isEmpty
                      ? null
                      : () {
                          // Call the clearCart method via context.read.
                          context.read<CartProvider>().clearCart();
                          // Provide user feedback.
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Cart cleared'),
                              duration: Duration(seconds: 1),
                            ),
                          );
                        },
                  child: const Text('Clear Cart'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}