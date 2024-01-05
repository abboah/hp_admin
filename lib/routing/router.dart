import 'package:flutter/material.dart';
import 'package:hp_admin/pages/clients/clients.dart';
import 'package:hp_admin/pages/overview/overview.dart';
import 'package:hp_admin/pages/products/products_page.dart';
import 'package:hp_admin/routing/routes.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case overviewPageRoute:
      return _getPageRoute(const OverviewPage());
    case clientsPageRoute:
      return _getPageRoute(const ClientsPage());
    case productsPageRoute:
      return _getPageRoute(const ProductsPage());
    default:
      return _getPageRoute(const OverviewPage());
  }
}

PageRoute _getPageRoute(Widget child) {
  return MaterialPageRoute(builder: (context) => child);
}
