import 'package:done_today/reusable_ui/brand_colors.dart';
import 'package:flutter/material.dart';

enum TaskProgress {
  Pending,
  InProgress,
  Completed,
}

extension TaskProgressExtension on TaskProgress {
  int get rawValue {
    switch (this) {
      case TaskProgress.Pending:
        return 0;
      case TaskProgress.InProgress:
        return 1;
      case TaskProgress.Completed:
        return 2;
    }
  }
}

class TaskProgressBar extends StatelessWidget {
  final TaskProgress progress;

  const TaskProgressBar({super.key, required this.progress});
  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(2.5)),
      height: 2,
      width: double.infinity,
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              color: BrandColors().primary,
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              color: progress.rawValue > 0
                  ? BrandColors().primary
                  : Colors.grey.shade300,
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              color: progress.rawValue > 1
                  ? BrandColors().primary
                  : Colors.grey.shade300,
            ),
          ),
        ],
      ),
    );
  }
}
