import 'package:flutter/material.dart';
import '../widgets/base_scaffold.dart';
import '../services/api_service.dart';
import 'dashboard_screen.dart';

class PostRegisterSteps extends StatefulWidget {
  final String name;
  final String pen;
  final String mobile;
  final String email;

  const PostRegisterSteps({
    Key? key,
    required this.name,
    required this.pen,
    required this.mobile,
    required this.email,
  }) : super(key: key);

  @override
  State<PostRegisterSteps> createState() => _PostRegisterStepsState();
}

class _PostRegisterStepsState extends State<PostRegisterSteps> {
  bool _emailVerified = false;
  bool _mobileVerified = false;
  bool _sendingEmail = false;
  bool _sendingMobile = false;

  Future<void> _startEmailVerify() async {
    setState(() => _sendingEmail = true);
    final ok = await ApiService.sendEmailOtp(widget.email);
    setState(() => _sendingEmail = false);
    if (!ok) {
      _toast('Failed to send email OTP');
      return;
    }
    _openOtpDialog(
      title: 'Verify Email',
      hint: 'Enter 6-digit OTP from email',
      onSubmit: (otp) async {
        final verified = await ApiService.verifyEmailOtp(widget.email, otp);
        if (verified) {
          setState(() => _emailVerified = true);
          Navigator.of(context).pop(true);
          _toast('Email verified');
        } else {
          _toast('Invalid email OTP');
        }
      },
      onResend: () async {
        await ApiService.sendEmailOtp(widget.email);
      },
    );
  }

  Future<void> _startMobileVerify() async {
    setState(() => _sendingMobile = true);
    final ok = await ApiService.sendMobileOtp(widget.mobile);
    setState(() => _sendingMobile = false);
    if (!ok) {
      _toast('Failed to send mobile OTP');
      return;
    }
    _openOtpDialog(
      title: 'Verify Mobile',
      hint: 'Enter 6-digit OTP from SMS',
      onSubmit: (otp) async {
        final verified = await ApiService.verifyMobileOtp(widget.mobile, otp);
        if (verified) {
          setState(() => _mobileVerified = true);
          Navigator.of(context).pop(true);
          _toast('Mobile verified');
        } else {
          _toast('Invalid mobile OTP');
        }
      },
      onResend: () async {
        await ApiService.sendMobileOtp(widget.mobile);
      },
    );
  }

  void _openOtpDialog({
    required String title,
    required String hint,
    required Future<void> Function(String otp) onSubmit,
    required Future<void> Function() onResend,
  }) {
    final ctrl = TextEditingController();
    int seconds = 60;
    late final StateSetter setSt;
    final timer = TickerFuture;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return StatefulBuilder(builder: (ctx, setStateDialog) {
          setSt = setStateDialog;
          // simple countdown via periodic future
          Future.doWhile(() async {
            await Future.delayed(const Duration(seconds: 1));
            if (!Navigator.of(ctx).mounted) return false;
            if (seconds <= 0) return false;
            setStateDialog(() => seconds--);
            return seconds > 0;
          });
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            title: Text(title),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: ctrl,
                  maxLength: 6,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: hint,
                    counterText: '',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 10),
                seconds > 0
                    ? Text('Resend in ${seconds}s', style: const TextStyle(color: Colors.grey))
                    : TextButton.icon(
                        onPressed: () async {
                          setStateDialog(() => seconds = 60);
                          await onResend();
                        },
                        icon: const Icon(Icons.refresh),
                        label: const Text('Resend OTP'),
                      ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final otp = ctrl.text.trim();
                  if (otp.length != 6) {
                    _toast('Enter a valid 6-digit OTP');
                    return;
                  }
                  await onSubmit(otp);
                },
                child: const Text('Verify'),
              ),
            ],
          );
        });
      },
    );
  }

  void _toast(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: 'Profile & Verification',
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Your Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 12),
                      _kv('Name', widget.name),
                      _kv('PEN', widget.pen),
                      const Divider(),
                      _verifyRow(
                        label: 'Email',
                        value: widget.email,
                        verified: _emailVerified,
                        sending: _sendingEmail,
                        onVerify: _startEmailVerify,
                      ),
                      const SizedBox(height: 6),
                      _verifyRow(
                        label: 'Mobile',
                        value: widget.mobile,
                        verified: _mobileVerified,
                        sending: _sendingMobile,
                        onVerify: _startMobileVerify,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              if (_emailVerified && _mobileVerified)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const DashboardScreen()),
                      );
                    },
                    child: const Text('Continue to Dashboard'),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _kv(String k, String v) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(width: 120, child: Text(k, style: const TextStyle(fontWeight: FontWeight.w600))),
          const SizedBox(width: 8),
          Expanded(child: Text(v)),
        ],
      ),
    );
  }

  Widget _verifyRow({
    required String label,
    required String value,
    required bool verified,
    required bool sending,
    required VoidCallback onVerify,
  }) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Text(value, overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Icon(
          verified ? Icons.check_circle : Icons.warning,
          color: verified ? Colors.green : Colors.orange,
        ),
        const SizedBox(width: 8),
        if (!verified)
          ElevatedButton(
            onPressed: sending ? null : onVerify,
            child: sending ? const SizedBox(height: 16, width: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Text('Verify'),
          ),
      ],
    );
  }
}
