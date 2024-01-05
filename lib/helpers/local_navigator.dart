import 'package:flutter/material.dart';
import 'package:hp_admin/constants/controllers.dart';
import 'package:hp_admin/routing/router.dart';
import 'package:hp_admin/routing/routes.dart';

Navigator localNavigator() => Navigator(
      key: navigationController.navigatorKey,
      onGenerateRoute: generateRoute,
      initialRoute: overviewPageRoute,
    );
