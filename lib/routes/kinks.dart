import 'package:auto_size_text/auto_size_text.dart';
import 'package:curve/services/colors_provider.dart';
import 'package:curve/services/responsive.dart';
import 'package:curve/services/settings_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Kinks extends StatelessWidget {
  const Kinks({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<SettingsModel, ColorsProvider>(
        builder: (context, categoryProvider, colorP, _) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Kinks"),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: Text(
                '${categoryProvider.selectedItem()}/${categoryProvider.categories.length} selected.',
                style: Theme.of(context)
                    .textTheme
                    .labelMedium!
                    .copyWith(color: Colors.grey),
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: Responsive.isMobile(context) ? 2 : 6,
                crossAxisSpacing: Responsive.isMobile(context) ? 10.0 : 7,
                mainAxisSpacing: Responsive.isMobile(context) ? 10.0 : 7,
                childAspectRatio: 4),
            itemCount: categoryProvider.categories.length,
            itemBuilder: (context, index) {
              return _buildCategoryToggle(categoryProvider.categories[index],
                  context, colorP.seedColorColor());
            },
          ),
        ),
      );
    });
  }

  Widget _buildCategoryToggle(
      Category category, BuildContext context, Color color) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          // ignore: deprecated_member_use
          color: color.withOpacity(0.4)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: Responsive.isMobile(context)
                  ? MediaQuery.of(context).size.width * 0.25
                  : MediaQuery.of(context).size.width * 0.07,
              child: AutoSizeText(
                category.name,
                maxLines: 5,
              ),
            ),
            Switch(
              value: category.isSelected,
              onChanged: (bool value) {
                Provider.of<SettingsModel>(context, listen: false)
                    .toggleCategory(category.name);
              },
            ),
          ],
        ),
      ),
    );
  }
}
