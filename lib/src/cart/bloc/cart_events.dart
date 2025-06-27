// Events
import 'package:equatable/equatable.dart';
import 'package:mini_pos/src/catalog/model/item_model.dart';
import 'package:replay_bloc/replay_bloc.dart';

/// Base class for cart events
sealed class CartEvent extends Equatable implements ReplayEvent {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

/// Event to add an item to the cart
class AddItem extends CartEvent {
  /// Creates an AddItem event for the given [item]
  const AddItem(this.item);

  /// The item to add
  final Item item;

  @override
  List<Object?> get props => [item];
}

/// Event to remove an item from the cart
class RemoveItem extends CartEvent {
  /// Creates a RemoveItem event for the given [itemId]
  const RemoveItem(this.itemId);

  /// ID of the item to remove
  final String itemId;

  @override
  List<Object?> get props => [itemId];
}

/// Event to change the quantity of an item
class ChangeQty extends CartEvent {
  /// Creates a ChangeQty event for the given [itemId] and [newQuantity]
  const ChangeQty(this.itemId, this.newQuantity);

  /// ID of the item to update
  final String itemId;

  /// New quantity for the item
  final int newQuantity;

  @override
  List<Object?> get props => [itemId, newQuantity];
}

/// Event to change the discount of an item
class ChangeDiscount extends CartEvent {
  /// Creates a ChangeDiscount event for the given [itemId] and [newDiscount]
  const ChangeDiscount(this.itemId, this.newDiscount);

  /// ID of the item to update
  final String itemId;

  /// New discount percentage (0.0 to 1.0)
  final double newDiscount;

  @override
  List<Object?> get props => [itemId, newDiscount];
}

/// Event to clear the entire cart
class ClearCart extends CartEvent {
  /// Creates a ClearCart event
  const ClearCart();
}

/// Event to undo the last cart action
class UndoAction extends CartEvent {
  /// Creates an UndoAction event
  const UndoAction();
}

/// Event to redo the last undone cart action
class RedoAction extends CartEvent {
  /// Creates a RedoAction event
  const RedoAction();
}
