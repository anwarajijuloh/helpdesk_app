import 'package:flutter/material.dart';

import '../config/constants.dart';

myAppBar(BuildContext ctx, String name, Function() onPressed) => AppBar(
      forceMaterialTransparency: true,
      centerTitle: false,
      toolbarHeight: 80,
      title: Padding(
        padding: const EdgeInsets.only(left: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Welcome',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: greenPrimary,
              ),
            ),
          ],
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 20),
          decoration: BoxDecoration(
              border: Border.all(
                color: grey1,
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(50)),
          child: IconButton(
            icon: const Icon(Icons.exit_to_app_rounded),
            onPressed: () {
              showDialog(
                context: ctx,
                builder: (ctx) {
                  return AlertDialog(
                    title: const Text('Apakah anda ingin keluar?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(),
                        child: const Text('Batal'),
                      ),
                      TextButton(
                        onPressed: onPressed,
                        child: const Text('Keluar'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ],
    );