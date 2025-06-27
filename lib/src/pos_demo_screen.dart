import 'package:flutter/material.dart';
import 'package:mini_pos/src/cart/view/cart_section_view.dart';
import 'package:mini_pos/src/catalog/view/catalog_section_view.dart';

/// Demo screen showcasing the Mini-POS checkout functionality
class PosDemoScreen extends StatelessWidget {
  const PosDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mini POS Demo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: const Row(
        children: [
          // Left side - Catalog
          Expanded(
            flex: 2,
            child: CatalogSection(),
          ),
          // Right side - Cart
          Expanded(
            flex: 1,
            child: CartSection(),
          ),
        ],
      ),
    );
  }
}
