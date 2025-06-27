import 'package:equatable/equatable.dart';

/// Represents a product item in the catalog
class Item extends Equatable {
  /// Creates an [Item] with the given properties
  const Item({
    required this.id,
    required this.name,
    required this.price,
    this.category = '',
    this.emoji = '📦',
  });

  /// Unique identifier for the item
  final String id;

  /// Display name of the item
  final String name;

  /// Price of the item in currency units
  final double price;

  /// Category of the item (optional)
  final String category;

  /// Emoji representation of the item (optional)
  final String emoji;

  /// Creates an [Item] from JSON data
  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      category: json['category'] as String? ?? '',
      emoji: json['emoji'] as String? ?? '📦',
    );
  }

  /// Converts the [Item] to JSON format
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'category': category,
      'emoji': emoji,
    };
  }

  /// Creates a copy of this [Item] with optionally modified properties
  Item copyWith({
    String? id,
    String? name,
    double? price,
    String? category,
    String? emoji,
  }) {
    return Item(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      category: category ?? this.category,
      emoji: emoji ?? this.emoji,
    );
  }

  @override
  List<Object?> get props => [id, name, price, category, emoji];

  @override
  String toString() => 'Item(id: $id, name: $name, price: $price)';
}
