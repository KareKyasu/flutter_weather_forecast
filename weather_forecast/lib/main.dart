import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:weather_forecast/model/area_model.dart';
import 'package:weather_forecast/routes.dart';
import 'package:weather_forecast/ui/weather_screen.dart';

void main() async {
  await DotEnv().load('.env');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AreaModel>(
          create: (context) => AreaModel(),
        )
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData.light(),
        home: WeatherScreen(),
        onGenerateRoute: Routes.onGenerateRoute,
      ),
    );
  }
}
