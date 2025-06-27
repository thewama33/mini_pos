import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:mini_pos/core/theme/app_theme.dart';
import 'package:mini_pos/src/catalog/bloc/catalog_bloc.dart';
import 'package:mini_pos/src/catalog/bloc/catalog_events.dart';
import 'package:mini_pos/src/cart/bloc/cart_bloc.dart';
import 'package:mini_pos/src/pos_demo_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final storage = await HydratedStorage.build(
    storageDirectory:
        HydratedStorageDirectory((await getTemporaryDirectory()).path),
  );
  HydratedBloc.storage = storage;
  runApp(const MiniPosApp());
}

class MiniPosApp extends StatelessWidget {
  const MiniPosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mini POS Demo',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      home: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => CatalogBloc()..add(const LoadCatalog()),
          ),
          BlocProvider(
            create: (context) => CartBloc(),
          ),
        ],
        child: const PosDemoScreen(),
      ),
    );
  }
}
