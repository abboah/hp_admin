import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hp_admin/constants/controllers.dart';
import 'package:hp_admin/helpers/reponsiveness.dart';
import 'package:hp_admin/pages/clients/widgets/clients_table.dart';
import 'package:hp_admin/widgets/custom_text.dart';

class ClientsPage extends StatelessWidget {
  const ClientsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(
          () => Row(
            children: [
              Container(
                  margin: EdgeInsets.only(
                      top: ResponsiveWidget.isSmallScreen(context) ? 56 : 6),
                  child: CustomText(
                    text: menuController.activeItem.value,
                    size: 24,
                    weight: FontWeight.bold,
                  )),
            ],
          ),
        ),
        Expanded(
            flex: 2,
            child: ListView(
              children: const [
                ClientsTable(),
              ],
            )),
      ],
    );
  }
}
