import 'dart:async';

import 'package:calculadora_financeira/fadeRoute.dart';
import 'package:calculadora_financeira/screens/calculoFrequencia/calculoFrequenciaScreen.dart';
import 'package:flutter/material.dart';

class Splashscreen extends StatefulWidget{
  @override
  SplashscreenState createState()  => new SplashscreenState();
}

class SplashscreenState extends State<Splashscreen> with TickerProviderStateMixin{
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new _SplashscreenAnimation(MediaQuery.of(context).size),
    );
  }
}


class _SplashscreenAnimation extends StatefulWidget{
  final Size screenSize;
  _SplashscreenAnimation(this.screenSize);
  @override
  _SplashscreenAnimationState createState()  => new _SplashscreenAnimationState();
}

class _SplashscreenAnimationState extends State<_SplashscreenAnimation> with TickerProviderStateMixin{
  AnimationController _controller;
  AnimationController _controllerOpacity;
  Animation<double> _tweenPosition;
  Animation<double> _tweenOpacity;
  double _position;
  double _opacity;

  @override
    void initState() {
      // TODO: implement initState
      super.initState();
      _controller = new AnimationController(vsync: this, duration: new Duration(seconds: 2));
      _controllerOpacity = new AnimationController(vsync: this, duration: new Duration(seconds: 2));
      _tweenPosition = new Tween(begin: 100.0, end: 0.0).animate(_controller);
      _tweenOpacity = new Tween(begin: 0.0, end: 1.0).animate(_controllerOpacity);

      _controllerOpacity.addListener((){
        setState(() {
          if(_controllerOpacity.status == AnimationStatus.completed){
            new Future.delayed(new Duration(milliseconds: 200), (){
              new Future.delayed(new Duration(microseconds: 600), (){
                Navigator.of(context).pushReplacement(FadeRoute(builder: (context) => CalculoFrequenciaScreen()));
              });
            });
          }
          else
            _opacity = _tweenOpacity.value;
        });
      });
      _controller.addListener((){
        setState(() {
          if(_controller.status == AnimationStatus.completed){
            _controllerOpacity.forward();
          }
          else
            _position = _tweenPosition.value;
        });
      });
      _controller.forward();
    }

    @override
      void dispose() {
        // TODO: implement dispose
        super.dispose();
        _controller.dispose();
        _controllerOpacity.dispose();
      }
  @override
  Widget build(BuildContext context) {
    return new Center(
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Container(
            child: new Text('G', style: new TextStyle(fontSize: 100.0),),
          ),
          new Container(
            margin: new EdgeInsets.only(left: (widget.screenSize.width/3) * ((_position ?? 100)/ 100)),
            child: Opacity(
              opacity: _opacity ?? 0.0,
              child: new Text('2', style: new TextStyle(fontSize: 100.0),)
            ),
          ),
          new Container(
            child: new Text('X', style: new TextStyle(fontSize: 100.0),),
          ),
        ],
      ),
    );
  }
}