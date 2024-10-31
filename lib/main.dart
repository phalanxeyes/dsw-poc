import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(ClimaApp());
}

class ClimaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Clima',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.blueAccent,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: Colors.white, // Antes era 'accentColor'
        ),
        textTheme: TextTheme(
          bodyMedium: TextStyle(color: Colors.white), // Reemplaza bodyText2
        ),
      ),
      home: ClimaPage(),
    );
  }
}

class ClimaPage extends StatefulWidget {
  @override
  _ClimaPageState createState() => _ClimaPageState();
}

class _ClimaPageState extends State<ClimaPage> {
  String _city = "";
  var _weatherData;

  final TextEditingController _controller = TextEditingController();

  // Función para obtener el clima usando la API
  Future<void> _fetchWeather(String city) async {
    final apiKey = 'ed02a16a0233183dbbd905db1ec5d3ca';
    final url =
        'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric&lang=es';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        setState(() {
          _weatherData = json.decode(response.body);
        });
      } else {
        setState(() {
          _weatherData = null;
        });
      }
    } catch (e) {
      setState(() {
        _weatherData = null;
      });
    }
  }

  // Función para obtener el ícono del clima basado en el estado del tiempo
  String _getWeatherIcon(String description) {
    if (description.contains("nube")) {
      return "☁️";
    } else if (description.contains("lluvia")) {
      return "🌧️";
    } else if (description.contains("sol")) {
      return "☀️";
    } else {
      return "🌥️";
    }
  }

  // Función para construir la UI con los datos del clima
  Widget _buildWeatherInfo() {
    if (_weatherData == null) {
      return Text(
        "No se encontraron datos.",
        style: TextStyle(color: Colors.white, fontSize: 20),
      );
    } else {
      final temperature = _weatherData['main']['temp'];
      final description = _weatherData['weather'][0]['description'];
      final cityName = _weatherData['name'];
      final weatherIcon = _getWeatherIcon(description);

      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "$cityName",
            style: TextStyle(
                fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          SizedBox(height: 10),
          Text(
            weatherIcon,
            style: TextStyle(fontSize: 100),
          ),
          SizedBox(height: 10),
          Text(
            "$temperature°C",
            style: TextStyle(fontSize: 64, color: Colors.white),
          ),
          SizedBox(height: 10),
          Text(
            description,
            style: TextStyle(fontSize: 24, color: Colors.white70),
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Clima', style: TextStyle(color: Colors.white)),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.lightBlueAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white.withOpacity(0.7),
                labelText: 'Ingrese el nombre de una ciudad',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onChanged: (value) {
                _city = value;
              },
            ),
            SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Colors.white.withOpacity(0.8), // Cambiado de 'primary'
                foregroundColor: Colors.blueAccent, // Cambiado de 'onPrimary'
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onPressed: () {
                if (_city.isNotEmpty) {
                  _fetchWeather(_city);
                }
              },
              child: Text(
                'Obtener Clima',
                style: TextStyle(fontSize: 18),
              ),
            ),
            SizedBox(height: 32),
            _buildWeatherInfo(),
          ],
        ),
      ),
    );
  }
}
