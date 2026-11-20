import 'package:http/http.dart' as http;

import '../constants/api_constant.dart';
import '../models/valorant_agent.dart';

class ApiService {
  static Future<List<Datum>> getAgents() async {
    final response = await http
        .get(Uri.parse(ApiConstant.agentsEndpoint))
        .timeout(const Duration(seconds: 20));

    if (response.statusCode == 200) {
      final temperatures = temperaturesFromJson(response.body);
      return temperatures.data;
    } else {
      throw Exception('Gagal memuat data agen Valorant');
    }
  }
}
