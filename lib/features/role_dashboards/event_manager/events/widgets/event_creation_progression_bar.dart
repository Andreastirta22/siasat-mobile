import 'package:flutter/material.dart';
import 'package:crewsync_mobile/core/theme/app_colors.dart';

enum EventCreationStep { createEvent, setupVenue, assignHeadcrew, ready }

class EventCreationProgressionBar extends StatelessWidget {
  final EventCreationStep currentStep;

  const EventCreationProgressionBar({super.key, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    final steps = [
      _ProgressStepData(title: 'Create\nEvent', icon: Icons.event_note_rounded),
      _ProgressStepData(title: 'Setup\nVenue', icon: Icons.location_on_rounded),
      _ProgressStepData(title: 'Assign\nHeadcrew', icon: Icons.groups_rounded),
      _ProgressStepData(title: 'Ready', icon: Icons.check_circle_rounded),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 24,
            spreadRadius: 0,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(steps.length * 2 - 1, (i) {
          if (i.isOdd) {
            // Connector line between steps
            final stepIndex = i ~/ 2;
            final isCompleted = currentStep.index > stepIndex;
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 28),
                child: _AnimatedConnector(isCompleted: isCompleted),
              ),
            );
          }

          final index = i ~/ 2;
          final isCompleted = currentStep.index > index;
          final isCurrent = currentStep.index == index;

          return _ProgressStepItem(
            title: steps[index].title,
            icon: steps[index].icon,
            isCompleted: isCompleted,
            isCurrent: isCurrent,
          );
        }),
      ),
    );
  }
}

class _AnimatedConnector extends StatelessWidget {
  final bool isCompleted;

  const _AnimatedConnector({required this.isCompleted});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          alignment: Alignment.centerLeft,
          children: [
            // Track
            Container(
              height: 3,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(100),
              ),
            ),
            // Fill
            AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
              height: 3,
              width: isCompleted ? constraints.maxWidth : 0,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(100),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ProgressStepItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isCompleted;
  final bool isCurrent;

  const _ProgressStepItem({
    required this.title,
    required this.icon,
    required this.isCompleted,
    required this.isCurrent,
  });

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primary;

    Color bgColor;
    Color iconColor;
    Color textColor;

    if (isCompleted) {
      bgColor = primary;
      iconColor = Colors.white;
      textColor = primary;
    } else if (isCurrent) {
      bgColor = primary.withOpacity(0.10);
      iconColor = primary;
      textColor = primary;
    } else {
      bgColor = Colors.grey.shade100;
      iconColor = Colors.grey.shade400;
      textColor = Colors.grey.shade400;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Outer glow ring (current step only)
        AnimatedContainer(
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOut,
          width: isCurrent ? 60 : 50,
          height: isCurrent ? 60 : 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isCurrent ? primary.withOpacity(0.08) : Colors.transparent,
          ),
          child: Center(
            // Inner circle
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeOut,
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: bgColor,
                shape: BoxShape.circle,
                boxShadow: isCurrent
                    ? [
                        BoxShadow(
                          color: primary.withOpacity(0.30),
                          blurRadius: 16,
                          spreadRadius: 2,
                        ),
                      ]
                    : isCompleted
                    ? [
                        BoxShadow(
                          color: primary.withOpacity(0.18),
                          blurRadius: 10,
                          spreadRadius: 1,
                        ),
                      ]
                    : [],
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 280),
                switchInCurve: Curves.easeOut,
                switchOutCurve: Curves.easeIn,
                transitionBuilder: (child, animation) => ScaleTransition(
                  scale: animation,
                  child: FadeTransition(opacity: animation, child: child),
                ),
                child: isCompleted
                    ? Icon(
                        Icons.check_rounded,
                        key: const ValueKey('check'),
                        color: iconColor,
                        size: 22,
                      )
                    : Icon(
                        icon,
                        key: ValueKey(icon.codePoint),
                        color: iconColor,
                        size: 22,
                      ),
              ),
            ),
          ),
        ),

        const SizedBox(height: 10),

        AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 300),
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: textColor,
            height: 1.35,
          ),
          child: Text(title, textAlign: TextAlign.center),
        ),
      ],
    );
  }
}

class _ProgressStepData {
  final String title;
  final IconData icon;

  _ProgressStepData({required this.title, required this.icon});
}
