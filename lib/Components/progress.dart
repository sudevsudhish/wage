import 'package:flutter/material.dart';

CircularProgress() {
  return Container(
    alignment: Alignment.center,
    padding: EdgeInsets.only(top: 10.0),
    child: CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation(
        Color(0xff2F2440),
      ),
    ),
  );
}

LinearProgress() {
  Container(
    alignment: Alignment.center,
    padding: EdgeInsets.only(bottom: 50.0),
    child: LinearProgressIndicator(
      valueColor: AlwaysStoppedAnimation(
        Colors.white,
      ),
    ),
  );
}
