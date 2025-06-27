import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_pos/core/extentions/money_extenstions.dart';
import 'package:mini_pos/src/cart/bloc/cart_bloc.dart';
import 'package:mini_pos/src/cart/bloc/cart_events.dart';
import 'package:mini_pos/src/cart/bloc/cart_states.dart';
import 'package:mini_pos/src/catalog/model/item_model.dart';

/// Widget for individual catalog items
class ItemCard extends StatelessWidget {
  const ItemCard({super.key, required this.item});

  final Item item;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is! CartLoaded) return const SizedBox.shrink();

          return InkWell(
            onTap: () {
              final messenger = ScaffoldMessenger.of(context);
              messenger.hideCurrentSnackBar();
              context.read<CartBloc>().add(AddItem(item));
              messenger.showSnackBar(
                SnackBar(
                  content: Text('${item.name} added to cart'),
                  duration: Duration(seconds: 5),
                  action: SnackBarAction(
                      label: "Undo",
                      onPressed: () {
                        context.read<CartBloc>().add(const UndoAction());
                      }),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    item.emoji,
                    style: const TextStyle(fontSize: 32),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item.name,
                    style: Theme.of(context).textTheme.titleSmall,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'L.E ${item.price.asMoney}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                  if (item.category.isNotEmpty)
                    Text(
                      item.category,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
