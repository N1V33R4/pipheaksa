import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pipheaksa/theme/pallet.dart';

class AddPostTypeScreen extends ConsumerStatefulWidget {
  final String type;

  const AddPostTypeScreen({super.key, required this.type});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddPostTypeScreenState();
}

class _AddPostTypeScreenState extends ConsumerState<AddPostTypeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
