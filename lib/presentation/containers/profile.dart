import 'package:material_ui/material_ui.dart';
import 'package:parousia/presentation/presentation.dart';
import 'package:provider/provider.dart';

class ProfileContainer extends StatelessWidget {
  final bool? userNavigated;

  const ProfileContainer({super.key, this.userNavigated});

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
    create: (context) =>
        ProfileViewModel(profile: context.read(), groups: context.read()),
    child: Consumer<ProfileViewModel>(
      builder: (context, vm, _) => ProfileScreen(
        profile: vm.profile,
        userNavigated: userNavigated,
        saving: vm.save.running,
        onSave: (name, image) async {
          await vm.save.execute((name: name, image: image));
          if (context.mounted) showFailure(context, vm.save.result);
          return vm.save.completed;
        },
      ),
    ),
  );
}
