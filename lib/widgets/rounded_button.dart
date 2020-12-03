import 'package:ble_pathfinder/utils/size_config.dart';
import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  const RoundedButton({
    Key key,
    this.btnText,
    this.btnColor,
    this.btnFunction,
  }) : super(key: key);

  final String btnText;
  final Color btnColor;
  final Function btnFunction;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: getProportionateScreenHeight(56),
      child: FlatButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        color: btnColor,
        onPressed: btnFunction,
        child: Text(
          btnText,
          style: TextStyle(
            fontSize: getProportionateScreenWidth(18),
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
