import 'package:flutter/material.dart';

import '../config/constants.dart';

class MySenderCard extends StatelessWidget {
  final String name;
  final String departement;
  final String? serial;
  const MySenderCard({
    super.key,
    required this.name,
    required this.departement,
    required this.serial,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 100,
      width: double.infinity,
      decoration: BoxDecoration(
        color: greenPrimary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: greenSecondary,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                bottomLeft: Radius.circular(10),
              ),
            ),
            child: const Column(
              children: [
                Icon(
                  Icons.person_pin_rounded,
                  color: greenPrimary,
                  size: 28,
                ),
                heightS,
                Text(
                  'Info Pengirim',
                  style: TextStyle(
                      fontSize: 6,
                      fontWeight: FontWeight.w500,
                      color: greenPrimary,),
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                width: 230,
                child: Text(
                  'Nama  : $name',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    overflow: TextOverflow.ellipsis
                  ),
                ),
              ),
              SizedBox(
                width: 230,
                child: Text(
                  'Posisi  : $departement',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(
                width: 230,
                child: Text(
                  'Serial  : $serial',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}