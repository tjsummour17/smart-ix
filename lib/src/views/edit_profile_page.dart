import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_ix/src/models/user.dart';
import 'package:smart_ix/src/providers/current_user_provider.dart';
import 'package:smart_ix/src/utils/build_context_x.dart';
import 'package:smart_ix/src/viewmodels/edit_profile_view_model.dart';
import 'package:smart_ix/src/views/widgets/container_decoration.dart';
import 'package:smart_ix/src/views/widgets/loading_widget.dart';
import 'package:smart_ix/src/views/widgets/main_button.dart';
import 'package:smart_ix/src/views/widgets/snack_bar.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  static const String routeName = '/EditProfile';

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (context) => EditProfileViewModel(),
        child: const _EditProfilePage(),
      );
}

class _EditProfilePage extends StatefulWidget {
  const _EditProfilePage({Key? key}) : super(key: key);

  @override
  State<_EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<_EditProfilePage> {
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _nameTextController = TextEditingController();
  final TextEditingController _phoneTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    CurrentUserProvider userProvider = context.read<CurrentUserProvider>();
    final User? user = userProvider.currentUser;
    if (user != null) {
      _nameTextController.text = user.name;
      _emailTextController.text = user.email;
      _phoneTextController.text = user.phone;
    }
  }

  void _updateProfile() {
    CurrentUserProvider userProvider = context.read<CurrentUserProvider>();
    User? user = userProvider.currentUser;
    if (user != null) {
      user = user.copy(
        name: _nameTextController.text,
        email: _emailTextController.text,
        phone: _phoneTextController.text,
      );
      EditProfileViewModel editProfileViewModel =
          context.read<EditProfileViewModel>();
      editProfileViewModel.update(user);
      userProvider.currentUser = user;
      AppSnackBar.show3Sec(
        context: context,
        message: context.appLocalizations.accountUpdatedSuccessfully,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    EditProfileViewModel editProfileViewModel =
        context.watch<EditProfileViewModel>();
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text(context.appLocalizations.editProfile),
          ),
          body: ListView(
            padding: const EdgeInsets.all(15),
            children: [
              Container(
                margin: const EdgeInsets.all(7.5),
                padding: const EdgeInsets.all(15),
                decoration: ContainerDecoration.cardStyle(context),
                child: Column(
                  children: [
                    Text(
                      context.appLocalizations.profile,
                      style: context.theme.textTheme.titleMedium,
                    ),
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: TextFormField(
                        controller: _nameTextController,
                        style: context.theme.textTheme.titleSmall,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: TextFormField(
                        controller: _emailTextController,
                        style: context.theme.textTheme.titleSmall,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: TextFormField(
                        controller: _phoneTextController,
                        style: context.theme.textTheme.titleSmall,
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Divider(),
                    MainButton(
                      onPressed: _updateProfile,
                      child: Text(context.appLocalizations.update),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        if (editProfileViewModel.isLoading)
          const LoadingWidget(
            backgroundColor: Colors.black12,
          )
      ],
    );
  }

  @override
  void dispose() {
    _emailTextController.dispose();
    _nameTextController.dispose();
    _phoneTextController.dispose();
    super.dispose();
  }
}
