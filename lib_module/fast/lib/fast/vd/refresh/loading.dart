import 'package:fast/gen/fast_l10n.dart';
import 'package:flutter/material.dart';

/// @author sunlunchang
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
            child:  Text(FastS.current.label_loading,
                style: Theme.of(context).dialogTheme.titleTextStyle),
          )
        ]));
  }
}
