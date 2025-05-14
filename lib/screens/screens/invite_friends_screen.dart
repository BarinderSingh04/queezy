import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:queezy/common/common.dart';
import 'package:queezy/widgets/buttons_widget.dart';

class InviteFriendsScreen extends StatefulWidget {
  const InviteFriendsScreen({super.key, this.code});
  final String? code;

  @override
  State<InviteFriendsScreen> createState() => _InviteFriendsScreenState();
}

class _InviteFriendsScreenState extends State<InviteFriendsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Invite Friend",
          style: context.textTheme.titleLarge!.copyWith(
            color: context.colorScheme.onPrimary,
            fontFamily: FontFamily.w500,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: Center(
        child: Container(
          height: 392,
          width: 327,
          decoration: BoxDecoration(
            color: context.colorScheme.secondary,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 150,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    color: Color(0xff9087E5),
                    image: DecorationImage(
                      image: AssetImage("assets/images/invitebg.png"),
                      fit: BoxFit.contain,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 27.0, vertical: 30),
                    child: Column(
                      spacing: 6,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset("assets/images/avatar5.png"),
                        Text(
                          "Invite Friend",
                          style: context.textTheme.titleLarge!.copyWith(
                            color: context.colorScheme.onPrimary,
                            fontFamily: FontFamily.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              Positioned(
                top: 130,
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/Union.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        Text(
                          "Invite friends and get a bonus points for every new player!",
                          textAlign: TextAlign.center,
                          style: context.textTheme.bodyLarge!.copyWith(fontFamily: FontFamily.w500),
                        ),
                        const SizedBox(height: 24),
                        Container(
                          height: 56,
                          width: MediaQuery.sizeOf(context).width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Color(0xffbfd2f2)),
                            color: Color(0xffEFEEFC),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Center(
                              child: Text(
                                widget.code ?? "",
                                style: context.textTheme.bodyLarge!.copyWith(
                                  fontFamily: FontFamily.w700,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(
                              child: PrimaryIconButton(
                                onPressed: () async {
                                  try {
                                    await Clipboard.setData(ClipboardData(text: widget.code!));
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text("Code copied to clippboard.")),
                                    );
                                  } catch (e) {
                                    ScaffoldMessenger.of(
                                      context,
                                    ).showSnackBar(SnackBar(content: Text(e.toString())));
                                  }
                                },
                                label: "Copy Code",
                                icon: Icon(Icons.content_paste),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Color(0xffe1def9)),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Icon(
                                  Icons.share_outlined,
                                  color: context.colorScheme.secondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
