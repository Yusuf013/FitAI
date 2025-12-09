import 'dart:convert';
import 'package:flutter/services.dart';

class StatsService {
  static Future<Map<String, dynamic>> loadStats() async {
    final raw = await rootBundle.loadString("assets/data/model_stats.json");
    return json.decode(raw);
  }
}
