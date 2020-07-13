import 'package:flutter/material.dart';

class ContactUs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: Text(
          'Contact Us',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10.0),
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
                    TextSpan(text: 'Help Desk #'),
                    TextSpan(
                      text: '1-(732)-443-0519',
                      style: new TextStyle(
                        color: Color(0xFF124570),
                      ),
                    ),
                    TextSpan(text: ' For any information or query'),
                  ],
                ),
              ),
              SizedBox(height: 15),
              Image.asset(
                'assets/images/contact_us/whatsapp.png',
                height: 90.0,
                width: 100.0,
              ),
              Text(
                'For information about our courses and general Inquiries, contact us on WhatsApp 1-(732)-305-0744',
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 15),
              Image.asset(
                'assets/images/contact_us/arrahma_email.png',
                height: 90.0,
                width: 100.0,
              ),
              Text(
                'For general Inquiries: arrahmaclass@gmail.com',
                style: new TextStyle(color: Color(0xFF124570)),
              ),
              SizedBox(height: 15),
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
                    TextSpan(
                        text:
                            'For any complaints, suggestions or questions directly to Ustaza, Please email at '),
                    TextSpan(
                      text: 'ustazanajihahashmi@gmail.com',
                      style: new TextStyle(
                        color: Color(0xFF124570),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15),
              Text(
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
