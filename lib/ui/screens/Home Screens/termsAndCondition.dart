import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../constants/appImagePaths.dart';
import '../../../constants/colors.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        },
        iconSize: 32.r, // Adjust the size as needed
      ),iconTheme: IconThemeData(color: appThemeColor),centerTitle: true,
        title: Image.asset(AppImages.appLogo),),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Terms and Conditions',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Welcome to the TALAASH App. By using our services, you agree to the following terms and conditions:',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              '''
1. Your use of the app is at your own risk. The app is provided on an "as is" and "as available" basis.

2. Always use a safe place/crowded place for exchange items. It is for your own saftey.

3. We are not responsible for any lost or found items. The app is a platform for users to connect and exchange information about lost and found items.

4. Users must provide accurate and truthful information when submitting details about lost or found items.

5. Users should use the app with full responsibility and respect the privacy and rights of others.

6. We reserve the right to modify, suspend, or terminate the app at any time without prior notice.

7. By using the app, you agree to receive notifications and updates related to lost and found items.

8. We may collect and use your personal information in accordance with our privacy policy.

9. These terms and conditions may be updated from time to time. It is your responsibility to review them periodically.

10. Roman Urdu refers to write urdu words in english like words. Example subha/shaam/dopehar.

11. If you do not agree to these terms, please do not use the TALAASH App.
''',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}