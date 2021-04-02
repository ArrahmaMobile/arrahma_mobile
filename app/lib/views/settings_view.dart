import 'package:arrahma_mobile_app/core/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_framework/flutter_framework.dart';
import 'package:inherited_state/inherited_state.dart';

class SettingsView extends StatefulWidget {
  @override
  _SettingsViewState createState() => _SettingsViewState();

  static const FEEDBACK_HOOK =
      '827337623088660480/xx6EgYsmK-GI_PBaZ-nOO4unO506WwLYt382CGJpMlrmslw1UL8HqCFmI0i7G3Sb6Ehd';
}

class _SettingsViewState extends State<SettingsView> {
  final storageService = SL.get<IStorageService>();
  final feedbackService = SL.get<FeedbackService>();

  ReactiveController<UserPreferences> userPrefCtrl;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    userPrefCtrl = RS.getReactive<UserPreferences>(context, subscribe: true);
  }

  UserPreferences _updatePref(
      UserPreferences Function(UserPreferences) prefUpdateFn) {
    userPrefCtrl.setState((pref) => prefUpdateFn(pref));
    final pref = userPrefCtrl.state;
    storageService.set(pref);
    return pref;
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);
    final themeMode = userPrefCtrl.state.themePerference.themeMode;
    return SingleChildScrollView(
      padding:
          appTheme.pagePadding.add(const EdgeInsets.symmetric(vertical: 20)),
      child: Column(
        children: [
          ListTile(
            leading: Icon(themeMode == ThemeMode.dark
                ? Icons.brightness_low
                : themeMode == ThemeMode.light
                    ? Icons.brightness_high
                    : Icons.brightness_auto),
            title: const Text('Theme Mode'),
            trailing: Text(
              EnumUtils.enumToString(themeMode, true),
              style: TextStyle(color: Colors.grey.shade500),
            ),
            onTap: () => _updatePref((pref) => pref.copyWith(
                themePerference: pref.themePerference.copyWith(
                    themeMode: ThemeMode.values[
                        (themeMode.index + 1) % ThemeMode.values.length]))),
          ),
          const Divider(thickness: 2),
          if (!AppUtils.isWeb)
            ListTile(
              leading: const Icon(Icons.bug_report),
              title: const Text('Report Bug/Feedback'),
              onTap: () => feedbackService.sendInfo(context,
                  SettingsView.FEEDBACK_HOOK, userPrefCtrl.state.userIdentity),
            ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('About'),
            onTap: () => NavigationUtils.pushView<dynamic>(
              context,
              AboutView(
                onSend: () => feedbackService.sendInfo(
                    context,
                    SettingsView.FEEDBACK_HOOK,
                    userPrefCtrl.state.userIdentity),
              ),
              padding: EdgeInsets.zero,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.support),
            title: const Text('Contact Us'),
            onTap: () => Utils.pushContactSupportView(context),
          ),
        ],
      ),
    );
  }
}
