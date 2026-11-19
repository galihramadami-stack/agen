import 'package:http/http.dart' as http;
import '../constants/api_constant.dart';
import '../models/agen_vaLorant.dart';

class ApiService {
  static Future<List<Datum>> getAgents() async {
    final response = await http.get(Uri.parse(ApiConstant.agentsEndpoint));

    if (response.statusCode == 200) {
      final temperatures = temperaturesFromJson(response.body);
      return temperatures.data;
    } else {
      throw Exception('Gagal memuat data agen Valorant');
    }
  }
}
