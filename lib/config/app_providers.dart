import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import '../core/core.dart';
import '../features/checkIn_app/providers/checkIn_provider.dart';
import 'app_theme.dart';
// import '../features/features.dart';

List<SingleChildWidget> appProviders = [
  ChangeNotifierProvider<ThemeProvider>(
    create: (context) => ThemeProvider(),
  ),
  ChangeNotifierProvider<GlobalStateManager>(
    create: (context) => GlobalStateManager(),
  ),
  ChangeNotifierProvider<CheckInProvider>(
    create: (context) => CheckInProvider(),
  ),
  // ChangeNotifierProvider<EnqueryProvider>(
  //   create: (context) => EnqueryProvider(),
  // )
];
