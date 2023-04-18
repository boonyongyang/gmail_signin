import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class ApiService {
  final String _baseUrl = 'http://192.168.100.99/datetime/datetime.php';

  Future<String> getCurrentDateTime() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl));
      debugPrint('response: ${response.body}');
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        debugPrint('json: $json');
        final dateTime = DateTime.parse(json['dateTime']).toLocal();
        await initializeDateFormatting('ms_MY');
        final malaysiaDateTime =
            DateFormat.yMMMMEEEEd('ms_MY').add_jms().format(dateTime);
        return malaysiaDateTime;
      } else {
        throw Exception('Failed to load current date time');
      }
    } catch (e) {
      debugPrint('Error: $e');
      return '';
    }
  }
}
