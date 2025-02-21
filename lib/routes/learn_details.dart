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
      appBar: AppBar(title: Text("Sections")),
      body: Consumer<ColorsProvider>(builder: (context, color, _) {
        return FutureBuilder(
            future: article.sections.isEmpty
                ? learnProvider.getArticle(article)
                : Future.value(true),
            builder: (ctx, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CupertinoActivityIndicator());
              } else if (snapshot.connectionState == ConnectionState.done) {
                return ListView.builder(
                    itemCount: article.sections.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            color: color.placeHolders(),
                          ),
                          //height: MediaQuery.of(context).size.height,
                          child: Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: Markdown(
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                data: article.sections[index].content),
                          ),
                        ),
                      );
                    });
              }
              return Container();
            });
      }),
    );
  }
}
