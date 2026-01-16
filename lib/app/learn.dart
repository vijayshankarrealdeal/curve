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
            title: const Text("Wellness & Intimacy"),
            centerTitle: true,
          ),
          body: learn.isLoading
              ? const Center(child: CupertinoActivityIndicator())
              : ListView.builder(
                  padding: const EdgeInsets.only(bottom: 20),
                  itemCount: learn.articles.length,
                  itemBuilder: (context, index) {
                    final article = learn.articles[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      child: GestureDetector(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (ctx) => LearnDetail(article))),
                        child: Container(
                          decoration: BoxDecoration(
                            color:
                                colorx.placeHolders(), // Uses your theme color
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              )
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        article.title,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineSmall!
                                            .copyWith(
                                                color: colorx
                                                    .navBarIconActiveColor(),
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20),
                                      ),
                                    ),
                                    Icon(
                                      CupertinoIcons.heart_circle_fill,
                                      color: colorx.seedColorColor(),
                                      size: 28,
                                    )
                                  ],
                                ),
                                const SizedBox(height: 12),
                                // Preview Text
                                Text(
                                  article.introduction,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                          height: 1.5,
                                          color: colorx
                                              .navBarIconActiveColor()
                                              .withOpacity(0.8)),
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      decoration: BoxDecoration(
                                          color: colorx.getScaffoldColor(),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Row(
                                        children: [
                                          Icon(CupertinoIcons.book_fill,
                                              size: 14,
                                              color: colorx
                                                  .navBarIconActiveColor()),
                                          const SizedBox(width: 5),
                                          Text(
                                            "${article.sectionsCount} Sections",
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelSmall,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Read Guide",
                                          style: TextStyle(
                                              color: colorx.seedColorColor(),
                                              fontWeight: FontWeight.w600),
                                        ),
                                        const SizedBox(width: 4),
                                        Icon(CupertinoIcons.arrow_right,
                                            size: 16,
                                            color: colorx.seedColorColor())
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
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
