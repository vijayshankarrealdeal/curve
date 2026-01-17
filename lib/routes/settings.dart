import 'package:curve/services/colors_provider.dart';
import 'package:curve/services/language_provider.dart'; // Import
import 'package:curve/auth/auth.dart';
import 'package:curve/routes/data_privacy.dart';
import 'package:curve/routes/feedback.dart';
import 'package:curve/routes/kinks.dart';
import 'package:curve/routes/report_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  void _showLanguageSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Consumer<LanguageProvider>(builder: (context, lang, _) {
          return Container(
            padding: const EdgeInsets.all(20),
            height: 400,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  lang.getText('languages'),
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemCount: lang.supportedLanguages.length,
                    itemBuilder: (context, index) {
                      final l = lang.supportedLanguages[index];
                      return ListTile(
                        leading: Text(l['flag']!,
                            style: const TextStyle(fontSize: 24)),
                        title: Text(l['name']!),
                        trailing: lang.locale.languageCode == l['code']
                            ? const Icon(Icons.check, color: Colors.blue)
                            : null,
                        onTap: () {
                          lang.changeLanguage(l['code']!);
                          Navigator.pop(ctx);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<ColorsProvider, LanguageProvider>(
      builder: (context, colorPr, lang, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text(lang.getText('settings')), // Translated Title
          ),
          body: CustomScrollView(
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
                        header: Text(lang.getText('settings')),
                        children: [
                          CupertinoFormRow(
                            prefix: Row(
                              children: [
                                Icon(colorPr.darkMode
                                    ? CupertinoIcons.light_max
                                    : CupertinoIcons.light_min),
                                const SizedBox(width: 10),
                                Text(colorPr.darkMode
                                    ? lang.getText('light_mode')
                                    : lang.getText('dark_mode')),
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
                                const Icon(CupertinoIcons.eye),
                                const SizedBox(width: 10),
                                Text(lang.getText('kinks')),
                              ],
                            ),
                            child: CupertinoButton(
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (ctx) => const Kinks()),
                              ),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: const Icon(CupertinoIcons.chevron_forward),
                            ),
                          ),
                          CupertinoFormRow(
                            prefix: Row(
                              children: [
                                const Icon(CupertinoIcons.at),
                                const SizedBox(width: 10),
                                Text(lang.getText('feedback')),
                              ],
                            ),
                            child: CupertinoButton(
                                onPressed: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (ctx) =>
                                              const FeedbackPage()),
                                    ),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child:
                                    const Icon(CupertinoIcons.chevron_forward)),
                          ),
                          CupertinoFormRow(
                            prefix: Row(
                              children: [
                                const Icon(CupertinoIcons.lock),
                                const SizedBox(width: 10),
                                Text(lang.getText('data_privacy')),
                              ],
                            ),
                            child: CupertinoButton(
                                onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (ctx) => const DataPrivacy())),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child:
                                    const Icon(CupertinoIcons.chevron_forward)),
                          ),
                          CupertinoFormRow(
                            prefix: Row(
                              children: [
                                const Icon(CupertinoIcons.globe,
                                    color: CupertinoColors.activeGreen),
                                const SizedBox(width: 10),
                                Text(lang.getText('languages')),
                              ],
                            ),
                            child: CupertinoButton(
                                onPressed: () => _showLanguageSheet(context),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: Row(
                                  children: [
                                    const Spacer(),
                                    // Show current flag
                                    Text(lang.supportedLanguages.firstWhere(
                                            (e) =>
                                                e['code'] ==
                                                lang.locale
                                                    .languageCode)['flag'] ??
                                        ""),

                                    const Icon(CupertinoIcons.chevron_forward),
                                  ],
                                )),
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
                            prefix: Row(
                              children: [
                                const Icon(
                                    CupertinoIcons.exclamationmark_triangle),
                                const SizedBox(width: 10),
                                Text(lang.getText('report')),
                              ],
                            ),
                            child: CupertinoButton(
                                onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (ctx) => const ReportPage())),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child:
                                    const Icon(CupertinoIcons.chevron_forward)),
                          ),
                          CupertinoFormRow(
                            prefix: Row(
                              children: [
                                const Icon(CupertinoIcons.waveform),
                                const SizedBox(width: 10),
                                Text(lang.getText('logout')),
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
                                  child: Text(lang.getText('exit')));
                            }),
                          ),
                          CupertinoFormRow(
                            prefix: Row(
                              children: [
                                const Icon(CupertinoIcons.delete,
                                    color: CupertinoColors.destructiveRed),
                                const SizedBox(width: 10),
                                Text(lang.getText('delete_account')),
                              ],
                            ),
                            child: CupertinoButton(
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                            title: Text(
                                                lang.getText('delete_account')),
                                            content:
                                                const Text("Are you sure?"),
                                            actions: [
                                              TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(ctx),
                                                  child: Text(
                                                      lang.getText('cancel'))),
                                              TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(ctx),
                                                  child: Text(
                                                      lang.getText('proceed'),
                                                      style: const TextStyle(
                                                          color: Colors.red)))
                                            ],
                                          ));
                                },
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: Text(lang.getText('proceed'))),
                          )
                        ]),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
