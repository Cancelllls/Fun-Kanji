import 'package:flutter/material.dart';

import 'package:fun_with_kanji/l10n/l10n.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:confetti/confetti.dart';
import 'package:fun_with_kanji/config/app_colors.dart';
import 'package:fun_with_kanji/models/kana.dart';
import 'package:fun_with_kanji/models/kanji.dart';
import 'package:fun_with_kanji/models/radical.dart';
import 'package:fun_with_kanji/pages/learning/learning.dart';
import 'package:fun_with_kanji/utils/writing_system.dart';

class LearningView extends StatelessWidget {
  final LearningController controller;
  const LearningView(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(controller.widget.writingSystem.getTitle(context)),
        actions: [
          Center(
            child: Text(
              L10n.of(context)!.countIntroduced(controller.started),
            ),
          ),
          const SizedBox(width: 4),
          const Icon(Icons.check_circle_outlined),
          const SizedBox(width: 4),
          IconButton(
            icon: const Icon(Icons.skip_next),
            tooltip: 'Skip',
            onPressed: controller.skipCharacter,
          ),
        ],
      ),
      body: Stack(
        children: [
          Builder(builder: (context) {
            final currentCharacter = controller.currentCharacter;
            final learningProgress = controller.learningProgress;
            if (currentCharacter == null || learningProgress == null) {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            }
            final choices = controller.choices;
            return ListView(padding: const EdgeInsets.all(16), children: [
              Semantics(
                label: 'Progress: ${learningProgress.stars} out of 10 stars',
                child: Row(
                  children: [
                    for (var i = 1; i <= 10; i++)
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            learningProgress.stars >= i
                                ? Icons.star
                                : Icons.star_outlined,
                            color: learningProgress.stars >= i
                                ? AppColors.starColor
                                : scheme.outlineVariant,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Semantics(
                label: 'Character: ${currentCharacter.toString()}',
                child: SizedBox(
                  height: 188,
                  child: Center(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      width: controller.answerCorrect == null ? 512 : 0,
                      height: controller.answerCorrect == null ? 188 : 0,
                      curve: Curves.easeInOut,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: controller.answerCorrect == null
                            ? scheme.primaryContainer
                            : controller.answerCorrect!
                                ? scheme.tertiary
                                : scheme.error,
                      ),
                      alignment: Alignment.bottomCenter,
                      padding: const EdgeInsets.only(bottom: 32),
                      child: controller.answerCorrect != null
                          ? null
                          : Stack(
                              children: [
                                Positioned.fill(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: CustomPaint(
                                      painter: _CardPatternPainter(
                                        color: scheme.primary
                                            .withValues(alpha: 0.06),
                                      ),
                                    ),
                                  ),
                                ),
                                Center(
                                  child: ConstrainedBox(
                                    constraints: const BoxConstraints(
                                      maxWidth: 128,
                                      maxHeight: 64,
                                    ),
                                    child: Material(
                                      color: scheme.surface,
                                      borderRadius: BorderRadius.circular(8),
                                      child: FittedBox(
                                        fit: BoxFit.fitHeight,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              currentCharacter is Kanji &&
                                                      controller.enterKanjiKana
                                                  ? currentCharacter.description
                                                  : currentCharacter.toString(),
                                              style: GoogleFonts.yujiSyuku(
                                                textStyle: TextStyle(
                                                  color: scheme.onSurface,
                                                  fontSize: 32,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
              ),
              if (currentCharacter is Kana) ...[
                const SizedBox(height: 16),
                Text(currentCharacter.type, textAlign: TextAlign.center),
              ],
              if (currentCharacter is Kanji && controller.enterKanjiKana) ...[
                const SizedBox(height: 16),
                Text(
                  currentCharacter.meanings.join(', '),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ],
              if (currentCharacter is Kanji &&
                  controller.learningProgress!.stars < 8) ...[
                const SizedBox(height: 16),
                Text(
                  '${L10n.of(context)!.radicalsName}: ${currentCharacter.radicals.join(', ')}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ],
              const SizedBox(height: 12),
              if (controller.answerCorrect == null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        controller.responseController.text =
                            currentCharacter.correctAnswers.join(', ');
                      },
                      icon: const Icon(Icons.lightbulb_outline,
                          size: 18, color: AppColors.starColor),
                      label: const Text('Show Answer',
                          style: TextStyle(color: AppColors.starColor)),
                    ),
                  ],
                ),
              if (controller.showHint || controller.hint == null)
                OutlinedButton(
                  onPressed: controller.editHint,
                  child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child:
                          Text(controller.hint ?? L10n.of(context)!.addHint)),
                )
              else
                OutlinedButton.icon(
                  onPressed: controller.editHint,
                  icon: const Icon(Icons.visibility_outlined),
                  label: Text(L10n.of(context)!.showHint),
                ),
              const SizedBox(height: 16),
              if (choices != null)
                ...choices.map(
                  (choice) => Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: ElevatedButton(
                      onPressed: () => controller.answerCorrect != null
                          ? null
                          : controller.checkChoice(choice),
                      child: Column(
                        children: [
                          Text(
                            choice is Kanji && controller.enterKanjiKana
                                ? choice.kanji
                                : choice.description,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 24),
                          ),
                          if (choice is Kanji &&
                              !controller.enterKanjiKana &&
                              choice.meanings.length > 1)
                            Text(
                              choice.meanings
                                  .getRange(1, choice.meanings.length)
                                  .join(', '),
                              textAlign: TextAlign.center,
                            ),
                        ],
                      ),
                    ),
                  ),
                )
              else ...[
                TextField(
                  readOnly: controller.answerCorrect != null,
                  controller: controller.responseController,
                  focusNode: controller.replyFocus,
                  autofocus: true,
                  autocorrect: false,
                  enableSuggestions: false,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                      hintText: currentCharacter is Kanji &&
                              controller.enterKanjiKana
                          ? L10n.of(context)!.enterKanji
                          : L10n.of(context)!.enterRomaji),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: controller.answerCorrect != null
                      ? () {}
                      : controller.checkStringChoice,
                  child: Text(L10n.of(context)!.check),
                )
              ],
              if (currentCharacter is Radical &&
                  (controller.learningProgress!.stars < 8 ||
                      controller.answerCorrect != null)) ...[
                const Divider(),
                Text(currentCharacter.reading,
                    style: const TextStyle(fontSize: 16)),
              ],
              if (currentCharacter is Kanji &&
                  (controller.learningProgress!.stars < 8 ||
                      controller.answerCorrect != null)) ...[
                const Divider(),
                Text(
                  '${L10n.of(context)!.onReadings}\n${currentCharacter.readingsOn.join('\n')}',
                  style: const TextStyle(fontSize: 16),
                ),
                const Divider(),
                Text(
                  '${L10n.of(context)!.kunReadings}\n${currentCharacter.readingsKun.join('\n')}',
                  style: const TextStyle(fontSize: 16),
                ),
                const Divider(),
              ]
            ]);
          }),
          Align(
            alignment: Alignment.topCenter,
            child: ExcludeSemantics(
              child: ConfettiWidget(
                confettiController: controller.confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                shouldLoop: false,
                colors: const [
                  AppColors.tertiary,
                  AppColors.primary,
                  AppColors.starColor,
                  AppColors.confettiPink,
                  AppColors.secondary,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CardPatternPainter extends CustomPainter {
  final Color color;
  _CardPatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    const spacing = 28.0;
    const radius = 6.0;

    for (double x = spacing; x < size.width; x += spacing) {
      for (double y = spacing; y < size.height; y += spacing) {
        final alpha = ((x / spacing + y / spacing) % 2 == 0) ? 1.0 : 0.4;
        paint.color = color.withValues(alpha: alpha);
        canvas.drawCircle(Offset(x, y), radius, paint);
      }
    }

    for (double x = spacing / 2; x < size.width; x += spacing) {
      for (double y = spacing / 2; y < size.height; y += spacing) {
        paint.color = color.withValues(alpha: 0.2);
        canvas.drawLine(
            Offset(x - 4, y - 4), Offset(x + 4, y + 4), paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
