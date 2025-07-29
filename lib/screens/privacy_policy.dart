import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sugar Team'),
        backgroundColor: Colors.grey,
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Privacy Policy',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Effective date: June 2024',
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              SizedBox(height: 20),
              Text(
                'At our team, we are committed to protecting your privacy. This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you use our mobile applications including Sweet Billions and website. By using our services, you agree to the collection and use of information in accordance with this policy.',
                style: TextStyle(fontSize: 16, color: Colors.black87, height: 1.5),
              ),
              SizedBox(height: 24),

              Text(
                'Information We Collect',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              SizedBox(height: 10),
              Text(
                '• Personal Data: We may collect information such as your device ID, IP address, and, if you contact us, your email address.\n'
                    '• Usage Data: We collect data on how you interact with our apps, including gameplay statistics, device information, and crash reports.\n'
                    '• Cookies & Tracking: We may use cookies and similar tracking technologies to monitor activity and store certain information.',
                style: TextStyle(fontSize: 16, color: Colors.black87, height: 1.5),
              ),
              SizedBox(height: 24),

              Text(
                'How We Use Your Information',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              SizedBox(height: 10),
              Text(
                '• To provide and maintain our services\n'
                    '• To improve and personalize user experience\n'
                    '• To analyze usage and trends\n'
                    '• To communicate with you, if you contact us\n'
                    '• To detect, prevent, and address technical issues',
                style: TextStyle(fontSize: 16, color: Colors.black87, height: 1.5),
              ),
              SizedBox(height: 24),

              Text(
                'Third-Party Services',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              SizedBox(height: 10),
              Text(
                'We use third-party analytics and advertising services to help us understand app usage and improve our products. These services may collect information sent by your device as part of a web page request, such as cookies or your IP address.\n\n'
                    '• AppsFlyer: We use AppsFlyer for analytics and attribution. For more information, please review their Privacy Policy.\n'
                    '• AppMetrica: We use AppMetrica for analytics. For more information, please review their Privacy Policy.',
                style: TextStyle(fontSize: 16, color: Colors.black87, height: 1.5),
              ),
              SizedBox(height: 24),

              Text(
                'Advertising',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              SizedBox(height: 10),
              Text(
                'Our apps may display advertisements provided by third-party ad networks. These networks may use cookies and similar technologies to collect information about your device and your interests in order to show relevant ads.',
                style: TextStyle(fontSize: 16, color: Colors.black87, height: 1.5),
              ),
              SizedBox(height: 24),

              Text(
                "Children's Privacy",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              SizedBox(height: 10),
              Text(
                'We do not knowingly collect personal information from children under 13. If you believe your child has provided us with personal information, please contact us so we can remove it.',
                style: TextStyle(fontSize: 16, color: Colors.black87, height: 1.5),
              ),
              SizedBox(height: 24),

              Text(
                'Data Security',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              SizedBox(height: 10),
              Text(
                'We implement reasonable security measures to protect your information. However, no method of transmission over the Internet or electronic storage is 100% secure.',
                style: TextStyle(fontSize: 16, color: Colors.black87, height: 1.5),
              ),
              SizedBox(height: 24),

              Text(
                'International Transfers',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              SizedBox(height: 10),
              Text(
                'Your information may be transferred to and maintained on servers located outside your country. By using our services, you consent to such transfers.',
                style: TextStyle(fontSize: 16, color: Colors.black87, height: 1.5),
              ),
              SizedBox(height: 24),

              Text(
                'Changes to This Policy',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              SizedBox(height: 10),
              Text(
                'We may update our Privacy Policy from time to time. We will notify you of any changes by posting the new policy on this page.',
                style: TextStyle(fontSize: 16, color: Colors.black87, height: 1.5),
              ),
              SizedBox(height: 24),

              Text(
                'Disclaimer',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              SizedBox(height: 10),
              Text(
                'We are not responsible for the content, privacy practices, or security of any third-party ads, links, or websites that may appear in our apps. Please review the privacy policies of those third parties before providing any information.',
                style: TextStyle(fontSize: 16, color: Colors.black87, height: 1.5),
              ),
              SizedBox(height: 24),

              Text(
                'Contact Us',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              SizedBox(height: 10),
              Text(
                'If you have any questions about this Privacy Policy, please contact us at email@sugar78.com.',
                style: TextStyle(fontSize: 16, color: Colors.black87, height: 1.5),
              ),
              SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}


