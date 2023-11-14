import 'package:flutter/material.dart';

class AppErrorPage extends StatelessWidget {
  final String error;
  final Function() reload;

  const AppErrorPage({required this.error, required this.reload});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(error,
              style: TextStyle(fontSize: 16), textAlign: TextAlign.center),
          SizedBox(height: 10),
          // ignore: deprecated_member_use
          ElevatedButton(
            onPressed: reload,
            child: Text('Recarregar'),
          )
        ],
      ),
    );
  }
}
