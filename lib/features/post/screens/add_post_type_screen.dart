import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pipheaksa/core/common/error_text.dart';
import 'package:pipheaksa/core/common/loader.dart';
import 'package:pipheaksa/core/utils.dart';
import 'package:pipheaksa/features/community/controller/community_controller.dart';
import 'package:pipheaksa/features/post/controller/post_controller.dart';
import 'package:pipheaksa/models/community_model.dart';
import 'package:pipheaksa/theme/pallet.dart';

class AddPostTypeScreen extends ConsumerStatefulWidget {
  final String type;

  const AddPostTypeScreen({super.key, required this.type});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddPostTypeScreenState();
}

class _AddPostTypeScreenState extends ConsumerState<AddPostTypeScreen> {
  final titleController = TextEditingController();
  final descController = TextEditingController();
  final linkController = TextEditingController();
  File? bannerFile;
  List<Community> communities = [];
  Community? selectedCommunity;

  @override
  void dispose() {
    titleController.dispose();
    descController.dispose();
    linkController.dispose();
    super.dispose();
  }

  void selectBannerImage() async {
    final res = await pickImage();
    if (res != null) {
      setState(() {
        bannerFile = File(res.files.first.path!);
      });
    }
  }

  void sharePost() {
    final postController = ref.read(postControllerProvider.notifier);

    if (widget.type == 'image' && bannerFile != null && titleController.text.isNotEmpty) {
      postController.shareImagePost(
        context: context,
        title: titleController.text.trim(),
        selectedCommunity: selectedCommunity ?? communities[0],
        file: bannerFile,
      );
    } else if (widget.type == 'text' &&
        titleController.text.isNotEmpty &&
        descController.text.isNotEmpty) {
      postController.shareTextPost(
        context: context,
        title: titleController.text.trim(),
        selectedCommunity: selectedCommunity ?? communities[0],
        description: descController.text.trim(),
      );
    } else if (widget.type == 'link' &&
        titleController.text.isNotEmpty &&
        linkController.text.isNotEmpty) {
      postController.shareLinkPost(
        context: context,
        title: titleController.text.trim(),
        selectedCommunity: selectedCommunity ?? communities[0],
        link: linkController.text.trim(),
      );
    } else {
      showSnackBar('Please enter all the fields.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTypeImage = widget.type == 'image';
    final isTypeText = widget.type == 'text';
    final isTypeLink = widget.type == 'link';
    final currentTheme = ref.watch(themeNotifierProvider);
    final isLoading = ref.watch(postControllerProvider);

    return isLoading
        ? const Loader()
        : Scaffold(
            appBar: AppBar(
              title: Text('Post ${widget.type}'),
              actions: [
                TextButton(onPressed: sharePost, child: const Text('Share')),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      filled: true,
                      hintText: 'Enter Title here',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(18),
                    ),
                    maxLength: 30,
                  ),
                  const SizedBox(height: 10),
                  if (isTypeImage)
                    GestureDetector(
                      onTap: () => selectBannerImage(),
                      child: DottedBorder(
                        borderType: BorderType.RRect,
                        radius: const Radius.circular(10),
                        dashPattern: const [10, 4],
                        strokeCap: StrokeCap.round,
                        color: currentTheme.textTheme.bodyMedium!.color!,
                        child: Container(
                            width: double.infinity,
                            height: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: bannerFile != null
                                ? Image.file(bannerFile!)
                                : const Center(
                                    child: Icon(
                                      Icons.camera_alt_outlined,
                                      size: 40,
                                    ),
                                  )),
                      ),
                    ),
                  if (isTypeText)
                    TextField(
                      controller: descController,
                      decoration: const InputDecoration(
                        filled: true,
                        hintText: 'Enter Description here',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(18),
                      ),
                      maxLines: 5,
                    ),
                  if (isTypeLink)
                    TextField(
                      controller: linkController,
                      decoration: const InputDecoration(
                        filled: true,
                        hintText: 'Enter Link here',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(18),
                      ),
                    ),
                  const SizedBox(height: 20),
                  const Align(
                    alignment: Alignment.topLeft,
                    child: Text('Select Community'),
                  ),
                  ref.watch(userCommunitiesProvider).when(
                        data: (data) {
                          communities = data;

                          if (data.isEmpty) return const SizedBox();

                          return DropdownButton(
                            value: selectedCommunity ?? data[0],
                            items: data
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e.name),
                                  ),
                                )
                                .toList(),
                            onChanged: (community) {
                              setState(() => selectedCommunity = community);
                            },
                          );
                        },
                        error: (error, stackTrace) => ErrorText(error: error.toString()),
                        loading: () => const Loader(),
                      ),
                ],
              ),
            ));
  }
}
