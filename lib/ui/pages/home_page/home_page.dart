import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/domain/provider/weather_provider.dart';
import 'package:weather_app/domain/weather_json/weather_data.dart';
import 'package:weather_app/ui/components/home_page_app_bar/home_page_app_bar.dart';
import 'package:weather_app/ui/components/home_page_body/block_card_widget.dart';
import 'package:weather_app/ui/components/home_page_body/seven_days_widget.dart';
import 'package:weather_app/ui/components/home_page_footer/home_page_footer.dart';
import 'package:weather_app/ui/components/home_page_header/home_page_header.dart';
import 'package:weather_app/ui/pages/noConnection/no_connection.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<WeatherProvider>(context);

    Widget _buildBody(
      BuildContext context,
      AsyncSnapshot<WeatherData?> snapshot,
      // ConnectivityResult? connectivityResult,
    ) {
      // ignore: unrelated_type_equality_checks
      if (WeatherProvider.checkInternet == true) {
        switch (snapshot.connectionState) {
          // case ConnectionState.none:
          //   return const NoConnectionPage();
          case ConnectionState.done:
            return const _HomePageContent();
          case ConnectionState.waiting:
          default:
            return DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.blueAccent.shade100,
              ),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );
        }
      } else {
        return const NoConnectionPage();
      }
    }

    return Scaffold(
      body: FutureBuilder(
        future: context.watch<WeatherProvider>().setUp(),
        builder: _buildBody,
      ),
    );
  }
}

class _HomePageContent extends StatelessWidget {
  const _HomePageContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<WeatherProvider>(context);

    return Ink(
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage(model.setTheme()),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            const HomePageAppBar(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(
                  top: 44,
                  left: 16,
                  right: 16,
                  bottom: 31,
                ),
                children: <Widget>[
                  GestureDetector(
                    onDoubleTap: () {
                      model.addFavorite(
                        context,
                        cityName: model.weatherData?.timezone,
                      );
                    },
                    child: const HomePageHeader(),
                  ),
                  const SizedBox(height: 40),
                  const SevenDaysWidget(),
                  const SizedBox(height: 28),
                  const BlockCardWidget(),
                  const SizedBox(height: 30),
                  HomePageFooter(
                    sunriseTime: model.setCurrentSunrise(),
                    sunsetTime: model.setCurrentSunset(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
