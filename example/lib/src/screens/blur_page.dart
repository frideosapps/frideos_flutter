import 'package:flutter/material.dart';

import 'package:frideos/frideos.dart';

class BlurPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blur'),
      ),
      body: Container(
        color: Colors.blue[800],
        child: Column(
          children: <Widget>[
            Container(
              height: 12,
            ),
            Expanded(
              child: LinearTransition(
                transitionDuration: 1000,
                firstWidget: Container(),
                secondWidget: BlurWidget(
                  sigmaX: 2,
                  sigmaY: 3,
                  child: Container(
                    color: Colors.blue[800],
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        const Text('Fixed blur',
                            style: TextStyle(fontSize: 34)),
                        const FlutterLogo(
                          size: 64,
                        ),
                        Container(
                          height: 12,
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
                      initialSigmaX: 2,
                      initialSigmaY: 22,
                      child: Container(
                        color: Colors.blue[800],
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            const Text('Blur in',
                                style: TextStyle(fontSize: 34)),
                            const FlutterLogo(
                              size: 64,
                            ),
                            Container(
                              height: 22,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: BlurOutWidget(
                      finalSigmaX: 2,
                      finalSigmaY: 12,
                      child: Container(
                        color: Colors.blue[800],
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            const Text('Blur out',
                                style: TextStyle(fontSize: 34)),
                            const FlutterLogo(
                              size: 64,
                            ),
                            Container(
                              height: 22,
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
                    finalSigmaY: 12,
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
                              const Text('Animated blur',
                                  style: TextStyle(fontSize: 34)),
                              const FlutterLogo(
                                size: 64,
                              ),
                              Container(
                                height: 22,
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
