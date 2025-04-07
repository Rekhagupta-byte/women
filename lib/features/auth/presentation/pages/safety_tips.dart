import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import 'base_page.dart';

class SafetyTechnique {
  final String name;
  final String description;
  final String videoPath;

  const SafetyTechnique(this.name, this.description, this.videoPath);
}

class EmergencyContact {
  final String name;
  final String number;
  final String description;

  const EmergencyContact(this.name, this.number, this.description);
}

class VideoPlayerWidget extends StatefulWidget {
  final String videoPath;

  const VideoPlayerWidget({Key? key, required this.videoPath})
      : super(key: key);

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(widget.videoPath)
      ..setLooping(true);
    _initializeVideoPlayerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Stack(
            alignment: Alignment.center,
            children: [
              AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              ),
              FloatingActionButton(
                onPressed: () {
                  setState(() {
                    if (_controller.value.isPlaying) {
                      _controller.pause();
                    } else {
                      _controller.play();
                    }
                  });
                },
                child: Icon(
                  _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                ),
              ),
            ],
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

class SafetyGuidePage extends StatelessWidget {
  const SafetyGuidePage({super.key});

  static const List<EmergencyContact> emergencyContacts = [
    EmergencyContact('Women Helpline', '1091', 'Available 24/7'),
    EmergencyContact('Police', '100', 'Emergency Response'),
    EmergencyContact('Ambulance', '102', 'Medical Emergency'),
    EmergencyContact('Domestic Violence', '181', 'Support Helpline'),
  ];

  static const List<SafetyTechnique> safetyTechniques = [
    SafetyTechnique(
      'Groin Kick',
      'If someone is coming at you from the front, a groin kick may deliver enough force to paralyze your attacker, making your escape possible.',
      'assets/WSA1.mp4',
    ),
    SafetyTechnique(
      'Heel Palm Strike',
      'This move can cause damage to the nose or throat. To execute, get in front of your attacker as much as is possible.',
      'assets/WSA2.mp4',
    ),
    SafetyTechnique(
      'Elbow Strike',
      'If your attacker is in close range and you are unable to get enough momentum to throw a strong punch or kick, use your elbows.',
      'assets/WSA3.mp4',
    ),
    SafetyTechnique(
      'Alternative Elbow Strike',
      'Depending on how you are standing when you are initially attacked, you may be in a better position for variations on the elbow strike.',
      'assets/WSA4.mp4',
    ),
    SafetyTechnique(
      'Escape from Attack',
      'For cases where the attacker is coming from behind, you will want to use this move. Focus on getting low and creating space to free yourself.',
      'assets/WSA5.mp4',
    ),
    SafetyTechnique(
      'Escape from hands trapped',
      'If your attacker comes from behind and traps your arms (this is similar to a bear hug, but you would not be able to move as freely), here is what to do:',
      'assets/WSA6.mp4',
    ),
    SafetyTechnique(
      'Escape from side headlock',
      'When the attacker locks their arm around your head from the side, your first instinct should be to avoid getting chocked.',
      'assets/WSA7.mp4',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return BasePage(
      body: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Safety Guide'),
            bottom: const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.phone), text: 'Helplines'),
                Tab(icon: Icon(Icons.fitness_center), text: 'Defense'),
                Tab(icon: Icon(Icons.tips_and_updates), text: 'Tips'),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              _buildHelplineTab(),
              _buildDefenseTab(),
              _buildTipsTab(),
            ],
          ),
        ),
      ),
      selectedIndex: 2,
    );
  }

  Widget _buildHelplineTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: emergencyContacts.length,
      itemBuilder: (context, index) {
        final contact = emergencyContacts[index];
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0), // ✅ Adds uniform spacing
            child: IntrinsicHeight(
              // ✅ Balances row height based on tallest element
              child: Row(
                crossAxisAlignment:
                    CrossAxisAlignment.stretch, // ✅ Makes items align evenly
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.red,
                    child: Icon(Icons.phone, color: Colors.white),
                  ),
                  SizedBox(width: 12), // ✅ Keeps spacing between avatar & text
                  Expanded(
                    // ✅ Ensures text doesn't overflow
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment:
                          MainAxisAlignment.center, // ✅ Centers text vertically
                      children: [
                        Text(
                          contact.name,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 4),
                        Text(contact
                            .description), // ✅ Full description is visible
                      ],
                    ),
                  ),
                  ElevatedButton.icon(
                    icon: Icon(Icons.call),
                    label: Text(contact.number),
                    onPressed: () => _launchCall(contact.number),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDefenseTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: safetyTechniques.length,
      itemBuilder: (context, index) {
        final technique = safetyTechniques[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: Column(
            children: [
              SizedBox(
                height: 200,
                child: VideoPlayerWidget(videoPath: technique.videoPath),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      technique.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(technique.description),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTipsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        TipCard(
          'Stay Alert',
          'Always be aware of your surroundings',
          Icons.visibility,
        ),
        TipCard(
          'Share Location',
          'Keep trusted contacts informed of your whereabouts',
          Icons.location_on,
        ),
        TipCard(
          'Trust Instincts',
          'If something feels wrong, leave immediately',
          Icons.psychology,
        ),
        TipCard(
          'Plan Ahead',
          'Know your routes and keep emergency numbers handy',
          Icons.map,
        ),
      ],
    );
  }

  Future<void> _launchCall(String number) async {
    final Uri callUri = Uri(scheme: 'tel', path: number);
    try {
      if (await canLaunchUrl(callUri)) {
        await launchUrl(callUri);
      }
    } catch (e) {
      debugPrint('Could not launch $callUri: $e');
    }
  }
}

class TipCard extends StatelessWidget {
  final String title;
  final String content;
  final IconData icon;

  const TipCard(this.title, this.content, this.icon, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.red),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(content),
          ],
        ),
      ),
    );
  }
}
