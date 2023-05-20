import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PlaceScreensController extends GetxController {
  var titleEditingController = TextEditingController();
  var descriptionEditingController = TextEditingController();

  @override
  void dispose() {
    titleEditingController.dispose();
    descriptionEditingController.dispose();
    super.dispose();
  }
}


List<Widget> getCommonPlaceWidgets(PlaceScreensController controller) {
  List<Widget> detailWidgets = <Widget>[];

  detailWidgets.add(
    TextFormField(
      controller: controller.titleEditingController,
      decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          hintText: 'Place Title'),
    ),
  );

  detailWidgets.add(
    const SizedBox(
      height: 20,
    ),
  );

  detailWidgets.add(
    TextFormField(
      controller: controller.descriptionEditingController,
      maxLength: 100,
      minLines: 4,
      maxLines: 6,
      decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          hintText: 'Place Description'),
    ),
  );

  return detailWidgets;
}