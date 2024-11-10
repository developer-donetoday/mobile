import 'dart:async';
import 'dart:ffi';

import 'package:done_today/api_client.dart';
import 'package:done_today/datatypes/profile.dart';
import 'package:done_today/mvp/profile_continue_view.dart';
import 'package:done_today/mvp/task_list_view.dart';
import 'package:done_today/reusables/circular_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_alert/flutter_platform_alert.dart';
import 'package:google_fonts/google_fonts.dart';

class OnboardingView extends StatefulWidget {
  @override
  _OnboardingViewState createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  TextEditingController _codeController = TextEditingController();
  bool processOccuring = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ApiClient().getProfile(null).then((profile) {
      if (profile != null) {
        setState(() {
          processOccuring = true;
        });
        processOccuring = false;
        Timer(Duration(seconds: 1), () {
          showProfileContinueSheet(profile);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    processOccuring = false;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.fromLTRB(
            40.0, MediaQuery.of(context).viewPadding.top + 120, 40.0, 0),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    "GET YOUR WORK\nDONE TODAY",
                    style: GoogleFonts.montserrat(
                        fontSize: 32, fontWeight: FontWeight.w800, height: 1),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              child: processOccuring
                  ? CircularProgressIndicator(
                      color: Colors.greenAccent.shade700,
                    )
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Start with your ambassador provided onboarding welcome code",
                          style: GoogleFonts.roboto(
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                          width: 100,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextField(
                            style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.w900,
                                fontSize: 24,
                                letterSpacing: 5),
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            controller: _codeController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                            ),
                            cursorColor: Colors.transparent,
                            onChanged: (value) async {
                              if (value.length == 4) {
                                setState(() {
                                  processOccuring = true;
                                });
                                FocusScope.of(context).unfocus();
                                Profile? profile =
                                    await ApiClient().useCode(value);
                                if (profile != null) {
                                  showProfileContinueSheet(profile);
                                } else {
                                  await FlutterPlatformAlert.showAlert(
                                    windowTitle: '$value is not valid',
                                    text: '',
                                    alertStyle: AlertButtonStyle.ok,
                                    iconStyle: IconStyle.information,
                                  );
                                  _codeController.clear();
                                }
                              }
                            },
                          ),
                        ),
                      ],
                    ),
            )
          ],
        ),
      ),
    );
  }

  void showProfileContinueSheet(Profile profile) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => ProfileContinueView(profile: profile),
    ));
  }
}
