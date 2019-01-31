import 'package:flutter/material.dart';

import 'package:frideos/frideos.dart';

class BlurPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Blur'),
      ),
      body: Container(
        color: Colors.blue[800],
        child: Column(
          children: <Widget>[
            Container(
              height: 12.0,
            ),
            Expanded(
              child: LinearTransition(
                transitionDuration: 1000,
                firstWidget: Container(),
                secondWidget: BlurWidget(
                  sigmaX: 2.0,
                  sigmaY: 3.0,
                  child: Container(
                    color: Colors.blue[800],
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Text('Fixed blur', style: TextStyle(fontSize: 34.0)),
                        FlutterLogo(
                          size: 64.0,
                        ),
                        Container(
                          height: 12.0,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: BlurInWidget(
                      initialSigmaX: 2.0,
                      initialSigmaY: 22.0,
                      child: Container(
                        color: Colors.blue[800],
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Text('Blur in', style: TextStyle(fontSize: 34.0)),
                            FlutterLogo(
                              size: 64.0,
                            ),
                            Container(
                              height: 22.0,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: BlurOutWidget(
                      finalSigmaX: 2.0,
                      finalSigmaY: 12.0,
                      child: Container(
                        color: Colors.blue[800],
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Text('Blur out', style: TextStyle(fontSize: 34.0)),
                            FlutterLogo(
                              size: 64.0,
                            ),
                            Container(
                              height: 22.0,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: LinearTransition(
                transitionDuration: 1000,
                firstWidget: Container(),
                secondWidget: Container(
                  child: AnimatedBlurWidget(
                    finalSigmaY: 12.0,
                    child: Container(
                      alignment: Alignment.center,
                      child: WavesWidget(
                        width: MediaQuery.of(context).size.width,
                        color: Colors.blue,
                        child: Container(
                          color: Colors.blue[800],
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Text('Animated blur',
                                  style: TextStyle(fontSize: 34.0)),
                              FlutterLogo(
                                size: 64.0,
                              ),
                              Container(
                                height: 22.0,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
