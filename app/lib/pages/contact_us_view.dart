import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ContactUsView extends StatelessWidget {
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
            const FaIcon(
              FontAwesomeIcons.whatsapp,
              size: 32,
            ),
            const Text(
              'For information about our courses and general Inquiries, contact us on WhatsApp 1-(732)-305-0744',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 15),
            const FaIcon(
              FontAwesomeIcons.solidEnvelope,
              size: 32,
            ),
            const Text(
              'For general Inquiries: arrahmaclass@gmail.com',
              style: TextStyle(color: Color(0xFF124570)),
            ),
            const SizedBox(height: 15),
            const FaIcon(
              FontAwesomeIcons.mailBulk,
              size: 32,
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
