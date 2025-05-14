import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:queezy/common/common.dart';
import 'package:queezy/model/result.dart';
import 'package:queezy/screens/cubit/auth_cubit.dart';
import 'package:queezy/screens/cubit/avatar_list_cubit.dart';
import 'package:queezy/screens/models/auth_model.dart';
import 'package:queezy/screens/models/avatar_model.dart';
import 'package:queezy/widgets/buttons_widget.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  String? selectedAvatar;
  User? user;
  bool show = false;
  final fkey = GlobalKey<FormState>();

  @override
  void initState() {
    final state = context.read<AuthCubit>().state;
    if (state is AuthenticatedState) {
      user = state.authModel.data;
      selectedAvatar = user!.avatarPath;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffEFEEFC),
      appBar: AppBar(
        title: Text(
          "Edit Profile",
          style: context.textTheme.titleLarge!.copyWith(
            fontFamily: FontFamily.w700,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: fkey,
          child: BlocBuilder<AvatarListCubit, Result<List<AvatarModel>>>(
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    SizedBox(height: 24),
                    InkWell(
                      onTap: () {
                        setState(() {
                          show = true;
                        });
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                      child: Center(
                        child:
                            selectedAvatar != null
                                ? SizedBox.square(
                                  dimension: 95,
                                  child: Stack(
                                    children: [
                                      AnimatedContainer(
                                        duration: Duration(milliseconds: 200),
                                        width: 95,
                                        height: 95,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(color: Colors.grey.shade100, width: 2),
                                        ),
                                        child: Image.network(selectedAvatar!),
                                      ),
                                      Align(
                                        alignment: Alignment.bottomRight,
                                        child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              show = true;
                                            });
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: context.colorScheme.secondary,
                                              border: Border.all(
                                                width: 3,
                                                color: context.colorScheme.secondary,
                                              ),
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(2.0),
                                              child: Icon(
                                                Icons.add,
                                                color: context.colorScheme.onPrimary,
                                                size: 18,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                                : Container(
                                  height: 80,
                                  width: 80,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: const Color.fromARGB(255, 209, 208, 208),
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(Icons.add, color: context.colorScheme.secondary),
                                ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Avatar",
                      style: context.textTheme.bodyLarge!.copyWith(fontFamily: FontFamily.w500),
                    ),
                    getAvatar(state),
                    const SizedBox(height: 16),
                    TextFormField(
                      initialValue: user?.name,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter name';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.person_outline,
                          color: context.colorScheme.secondary,
                        ),
                        hintStyle: context.textTheme.bodyLarge!.copyWith(color: Color(0xff858494)),
                        hintText: "Enter your name",
                      ),
                      onSaved: (value) => context.read<AuthCubit>().updateForm("name", value),
                      textInputAction: TextInputAction.done,
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      initialValue: user?.email,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a valid email';
                        }
                        if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                          return 'Please enter a valid email format';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.email_outlined,
                          color: context.colorScheme.secondary,
                        ),
                        hintText: "Your email address",
                      ),
                      onSaved: (value) => context.read<AuthCubit>().updateForm("email", value),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: 24),
                    BlocConsumer<AuthCubit, AuthenticationState>(
                      listener: (context, state) {
                        if (state is AuthenticatedState) {
                          context.pop();
                        }
                        if (state is AuthenticationFailure) {
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text(state.error)));
                        }
                      },
                      builder: (context, state) {
                        return PrimaryButton(
                          isLoading: state is AuthenticationLoading,
                          label: "Update",
                          onPressed: () {
                            if (fkey.currentState!.validate()) {
                              fkey.currentState!.save();
                              context.read<AuthCubit>().updateProfile();
                            }
                          },
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget getAvatar(Result<List<AvatarModel>> state) {
    return state.when(
      onData: (data) {
        return Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: AnimatedSize(
            curve: Curves.easeInOut,
            duration: Duration(milliseconds: 250),
            child:
                show
                    ? GridView.builder(
                      shrinkWrap: true,
                      itemCount: data!.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemBuilder: (context, index) {
                        final avatar = data[index];
                        return InkWell(
                          onTap: () {
                            FocusManager.instance.primaryFocus?.unfocus();
                            context.read<AuthCubit>().updateForm("avatar", avatar.localPath);
                            setState(() {
                              show = false;
                              selectedAvatar = avatar.path;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color:
                                    selectedAvatar == avatar.path
                                        ? context.colorScheme.secondary
                                        : Colors.grey.shade100,
                                width: 3,
                              ),
                            ),
                            child: Image.network(avatar.path),
                          ),
                        );
                      },
                    )
                    : SizedBox.shrink(),
          ),
        );
      },
      onLoading: () {
        return Center(child: CircularProgressIndicator());
      },
      onError: (e) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Center(child: Text(e.toString())),
        );
      },
    );
  }
}
