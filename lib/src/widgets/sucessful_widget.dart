import 'package:flutter/material.dart';
import 'package:flutter_paystack/src/common/utils.dart';
import 'package:flutter_paystack/src/widgets/animated_widget.dart';

class SuccessfulWidget extends StatefulWidget {
  final int amount;
  final VoidCallback onCountdownComplete;

  SuccessfulWidget({@required this.amount, @required this.onCountdownComplete});

  @override
  _SuccessfulWidgetState createState() {
    return  _SuccessfulWidgetState();
  }
}

class _SuccessfulWidgetState extends State<SuccessfulWidget>
    with TickerProviderStateMixin {
  final sizedBox = const SizedBox(height: 20.0);
  AnimationController _mainController;
  AnimationController _opacityController;
  Animation<double> _opacity;

  static const int kStartValue = 4;
  AnimationController _countdownController;
  Animation _countdownAnim;

  @override
  void initState() {
    super.initState();
    _mainController =  AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _mainController.forward();

    _countdownController =  AnimationController(
      vsync: this,
      duration:  Duration(seconds: kStartValue),
    );
    _countdownController.addListener(() => setState(() {}));
    _countdownAnim =
         StepTween(begin: kStartValue, end: 0).animate(_countdownController);

    _opacityController =  AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _opacity =
         CurvedAnimation(parent: _opacityController, curve: Curves.linear)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              _opacityController.reverse();
            } else if (status == AnimationStatus.dismissed) {
              _opacityController.forward();
            }
          });

    WidgetsBinding.instance.addPostFrameCallback((_) => _startCountdown());
  }

  @override
  void dispose() {
    _mainController.dispose();
    _countdownController.dispose();
    _opacityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accentColor = Theme.of(context).accentColor;
    return  Container(
      child:  CustomAnimatedWidget(
        controller: _mainController,
        child:  Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            sizedBox,
             Image.asset(
              'assets/images/successful.png',
              color: accentColor,
              width: 50.0,
              package: 'flutter_paystack',
            ),
            sizedBox,
            const Text(
              'Payment Successful',
              style: const TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w500,
                fontSize: 16.0,
              ),
            ),
             SizedBox(
              height: 5.0,
            ),
            widget.amount == null || widget.amount.isNegative
                ?  Container()
                :  Text('You paid ${Utils.formatAmount(widget.amount)}',
                    style: const TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.normal,
                      fontSize: 14.0,
                    )),
            sizedBox,
             FadeTransition(
              opacity: _opacity,
              child:  Text(
                _countdownAnim.value.toString(),
                style: TextStyle(
                    color: accentColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 25.0),
              ),
            ),
             SizedBox(
              height: 30.0,
            )
          ],
        ),
      ),
    );
  }

  void _startCountdown() {
    if (_countdownController.isAnimating ||
        _countdownController.isCompleted ||
        !mounted) {
      return;
    }
    _countdownController.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        widget.onCountdownComplete();
      }
    });
    _countdownController.forward();
    _opacityController.forward();
  }
}
