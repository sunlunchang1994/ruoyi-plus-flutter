import 'package:flutter/material.dart';

/// @Author sunlunchang
class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
           const CircularProgressIndicator(),
           Padding(
            padding: const EdgeInsets.only(
              top: 16,
            ),
            child:  Text("正在加载...",
                style: Theme.of(context).dialogTheme.titleTextStyle),
          )
        ]));
  }
}
