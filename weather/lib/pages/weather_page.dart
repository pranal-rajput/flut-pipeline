import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather/models/weather_model.dart';
import 'package:weather/services/weather_service.dart';

class WeatherPage extends StatefulWidget {
  final VoidCallback onToggleTheme;
  final bool isDarkMode;

  const WeatherPage({super.key, required this.onToggleTheme, required this.isDarkMode});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final _weatherService = WeatherService('d7140a0953efeac301b22374176a294a');
  Weather? _weather;
  String? _errorMessage;

  Future<void> _fetchWeather() async {
    try {
      String cityName = await _weatherService.getCurrentCity();
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
        _errorMessage = null;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    }
  }

  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return 'assets/sun.json';

    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'haze':
      case 'fog':
      case 'dust':
        return 'assets/clouds.json';

      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/rain.json';

      case 'thunderstorm':
        return 'assets/thunderStorm.json';

      case 'clear':
        return 'assets/sun.json';
      default:
        return 'assets/sun.json';
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daily Weather",
        style: TextStyle(fontSize: 24, fontWeight:FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(
              widget.isDarkMode ? Icons.light_mode : Icons.dark_mode,
              color: widget.isDarkMode ? Colors.yellow : Colors.black,
            ),
            onPressed: widget.onToggleTheme,
            tooltip: 'Toggle Theme',
          ),
        ],
      ),
      body: Center(
        child: _errorMessage != null
            ? Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              )
            : _weather == null
                ? const CircularProgressIndicator()
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _weather!.cityName,
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      Lottie.asset(getWeatherAnimation(_weather!.mainCondition)),
                      Text(
                        '${_weather!.temperature.round()}°C',
                        style: const TextStyle(fontSize: 48),
                      ),
                      Text(
                        _weather!.mainCondition,
                        style: const TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
      ),
      
    );
  }
}
