import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_pos/src/catalog/bloc/catalog_bloc.dart';
import 'package:mini_pos/src/catalog/bloc/catalog_states.dart';
import 'package:mini_pos/src/catalog/view/components/item_card.dart';

/// Widget displaying the product catalog
class CatalogSection extends StatelessWidget {
  const CatalogSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(color: Theme.of(context).dividerColor),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Catalog',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: BlocBuilder<CatalogBloc, CatalogState>(
              builder: (context, state) {
                if (state is CatalogLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is CatalogError) {
                  return Center(
                    child: Text(
                      state.message,
                      style:
                          TextStyle(color: Theme.of(context).colorScheme.error),
                    ),
                  );
                } else if (state is CatalogLoaded) {
                  return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 0.8,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: state.items.length,
                    itemBuilder: (context, index) {
                      final item = state.items[index];
                      return ItemCard(item: item);
                    },
                  );
                }
                return const Center(child: Text('No catalog loaded'));
              },
            ),
          ),
        ],
      ),
    );
  }
}
