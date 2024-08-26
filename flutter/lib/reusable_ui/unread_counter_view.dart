import 'package:done_today/reusable_ui/brand_colors.dart';
import 'package:flutter/material.dart';

class UnreadCounterView extends StatefulWidget {
  final int count;

  UnreadCounterView({required this.count});

  @override
  _UnreadCounterViewState createState() => _UnreadCounterViewState();
}

class _UnreadCounterViewState extends State<UnreadCounterView> {
  @override
  Widget build(BuildContext context) {
    bool areMessages = widget.count > 0;
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: areMessages ? BrandColors().primary : Colors.grey.shade300,
      ),
      child: Center(
        child: Text(
          widget.count == -1 ? "" : widget.count.toString(),
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
