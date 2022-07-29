/*
import 'dart:math';

import 'package:flutter/material.dart';

import '../../../models/inquiryChatModel.dart';


// RANDOM DATA

final Random random = Random.secure();


List<ChatEntry> getChatEntries() {
  final nbMessages = random.nextInt(17) + 3;
  final lastRead = random.nextInt(nbMessages);
  DateTime date = DateTime.now();
  return List.generate(
    nbMessages,
        (index) {
      date = date.subtract(Duration(minutes: random.nextInt(30)));
      return ChatEntry(
        text: faker.lorem
            .words(2 + random.nextInt(random.nextBool() ? 3 : 15))
            .join(' '),
        date: date,
        read: index >= lastRead,
        sent: random.nextBool(),
      );
    },
  ).reversed.toList();
}*/
