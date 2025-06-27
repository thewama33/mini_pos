
// States
import 'package:equatable/equatable.dart';
import 'package:mini_pos/src/catalog/model/item_model.dart';

/// Base class for catalog states
abstract class CatalogState extends Equatable {
  const CatalogState();

  @override
  List<Object?> get props => [];
}

/// Initial state of the catalog
class CatalogInitial extends CatalogState {
  const CatalogInitial();
}

/// State when catalog is being loaded
class CatalogLoading extends CatalogState {
  const CatalogLoading();
}

/// State when catalog is successfully loaded
class CatalogLoaded extends CatalogState {
  /// Creates a loaded state with the given [items]
  const CatalogLoaded(this.items);

  /// List of catalog items
  final List<Item> items;

  @override
  List<Object?> get props => [items];
}

/// State when catalog loading fails
class CatalogError extends CatalogState {
  /// Creates an error state with the given [message]
  const CatalogError(this.message);

  /// Error message
  final String message;

  @override
  List<Object?> get props => [message];
}
