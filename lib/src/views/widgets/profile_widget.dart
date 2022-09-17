import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_ix/src/l10n/lang.dart';
import 'package:smart_ix/src/models/user.dart';
import 'package:smart_ix/src/providers/current_user_provider.dart';
import 'package:smart_ix/src/providers/locale_provider.dart';
import 'package:smart_ix/src/providers/theme_provider.dart';
import 'package:smart_ix/src/utils/build_context_x.dart';
import 'package:smart_ix/src/views/edit_profile_page.dart';
import 'package:smart_ix/src/views/login_page.dart';
import 'package:smart_ix/src/views/widgets/container_decoration.dart';
import 'package:smart_ix/src/views/widgets/main_button.dart';
import 'package:smart_ix/src/views/widgets/main_dropdown_button.dart';

class ProfileWidget extends StatefulWidget {
  const ProfileWidget({Key? key}) : super(key: key);

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  void logout() {
    CurrentUserProvider? userProvider = context.read<CurrentUserProvider>();
    userProvider.logout();
    Navigator.popUntil(context, (route) => false);
    Navigator.pushNamed(context, LoginPage.routeName);
  }

  void editProfile() => Navigator.pushNamed(context, EditProfilePage.routeName);

  void onThemeChanged(int index) {}

  @override
  Widget build(BuildContext context) {
    LocaleProvider localeProvider = context.watch<LocaleProvider>();
    ThemeProvider themeProvider = context.watch<ThemeProvider>();
    CurrentUserProvider userProvider = context.watch<CurrentUserProvider>();
    final User? user = userProvider.currentUser;
    if (user == null) {
      return Center(
        child: TextButton(
          onPressed: logout,
          child: Text(context.appLocalizations.logout),
        ),
      );
    }
    return ListView(
      padding: const EdgeInsets.all(7.5),
      children: [
        Container(
          margin: const EdgeInsets.all(7.5),
          padding: const EdgeInsets.all(15),
          decoration: ContainerDecoration.cardStyle(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      context.appLocalizations.profile,
                      style: context.theme.textTheme.titleMedium,
                    ),
                  ),
                  Material(
                    elevation: 0,
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(50),
                    child: IconButton(
                      onPressed: editProfile,
                      icon: const Icon(Icons.edit),
                      splashRadius: 15,
                      padding: const EdgeInsets.all(5),
                      constraints: const BoxConstraints(),
                    ),
                  )
                ],
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  '${context.appLocalizations.fullName}: ${user.name}',
                  style: context.theme.textTheme.titleSmall,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  '${context.appLocalizations.email}: ${user.email}',
                  style: context.theme.textTheme.titleSmall,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Text(
                  '${context.appLocalizations.phone}: ${user.phone}',
                  style: context.theme.textTheme.titleSmall,
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.all(7.5),
          padding: const EdgeInsets.all(15),
          decoration: ContainerDecoration.cardStyle(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.appLocalizations.settings,
                style: context.theme.textTheme.titleMedium,
              ),
              const Divider(),
              const SizedBox(height: 10),
              MainDropdownButton(
                onSelectedItemChanged: (int index) =>
                    localeProvider.setLocale(Lang.all[index]),
                value: Lang.getLangName(localeProvider.locale.languageCode),
                trailing: Icon(
                  Icons.language,
                  color: context.colorScheme.onSurface,
                ),
                leading: Icon(
                  Icons.navigate_next_rounded,
                  color: context.colorScheme.onSurface,
                ),
                children: Lang.all
                    .map(
                      (Locale locale) => MainDropdownItem<Locale>(
                        child: Text(Lang.getLangName(locale.languageCode)),
                        value: locale,
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 15),
              MainDropdownButton(
                onSelectedItemChanged: (int index) =>
                    themeProvider.setThemeMode(ThemeMode.values[index]),
                value: themeProvider.themeMode.toLocalizedString(context),
                trailing: Icon(
                  Icons.brightness_4,
                  color: context.colorScheme.onSurface,
                ),
                leading: Icon(
                  Icons.navigate_next_rounded,
                  color: context.colorScheme.onSurface,
                ),
                children: ThemeMode.values
                    .map(
                      (ThemeMode mode) => MainDropdownItem<ThemeMode>(
                        child: Text(mode.toLocalizedString(context)),
                        value: mode,
                      ),
                    )
                    .toList(),
              ),
              const Divider(height: 30),
              MainButton(
                onPressed: logout,
                backgroundColor: context.colorScheme.surface,
                child: Row(
                  children: [
                    Icon(
                      Icons.logout,
                      color: context.colorScheme.onSurface,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      context.appLocalizations.logout,
                      style: context.textTheme.titleSmall,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
