import 'package:curve/services/colors_provider.dart';
import 'package:curve/auth/auth.dart';
import 'package:curve/routes/feedback.dart';
import 'package:curve/routes/kinks.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: Consumer<ColorsProvider>(builder: (context, colorPr, _) {
        return CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  CupertinoFormSection(
                      backgroundColor: colorPr.getScaffoldColor(),
                      decoration: BoxDecoration(
                        color: colorPr.getAppBarColor(),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      header: const Text("App Settings"),
                      children: [
                        CupertinoFormRow(
                          prefix: Row(
                            children: [
                              Icon(colorPr.darkMode
                                  ? CupertinoIcons.light_max
                                  : CupertinoIcons.light_min),
                              const SizedBox(width: 10),
                              Text(colorPr.darkMode
                                  ? "Switch Light Mode "
                                  : "Switch Dark Mode"),
                            ],
                          ),
                          child: CupertinoSwitch(
                            value: colorPr.darkMode,
                            onChanged: (value) => colorPr.setDarkMode(value),
                          ),
                        ),
                        CupertinoFormRow(
                          prefix: Row(
                            children: [
                              Icon(
                                CupertinoIcons.eye,
                              ),
                              SizedBox(width: 10),
                              Text('Kinks'),
                            ],
                          ),
                          child: CupertinoButton(
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (ctx) => Kinks(),
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: const Icon(CupertinoIcons.chevron_forward),
                          ),
                        ),
                        CupertinoFormRow(
                          prefix: const Row(
                            children: [
                              Icon(
                                CupertinoIcons.at,
                              ),
                              SizedBox(width: 10),
                              Text("Feedback"),
                            ],
                          ),
                          child: CupertinoButton(
                              onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (ctx) => FeedbackPage(),
                                    ),
                                  ),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child:
                                  const Icon(CupertinoIcons.chevron_forward)),
                        ),
                        CupertinoFormRow(
                          prefix: const Row(
                            children: [
                              Icon(
                                CupertinoIcons.lock,
                              ),
                              SizedBox(width: 10),
                              Text("Data & Privacy"),
                            ],
                          ),
                          child: CupertinoButton(
                              onPressed: () {},
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child:
                                  const Icon(CupertinoIcons.chevron_forward)),
                        ),
                        CupertinoFormRow(
                          prefix: const Row(
                            children: [
                              Icon(CupertinoIcons.globe,
                                  color: CupertinoColors.activeGreen),
                              SizedBox(width: 10),
                              Text("Languages"),
                            ],
                          ),
                          child: CupertinoButton(
                              onPressed: () {},
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child:
                                  const Icon(CupertinoIcons.chevron_forward)),
                        ),
                      ]),
                  CupertinoFormSection(
                      backgroundColor: colorPr.getScaffoldColor(),
                      decoration: BoxDecoration(
                        color: colorPr.getAppBarColor(),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      header: const Text("Help"),
                      children: [
                        CupertinoFormRow(
                          prefix: const Row(
                            children: [
                              Icon(
                                CupertinoIcons.exclamationmark_triangle,
                              ),
                              SizedBox(width: 10),
                              Text("Report"),
                            ],
                          ),
                          child: CupertinoButton(
                              onPressed: () {},
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child:
                                  const Icon(CupertinoIcons.chevron_forward)),
                        ),
                        CupertinoFormRow(
                          prefix: const Row(
                            children: [
                              Icon(
                                CupertinoIcons.waveform,
                              ),
                              SizedBox(width: 10),
                              Text("Logout"),
                            ],
                          ),
                          child: Consumer<AuthProvider>(
                              builder: (context, auth, _) {
                            return CupertinoButton(
                                onPressed: () {
                                  auth.signout();
                                  Navigator.pop(context);
                                },
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: const Text("Exit"));
                          }),
                        ),
                        CupertinoFormRow(
                          prefix: const Row(
                            children: [
                              Icon(CupertinoIcons.delete,
                                  color: CupertinoColors.destructiveRed),
                              SizedBox(width: 10),
                              Text("Delete Account"),
                            ],
                          ),
                          child: CupertinoButton(
                              onPressed: () {},
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: const Text("Proceed")),
                        )
                      ]),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
