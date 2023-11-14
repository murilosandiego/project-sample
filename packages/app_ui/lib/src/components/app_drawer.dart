import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({
    super.key,
    required this.onTapLogout,
    required this.username,
    required this.email,
  });

  final String username;
  final String email;
  final void Function()? onTapLogout;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            margin: const EdgeInsets.all(0),
            padding: const EdgeInsets.all(0),
            child: UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  username[0],
                  style: const TextStyle(fontSize: 32),
                ),
              ),
              accountName: Text(username),
              accountEmail: Text(email),
            ),
          ),
          ListTile(
            title: const Text('Sair'),
            onTap: onTapLogout,
            trailing: const Icon(Icons.exit_to_app),
          )
        ],
      ),
    );
  }
}
