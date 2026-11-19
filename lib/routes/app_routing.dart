import 'package:flutter/material.dart';
import 'package:agen_flutter/pages/agent_valo.dart';

class AppRouting {
  static const String initialRoute = '/';
  static const String agentValo = '/agent-valo';

  static Map<String, WidgetBuilder> get routes => {
        initialRoute: (context) => const AgentValo(),
        agentValo: (context) => const AgentValo(),
      };
}
