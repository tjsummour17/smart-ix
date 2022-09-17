import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_ix/src/models/user.dart';
import 'package:smart_ix/src/providers/current_user_provider.dart';
import 'package:smart_ix/src/repo/authentication_firebase_repo.dart';
import 'package:smart_ix/src/utils/build_context_x.dart';
import 'package:smart_ix/src/viewmodels/create_account_view_model.dart';
import 'package:smart_ix/src/views/main_page.dart';
import 'package:smart_ix/src/views/widgets/snack_bar.dart';

class CreateAccountPage extends StatelessWidget {
  const CreateAccountPage({Key? key}) : super(key: key);
  static String routeName = '/createAccount';

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (context) => CreateAccountViewModel(),
        child: const _CreateAccountPage(),
      );
}

class _CreateAccountPage extends StatefulWidget {
  const _CreateAccountPage({Key? key}) : super(key: key);

  @override
  State<_CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<_CreateAccountPage> {
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _nameTextController = TextEditingController();
  final TextEditingController _phoneTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();

  Future<void> _createAccount() async {
    CreateAccountViewModel accountViewModel =
        context.read<CreateAccountViewModel>();
    User? user = User(
      name: _nameTextController.text,
      phone: _phoneTextController.text,
      email: _emailTextController.text,
      password: _passwordTextController.text,
    );
    final result = await accountViewModel.createAccount(user: user);
    switch (result.status) {
      case CreateAccountStatus.success:
        CurrentUserProvider userProvider = context.read<CurrentUserProvider>();
        user = result.user;
        if (user != null) {
          userProvider.saveUser(user);
          Navigator.popUntil(context, (route) => false);
          Navigator.pushNamed(context, MainPage.routeName);
        }
        break;
      case CreateAccountStatus.alreadyExists:
        AppSnackBar.show3Sec(
          context: context,
          message: 'Email already registered',
        );
        break;
      case CreateAccountStatus.weakPassword:
        AppSnackBar.show3Sec(
          context: context,
          message: 'Week password try different password',
        );
        break;
      case CreateAccountStatus.unknownError:
        AppSnackBar.show3Sec(
          context: context,
          message: 'Something went wrong',
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Text(
                    context.appLocalizations.createAccount,
                    style: const TextStyle(
                      fontSize: 32,
                      color: Color(0xff1877F2),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Container(
                    width: 430,
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
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _nameTextController,
                          decoration: InputDecoration(
                            labelText: context.appLocalizations.fullName,
                          ),
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          controller: _phoneTextController,
                          decoration: InputDecoration(
                            labelText: context.appLocalizations.phone,
                          ),
                        ),
                        const SizedBox(height: 15),
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
                          child: ElevatedButton(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                context.appLocalizations.createAccount,
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            onPressed: _createAccount,
                          ),
                        ),
                        const Divider(thickness: 1.5, height: 30),
                        Text(context.appLocalizations.alreadyHaveAccount),
                        const SizedBox(height: 15),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                context.appLocalizations.login,
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailTextController.dispose();
    _nameTextController.dispose();
    _phoneTextController.dispose();
    _passwordTextController.dispose();
    super.dispose();
  }
}
