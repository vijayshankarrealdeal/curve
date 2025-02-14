import 'package:auto_size_text/auto_size_text.dart';
import 'package:curve/api/responsive.dart';
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

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Curves"),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: IconButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (ctx) => Settings(),
                ),
              ),
              icon: Icon(CupertinoIcons.gear),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.custom(
          shrinkWrap: true, // Prevents the GridView from scrolling
          physics: NeverScrollableScrollPhysics(), // Disables scrolling
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
                  title: "4 Cards",
                  textColor: Colors.red.shade50,
                  extraIcon: Mdi.cards_playing,
                  iconColor: Colors.red.shade50,
                ),
                AppCardsHome(
                    cardColor: Colors.blueGrey.shade900,
                    title: "Keyword Obsession",
                    textColor: Colors.blueGrey.shade50,
                    iconAdd: CupertinoIcons.textformat,
                    iconColor: Colors.blueGrey.shade50),
                AppCardsHome(
                  cardColor: Colors.pink.shade900,
                  title: "Truth or Dare",
                  textColor: Colors.pink.shade50,
                  iconColor: Colors.pink.shade50,
                  iconAdd: CupertinoIcons.hand_raised_fill,
                ),
                AppCardsHome(
                  cardColor: Colors.purple.shade900,
                  title: "Intimacy Maze",
                  textColor: Colors.purple.shade50,
                  iconColor: Colors.purple.shade50,
                  iconAdd: CupertinoIcons.grid,
                ),
              ];
              return GestureDetector(
                onTap: () {
                  if (cards[index].title == "Intimacy Maze") {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (ctx) => MazeGrid()));
                  } else if (cards[index].title == "Truth or Dare") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (ctx) => TruthDareCardPage(),
                      ),
                    );
                  } else if (cards[index].title == "Keyword Obsession") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (ctx) => KeywordObesseion(),
                      ),
                    );
                  } else if (cards[index].title == "4 Cards") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (ctx) => FourCards(),
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
