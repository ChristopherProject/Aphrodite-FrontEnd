// ignore_for_file: library_private_types_in_public_api, deprecated_member_use, depend_on_referenced_packages

import 'package:aphrodite/pages/login.dart';
import 'package:aphrodite/pages/settings/change_password.dart';
import 'package:aphrodite/pages/settings/edit_Profile.dart';
import 'package:aphrodite/utilitities/requests.dart';
import 'package:aphrodite/utilitities/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserProfilePage extends StatefulWidget {
  final Map<String, dynamic> userInformations;
  final Map<String, dynamic> privateData;

  const UserProfilePage({
    Key? key,
    required this.userInformations,
    required this.privateData,
  }) : super(key: key);

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  bool showSearchBar = false;
  CircleAvatar? avatarWidget;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Padding(
            padding: const EdgeInsets.only(left: 0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CupertinoButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            SettingsScreen(
                          userInformations: widget.userInformations,
                          privateData: widget.privateData,
                        ),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          return child;
                        },
                      ),
                    );
                  },
                  child: const Icon(
                    CupertinoIcons.equal,
                    color: Colors.black45,
                    size: 34.0,
                  ),
                ),
                const SizedBox(width: 1),
                Flexible(
                  child: Container(
                    alignment: Alignment.center,
                    child: const Text('Aphrodite'),
                  ),
                ),
                CupertinoButton(
                  onPressed: () {
                    setState(() {
                      showSearchBar = !showSearchBar;
                    });
                  },
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: showSearchBar
                        ? const SizedBox.shrink()
                        : const Icon(
                            CupertinoIcons.search,
                            color: Colors.black45,
                            size: 27.0,
                          ),
                  ),
                ),
                if (showSearchBar)
                  Expanded(
                    child: CupertinoTextField(
                      placeholder: 'Cerca...',
                      style: TextStyle(
                        color: CupertinoTheme.of(context)
                            .textTheme
                            .textStyle
                            .color,
                      ),
                      onChanged: (String value) async {
                        if (value.isNotEmpty) {
                          try {
                            final Map<String, dynamic> user =
                                await Requests.findUserInformationsByName(
                                    value);
                            String userAvatar = user['profile_pic'] ??
                                'https://i.imgur.com/WxNkK7J.png';
                            final CircleAvatar circleAvatar = CircleAvatar(
                              backgroundImage: NetworkImage(userAvatar),
                              radius: 25,
                            );
                            // Use setState to trigger a rebuild
                            setState(() {
                              avatarWidget = circleAvatar;
                            });
                            // ignore: empty_catches
                          } catch (e) {}
                        }
                      },
                      textInputAction: TextInputAction.none,
                    ),
                  ),
              ],
            ),
          ),
          automaticallyImplyLeading: false,
        ),
        body: Container(
          padding: const EdgeInsets.only(left: 10, right: 30, top: 40),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              avatarWidget ?? const SizedBox.shrink(),
              const SizedBox(width: 7),
              const Padding(
                padding: EdgeInsets.only(top: 10), //TODO: FIX IT
                /*child: Text(
                  'Pietro',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),*/
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SettingsScreen extends StatefulWidget {
  final Map<String, dynamic> userInformations;
  final Map<String, dynamic> privateData;

  const SettingsScreen(
      {Key? key, required this.userInformations, required this.privateData})
      : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CupertinoButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          UserProfilePage(
                        userInformations: widget.userInformations,
                        privateData: widget.privateData,
                      ),
                      transitionsBuilder:(context, animation, secondaryAnimation, child) {
                        return child;
                      },
                    ),
                  );
                },
                child: const Icon(
                  CupertinoIcons.arrow_left,
                  color: Color.fromARGB(255, 15, 15, 15),
                  size: 21.0,
                ),
              ),
              const SizedBox(width: 1),
              const Text('Settings'),
              Align(
                alignment: Alignment.topRight,
                child: CupertinoButton(
                  onPressed: () {
                    Requests.clearCredentials();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const LoginForm(),
                      ),
                    );
                  },
                  child: const Icon(
                    CupertinoIcons.arrow_right_to_line_alt,//exit icon
                    color: Color.fromARGB(255, 15, 15, 15),
                  ),
                ),
              ),
            ],
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text(
              'Account',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(
                      widget.userInformations['profile_pic'] ??
                          const AssetImage('assets/avatar.png')),
                  radius: 25,
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('username: ${widget.userInformations['username']}',
                        style: const TextStyle(fontSize: 16)),
                    Text('Numero: ${widget.privateData['phone_number']}',
                        style: const TextStyle(fontSize: 16)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            const SizedBox(height: 3),
            const Divider(),
            const Text(
              'Apparence',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 1),
            ListTile(
              title: const Text('Edit Profile'),
              leading: const Icon(Icons.edit),
              onTap: () {
                //edit profile page
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        ProfileEditPage(
                            userInformations: widget.userInformations),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      return child;
                    },
                  ),
                );
              },
            ),
            ListTile(
              title: const Text('Theme Dark'),
              trailing: CupertinoSwitch(
                value: Provider.of<AppTheme>(context).currentTheme ==
                    AppTheme.darkTheme,
                onChanged: (bool value) {
                  Provider.of<AppTheme>(context, listen: false).toggleTheme();
                },
              ),
              leading: const Icon(Icons.color_lens),
            ),
            const SizedBox(height: 2),
            const Divider(),
            const Text(
              'Privacy & Security',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 1),
            ListTile(
              title: const Text('Notifications'),
              trailing:
                  CupertinoSwitch(value: false, onChanged: (bool value) {}),
              leading: const Icon(Icons.notifications),
            ),
            ListTile(
              title: const Text('Change Password'),
              leading: const Icon(Icons.lock),
              onTap: () {
                //change password screen
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        ProfileChangePasswordPage(
                            userInformations: widget.userInformations),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      return child;
                    },
                  ),
                );
              },
            ),
            ListTile(
              title: const Text('Privacy Settings'),
              leading: const Icon(Icons.privacy_tip),
              onTap: () {
                // privacy settings
              },
            ),
            const SizedBox(height: 2),
          ],
        ),
      ),
    );
  }
}
