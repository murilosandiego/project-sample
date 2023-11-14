import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  const AppButton.primary({
    required this.label,
    this.onPressed,
    this.isLoading = false,
  }) : _primary = true;

  const AppButton.secondary({
    required this.label,
    this.onPressed,
    this.isLoading = false,
  }) : _primary = false;

  final String label;
  final bool isLoading;
  final Function()? onPressed;
  final bool _primary;

  @override
  Widget build(BuildContext context) {
    return _primary
        ? SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isLoading ? null : onPressed,
              child: isLoading
                  ? SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(),
                    )
                  : Text(label),
            ),
          )
        : TextButton(
            onPressed: isLoading ? null : onPressed,
            child: isLoading
                ? SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(),
                  )
                : Text(label),
          );
  }
}
