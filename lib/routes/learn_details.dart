import 'package:curve/models/learn_model.dart';
import 'package:curve/services/colors_provider.dart';
import 'package:curve/services/learn_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:provider/provider.dart';

class LearnDetail extends StatelessWidget {
  final Article article;
  const LearnDetail(this.article, {super.key});

  @override
  Widget build(BuildContext context) {
    final learnProvider = Provider.of<LearnProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text("Guide")),
      body: Consumer<ColorsProvider>(builder: (context, color, _) {
        return FutureBuilder(
            // Fetches data if not present (handled by provider logic)
            future: learnProvider.getArticle(article),
            builder: (ctx, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CupertinoActivityIndicator());
              } else if (snapshot.hasData) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Section
                      Text(
                        article.title,
                        style: Theme.of(context)
                            .textTheme
                            .displaySmall!
                            .copyWith(
                                fontWeight: FontWeight.bold,
                                color: color.navBarIconActiveColor()),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                            color: color.seedColorColor().withOpacity(0.1),
                            border: Border(
                                left: BorderSide(
                                    color: color.seedColorColor(), width: 4)),
                            borderRadius: BorderRadius.circular(8)),
                        child: Text(
                          article.introduction,
                          style: const TextStyle(
                              fontSize: 16, fontStyle: FontStyle.italic),
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Sections List
                      ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: article.sections.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 20),
                          itemBuilder: (context, index) {
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(18),
                                color: color.placeHolders(),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: MarkdownBody(
                                  data: article.sections[index].content,
                                  styleSheet: MarkdownStyleSheet(
                                    h1: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold),
                                    h3: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: color.seedColorColor()),
                                    p: TextStyle(
                                        fontSize: 16,
                                        height: 1.6,
                                        color: color.navBarIconActiveColor()),
                                    listBullet: TextStyle(
                                        color: color.seedColorColor()),
                                  ),
                                ),
                              ),
                            );
                          }),

                      const SizedBox(height: 30),
                      const Divider(),
                      const SizedBox(height: 10),

                      // Conclusion
                      Text(
                        "Takeaway",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        article.conclusion,
                        style: const TextStyle(fontSize: 16, height: 1.5),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                );
              }
              return const Center(
                  child: Text("Could not load article content."));
            });
      }),
    );
  }
}
