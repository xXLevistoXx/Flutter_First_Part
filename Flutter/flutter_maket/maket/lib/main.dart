import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'medinow',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromRGBO(234, 230, 217, 100)),
        useMaterial3: true,
      ),
      home: const AuthScreen(),
    );
  }
}

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/backgroundd.jpg'), 
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'medinow',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Meditate With Us',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AccountScreen()),
                    );
                  },
                  child: const Text('sign in with Apple'),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const MeditateScreen()),
                    );
                  },
                  child: const Text('Continue with Email or Phone'),
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SessionScreen()),
                  );
                },
                child: const Text(
                  'Continue with Google',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
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

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Organizer'),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/ava.jpg'), 
            ),
            const SizedBox(height: 16),
            const Text(
              'Uteshin Lev',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text(
                      '2,368',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text('Followers'),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      '346',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text('Following'),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      '13',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text('Events'),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                  },
                  icon: const Icon(Icons.person_add),
                  label: const Text('Follow'),
                ),
                const SizedBox(width: 16),
                OutlinedButton.icon(
                  onPressed: () {
                  },
                  icon: const Icon(Icons.message),
                  label: const Text('Messages'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                  },
                  child: const Text('About'),
                ),
                ElevatedButton(
                  onPressed: () {
                  },
                  child: const Text('Events'),
                ),
                ElevatedButton(
                  onPressed: () {
                  },
                  child: const Text('Reviewers'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Expanded(
              child: SingleChildScrollView(
                child: Text(
                  'About: Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MeditateScreen extends StatelessWidget {
  const MeditateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Meditate',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const Divider(
            color: Colors.black26,
            height: 1,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildSortButton('All'),
                _buildSortButton('Bible in a Year'),
                _buildSortButton('Dallies'),
                _buildSortButton('Minutes'),
                _buildSortButton('Sun'),
                _buildSortButton('Moon'),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: _buildCard(
                    image: 'assets/card1.jpg',
                    title: 'A Song of Moon',
                    description: 'Start with the basics',
                    sessions: '9 Sessions',
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: _buildCard(
                        image: 'assets/card2.jpg',
                        title: 'The Sleep Hour',
                        description: 'Ashna Mukherjee',
                        sessions: '3 Sessions',
                      ),
                    ),
                    Expanded(
                      child: _buildCard(
                        image: 'assets/card3.jpg',
                        title: 'Easy on the Mission',
                        description: 'Peter Mach',
                        sessions: '5 Minutes',
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: _buildCard(
                        image: 'assets/card4.jpg',
                        title: 'Relax with Me',
                        description: 'Amanda James',
                        sessions: '3 Minutes',
                      ),
                    ),
                    Expanded(
                      child: _buildCard(
                        image: 'assets/card5.jpg',
                        title: 'Sun and Energy',
                        description: 'Micheal Hiu',
                        sessions: '5 Minutes',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSortButton(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ElevatedButton(
        onPressed: () {
        },
        child: Text(label),
      ),
    );
  }

  Widget _buildCard({
    required String image,
    required String title,
    required String description,
    required String sessions,
  }) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            image,
            fit: BoxFit.cover,
            height: 150,
            width: double.infinity,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.favorite),
                    const SizedBox(width: 4),
                    Text(sessions),
                    const Spacer(),
                    TextButton.icon(
                      onPressed: () {
                      },
                      label: const Text('Start >'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SessionScreen extends StatelessWidget {
  const SessionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Container(
            margin: const EdgeInsets.all(8.0),
            height: MediaQuery.of(context).size.height / 3,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              image: const DecorationImage(
                image: AssetImage('assets/session_image.jpg'), 
                fit: BoxFit.cover,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Peter Mach',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Mind Deep Relax',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Join the Community as we prepare over 33 days to relax and feel joy with the mind and happnies session across the World.',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                 Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, 
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.play_arrow, color: Colors.white),
                  SizedBox(width: 8), 
                  Text('Play Next Session'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildSessionItem(
            iconColor: Colors.blue,
            title: 'Sweet Memories',
            description: 'December 29 Pre-Launch',
          ),
          _buildSessionItem(
            iconColor: Colors.green,
            title: 'A Day Dream',
            description: 'December 29 Pre-Launch',
          ),
          _buildSessionItem(
            iconColor: Colors.orange,
            title: 'A Day Dream',
            description: 'December 29 Pre-Launch',
          ),
        ],
      ),
    );
  }

  Widget _buildSessionItem({
    required Color iconColor,
    required String title,
    required String description,
  }) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8.0), 
        child: Container(
          color: iconColor,
          width: 40.0, 
          height: 40.0, 
          child: const Icon(Icons.play_arrow, color: Colors.white),
        ),
      ),
      title: Text(title),
      subtitle: Text(description),
      trailing: const Icon(Icons.more_horiz),
    );
  }
}