# Mini POS - Checkout Core

A Flutter implementation of a headless checkout engine with BLoC architecture, featuring a complete demo UI.

## Overview

This project implements a Point of Sale (POS) checkout system with both business logic and demonstration interface:

- **CatalogBloc**: Loads product catalog from Flutter assets
- **CartBloc**: Manages cart operations (add/remove items, change quantities/discounts)
- **Receipt Builder**: Generates receipt data structures
- **Business Rules**: 15% VAT calculation, line-level discounts
- **Demo UI**: Interactive POS interface showcasing all functionality
- **Immutable State**: All models use value equality with Equatable

## Flutter & Dart Versions

- Flutter **3.27.4**
- Dart **3.6.2**

## Better Run Platforms

- MacOS
- Web
- Windows
- Linux

## Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  bloc: ^9.0.0
  equatable: ^2.0.7
  flutter_bloc: ^9.1.1
  hydrated_bloc: ^10.0.0
  google_fonts: ^6.2.1
  path_provider: ^2.1.4
  replay_bloc: ^0.3.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0
  bloc_test: ^10.0.0
```

## Project Structure

```
lib
├── core
│   ├── extentions
│   │   └── money_extenstions.dart
│   ├── shared
│   │   ├── components
│   │   └── screens
│   └── theme
│       └── app_theme.dart
├── main.dart
└── src
    ├── cart
    │   ├── bloc
    │   │   ├── cart_bloc.dart
    │   │   ├── cart_events.dart
    │   │   └── cart_states.dart
    │   ├── cart_model.dart
    │   ├── model
    │   ├── receipt.dart
    │   └── view
    │       ├── cart_section_view.dart
    │       ├── components
    │       │   └── cart_line_items.dart
    │       └── widgets
    │           ├── cart_total_widget.dart
    │           └── receipt_dialog_widget.dart
    ├── catalog
    │   ├── bloc
    │   │   ├── catalog_bloc.dart
    │   │   ├── catalog_events.dart
    │   │   └── catalog_states.dart
    │   ├── model
    │   │   └── item_model.dart
    │   └── view
    │       ├── catalog_section_view.dart
    │       └── components
    │           └── item_card.dart
    └── pos_demo_screen.dart

```

## Getting Started

### Installation

```bash
# Install dependencies
flutter pub get
```

### Running the Demo App

```bash
# Run the interactive demo
flutter run
```

### Running Tests

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run static analysis
flutter analyze --fatal-warnings
```

## Business Rules Implemented

1. **VAT Calculation**: 15% VAT applied to subtotal
2. **Line Discounts**: Per-line discount percentages (0-100%)
3. **Totals Calculation**:
   - `lineNet = price × qty × (1 – discount%)`
   - `subtotal = Σ lineNet`
   - `vat = subtotal × 0.15`
   - `grandTotal = subtotal + vat`
4. **Money Rounding**: All monetary values rounded to 2 decimal places

## Required Tests Included

✅ **Test 1**: Two different items → correct totals  
✅ **Test 2**: Qty + discount changes update totals  
✅ **Test 3**: Clearing cart resets state  

Additional comprehensive tests cover:

- All BLoC events and state transitions
- Edge cases (zero quantities, invalid discounts)
- Model equality and immutability
- Receipt generation

## Key Features

### CatalogBloc

- Loads catalog from `assets/catalog.json`
- Emits `CatalogLoaded(List<Item>)` on success
- Error handling for missing/invalid files

### CartBloc Events

- `AddItem(Item)` - Add item or increment quantity
- `RemoveItem(String itemId)` - Remove item completely
- `ChangeQty(String itemId, int newQty)` - Update item quantity
- `ChangeDiscount(String itemId, double discount)` - Apply line discount
- `ClearCart()` - Empty the cart

### Receipt Builder

Pure function `buildReceipt(CartState, DateTime)` that creates immutable receipt data structure with header, lines, and totals.

## Time Spent

Total: **~4 hours**

---
### Completed Items

- ✅ Code quality (immutable state, doc comments, short methods)
- ✅ Comprehensive unit tests (>95% coverage)
- ✅ All business rule validations

- ✅ Undo/redo functionality
- ✅ Hydration with hydrated_bloc
- ✅ Money extension

## Notes

- All classes are public under `lib/src/` for external test access
- No mutable fields - uses value equality throughout
- Passes `dart analyze --fatal-warnings`
- Focus on deterministic business logic without UI dependencies
