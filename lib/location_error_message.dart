import 'package:flutter/material.dart';

class LocationErrorMessage extends StatelessWidget {
  final bool visible;
  final bool onlyContent;

  const LocationErrorMessage({super.key, required this.visible, this.onlyContent = false});

  @override
  Widget build(BuildContext context) {
    return onlyContent
        ? (visible ? const SizedBox() : _buildContent())
        : Visibility(
            visible: visible,
            child: Container(
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(35), topLeft: Radius.circular(35)),
                    color: Theme.of(context).colorScheme.onBackground),
                child: _buildContent()));
  }

  _buildContent() {
    return const Padding(
      padding: EdgeInsets.all(15.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(Icons.location_on),
              Text(
                "Location:",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "Note: android version 11 and lower requires enabling location for the device detection",
          ),
        ],
      ),
    );
  }
}
