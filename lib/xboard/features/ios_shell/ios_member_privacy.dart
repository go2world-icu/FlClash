import 'package:fl_clash/common/common.dart';
import 'package:flutter/widgets.dart';

import 'ios_member_strings.dart';

Future<void> showIosMemberPrivacy(BuildContext context) => dialogs.showAlert(
  title: context.iosMemberStrings.privacy,
  message: TextSpan(text: context.iosMemberStrings.privacyDetails),
);
