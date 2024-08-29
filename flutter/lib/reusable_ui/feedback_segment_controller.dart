import 'package:done_today/reusable_ui/brand_colors.dart';
import 'package:flutter/material.dart';

typedef OnSegmentSelected = void Function(int selectedIndex);

class FeedbackSegmentController extends StatefulWidget {
  final OnSegmentSelected onSegmentSelected;

  const FeedbackSegmentController({Key? key, required this.onSegmentSelected})
      : super(key: key);

  @override
  _FeedbackSegmentControllerState createState() =>
      _FeedbackSegmentControllerState();
}

class _FeedbackSegmentControllerState extends State<FeedbackSegmentController> {
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
                    child: Text(
                  "Not Great",
                  style: TextStyle(
                      color: selectedIndex == 0
                          ? selectedTextColor
                          : unselectedTextColor),
                )),
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
                    child: Text(
                  "Average",
                  style: TextStyle(
                      color: selectedIndex == 1
                          ? selectedTextColor
                          : unselectedTextColor),
                )),
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
                  child: Text(
                    "Awesome",
                    style: TextStyle(
                        color: selectedIndex == 2
                            ? selectedTextColor
                            : unselectedTextColor),
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
