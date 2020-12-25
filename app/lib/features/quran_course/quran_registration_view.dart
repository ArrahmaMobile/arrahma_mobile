import 'package:arrahma_shared/shared.dart';
import 'package:flutter/material.dart';

class QuranRegistrationView extends StatelessWidget {
  const QuranRegistrationView({
    Key key,
    @required this.registration,
  }) : super(key: key);
  final QuranCourseRegistration registration;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ConstrainedBox(
          constraints: const BoxConstraints(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'IMP: After you submit the form, you should receive a confirmation email. If you do not receive it,'
                'please check your junk email or re-register with correct email address.',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              ),
              const SizedBox(height: 20),
              const Text(
                'Prerequisites:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Have you completed Taleem ul Quran course?',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
