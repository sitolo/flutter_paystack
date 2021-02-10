import 'package:flutter/material.dart';

class WhiteButton extends _BaseButton {
  final bool flat;
  final IconData iconData;
  final bool bold;

  WhiteButton({
    @required VoidCallback onPressed,
    String text,
    Widget child,
    this.flat = false,
    this.bold = true,
    this.iconData,
  }) : super(
          onPressed: onPressed,
          showProgress: false,
          text: text,
          child: child,
          iconData: iconData,
          textStyle:  TextStyle(
              fontSize: 14.0,
              color: Colors.black87.withOpacity(0.8),
              fontWeight: bold ? FontWeight.bold : FontWeight.normal),
          color: Colors.white,
          borderSide: flat
              ? BorderSide.none
              : const BorderSide(color: Colors.grey, width: 0.5),
        );
}

class AccentButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final bool showProgress;

  AccentButton({
    Key key,
    @required this.onPressed,
    @required this.text,
    this.showProgress = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _BaseButton(
      onPressed: onPressed,
      showProgress: showProgress,
      color: Theme.of(context).accentColor,
      borderSide: BorderSide.none,
      textStyle: const TextStyle(
          fontSize: 14.0, color: Colors.white, fontWeight: FontWeight.bold),
      text: text,
    );
  }
}

class _BaseButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final bool showProgress;
  final TextStyle textStyle;
  final Color color;
  final BorderSide borderSide;
  final IconData iconData;
  final Widget child;

  _BaseButton({
    @required this.onPressed,
    @required this.showProgress,
    @required this.text,
    @required this.textStyle,
    @required this.color,
    @required this.borderSide,
    this.iconData,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    const borderRadius = const BorderRadius.all(Radius.circular(5.0));
    var textWidget;
    if (text != null) {
      textWidget =  Text(
        text,
        textAlign: TextAlign.center,
        style: textStyle,
      );
    }
    return  Container(
        width: double.infinity,
        height: 50.0,
        alignment: Alignment.center,
        decoration:  BoxDecoration(
          borderRadius: borderRadius,
          color: color,
        ),
        child:  Container(
          width: double.infinity,
          height: double.infinity,
          child:  FlatButton(
              onPressed: showProgress ? null : onPressed,
              shape:  RoundedRectangleBorder(
                  borderRadius: borderRadius, side: borderSide),
              child: showProgress
                  ?  Container(
                      width: 20.0,
                      height: 20.0,
                      child:  Theme(
                          data: Theme.of(context)
                              .copyWith(accentColor: Colors.white),
                          child:  CircularProgressIndicator(
                            strokeWidth: 2.0,
                          )),
                    )
                  : iconData == null
                      ? child == null ? textWidget : child
                      :  Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                             Icon(
                              iconData,
                              color: textStyle.color.withOpacity(0.5),
                            ),
                            const SizedBox(width: 2.0),
                            textWidget,
                          ],
                        )),
        ));
  }
}
