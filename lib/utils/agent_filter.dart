import '../models/valorant_agent.dart';

List<Datum> filterAgentsForTab(List<Datum> agents, String tab) {
  if (tab == 'Popular') return agents;
  if (tab == 'Trending') return agents.reversed.toList();
  if (tab == 'New One') {
    return List<Datum>.of(agents)..sort((a, b) {
      if (a.releaseDate == null) return b.releaseDate == null ? 0 : 1;
      if (b.releaseDate == null) return -1;
      return b.releaseDate!.compareTo(a.releaseDate!);
    });
  }

  return agents.where((agent) {
    final roleName = agent.role == null
        ? null
        : displayNameValues.reverse[agent.role!.displayName];
    return roleName?.toLowerCase() == tab.toLowerCase();
  }).toList();
}
