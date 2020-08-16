import 'package:flutter/material.dart';

class ContactUs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Contact Us',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Image.asset(
                'assets/images/contact_us/contact_us_banner.png',
              ),
              Image.asset(
                'assets/images/contact_us/phone.png',
                height: 90.0,
                width: 100.0,
              ),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: theme.textTheme.bodyText2,
                  children: <TextSpan>[
                    const TextSpan(text: 'Help Desk #'),
                    const TextSpan(
                      text: '1-(732)-443-0519',
                      style: TextStyle(
                        color: Color(0xFF124570),
                      ),
                    ),
                    const TextSpan(text: ' For any information or query'),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              Image.asset(
                'assets/images/contact_us/whatsapp.png',
                height: 90.0,
                width: 100.0,
              ),
              const Text(
                'For information about our courses and general Inquiries, contact us on WhatsApp 1-(732)-305-0744',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 15),
              Image.asset(
                'assets/images/contact_us/arrahma_email.png',
                height: 90.0,
                width: 100.0,
              ),
              const Text(
                'For general Inquiries: arrahmaclass@gmail.com',
                style: TextStyle(color: Color(0xFF124570)),
              ),
              const SizedBox(height: 15),
              Image.asset(
                'assets/images/contact_us/ustaza_email.png',
                height: 90.0,
                width: 100.0,
              ),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: theme.textTheme.bodyText2,
                  children: <TextSpan>[
                    const TextSpan(
                        text:
                            'For any complaints, suggestions or questions directly to Ustaza, Please email at '),
                    const TextSpan(
                      text: 'ustazanajihahashmi@gmail.com',
                      style: TextStyle(
                        color: Color(0xFF124570),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                'Your emails will be confidential and will be received by Ustaza only.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
