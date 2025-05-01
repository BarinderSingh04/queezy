import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:queezy/common/common.dart';
import 'package:queezy/di/service_locator.dart';
import 'package:queezy/model/result.dart';
import 'package:queezy/routes/routes.dart';
import 'package:queezy/screens/cubit/auth_cubit.dart';
import 'package:queezy/screens/models/auth_model.dart';
import 'package:queezy/widgets/buttons_widget.dart';

class SignUpPage extends StatefulWidget {
  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final PageController _controller = PageController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmpasswordController =
      TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final _signupFormKey = GlobalKey<FormState>();

  int currentPage = 0;
  bool show = false;
  String? avatarSelected;

  final List avatar = [
    "assets/images/avatar1.png",
    "assets/images/avatar2.png",
    "assets/images/avatar3.png",
    "assets/images/avatar4.png",
    "assets/images/avatar5.png",
    "assets/images/avatar6.png",
    "assets/images/avatar7.png",
    "assets/images/avatar8.png",
    "assets/images/avatar9.png",
    "assets/images/avatar10.png",
    "assets/images/avatar11.png",
    "assets/images/avatar12.png",
  ];

  final List<String> titles = [
    "What's your email?",
    "What's your password?",
    "Create a username",
  ];

  void _nextPage() {
    if (_signupFormKey.currentState!.validate()) {
      if (currentPage < 2) {
        _controller.nextPage(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      } else {
        if (_signupFormKey.currentState!.validate()) {
          _signupFormKey.currentState!.save();
          context.read<AuthCubit>().signup();
        }
      }
    }
  }

  void _prevPage() {
    if (currentPage > 0) {
      _controller.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
          backgroundColor: context.colorScheme.tertiary,
          appBar: AppBar(
            backgroundColor: context.colorScheme.tertiary,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: _prevPage,
            ),
            title: Text(
              titles[currentPage],
              style: context.textTheme.headlineSmall!.copyWith(
                fontFamily: FontFamily.w500,
              ),
            ),
            centerTitle: true,
          ),
          body: Column(
            children: [
              Expanded(
                child: Form(
                  key: _signupFormKey,
                  child: BlocConsumer<AuthCubit, Result<AuthModel>>(
                    listener: (context, state) {
                      if (state.data != null) {
                        Navigator.pushNamed(context, NavRoute.bottomNav.path);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Signup successfull!")),
                        );
                      }
                      if (state.error != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(state.error.toString())),
                        );
                      }
                    },
                    builder: (context, state) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
                        child: PageView(
                          controller: _controller,
                                      
                          onPageChanged: (index) {
                            setState(() => currentPage = index);
                          },
                          children: [
                            _buildInputField(
                              Icons.email_outlined,
                              "Your email address",
                              emailController,
                            ),
                            _buildPasswordField(),
                                      
                            _buildAvatarInputField(
                              Icons.person_outline,
                              "Your username",
                              usernameController,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
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
                      valueColor: AlwaysStoppedAnimation<Color>(
                        context.colorScheme.secondary,
                      ),
                    ),
              
                    SizedBox(height: 16),
                    PrimaryButton(
                      onPressed: _nextPage,
                      label:
                          currentPage == 2
                              ? 'Sign Up'
                              : "Next",
                    ),
                  ],
                ),
              ),
            ],
          ),
    );
  }

  Widget _buildInputField(
    IconData icon,
    String hint,
    TextEditingController controller,
  ) {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a valid email';
        }
        if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
          return 'Please enter a valid email format';
        }
        return null;
      },
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: context.colorScheme.secondary),
        hintText: hint,
        hintStyle: context.textTheme.bodyLarge!.copyWith(
          color: Color(0xff858494),
        ),
        filled: true,
        fillColor: context.colorScheme.onPrimary,
        contentPadding: EdgeInsets.symmetric(vertical: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
      onSaved:
              (value) => context.read<AuthCubit>().updateForm("email", value),
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.emailAddress,
    );
  }

  Widget _buildAvatarInputField(
    IconData icon,
    String hint,
    TextEditingController controller,
  ) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            setState(() {
              show = true;
            });
          },
          child: Center(
            child:
                avatarSelected != null
                    ? Stack(
                      children: [
                        Image.asset(avatarSelected ?? '', scale: 0.9),
                        SizedBox(
                          height: 67,
                          width: 67,
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  show = true;
                                });
                                avatarGrid();
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
                        ),
                      ],
                    )
                    : Container(
                      height: 65,
                      width: 65,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color.fromARGB(255, 209, 208, 208),
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Icon(
                        Icons.add,
                        color: context.colorScheme.secondary,
                      ),
                    ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          "Avatar",
          style: context.textTheme.bodyLarge!.copyWith(
            fontFamily: FontFamily.w500,
          ),
        ),

        show == true ? avatarGrid() : SizedBox.shrink(),
        const SizedBox(height: 30),
        TextFormField(
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter name';
            }

            return null;
          },
          controller: controller,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: context.colorScheme.secondary),
            hintText: hint,
            hintStyle: context.textTheme.bodyLarge!.copyWith(
              color: Color(0xff858494),
            ),
            filled: true,
            fillColor: context.colorScheme.onPrimary,
            contentPadding: EdgeInsets.symmetric(vertical: 20),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
          ),
          onSaved:
              (value) => context.read<AuthCubit>().updateForm("name", value),
          textInputAction: TextInputAction.done,
        ),
      ],
    );
  }

  Container avatarGrid() {
    return Container(
      height: 300,
      child: GridView.builder(
        itemCount: avatar.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
        ),
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              avatarSelected = avatar[index];
              context.read<AuthCubit>().updateForm("avatar", avatarSelected);
              setState(() {
                show = false;
              });
            },
            child: Image.asset(avatar[index]),
          );
        },
      ),
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          validator: (value) {
            if (value == null || value.length < 8) {
              return 'Password must be at least 8 characters long';
            }
            return null;
          },
          controller: passwordController,
          obscureText: true,
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.lock_outline,
              color: context.colorScheme.secondary,
            ),
            suffixIcon: Icon(
              Icons.visibility_off_outlined,
              color: Color(0xff858494),
            ),
            hintText: "Your password",
            hintStyle: context.textTheme.bodyLarge!.copyWith(
              color: Color(0xff858494),
            ),
            filled: true,
            fillColor: context.colorScheme.onPrimary,
            contentPadding: EdgeInsets.symmetric(vertical: 20),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
          ),
          onSaved:
              (value) => context.read<AuthCubit>().updateForm("password", value),
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 10),
        Text(
          "Must be at least 8 character",
          style: context.textTheme.bodyMedium!.copyWith(
            color: Color(0xff858494),
          ),
        ),
        const SizedBox(height: 30),
        Text(
          "Confirm Password",
          style: context.textTheme.bodyMedium!.copyWith(
            fontFamily: FontFamily.w500,
          ),
        ),
        const SizedBox(height: 10),
        _buildConfirmPasswordField(),
      ],
    );
  }

  Widget _buildConfirmPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          validator: (value) {
            if (value == null || value != passwordController.text) {
              return 'Password must be confirmed';
            }
            return null;
          },
          controller: confirmpasswordController,
          obscureText: true,
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.lock_outline,
              color: context.colorScheme.secondary,
            ),
            suffixIcon: Icon(
              Icons.visibility_off_outlined,
              color: Color(0xff858494),
            ),
            hintText: "Your password",
            hintStyle: context.textTheme.bodyLarge!.copyWith(
              color: Color(0xff858494),
            ),
            filled: true,
            fillColor: context.colorScheme.onPrimary,
            contentPadding: EdgeInsets.symmetric(vertical: 20),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
          ),
          onSaved:
              (value) => context.read<AuthCubit>().updateForm("confirmPassword", value),
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 10),
        Text(
          "Must be at same",
          style: context.textTheme.bodyMedium!.copyWith(
            color: Color(0xff858494),
          ),
        ),
      ],
    );
  }
}
