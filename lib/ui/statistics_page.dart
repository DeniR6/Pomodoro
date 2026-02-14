import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/session_repository_provider.dart';
import '../application/statistics_service.dart';

class StatisticsPage extends ConsumerWidget {
  const StatisticsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder(
      future: ref.read(sessionRepositoryProvider).loadSessions(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final stats = StatisticsService(snapshot.data!);
        final weekly = stats.weeklyOverview();

        return Scaffold(
          appBar: AppBar(title: const Text("Statistik")),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                _StatCard(
                  title: "Heute",
                  value: "${stats.pomodorosToday()}",
                ),

                _StatCard(
                  title: "Gesamt Minuten",
                  value: "${stats.totalFocusMinutes()}",
                ),

                _StatCard(
                  title: "Aktuelle Streak",
                  value: "${stats.currentStreak()} Tage 🔥",
                ),

                const SizedBox(height: 20),

                const Text(
                  "Wochenübersicht",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
                  children: List.generate(7, (i) {
                    final count = weekly[i] ?? 0;

                    return Column(
                      children: [
                        Container(
                          height: count * 20,
                          width: 20,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius:
                            BorderRadius.circular(6),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          ["Mo","Di","Mi","Do","Fr","Sa","So"][i],
                        )
                      ],
                    );
                  }),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;

  const _StatCard({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(title),
        trailing: Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}