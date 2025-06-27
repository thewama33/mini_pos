// Events
import 'package:equatable/equatable.dart';

/// Base class for catalog events
abstract class CatalogEvent extends Equatable {
  const CatalogEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load the catalog from assets
class LoadCatalog extends CatalogEvent {
  const LoadCatalog();
}
