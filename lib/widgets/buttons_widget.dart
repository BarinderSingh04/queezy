import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:queezy/common/common.dart';

class PrimaryIconButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;
  final Icon icon;

  const PrimaryIconButton({
    super.key,
    required this.onPressed,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: icon,
      label: Text(
        label,
        style: context.textTheme.bodyLarge!.copyWith(
          fontFamily: FontFamily.w500,
          color: context.colorScheme.onPrimary,
        ),
      ),
      style: ElevatedButton.styleFrom(
        fixedSize: Size(MediaQuery.sizeOf(context).width, 56),
        backgroundColor: context.colorScheme.secondary,

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}

class PrimaryButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isLoading;
  final String label;

  const PrimaryButton({
    super.key,
    this.isLoading = false,
    required this.onPressed,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child:
          isLoading
              ? Center(
                child: LoadingAnimationWidget.horizontalRotatingDots(color: Colors.white, size: 34),
              )
              : Text(
                label,
                style: context.textTheme.bodyLarge!.copyWith(
                  fontFamily: FontFamily.w500,
                  color: context.colorScheme.onPrimary,
                ),
              ),
      style: ElevatedButton.styleFrom(
        fixedSize: Size(MediaQuery.sizeOf(context).width, 50),
        backgroundColor: context.colorScheme.secondary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}

class OutlineButton extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;
  final bool isLoading;
  const OutlineButton({super.key, required this.title, this.onPressed, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        fixedSize: Size(MediaQuery.sizeOf(context).width, 50),
        backgroundColor: context.colorScheme.onPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: context.colorScheme.onSecondary),
        ),
      ),
      onPressed: onPressed,
      child:
          isLoading
              ? Center(
                child: LoadingAnimationWidget.horizontalRotatingDots(
                  color: context.colorScheme.secondary,
                  size: 34,
                ),
              )
              : Text(
                title,
                style: context.textTheme.bodyMedium!.copyWith(
                  color: context.colorScheme.secondary,
                  fontFamily: FontFamily.w500,
                ),
              ),
    );
  }
}

class RoundedIconButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;
  final Icon? icon;
  final ImageIcon? image;
  final Color color;

  const RoundedIconButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.icon,
    this.image,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: icon ?? image,
      label: Text(
        label,
        style: context.textTheme.bodyLarge!.copyWith(
          fontFamily: FontFamily.w500,
          color: context.colorScheme.secondary,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: StadiumBorder(),
        elevation: 1,
      ),
    );
  }
}

class GoogleLoginButton extends StatelessWidget {
  final VoidCallback onPressed;

  const GoogleLoginButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Image.asset('assets/images/google-g-logo-85b2.png', height: 20),
      label: Text(
        'Login with Google',
        style: context.textTheme.bodyLarge!.copyWith(fontFamily: FontFamily.w500),
      ),
      style: ElevatedButton.styleFrom(
        fixedSize: Size(MediaQuery.sizeOf(context).width, 56),
        backgroundColor: Colors.white,

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 2,
      ),
    );
  }
}

class FacebookLoginButton extends StatelessWidget {
  final VoidCallback onPressed;

  const FacebookLoginButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(Icons.facebook, color: Colors.white, size: 28),
      label: Text(
        'Login with Facebook',
        style: context.textTheme.bodyLarge!.copyWith(
          fontFamily: FontFamily.w500,
          color: context.colorScheme.onPrimary,
        ),
      ),
      style: ElevatedButton.styleFrom(
        fixedSize: Size(MediaQuery.sizeOf(context).width, 56),
        backgroundColor: Color(0xFF0056B2),

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}

class LightPrimaryButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;

  const LightPrimaryButton({super.key, required this.onPressed, required this.label});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(
        label,
        style: context.textTheme.bodyLarge!.copyWith(
          fontFamily: FontFamily.w500,
          color: context.colorScheme.secondary,
        ),
      ),
      style: ElevatedButton.styleFrom(
        fixedSize: Size(MediaQuery.sizeOf(context).width, 50),
        backgroundColor: context.colorScheme.tertiary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}

class PlainTextButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;
  final Color color;

  const PlainTextButton({
    super.key,
    required this.onPressed,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        label,
        style: context.textTheme.bodyLarge!.copyWith(fontFamily: FontFamily.w500, color: color),
      ),
    );
  }
}
