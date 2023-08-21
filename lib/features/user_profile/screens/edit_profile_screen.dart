import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pipheaksa/core/common/error_text.dart';
import 'package:pipheaksa/core/common/loader.dart';
import 'package:pipheaksa/core/constants/constants.dart';
import 'package:pipheaksa/core/utils.dart';
import 'package:pipheaksa/features/auth/controller/auth_controller.dart';
import 'package:pipheaksa/features/user_profile/controller/user_profile_controller.dart';
import 'package:pipheaksa/theme/pallet.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  final String uid;

  const EditProfileScreen({super.key, required this.uid});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  File? bannerFile;
  File? profileFile;
  late TextEditingController nameController;

  @override
  void initState() {
    nameController = TextEditingController(text: ref.read(userProvider)!.name);
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
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

  void selectProfileImage() async {
    final res = await pickImage();
    if (res != null) {
      setState(() {
        profileFile = File(res.files.first.path!);
      });
    }
  }

  void save() {
    ref.read(userProfileControllerProvider.notifier).editUserProfile(
          profileFile: profileFile,
          bannerFile: bannerFile,
          context: context,
          name: nameController.text.trim(),
        );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(userProfileControllerProvider);
    final currentTheme = ref.watch(themeNotifierProvider);

    return isLoading
        ? const Loader()
        : ref.watch(getUserDataProvider(widget.uid)).when(
              data: (user) => Scaffold(
                backgroundColor: currentTheme.backgroundColor,
                appBar: AppBar(
                  centerTitle: false,
                  title: const Text('Edit Profile'),
                  actions: [
                    TextButton(
                      onPressed: save,
                      child: const Text('Save'),
                    ),
                  ],
                ),
                body: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 200,
                        child: Stack(
                          children: [
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
                                      : user.banner.isEmpty ||
                                              user.banner == Constants.bannerDefault
                                          ? const Center(
                                              child: Icon(
                                                Icons.camera_alt_outlined,
                                                size: 40,
                                              ),
                                            )
                                          : Image.network(user.banner),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 20,
                              left: 20,
                              child: GestureDetector(
                                  onTap: () => selectProfileImage(),
                                  child: profileFile != null
                                      ? CircleAvatar(
                                          backgroundImage: FileImage(profileFile!),
                                          radius: 32,
                                        )
                                      : CircleAvatar(
                                          backgroundImage: NetworkImage(user.profilePic),
                                          radius: 32,
                                        )),
                            )
                          ],
                        ),
                      ),
                      TextField(
                        controller: nameController,
                        decoration: InputDecoration(
                          filled: true,
                          hintText: 'Name',
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.blue),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.all(18),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              error: (error, stackTrace) => ErrorText(error: error.toString()),
              loading: () => const Loader(),
            );
  }
}
