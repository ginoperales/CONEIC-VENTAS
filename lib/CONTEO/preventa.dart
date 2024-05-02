import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MaterialApp(
    home: JsonDataWidget(),
  ));
}

class JsonDataWidget extends StatefulWidget {
  const JsonDataWidget({super.key});

  @override
  _JsonDataWidgetState createState() => _JsonDataWidgetState();
}

class _JsonDataWidgetState extends State<JsonDataWidget> {
  List<dynamic> jsonData = [];

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse(
        'https://script.google.com/macros/s/AKfycbxhqQpXclnyPZQzVUvWPgJa6Q_ceJol1bAISUYDy0Ofn8pl5263h5bnsOOIFunybKO-/exec'));

    if (response.statusCode == 200) {
      setState(() {
        jsonData = json.decode(response.body)['data'];
      });
    } else {
      throw Exception('Error al cargar los datos');
    }
  }

  DateTime parseDate(String dateString) {
    final List<String> dateParts = dateString.split('/');
    if (dateParts.length != 3) {
      throw FormatException('Formato de fecha incorrecto: $dateString');
    }
    final int day = int.parse(dateParts[0]);
    final int month = int.parse(dateParts[1]);
    final int year = int.parse(dateParts[2]);

    return DateTime(year, month, day);
  }

  @override
  void initState() {
    super.initState();
    fetchData(); // Llama a fetchData una vez al inicio
    // Configura un Timer para actualizar los datos cada 30 segundos
    Timer.periodic(const Duration(seconds: 2), (_) {
      if (mounted) {
        fetchData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CONEIC Ucayali 2024'),
      ),
      body: jsonData.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: jsonData.length,
              itemBuilder: (context, index) {
                final data = jsonData[index];
                try {
                  final endDate = parseDate(data['Fecha final']);

                  // Agregar condiciones para mostrar "Etapa Culminada"
                  if (data['Numero de inscritos'] >=
                          data['Limite de inscritos'] ||
                      DateTime.now().isAfter(endDate)) {
                    return ListTile(
                      title: const Text(
                        'Etapa Culminada',
                        style: TextStyle(
                          fontSize: 30,
                          fontFamily: 'Arial',
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              // Acción para el botón "Inscritos"
                            },
                            child: Text('Inscritos'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              // Acción para el botón "Ir a Facebook"
                            },
                            child: Text('Ir a Facebook'),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListTile(
                    title: Column(
                      children: [
                        Text(
                          '${data['Etapa']}',
                          style: TextStyle(
                            fontSize: 30,
                            fontFamily: 'Arial',
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Cantidad de solicitudes: ${data['Cantidad de solicitudes']}',
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'Arial',
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'Limite de inscritos: ${data['Limite de inscritos']}',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Arial',
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'Número de inscritos: ${data['Numero de inscritos']}',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Arial',
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'RESTAN: ${data['Restantes']}',
                          style: TextStyle(
                            fontSize: 25,
                            fontFamily: 'Arial',
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'Fecha inicio: ${data['Fecha inicio']}',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Arial',
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'Fecha final: ${data['Fecha final']}',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Arial',
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        CountdownTimer(targetDate: endDate),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                // Acción para el botón "Inscritos"
                              },
                              child: Text('Inscritos'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                // Acción para el botón "Inscribirse"
                                // Navigator.pushNamed(context, '/inscribirse');
                                // Si estás utilizando Navigator 2.0
                                // Puedes colocar un enlace aquí
                              },
                              child: Text('Inscribirse'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                } catch (e) {
                  return ListTile(
                    title: Text(
                      'Error de formato de fecha:',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Arial',
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    subtitle: Text(
                      e.toString(),
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Arial',
                        color: Colors.red,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                }
              },
            ),
    );
  }
}

class CountdownTimer extends StatefulWidget {
  final DateTime targetDate;

  const CountdownTimer({Key? key, required this.targetDate}) : super(key: key);

  @override
  _CountdownTimerState createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  late Timer _timer;
  Duration _timeUntilTarget = Duration();

  @override
  void initState() {
    super.initState();
    _timeUntilTarget = widget.targetDate.difference(DateTime.now());
    _timer =
        Timer.periodic(Duration(seconds: 1), (_) => _updateTimeUntilTarget());
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _updateTimeUntilTarget() {
    setState(() {
      _timeUntilTarget = widget.targetDate.difference(DateTime.now());
    });
  }

  @override
  Widget build(BuildContext context) {
    int days = _timeUntilTarget.inDays;
    int hours = _timeUntilTarget.inHours.remainder(24);
    int minutes = _timeUntilTarget.inMinutes.remainder(60);
    int seconds = _timeUntilTarget.inSeconds.remainder(60);

    return Text(
      'Tiempo restante: $days días $hours horas $minutes minutos $seconds segundos',
      style: TextStyle(
        fontSize: 16,
        fontFamily: 'Arial',
        color: Colors.black,
      ),
      textAlign: TextAlign.center,
    );
  }
}
