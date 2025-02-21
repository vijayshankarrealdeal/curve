import 'package:curve/routes/learn_details.dart';
import 'package:curve/services/colors_provider.dart';
import 'package:curve/services/learn_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:provider/provider.dart';

class Learn extends StatelessWidget {
  const Learn({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<LearnProvider, ColorsProvider>(
      builder: (context, learn, colorx, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Learn"),
          ),
          body: ListView.builder(
            itemCount: learn.articles.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: colorx.placeHolders(),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          learn.articles[index].title,
                          style: Theme.of(context)
                              .textTheme
                              .headlineLarge!
                              .copyWith(
                                color: colorx.navBarIconActiveColor(),
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Markdown(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            data: learn.articles[index].introduction),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 12,
                              child: Center(
                                child: Text(
                                  learn.articles[index].sectionsCount
                                      .toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall!
                                      .copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ),
                            ),
                            CupertinoButton(
                              padding: EdgeInsets.zero,
                              onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (ctx) => LearnDetail(
                                            learn.articles[index],
                                          ))),
                              child: Text(
                                "Learn More",
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium!
                                    .copyWith(
                                      color: colorx.seedColorColor(),
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
