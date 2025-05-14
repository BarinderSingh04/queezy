import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:queezy/common/common.dart';
import 'package:queezy/model/result.dart';
import 'package:queezy/screens/cubit/auth_cubit.dart';
import 'package:queezy/screens/cubit/avatar_list_cubit.dart';
import 'package:queezy/screens/models/avatar_model.dart';
import 'package:queezy/widgets/buttons_widget.dart';

class SignUpPage extends StatefulWidget {
  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final PageController _controller = PageController();
  final _signupFormKeys = List.generate(3, (_) => GlobalKey<FormState>());

  int currentPage = 0;
  bool show = false;
  String? avatarSelected;

  final List<String> titles = ["What's your email?", "What's your password?", "Create a profile"];

  void _nextPage() {
    final _signupFormKey = _signupFormKeys[currentPage];
    if (_signupFormKey.currentState!.validate()) {
      _signupFormKey.currentState!.save();
      if (currentPage < 2) {
        _controller.nextPage(duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
      } else {
        context.read<AuthCubit>().signup();
      }
    }
  }

  void _prevPage() {
    if (currentPage > 0) {
      _controller.previousPage(duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorScheme.tertiary,
      appBar: AppBar(
        backgroundColor: context.colorScheme.tertiary,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: _prevPage,
        ),
        title: Text(titles[currentPage]),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocConsumer<AuthCubit, AuthenticationState>(
              listener: (context, state) {
                if (state is AuthenticationFailure) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(state.error.toString())));
                }
              },
              builder: (context, state) {
                return PageView(
                  physics: NeverScrollableScrollPhysics(),
                  controller: _controller,
                  onPageChanged: (index) {
                    setState(() => currentPage = index);
                  },
                  children: [
                    AddEmailPage(formKey: _signupFormKeys[0]),
                    AddPasswordPage(formKey: _signupFormKeys[1]),
                    AvatarPage(formKey: _signupFormKeys[2]),
                  ],
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "${currentPage + 1} of 3",
                    style: context.textTheme.bodyLarge!.copyWith(
                      color: context.colorScheme.secondary,
                      fontFamily: FontFamily.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                LinearProgressIndicator(
                  value: (currentPage + 1) / 3,
                  backgroundColor: Color.fromARGB(255, 208, 203, 243),
                  valueColor: AlwaysStoppedAnimation<Color>(context.colorScheme.secondary),
                ),
                SizedBox(height: 16),
                PrimaryButton(
                  isLoading: context.watch<AuthCubit>().state is AuthenticationLoading,
                  onPressed: _nextPage,
                  label: currentPage == 2 ? 'Sign Up' : "Next",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AddEmailPage extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  const AddEmailPage({super.key, required this.formKey});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(height: 16),
            TextFormField(
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
                prefixIcon: Icon(Icons.email_outlined, color: context.colorScheme.secondary),
                hintText: "Your email address",
              ),
              onSaved: (value) => context.read<AuthCubit>().updateForm("email", value),
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.emailAddress,
            ),
          ],
        ),
      ),
    );
  }
}

class AddPasswordPage extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  const AddPasswordPage({super.key, required this.formKey});

  @override
  State<AddPasswordPage> createState() => _AddPasswordPageState();
}

class _AddPasswordPageState extends State<AddPasswordPage> {
  final _passwordFormKey = GlobalKey<FormFieldState>();
  bool _obscuredPassword = true;
  bool _obscuredConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            TextFormField(
              key: _passwordFormKey,
              validator: (value) {
                if (value == null || value.length < 8) {
                  return 'Password must be at least 8 characters long';
                }
                return null;
              },
              obscureText: _obscuredPassword,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock_outline, color: context.colorScheme.secondary),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _obscuredPassword = !_obscuredPassword;
                    });
                  },
                  icon: Icon(
                    _obscuredPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                    color: Color(0xff858494),
                  ),
                ),
                hintText: "Your password",
                hintStyle: context.textTheme.bodyLarge!.copyWith(color: Color(0xff858494)),
              ),
              onSaved: (value) => context.read<AuthCubit>().updateForm("password", value),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 10),
            Text(
              "Must be at least 8 character",
              style: context.textTheme.bodyMedium!.copyWith(color: Color(0xff858494)),
            ),
            const SizedBox(height: 30),
            Text(
              "Confirm Password",
              style: context.textTheme.bodyMedium!.copyWith(fontFamily: FontFamily.w500),
            ),
            const SizedBox(height: 10),
            TextFormField(
              obscureText: _obscuredConfirmPassword,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Confirm password is required.';
                }
                if (value != _passwordFormKey.currentState!.value) {
                  return 'Passwords do not match.';
                }
                return null;
              },
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock_outline, color: context.colorScheme.secondary),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _obscuredConfirmPassword = !_obscuredConfirmPassword;
                    });
                  },
                  icon: Icon(
                    _obscuredConfirmPassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: Color(0xff858494),
                  ),
                ),
                hintText: "Your password",
              ),
              onSaved: (value) => context.read<AuthCubit>().updateForm("confirmPassword", value),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 10),
            Text(
              "Must be at same",
              style: context.textTheme.bodyMedium!.copyWith(color: Color(0xff858494)),
            ),
          ],
        ),
      ),
    );
  }
}

class AvatarPage extends StatefulWidget {
  final GlobalKey<FormState> formKey;

  const AvatarPage({super.key, required this.formKey});

  @override
  State<AvatarPage> createState() => _AvatarPageState();
}

class _AvatarPageState extends State<AvatarPage> with TickerProviderStateMixin {
  String? selectedAvatar;
  bool show = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: BlocBuilder<AvatarListCubit, Result<List<AvatarModel>>>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                SizedBox(height: 16),
                InkWell(
                  onTap: () {
                    setState(() {
                      show = true;
                    });
                  },
                  child: Center(
                    child:
                        selectedAvatar != null
                            ? SizedBox.square(
                              dimension: 80,
                              child: Stack(
                                children: [
                                  AnimatedContainer(
                                    duration: Duration(milliseconds: 200),
                                    width: 80,
                                    height: 80,
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
                                border: Border.all(color: const Color.fromARGB(255, 209, 208, 208)),
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter name';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.person_outline, color: context.colorScheme.secondary),
                    hintStyle: context.textTheme.bodyLarge!.copyWith(color: Color(0xff858494)),
                    hintText: "Enter your name",
                  ),
                  onSaved: (value) => context.read<AuthCubit>().updateForm("name", value),
                  textInputAction: TextInputAction.done,
                ),
              ],
            ),
          );
        },
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
