import 'package:done_today/reusable_ui/brand_colors.dart';
import 'package:flutter/material.dart';

typedef OnSegmentSelected = void Function(int selectedIndex);

class SegmentedController extends StatefulWidget {
  final OnSegmentSelected onSegmentSelected;

  const SegmentedController({Key? key, required this.onSegmentSelected})
      : super(key: key);

  @override
  _SegmentedControllerState createState() => _SegmentedControllerState();
}

class _SegmentedControllerState extends State<SegmentedController> {
  int selectedIndex = 0;

  Color selectedColor = BrandColors().primary;
  Color unselectedColor = Colors.grey.shade200;

  Color selectedTextColor = Colors.white;
  Color unselectedTextColor = Colors.grey.shade600;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedIndex = 0;
                });
                widget.onSegmentSelected(selectedIndex);
              },
              child: Container(
                color: selectedIndex == 0 ? selectedColor : unselectedColor,
                padding: EdgeInsets.all(10),
                child: Center(
                  child: Icon(
                    Icons.lock,
                    color: selectedIndex == 0
                        ? selectedTextColor
                        : unselectedTextColor,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedIndex = 1;
                });
                widget.onSegmentSelected(selectedIndex);
              },
              child: Container(
                color: selectedIndex == 1 ? selectedColor : unselectedColor,
                padding: EdgeInsets.all(10),
                child: Center(
                  child: Icon(
                    Icons.diversity_3,
                    color: selectedIndex == 1
                        ? selectedTextColor
                        : unselectedTextColor,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedIndex = 2;
                });
                widget.onSegmentSelected(selectedIndex);
              },
              child: Container(
                color: selectedIndex == 2 ? selectedColor : unselectedColor,
                padding: EdgeInsets.all(10),
                child: Center(
                  child: Icon(
                    Icons.public,
                    color: selectedIndex == 2
                        ? selectedTextColor
                        : unselectedTextColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
