import 'package:flutter/material.dart';
import 'package:wikisurf/pages/gameplay_page.dart';
import 'package:wikisurf/ui/flash_icons_row.dart';
import 'package:wikisurf/ui/wiki_container.dart';
import 'package:wikisurf/utils/flash_manager.dart';

class LevelSelectPage extends StatelessWidget {
  const LevelSelectPage({super.key});

  @override
  Widget build(BuildContext context) {
    final levels = _demoLevels;

    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: const Text(
          'Choose a Level',
          style: TextStyle(fontFamily: 'Georgia', color: Colors.black87),
        ),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        actions: [FlashRow()],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Divider(height: 1),

          Expanded(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: const AssetImage('assets/bg.png'),
                  colorFilter: ColorFilter.mode(
                    Colors.black.withValues(alpha: 0.6),
                    BlendMode.dstATop,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: levels.length,
                itemBuilder: (_, i) {
                  final level = levels[i];

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => WikiSurfGamePage(
                              startPage: level['start']!,
                              targetPage: level['target']!,
                            ),
                          ),
                        );
                        flashes.loseFlash();
                      },
                      child: WikiContainer(
                        padding: const EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 20,
                        ),
                        borderRadius: BorderRadius.circular(18),
                        backgroundColor: Colors.white70.withValues(alpha: 0.5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Level information
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    'Start: ${level['start']}\nTarget: ${level['target']}',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  level['theme']!,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                              ],
                            ),
                            // Difficulty Chip
                            Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 4,
                                horizontal: 12,
                              ),
                              decoration: BoxDecoration(
                                color: _chipColor(
                                  level['difficulty']!,
                                ).withValues(alpha: 0.8),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                level['difficulty']!,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  static List<Map<String, String>> get _demoLevels => [
    {'start': 'Dog', 'target': 'Cat', 'difficulty': 'Easy', 'theme': 'Pets'},
    {
      'start': 'Monaco',
      'target': 'Istanbul',
      'difficulty': 'Medium',
      'theme': 'Geography',
    },
    {
      'start': 'Chess',
      'target': 'World War II',
      'difficulty': 'Medium',
      'theme': 'History',
    },
    {
      'start': 'Bitcoin',
      'target': 'Karl Marx',
      'difficulty': 'Hard',
      'theme': 'Economics',
    },
    {
      'start': 'Cat',
      'target': 'Quantum Mechanics',
      'difficulty': 'Hard',
      'theme': 'Science',
    },
    {
      'start': 'The Godfather',
      'target': ' Joseph Stalin',
      'difficulty': 'Hard',
      'theme': 'Culture',
    },
    {
      'target': 'Cat',
      'start': 'Quantum Mechanics',
      'difficulty': 'Hard',
      'theme': 'Culture',
    },
    {
      'start': 'Pizza',
      'target': 'Michelangelo',
      'difficulty': 'Medium',
      'theme': 'Italy',
    },
    {
      'start': 'Coffee',
      'target': 'Industrial Revolution',
      'difficulty': 'Hard',
      'theme': 'History',
    },
    {
      'start': 'Python (programming language)',
      'target': 'Monty Python',
      'difficulty': 'Medium',
      'theme': 'Entertainment',
    },
    {
      'start': 'Batman',
      'target': 'Transylvania',
      'difficulty': 'Medium',
      'theme': 'Dark Themes',
    },
    {
      'start': 'Sushi',
      'target': 'Samurai',
      'difficulty': 'Easy',
      'theme': 'Japan',
    },
    {
      'start': 'Moon',
      'target': 'Werewolf',
      'difficulty': 'Easy',
      'theme': 'Mythology',
    },
    {
      'start': 'Harry Potter',
      'target': 'Albert Einstein',
      'difficulty': 'Hard',
      'theme': 'Magic & Science',
    },
    {
      'start': 'Pyramid',
      'target': 'Alien (film)',
      'difficulty': 'Medium',
      'theme': 'Mystery',
    },
    {
      'start': 'Leonardo DiCaprio',
      'target': 'Climate change',
      'difficulty': 'Easy',
      'theme': 'Environment',
    },
    {
      'start': 'The Beatles',
      'target': 'Beatle (insect)',
      'difficulty': 'Medium',
      'theme': 'Music & Nature',
    },
    {
      'start': 'Apple Inc.',
      'target': 'Isaac Newton',
      'difficulty': 'Easy',
      'theme': 'Connections',
    },
    {
      'start': 'The Lord of the Rings',
      'target': 'Volcano',
      'difficulty': 'Medium',
      'theme': 'Fantasy',
    },
    {
      'start': 'Chocolate',
      'target': 'Maya civilization',
      'difficulty': 'Medium',
      'theme': 'Food History',
    },
    {
      'start': 'Starbucks',
      'target': 'Seattle',
      'difficulty': 'Easy',
      'theme': 'Cities & Brands',
    },
    {
      'start': 'Marie Curie',
      'target': 'Poland',
      'difficulty': 'Easy',
      'theme': 'Science & Geography',
    },
    {
      'start': 'Frankenstein',
      'target': 'Electricity',
      'difficulty': 'Easy',
      'theme': 'Literature & Science',
    },
    {
      'start': 'Sparta',
      'target': 'Olympic Games',
      'difficulty': 'Medium',
      'theme': 'Ancient Greece',
    },
    {
      'start': 'Vincent van Gogh',
      'target': 'Sunflower',
      'difficulty': 'Easy',
      'theme': 'Art',
    },
    {
      'start': 'Nintendo',
      'target': 'Samurai',
      'difficulty': 'Medium',
      'theme': 'Japan & Entertainment',
    },
    {
      'start': 'Democracy',
      'target': 'Socrates',
      'difficulty': 'Medium',
      'theme': 'Philosophy',
    },
  ];

  static Color _chipColor(String diff) {
    switch (diff.toLowerCase()) {
      case 'easy':
        return Colors.green;
      case 'medium':
        return Colors.orange;
      case 'hard':
        return Colors.redAccent;
      default:
        return Colors.grey;
    }
  }
}
