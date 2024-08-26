import 'package:done_today/api_client.dart';
import 'package:done_today/reusable_ui/brand_colors.dart';
import 'package:done_today/reusable_ui/segmented_controller.dart';
import 'package:flutter/material.dart';

class NewPostBottomSheet extends StatefulWidget {
  @override
  _NewPostBottomSheetState createState() => _NewPostBottomSheetState();
}

class _NewPostBottomSheetState extends State<NewPostBottomSheet> {
  int privacySettingIndex = 0;
  TextEditingController _controller = TextEditingController();

  var isPosting = false;

  var privacyDefinitions = [
    {
      "title": "Unlisted",
      "description": "Only people with the link can see this post."
    },
    {
      "title": "Neighbors",
      "description":
          "People that you have worked with or connected with can see this post."
    },
    {"title": "Public", "description": "Everyone can see this post."}
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'What Can We Help You With?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  onChanged: (value) {
                    if (value.contains("\n")) {
                      _controller.text = value.replaceAll("\n", "");
                      FocusScope.of(context).unfocus();
                    }
                  },
                  decoration: InputDecoration(
                    hintText:
                        'I need help pulling weeds and fixing up some landscaping. It should be about 2 hours of work.',
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.all(10),
                  ),
                  maxLines: 4, // Add this line to allow multiple lines
                  controller: _controller,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: SegmentedController(
                onSegmentSelected: (selectedIndex) {
                  setState(() {
                    privacySettingIndex = selectedIndex;
                  });
                },
              ),
            ),
            Container(
              height: 200,
              child: Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      privacyDefinitions[privacySettingIndex]["title"]!,
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    Text(privacyDefinitions[privacySettingIndex]
                        ["description"]!),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      Positioned(
          left: 15,
          right: 15,
          bottom: MediaQuery.of(context).padding.bottom + 15,
          child: Container(
            width: double
                .infinity, // Makes the Container fill the width of its parent
            child: isPosting
                ? Center(child: CircularProgressIndicator())
                : TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: BrandColors().primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            10), // Set the desired corner radius here
                      ),
                    ),
                    onPressed: () async {
                      if (_controller.text.isEmpty) {
                        setState(() {
                          isPosting = false;
                        });
                        return;
                      }
                      setState(() {
                        isPosting = true;
                      });
                      var success = await ApiClient().createTask(
                          _controller.text,
                          privacyDefinitions[privacySettingIndex]["title"]!);
                      if (success) {
                        Navigator.of(context).pop();
                      }
                    },
                    child: Text(
                      'Create Task',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ),
          ))
    ]);
  }
}
