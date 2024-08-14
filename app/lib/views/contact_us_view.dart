import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsView extends StatefulWidget {
  @override
  _ContactUsViewState createState() => _ContactUsViewState();
}

class _ContactUsViewState extends State<ContactUsView> {
  TapGestureRecognizer? _openPhone;
  TapGestureRecognizer? _openUstazanaEmail;
  TapGestureRecognizer? _openGeneralInquiriesEmail;

  @override
  void initState() {
    super.initState();
    _openPhone = TapGestureRecognizer()
      ..onTap = () {
        launchUrl(Uri.parse('tel:+1-(732)-443-0519'));
      };
    _openUstazanaEmail = TapGestureRecognizer()
      ..onTap = () {
        launchUrl(Uri.parse('mailto:ustazanajihahashmi@gmail.com'));
      };
    _openGeneralInquiriesEmail = TapGestureRecognizer()
      ..onTap = () {
        launchUrl(Uri.parse('mailto:arrahmaclass@gmail.com'));
      };
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            const FaIcon(
              FontAwesomeIcons.phone,
              size: 32,
            ),
            const SizedBox(height: 10),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: theme.textTheme.bodyMedium,
                children: <TextSpan>[
                  const TextSpan(text: 'Help Desk #'),
                  TextSpan(
                    text: '1-(732)-443-0519',
                    recognizer: _openPhone,
                    style: const TextStyle(
                      color: Color(0xFF124570),
                    ),
                  ),
                  const TextSpan(text: 'For any information or query'),
                ],
              ),
            ),
            const SizedBox(height: 15),
            const FaIcon(
              FontAwesomeIcons.whatsapp,
              size: 32,
            ),
            const SizedBox(height: 10),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: theme.textTheme.bodyMedium,
                children: <TextSpan>[
                  const TextSpan(
                      text:
                          'For information about our courses and general Inquiries, contact us on WhatsApp:'),
                  TextSpan(
                    text: '1-(732)-305-0744',
                    // recognizer: ,
                    style: const TextStyle(
                      color: Color(0xFF124570),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            const FaIcon(
              FontAwesomeIcons.solidEnvelope,
              size: 32,
            ),
            const SizedBox(height: 10),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: theme.textTheme.bodyMedium,
                children: <TextSpan>[
                  const TextSpan(text: 'For general Inquiries:'),
                  TextSpan(
                    text: 'arrahmaclass@gmail.com',
                    recognizer: _openGeneralInquiriesEmail,
                    style: const TextStyle(
                      color: Color(0xFF124570),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            const FaIcon(
              FontAwesomeIcons.mailBulk,
              size: 32,
            ),
            const SizedBox(height: 10),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: theme.textTheme.bodyMedium,
                children: <TextSpan>[
                  const TextSpan(
                      text:
                          'For any complaints, suggestions or questions directly to Ustaza, Please email at '),
                  TextSpan(
                    text: 'ustazanajihahashmi@gmail.com',
                    recognizer: _openUstazanaEmail,
                    style: const TextStyle(
                      color: Color(0xFF124570),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 55),
            const Text(
              'Your emails will be confidential and will be received by Ustaza only.',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
