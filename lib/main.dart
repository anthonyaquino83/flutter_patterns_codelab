// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import 'data.dart';

void main() {
  runApp(const DocumentApp());
}

class DocumentApp extends StatelessWidget {
  const DocumentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: DocumentScreen(
        document: Document(),
      ),
    );
  }
}

class DocumentScreen extends StatelessWidget {
  final Document document;

  const DocumentScreen({
    required this.document,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // final metadataRecord = document.metadata; // record
    // final (title, modified: modified) = document.metadata; // pattern
    // pattern shorthand for field and variable with same name
    // final (title, :modified) = document.metadata;
    final (title, :modified) = document.metadataWithPattern;
    final formattedModifiedDate = formatDate(modified); // Add this line
    final blocks = document.getBlocks();

    return Scaffold(
      appBar: AppBar(
        // title: Text(metadataRecord.$1), // Modify this line,
        title: Text(title), // Modify this line,
      ),
      body: Column(
        children: [
          Text(
            // 'Last modified ${metadataRecord.modified}',
            // 'Last modified $modified',
            'Last modified: $formattedModifiedDate',
          ),
          Expanded(
            child: ListView.builder(
              itemCount: blocks.length,
              itemBuilder: (context, index) {
                return BlockWidget(block: blocks[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}

// class BlockWidget extends StatelessWidget {
//   final Block block;

//   const BlockWidget({
//     required this.block,
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     TextStyle? textStyle;
//     // A switch expression looks similar to a switch statement,
//     // but it eliminates the case keyword and uses =>
//     // to separate the pattern from the case body.
//     textStyle = switch (block.type) {
//       'h1' => Theme.of(context).textTheme.displayMedium,
//       'p' || 'checkbox' => Theme.of(context).textTheme.bodyMedium,
//       _ => Theme.of(context).textTheme.bodySmall
//     };

//     return Container(
//       margin: const EdgeInsets.all(8),
//       child: Text(
//         block.text,
//         style: textStyle,
//       ),
//     );
//   }
// }

class BlockWidget extends StatelessWidget {
  final Block block;

  const BlockWidget({
    required this.block,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      child: switch (block) {
        HeaderBlock(:final text) => Text(
            text,
            style: Theme.of(context).textTheme.displayMedium,
          ),
        ParagraphBlock(:final text) => Text(text),
        CheckboxBlock(:final text, :final isChecked) => Row(
            children: [
              Checkbox(value: isChecked, onChanged: (_) {}),
              Text(text),
            ],
          ),
      },
    );
  }
}

String formatDate(DateTime dateTime) {
  final today = DateTime.now();
  final difference = dateTime.difference(today);
  return switch (difference) {
    Duration(inDays: 0) => 'today',
    Duration(inDays: 1) => 'tomorrow',
    Duration(inDays: -1) => 'yesterday',
    Duration(inDays: final days) when days > 7 => '${days ~/ 7} weeks from now',
    Duration(inDays: final days) when days < -7 =>
      '${days.abs() ~/ 7} weeks ago',
    Duration(inDays: final days, isNegative: true) => '${days.abs()} days ago',
    Duration(inDays: final days) => '$days days from now',
  };
}
