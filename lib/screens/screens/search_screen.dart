import 'package:flutter/material.dart';
import 'package:queezy/common/common.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Discover",
          style: context.textTheme.titleLarge!.copyWith(
            color: context.colorScheme.onPrimary,
            fontFamily: FontFamily.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF7B6CF9),
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color(0xff5b4dc3),
                  prefixIcon: Icon(
                    Icons.search,
                    color: context.colorScheme.onPrimary,
                  ),
                  hintText: "Quiz, categories, or friends",
                  hintStyle: context.textTheme.bodyMedium!.copyWith(
                    color: context.colorScheme.onPrimary,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: DefaultTabController(
                length: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TabBar(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      labelPadding: EdgeInsets.symmetric(horizontal: 4),
                      tabAlignment: TabAlignment.fill,
                      labelColor: context.colorScheme.secondary,
                      labelStyle: context.textTheme.bodyMedium!.copyWith(
                        fontFamily: FontFamily.w700,
                      ),
                      unselectedLabelColor: Colors.grey,
                      indicatorColor: Colors.deepPurple,
                      indicatorWeight: 1,
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicator: CircleTabIndicator(
                        color: Colors.deepPurple,
                        radius: 3,
                      ),

                      dividerColor: Colors.transparent,
                      tabs: [
                        Tab(text: 'Top'),
                        Tab(text: 'Quiz'),
                        Tab(text: 'Categories'),
                        Tab(text: 'Friends'),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          _TopTabContent(),
                          Center(child: Text('Quiz')),
                          Center(child: Text('Categories')),
                          Center(child: Text('Friends')),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CircleTabIndicator extends Decoration {
  final BoxPainter _painter;

  CircleTabIndicator({required Color color, required double radius})
    : _painter = _CirclePainter(color, radius);

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) => _painter;
}

class _CirclePainter extends BoxPainter {
  final Paint _paint;
  final double radius;

  _CirclePainter(Color color, this.radius)
    : _paint =
          Paint()
            ..color = color
            ..isAntiAlias = true;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration cfg) {
    if (cfg.size == null) return;

    final Offset circleOffset =
        offset + Offset(cfg.size!.width / 2, cfg.size!.height - radius);

    canvas.drawCircle(circleOffset, radius, _paint);
  }
}

class _TopTabContent extends StatelessWidget {
  const _TopTabContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Quiz',
              style: context.textTheme.titleLarge!.copyWith(
                fontFamily: FontFamily.w500,
              ),
            ),
            Text(
              'See all',
              style: context.textTheme.bodyMedium!.copyWith(
                color: context.colorScheme.secondary,
                fontFamily: FontFamily.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _QuizCard(
          title: 'Statistics Math Quiz',
          subtitle: 'Math • 12 Quizzes',
          image: Image.asset("assets/images/stats_frame.png"),
        ),
        const SizedBox(height: 16),
        _QuizCard(
          title: 'Matrices Quiz',
          subtitle: 'Math • 6 Quizzes',
          image: Image.asset("assets/images/maths_frame.png"),
        ),
        const SizedBox(height: 32),
        Text(
          'Friends',
          style: context.textTheme.titleLarge!.copyWith(
            fontFamily: FontFamily.w500,
          ),
        ),
        const SizedBox(height: 16),
        _FriendTile(
          name: 'Maren Workman',
          points: 325,
          image: 'assets/images/avatar1.png',
          flag: "assets/images/colombia.png",
        ),
        _FriendTile(
          name: 'Brandon Matrovs',
          points: 124,
          image: 'assets/images/avatar2.png',
          flag: 'assets/images/czech_republic.png',
        ),
        _FriendTile(
          name: 'Manuela Lipshutz',
          points: 437,
          image: 'assets/images/avatar3.png',
          flag: 'assets/images/italy.png',
        ),
      ],
    );
  }
}

class _QuizCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Image image;

  const _QuizCard({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: EdgeInsets.all(8),
      child: ListTile(
        leading: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
          child: image,
        ),
        title: Text(
          title,
          style: context.textTheme.bodyLarge!.copyWith(
            fontFamily: FontFamily.w500,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: context.textTheme.bodyMedium!.copyWith(
            fontFamily: FontFamily.w400,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 18,
          color: context.colorScheme.secondary,
        ),
      ),
    );
  }
}

class _FriendTile extends StatelessWidget {
  final String name;
  final int points;
  final String image;
  final String flag;

  const _FriendTile({
    Key? key,
    required this.name,
    required this.points,
    required this.image,
    required this.flag,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Stack(
        children: [
          CircleAvatar(radius: 30, backgroundImage: AssetImage(image)),
          SizedBox(height: 80, width: 60, child: Align(
            alignment: Alignment.bottomRight,
            child: Image.asset(flag))),
        ],
      ),
      title: Text(
        name,
        style: context.textTheme.bodyLarge!.copyWith(
          fontFamily: FontFamily.w500,
        ),
      ),
      subtitle: Text(
        '$points points',
        style: context.textTheme.bodyMedium!.copyWith(
          fontFamily: FontFamily.w400,
        ),
      ),
    );
  }
}
