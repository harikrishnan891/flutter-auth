import 'package:flutter/material.dart';
import '../widgets/base_scaffold.dart';
import '../widgets/otp_verify_modal.dart';
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
  bool emailVerified = false;
  bool mobileVerified = false;

  void _openOTP(bool isEmail) {
    showDialog(
      context: context,
      builder: (_) => OTPVerifyModal(
        isEmail: isEmail,
        contact: isEmail ? widget.email : widget.mobile,
        onSubmit: (otp) {
          // TODO: call Node API to verify; simulate success:
          setState(() {
            if (isEmail) {
              emailVerified = true;
            } else {
              mobileVerified = true;
            }
          });
          Navigator.pop(context, true);
        },
        onCancel: () => Navigator.pop(context, false),
        onResend: () {
          // TODO: Node API to resend OTP
        },
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[600],
                  ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerificationRow({
    required String label,
    required String value,
    required bool verified,
    required VoidCallback onVerify,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[600],
                  ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          const SizedBox(width: 8),
          verified
              ? Icon(Icons.verified, color: Theme.of(context).primaryColor)
              : TextButton(
                  onPressed: onVerify,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(50, 30),
                  ),
                  child: const Text('Verify'),
                ),
        ],
      ),
    );
  }

  Widget _buildSecurityOption(String text, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[700]),
          const SizedBox(width: 12),
          Text(text, style: const TextStyle(fontSize: 14)),
          const Spacer(),
          Icon(Icons.chevron_right, color: Colors.grey[500]),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: 'Profile Verification',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Account Details',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const Divider(height: 24),
                _buildInfoRow('Full Name', widget.name),
                _buildInfoRow('PEN', widget.pen),
                const SizedBox(height: 16),
                Text(
                  'Verification',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const Divider(height: 24),
                _buildVerificationRow(
                  label: 'Email',
                  value: widget.email,
                  verified: emailVerified,
                  onVerify: () => _openOTP(true),
                ),
                _buildVerificationRow(
                  label: 'Mobile',
                  value: widget.mobile,
                  verified: mobileVerified,
                  onVerify: () => _openOTP(false),
                ),
                if (emailVerified && mobileVerified) ...[
                  const SizedBox(height: 32),
                  // Security Status Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.verified_user,
                                color: Theme.of(context).primaryColor),
                            const SizedBox(width: 12),
                            Text(
                              "2FA Security Status",
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const LinearProgressIndicator(
                          value: 1.0,
                          backgroundColor: Colors.grey,
                          color: Colors.green,
                          minHeight: 6,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Maximum Security Achieved",
                          style: TextStyle(
                              color: Colors.green[700],
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),

                  // Security Recommendation
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.security,
                                color: Colors.blue[700], size: 20),
                            const SizedBox(width: 8),
                            Text(
                              "PROTECT YOUR ACCOUNT",
                              style: TextStyle(
                                  color: Colors.blue[700],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "For enhanced security, enable backup authentication methods:",
                          style: TextStyle(color: Colors.black87),
                        ),
                        const SizedBox(height: 8),
                        _buildSecurityOption(
                            "Authenticator App", Icons.mobile_friendly),
                        _buildSecurityOption("Security Keys", Icons.usb),
                        _buildSecurityOption("Backup Codes", Icons.lock),
                      ],
                    ),
                  ),

                  // Continue Button
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DashboardScreen(),
                          ),
                        );
                      },
                      child: const Text("ACCESS SECURE DASHBOARD"),
                    ),
                  )
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
