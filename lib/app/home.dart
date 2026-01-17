import 'package:auto_size_text/auto_size_text.dart';
import 'package:curve/services/language_provider.dart'; // Import
import 'package:curve/services/responsive.dart';
import 'package:curve/models/model.dart';
import 'package:curve/routes/four_cards.dart';
import 'package:curve/routes/keyword_obesseion.dart';
import 'package:curve/routes/maze_grid.dart';
import 'package:curve/routes/settings.dart';
import 'package:curve/routes/truth_dare.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    // Listen to LanguageProvider
    final lang = Provider.of<LanguageProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(lang.getText('app_name')),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: IconButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (ctx) => const Settings(),
                ),
              ),
              icon: const Icon(CupertinoIcons.gear),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.custom(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverWovenGridDelegate.count(
            crossAxisCount: 2,
            mainAxisSpacing: 0.5,
            crossAxisSpacing: 0.5,
            pattern: [
              WovenGridTile(
                5 / 7,
                crossAxisRatio: Responsive.isMobile(context) ? 0.95 : 0.2,
                alignment: AlignmentDirectional.topEnd,
              ),
              WovenGridTile(0.8,
                  crossAxisRatio: Responsive.isMobile(context) ? 1 : 0.2)
            ],
          ),
          childrenDelegate: SliverChildBuilderDelegate(
            childCount: 4,
            (context, index) {
              List<AppCardsHome> cards = [
                AppCardsHome(
                  cardColor: Colors.red.shade900,
                  title: lang.getText('4_cards'), // Translated
                  textColor: Colors.red.shade50,
                  extraIcon: Mdi.cards_playing,
                  iconColor: Colors.red.shade50,
                ),
                AppCardsHome(
                    cardColor: Colors.blueGrey.shade900,
                    title: lang.getText('keyword'), // Translated
                    textColor: Colors.blueGrey.shade50,
                    iconAdd: CupertinoIcons.textformat,
                    iconColor: Colors.blueGrey.shade50),
                AppCardsHome(
                  cardColor: Colors.pink.shade900,
                  title: lang.getText('truth_dare'), // Translated
                  textColor: Colors.pink.shade50,
                  iconColor: Colors.pink.shade50,
                  iconAdd: CupertinoIcons.hand_raised_fill,
                ),
                AppCardsHome(
                  cardColor: Colors.purple.shade900,
                  title: lang.getText('maze'), // Translated
                  textColor: Colors.purple.shade50,
                  iconColor: Colors.purple.shade50,
                  iconAdd: CupertinoIcons.grid,
                ),
              ];
              // Logic to handle taps (comparing index is safer than title now that titles change)
              return GestureDetector(
                onTap: () {
                  if (index == 3) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (ctx) => const MazeGrid()));
                  } else if (index == 2) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (ctx) => const TruthDareCardPage(),
                      ),
                    );
                  } else if (index == 1) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (ctx) => const KeywordObesseion(),
                      ),
                    );
                  } else if (index == 0) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (ctx) => const FourCards(),
                      ),
                    );
                  }
                },
                child: Card(
                  elevation: 12,
                  child: Container(
                    decoration: BoxDecoration(
                      color: cards[index].cardColor,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        cards[index].extraIcon != ""
                            ? Iconify(
                                cards[index].extraIcon,
                                size: 95,
                                color: cards[index].iconColor,
                              )
                            : Icon(cards[index].iconAdd,
                                size: 95, color: cards[index].iconColor),
                        Align(
                          alignment: Alignment.center,
                          child: AutoSizeText(
                            cards[index].title,
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(color: cards[index].textColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}