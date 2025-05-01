// class TrueFalseWidget extends StatefulWidget {
//   const TrueFalseWidget({super.key});

//   @override
//   State<TrueFalseWidget> createState() => _TrueFalseWidgetState();
// }

// class _TrueFalseWidgetState extends State<TrueFalseWidget> {
//   final PageController _pageController = PageController();

//   final int totalQuestions = 2;

//   int currentQuestion = 1;

//   String? selected;

//   int skipped = 0;

//   final _controller = CountDownController();

//   bool isAnswered = false;

//   final List<Map<String, dynamic>> questions = [
//     {
//       'question': 'Theodorus of Samos is the person who invented keys??',
//       'options': ['True', 'False'],
//       'correct': "True",
//     },
//     {
//       'question': 'Are you human?',
//       'options': ['True', 'False'],
//       'correct': "True",
//     },
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: PageView.builder(
//         controller: _pageController,
//         itemCount: questions.length,
//         onPageChanged: (index) {},
//         itemBuilder: (context, index) {
//           final question = questions[index];
//           return Container(
//             margin: EdgeInsets.all(16),
//             padding: EdgeInsets.all(20),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(28),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const SizedBox(height: 10),

//                 Center(
//                   child: SizedBox(
//                     height: 100,
//                     width: 100,
//                     child: CountDownProgressIndicator(
//                       controller: _controller,
//                       strokeWidth: 50,
//                       valueColor: Colors.pink.shade100,
//                       backgroundColor: Colors.transparent,
//                       initialPosition: 0,
//                       duration: 10,
//                       onComplete: () {
//                         if (selected != question["correct"]) {
//                           setState(() {
//                             skipped++;
//                             selected = null;
//                             isAnswered = false;

//                             if (_pageController.page!.round() <
//                                 totalQuestions - 1) {
//                               _pageController.nextPage(
//                                 duration: Duration(milliseconds: 300),
//                                 curve: Curves.easeIn,
//                               );
//                               _controller.restart(initialPosition: 10);
//                             } else {
//                               final score = totalQuestions - skipped;
//                               Navigator.pushNamed(
//                                 context,
//                                 NavRoute.resultScreen.path,
//                                 arguments: score,
//                               );
//                             }
//                           });
//                         }
//                       },
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 20),
//                 Text(
//                   'Question ${index + 1} of $totalQuestions',
//                   style: context.textTheme.bodyMedium!.copyWith(
//                     color: context.colorScheme.onSecondary,
//                     fontFamily: FontFamily.w500,
//                   ),
//                 ),
//                 SizedBox(height: 10),
//                 Center(
//                   child: Image.asset("assets/images/boolIllustration.png"),
//                 ),
//                 const SizedBox(height: 10),
//                 Text(
//                   question["question"].toString(),
//                   style: context.textTheme.titleLarge,
//                 ),
//                 SizedBox(height: 24),
//                 Expanded(
//                   child: ListView.separated(
//                     itemCount: question["options"].length,
//                     itemBuilder: (BuildContext context, int optionIndex) {
//                       final optionText = question["options"][optionIndex];
//                       bool isCorrect = selected == question["correct"];
//                       bool isSelected = selected == optionText;

//                       return InkWell(
//                         onTap:
//                             selected == null
//                                 ? () {
//                                   setState(() {
//                                     selected = optionText;
//                                     isAnswered = true;

//                                     if (selected == question["correct"]) {
//                                       Future.delayed(
//                                         Duration(milliseconds: 500),
//                                         () {
//                                           if (_pageController.page!.round() <
//                                               totalQuestions - 1) {
//                                             _pageController.nextPage(
//                                               duration: Duration(
//                                                 milliseconds: 300,
//                                               ),
//                                               curve: Curves.easeIn,
//                                             );
//                                             _controller.restart(
//                                               initialPosition: 10,
//                                             );
//                                           }
//                                           selected = null;
//                                           isAnswered = false;
//                                         },
//                                       );
//                                     }
//                                   });
//                                 }
//                                 : null,

//                         child: Container(
//                           margin: EdgeInsets.symmetric(vertical: 8),
//                           padding: EdgeInsets.symmetric(
//                             horizontal: 16,
//                             vertical: 14,
//                           ),
//                           decoration: BoxDecoration(
//                             color:
//                                 isSelected
//                                     ? (isCorrect ? Colors.green : Colors.red)
//                                     : Colors.white,

//                             borderRadius: BorderRadius.circular(16),
//                             border: Border.all(color: Colors.grey.shade300),
//                           ),
//                           child: Text(
//                             optionText,
//                             style:
//                                 isSelected
//                                     ? context.textTheme.bodyLarge!.copyWith(
//                                       fontFamily: FontFamily.w500,
//                                     )
//                                     : context.textTheme.bodyLarge,
//                           ),
//                         ),
//                       );
//                     },
//                     separatorBuilder: (BuildContext context, int index) {
//                       return const SizedBox(height: 10);
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
