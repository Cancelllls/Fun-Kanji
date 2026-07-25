import 'package:flutter/material.dart';

import 'package:fun_with_kanji/config/app_colors.dart';

class LeanUnitListTile extends StatelessWidget {
  final int? progress;
  final String title;
  final void Function() onTap;
  final void Function() onSettings;
  final String symbol;

  const LeanUnitListTile({
    required this.progress,
    required this.title,
    required this.symbol,
    required this.onTap,
    required this.onSettings,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: Card(
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: scheme.onSurface,
                      ),
                    ),
                  ),
                  Icon(Icons.arrow_right_outlined, color: scheme.primary),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: scheme.primaryContainer,
                    foregroundColor: scheme.onPrimaryContainer,
                    child: Text(
                      symbol,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 32,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  SizedBox(
                    width: 72,
                    height: 72,
                    child: Material(
                      borderRadius: BorderRadius.circular(72),
                      color: scheme.secondaryContainer,
                      child: Stack(
                        children: [
                          SizedBox(
                            width: 72,
                            height: 72,
                            child: CircularProgressIndicator(
                              value: (progress ?? 0) / 100,
                              strokeWidth: 5,
                              color: AppColors.tertiary,
                              backgroundColor:
                                  scheme.surfaceContainerHighest,
                            ),
                          ),
                          if (progress != null)
                            Center(
                                child: Text(
                              '$progress%',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                                color: scheme.onSecondaryContainer,
                              ),
                            )),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  SizedBox(
                    width: 64,
                    height: 64,
                    child: Material(
                      borderRadius: BorderRadius.circular(64),
                      color: scheme.surfaceContainerHighest,
                      child: IconButton(
                        icon: Icon(Icons.settings_outlined,
                            color: scheme.onSurfaceVariant),
                        onPressed: onSettings,
                      ),
                    ),
                  ),
                ],
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
