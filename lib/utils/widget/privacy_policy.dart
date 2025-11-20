import 'package:flutter/material.dart';
import 'package:sportspark/utils/const/const.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.bluePrimaryDual,
        elevation: 0,
        
        title: const Text(
          'Privacy Policy',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: false,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Third-Party Advertising Partners'),
            _buildText(
                'We may work with third-party ad servers or ad networks that use technologies like cookies, JavaScript, or web beacons in advertisements and links on LearnFort Sports Park. These technologies help measure campaign effectiveness and personalize ads. These third parties automatically receive your IP address when this occurs. LearnFort Sports Park has no access to or control over cookies used by third-party advertisers.'),

            const SizedBox(height: 16),
            _buildText(
                'Our Privacy Policy does not apply to other advertisers or websites. We advise you to review the privacy policies of these third-party ad servers for more information, including how to opt out.'),

            _buildSectionTitle('Children\'s Privacy'),
            _buildText(
                'We do not knowingly collect personally identifiable information from children. We encourage parents and guardians to monitor their children\'s online activity. If you believe your child has provided personal information on our platform, please contact us immediately, and we will promptly remove it.'),

            _buildSectionTitle('Information We Collect'),
            _buildText(
                'We only collect personal information that you voluntarily provide, such as when you:\n• Register an account\n• Fill out a form\n• Contact us via the website\n\nThis may include your name, email address, phone number, and other contact details.'),

            _buildSectionTitle('How We Use Your Information'),
            _buildBullet('To provide the services you request (registration, inquiries, etc.)'),
            _buildBullet('To improve your experience on our website'),
            _buildBullet(
                'To send you occasional marketing emails (newsletters, promotions). You can unsubscribe anytime using the link at the bottom of any email.'),

            _buildSectionTitle('Sharing Your Information'),
            _buildText('We may share your information only in these cases:'),
            _buildBullet(
                'With trusted service providers (e.g., hosting, email services) who help us operate the website'),
            _buildBullet(
                'With law enforcement if required by law or to protect our rights and safety'),

            _buildSectionTitle('This Policy Applies Only Online'),
            _buildText(
                'This Privacy Policy applies only to our online activities and information collected through learnfort.in or our mobile app. It does not apply to information collected offline.'),

            const SizedBox(height: 20),
            _buildSectionTitle('Your Consent'),
            _buildText(
                'By using LearnFort Sports Park website or app, you consent to this Privacy Policy and agree to its terms.'),

            const SizedBox(height: 30),
            Center(
              child: Text(
                'Last updated: November 2025',
                style: TextStyle(
                  color: AppColors.textLight,
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 20),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.bluePrimaryDual,
        ),
      ),
    );
  }

  Widget _buildText(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 15,
        height: 1.6,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildBullet(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '• ',
            style: TextStyle(
              fontSize: 15,
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 15,
                height: 1.6,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}