import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../widgets/app_header.dart';
import '../widgets/app_footer.dart';
import 'dashboard_screen.dart';

class OTPInfoScreen extends StatefulWidget {
  final String email;
  final String mobile;
  const OTPInfoScreen({super.key, required this.email, required this.mobile});

  @override State<OTPInfoScreen> createState() => _OTPInfoScreenState();
}

class _OTPInfoScreenState extends State<OTPInfoScreen> {
  bool _done = false;

  @override
  void initState() {
    super.initState();
    // simulate few seconds of "sending" animation, then go to Dashboard
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() => _done = true);
      Future.delayed(const Duration(milliseconds: 800), () {
        if (!mounted) return;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const DashboardScreen()),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final maskedEmail = widget.email.replaceAll(RegExp(r'(?<=.).(?=[^@]*?@)'), '•');
    final m = widget.mobile.replaceAll(RegExp(r'\D'), '');
    final maskedMobile = m.length >= 10 ? '${m.substring(0,2)}••••••${m.substring(m.length-2)}' : '••••••••••';

    return Scaffold(
      appBar: const AppHeader(),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: width < 500 ? width - 32 : 460),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Verify your identity',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ).animate().fadeIn(duration: 250.ms).slideY(begin: -0.1, end: 0),
                  const SizedBox(height: 12),
                  Text(
                    'We’ve sent OTPs to your registered email and mobile number.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[700]),
                  ).animate().fadeIn(duration: 300.ms),
                  const SizedBox(height: 18),

                  _Row(label: 'Email', value: maskedEmail)
                      .animate().fadeIn(duration: 350.ms, delay: 80.ms),
                  const SizedBox(height: 8),
                  _Row(label: 'Mobile', value: maskedMobile)
                      .animate().fadeIn(duration: 350.ms, delay: 140.ms),

                  const SizedBox(height: 24),
                  _done
                      ? const Icon(Icons.check_circle, color: Colors.green, size: 42)
                          .animate().scale(duration: 300.ms)
                      : const SizedBox(
                          height: 28, width: 28,
                          child: CircularProgressIndicator(strokeWidth: 3),
                        ).animate().fadeIn(duration: 250.ms),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: const AppFooter(),
    );
  }
}

class _Row extends StatelessWidget {
  final String label; final String value;
  const _Row({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.black87),
          ),
        ),
      ],
    );
  }
}
