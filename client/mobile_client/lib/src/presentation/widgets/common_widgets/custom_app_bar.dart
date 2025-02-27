import 'package:flutter/material.dart';
import '/src/config/router/app_route_constants.dart';
import '/src/presentation/widgets/common_widgets/search_text_form_field.dart';
import '/src/utils/constants/constants.dart';
import 'package:go_router/go_router.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      flexibleSpace: Container(
        decoration: const BoxDecoration(gradient: Constants.appBarGradient),
      ),
      title: SearchTextFormField(onTapSearchField: (String query) {
        context.pushNamed(AppRouteConstants.searchScreenRoute.name,
            pathParameters: {'searchQuery': query});
      }),
    );
  }
}
