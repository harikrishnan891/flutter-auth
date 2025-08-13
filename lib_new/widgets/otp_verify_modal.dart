import 'dart:async';
import 'package:flutter/material.dart';

class OTPVerifyModal extends StatefulWidget {
  final bool isEmail;
  final String contact; // email or mobile to mask
  final Function(String otp) onSubmit; // callback to parent
  final VoidCallback onCancel;
  final VoidCallback onResend;

  const OTPVerifyModal({
    Key? key,
    required this.isEmail,
    required this.contact,
    required this.onSubmit,
    required this.onCancel,
    required this.onResend,
  }) : super(key: key);

  @override
  _OTPVerifyModalState createState() => _OTPVerifyModalState();
}

class _OTPVerifyModalState extends State<OTPVerifyModal>
    with SingleTickerProviderStateMixin {
  final _otpController = TextEditingController();
  int _secondsRemaining = 60;
  Timer? _timer;
  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _startTimer();

    _animController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeInOut);
    _animController.forward();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _otpController.dispose();
    _animController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _secondsRemaining = 60;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        _timer?.cancel();
      }
    });
  }

  String _maskContact(String value) {
    if (widget.isEmail) {
      var parts = value.split('@');
      if (parts[0].length > 2) {
        return parts[0][0] +
            '*' * (parts[0].length - 2) +
            parts[0].substring(parts[0].length - 1) +
            '@' +
            parts[1];
      }
      return value;
    } else {
      // Mask mobile
      return value.replaceRange(2, value.length - 2, '*' * (value.length - 4));
    }
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnim,
      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Icon(Icons.verified_user, color: widget.isEmail ? Colors.blue : Colors.green),
            const SizedBox(width: 10),
            Text(
              widget.isEmail ? "Verify Email" : "Verify Mobile",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "We have sent an OTP to ${_maskContact(widget.contact)}",
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _otpController,
              keyboardType: TextInputType.number,
              maxLength: 6,
              decoration: InputDecoration(
                labelText: "Enter OTP",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                counterText: '',
              ),
            ),
            const SizedBox(height: 10),
            _secondsRemaining > 0
                ? Text("Resend OTP in $_secondsRemaining sec")
                : TextButton.icon(
                    onPressed: () {
                      widget.onResend();
                      _startTimer();
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text("Resend OTP"),
                  )
          ],
        ),
        actions: [
          TextButton(
            onPressed: widget.onCancel,
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              if (_otpController.text.length == 6) {
                widget.onSubmit(_otpController.text);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Enter a valid 6-digit OTP")),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text("Verify"),
          ),
        ],
      ),
    );
  }
}
