import 'dart:async';

import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const twentyFiveMinutes = 1500;
  int totalSeconds = twentyFiveMinutes;
  bool isRunning = false;
  bool isDialog = false;
  int count = 0;
  late Timer timer;

  void onTick(Timer timer) {
    setState(() {
      if (totalSeconds == 0) {
        count += 1;
        isRunning = false;
        totalSeconds = twentyFiveMinutes;
        timer.cancel();
      } else {
        totalSeconds = totalSeconds - 1;
      }
    });
  }

  void onClickedReset() {
    setState(() {
      isRunning = false;
      totalSeconds = twentyFiveMinutes;
      timer.cancel();
    });
  }

  Future<void> _showMyDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Reset'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: [
                Text('Would you like to Reset the timer?'),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                onClickedReset();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('No'),
              onPressed: () {
                onPausePressed();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void onStartPressed() {
    timer = Timer.periodic(
      const Duration(seconds: 1),
      onTick,
    );
    // the reason why there is no paranthesis on onTick void function is because
    // if you add (), then it means it will call function immediately
    // Timer will add paranthesis in every second.
    // isRunning = !isRunning; --> I can also change the image with this but way to slow
    // as setState is mentioned in onTick so there is an delay.
    // So it's better to create setState in thios method as well
    setState(() {
      isRunning = true;
    });
    // Then it will changed right after click the button.
  }
  // Timer time = Timer(const Duration(minutes: 25), handleTimeout);

  void onPausePressed() {
    timer.cancel();
    setState(() {
      isRunning = false;
    });
  }

  String format(int seconds) {
    var duration = Duration(seconds: seconds);

    return duration.toString().split('.')[0].substring(2, 7);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Flexible(
          flex: 1,
          child: Container(
            alignment: Alignment.bottomCenter,
            child: Text(
              format(totalSeconds),
              style: TextStyle(
                  color: Theme.of(context).cardColor,
                  fontSize: 40,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ),
        Flexible(
          flex: 3,
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 200),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      onPressed: isRunning ? onPausePressed : onStartPressed,
                      icon: Icon(
                        isRunning
                            ? Icons.pause_circle_outline
                            : Icons.play_circle_outline,
                        size: 98,
                        color: Theme.of(context).cardColor,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        timer.cancel();
                        _showMyDialog(context);
                      },
                      icon: Icon(
                        Icons.restore,
                        size: 98,
                        color: Theme.of(context).cardColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Flexible(
          flex: 1,
          child: Row(
            children: [
              Expanded(
                child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Theme.of(context).cardColor,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Pomodoros',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color:
                                Theme.of(context).textTheme.displayLarge!.color,
                          ),
                        ),
                        Text(
                          '$count',
                          style: TextStyle(
                            fontSize: 58,
                            fontWeight: FontWeight.w600,
                            color:
                                Theme.of(context).textTheme.displayLarge!.color,
                          ),
                        ),
                      ],
                    )),
              ),
            ],
          ),
        ),
      ],
    ));
  }
}
