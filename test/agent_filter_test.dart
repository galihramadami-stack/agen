import 'package:flutter_test/flutter_test.dart';
import 'package:agen_flutter/models/valorant_agent.dart';
import 'package:agen_flutter/utils/agent_filter.dart';

void main() {
  final agents = [
    Datum(
      uuid: 'first',
      displayName: 'First',
      description: '',
      releaseDate: DateTime(2020),
      role: Role(displayName: DisplayName.duelist),
    ),
    Datum(
      uuid: 'second',
      displayName: 'Second',
      description: '',
      releaseDate: DateTime(2022),
      role: Role(displayName: DisplayName.sentinel),
    ),
    Datum(uuid: 'third', displayName: 'Third', description: ''),
  ];

  test('filters agents by role without changing original list', () {
    final result = filterAgentsForTab(agents, 'Duelist');

    expect(result.map((agent) => agent.uuid), ['first']);
    expect(agents.map((agent) => agent.uuid), ['first', 'second', 'third']);
  });

  test('sorts newest agents first and leaves undated agents last', () {
    final result = filterAgentsForTab(agents, 'New One');

    expect(result.map((agent) => agent.uuid), ['second', 'first', 'third']);
  });

  test('shows trending agents in reverse order', () {
    expect(filterAgentsForTab(agents, 'Trending').map((agent) => agent.uuid), [
      'third',
      'second',
      'first',
    ]);
  });
}
