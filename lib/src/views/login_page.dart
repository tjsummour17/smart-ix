import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_ix/src/l10n/lang.dart';
import 'package:smart_ix/src/providers/current_user_provider.dart';
import 'package:smart_ix/src/providers/locale_provider.dart';
import 'package:smart_ix/src/providers/theme_provider.dart';
import 'package:smart_ix/src/repo/authentication_firebase_repo.dart';
import 'package:smart_ix/src/utils/build_context_x.dart';
import 'package:smart_ix/src/viewmodels/login_view_model.dart';
import 'package:smart_ix/src/views/create_account_page.dart';
import 'package:smart_ix/src/views/main_page.dart';
import 'package:smart_ix/src/views/widgets/loading_widget.dart';
import 'package:smart_ix/src/views/widgets/main_button.dart';
import 'package:smart_ix/src/views/widgets/main_dropdown_button.dart';
import 'package:smart_ix/src/views/widgets/snack_bar.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  static String routeName = '/login';

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (context) => LoginViewModel(),
        child: const _LoginPage(),
      );
}

class _LoginPage extends StatefulWidget {
  const _LoginPage();

  @override
  State<_LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<_LoginPage> {
  final TextEditingController _emailTextController = TextEditingController();

  final TextEditingController _passwordTextController = TextEditingController();

  Future<void> _login() async {
    LoginViewModel loginViewModel = context.read<LoginViewModel>();
    final result = await loginViewModel.signIn(
      email: _emailTextController.text,
      password: _passwordTextController.text,
    );
    switch (result.status) {
      case SignInStatus.success:
        CurrentUserProvider userProvider = context.read<CurrentUserProvider>();
        final newUser = result.user;
        if (newUser != null) {
          userProvider.saveUser(newUser);
          Navigator.pushReplacementNamed(context, MainPage.routeName);
        }
        break;
      case SignInStatus.userNotExists:
        AppSnackBar.show3Sec(
          context: context,
          message: 'Email is not registered',
        );
        break;
      case SignInStatus.wrongPassword:
        AppSnackBar.show3Sec(context: context, message: 'Incorrect password');
        break;
      case SignInStatus.unknownError:
        AppSnackBar.show3Sec(context: context, message: 'Something went wrong');
    }
  }

  @override
  Widget build(BuildContext context) {
    LocaleProvider localeProvider = context.read<LocaleProvider>();
    ThemeProvider themeProvider = context.read<ThemeProvider>();
    LoginViewModel loginViewModel = context.watch<LoginViewModel>();
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            actions: [
              const SizedBox(width: 5),
              Center(
                child: IntrinsicWidth(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: MainDropdownButton(
                      hintText: context.appLocalizations.language,
                      children: Lang.all
                          .map(
                            (locale) => MainDropdownItem(
                              value: locale,
                              child:
                                  Text(Lang.getLangName(locale.languageCode)),
                            ),
                          )
                          .toList(),
                      onSelectedItemChanged: (int index) =>
                          localeProvider.setLocale(Lang.all[index]),
                    ),
                  ),
                ),
              ),
              Center(
                child: IntrinsicWidth(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: MainDropdownButton(
                      hintText: context.appLocalizations.theme,
                      children: ThemeMode.values
                          .map(
                            (mode) => MainDropdownItem<ThemeMode>(
                              value: mode,
                              child: Text(mode.toLocalizedString(context)),
                            ),
                          )
                          .toList(),
                      onSelectedItemChanged: (index) =>
                          themeProvider.setThemeMode(ThemeMode.values[index]),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 5),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(15.0),
            children: [
              const SizedBox(height: 20),
              Text(
                context.appLocalizations.appName,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 60,
                  color: context.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              Text(
                context.appLocalizations.appDescription,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 40),
              Container(
                width: 430,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 30,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 5,
                      color: Theme.of(context).shadowColor,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    TextFormField(
                      controller: _emailTextController,
                      decoration: InputDecoration(
                        labelText: context.appLocalizations.email,
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: _passwordTextController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: context.appLocalizations.password,
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: MainButton(
                        child: Text(
                          context.appLocalizations.login,
                          style: context.textTheme.labelLarge,
                        ),
                        onPressed: _login,
                      ),
                    ),
                    const Divider(thickness: 1.5, height: 30),
                    Text(context.appLocalizations.dontHaveAccount),
                    const SizedBox(height: 15),
                    SizedBox(
                      width: double.infinity,
                      child: MainButton(
                        child: Text(
                          context.appLocalizations.createAccount,
                          style: context.textTheme.labelLarge,
                        ),
                        onPressed: () => Navigator.pushNamed(
                          context,
                          CreateAccountPage.routeName,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (loginViewModel.isLoading)
          const LoadingWidget(
            backgroundColor: Colors.black12,
          )
      ],
    );
  }

  @override
  void dispose() {
    _emailTextController.dispose();
    _passwordTextController.dispose();
    super.dispose();
  }
}
