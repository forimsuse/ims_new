import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../size_config.dart';

class ImsAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? titleWidget;
  final Widget? leading;
  final Widget? bottomWidget;

  const ImsAppBar(
      {super.key, required this.title, this.titleWidget, this.leading, this.bottomWidget});

  @override
  AppBar build(BuildContext context) {
    return _buildContent(context);
  }

  AppBar _buildContent(BuildContext context) {
    return AppBar(
      toolbarHeight: preferredSize.height,
      // Set this height
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      systemOverlayStyle: const SystemUiOverlayStyle(
        // Status bar color
        statusBarColor: Colors.white,
        // Status bar brightness (optional)
        statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
        statusBarBrightness: Brightness.light, // For iOS (dark icons)
      ),
      leading: const SizedBox(),
      flexibleSpace: Padding(
        padding: EdgeInsets.only(
            left: 10 * SizeConfig.screenWidthProportion,
            right: 10 * SizeConfig.screenWidthProportion,
            top: SizeConfig.getHeightStatusBar(context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  leading ?? const SizedBox(),
                  titleWidget ??
                      Text(
                        title,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18 * SizeConfig.screenHeightProportion,
                          fontWeight: FontWeight.w400,
                          height: 0,
                        ),
                      ),
                  //const ExitButton(),
                ],
              ),
            ),
            bottomWidget ?? const SizedBox()
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size(SizeConfig.screenWidth, SizeConfig.screenHeight * 0.09);
}
