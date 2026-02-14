import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/session_repository_provider.dart';
import '../application/statistics_service.dart';


class WikiPage extends StatelessWidget {
  const WikiPage({super.key});

  // ✏️ HIER kannst du später ganz einfach Texte ändern
  static const String introText = '''
Die Pomodoro-Technik ist eine Zeitmanagement-Methode, die in den 1980er Jahren entwickelt wurde.
Sie basiert auf der Idee, Arbeit in kurze, fokussierte Intervalle zu unterteilen.
''';

  static const String historyText = '''
Die Methode wurde von Francesco Cirillo entwickelt.
Der Name "Pomodoro" stammt von einem tomatenförmigen Küchentimer,
den er während seines Studiums verwendete.
''';

  static const String methodText = '''
Ein klassischer Pomodoro-Zyklus besteht aus:

1. 25 Minuten konzentrierter Arbeit
2. 5 Minuten Pause
3. Nach 4 Durchgängen eine längere Pause (15–30 Minuten)

Diese Struktur hilft dabei, Ablenkungen zu minimieren
und die Konzentration zu steigern.
''';

  static const String benefitsText = '''
Vorteile der Methode:

• Verbesserte Konzentration  
• Weniger Prokrastination  
• Klare Zeitstruktur  
• Bessere Selbsteinschätzung  
• Höhere Produktivität  
''';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pomodoro – Wiki"),
        centerTitle: true,
      ),
      body: Scrollbar(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [

              _WikiTitle("Pomodoro-Technik"),

              SizedBox(height: 20),
              _WikiSection(
                title: "Einleitung",
                content: introText,
              ),

              _WikiSection(
                title: "Geschichte",
                content: historyText,
              ),

              _WikiSection(
                title: "Die Methode",
                content: methodText,
              ),

              _WikiSection(
                title: "Vorteile",
                content: benefitsText,
              ),

              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

class _WikiTitle extends StatelessWidget {
  final String title;
  const _WikiTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class _WikiSection extends StatelessWidget {
  final String title;
  final String content;

  const _WikiSection({
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(
              fontSize: 16,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}