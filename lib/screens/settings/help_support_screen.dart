import 'package:flutter/material.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final primaryGreen = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: primaryGreen,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Faq's",
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
          children: [
            // Dummy answers add kiye hain, aap inhein project ke hisaab se tabdeel kar sakte hain
            _buildFaqTile(
              'What is Cultivest and how does it help farmers?',
              'Cultivest is a comprehensive agricultural marketplace that connects farmers, sellers, and experts to facilitate smooth trading and provide modern farming solutions.',
            ),
            _buildFaqTile(
              'Who can use the Cultivest platform?',
              'Farmers, agricultural experts, buyers, and sellers of agricultural equipment or products can easily use this platform to grow their business.',
            ),
            _buildFaqTile(
              'Is Cultivest available in my region or city?',
              'Currently, Cultivest is expanding across major agricultural hubs in Pakistan. You can use the location settings to find services near you.',
            ),
            _buildFaqTile(
              'How do I buy or sell agricultural products on Cultivest?',
              'Simply navigate to the Marketplace section from the bottom menu, where you can browse available products or list your own inventory if you are a seller.',
            ),
            _buildFaqTile(
              'How do I access expert advice or live sessions?',
              'Go to the Learning Tools or Community section to find scheduled expert sessions, agricultural guides, and forums for direct interaction.',
            ),
          ],
        ),
      ),
    );
  }

  // --- Modular UI Builder for FAQ Cards ---
  Widget _buildFaqTile(String question, String answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15.0),
      decoration: BoxDecoration(
        color: const Color(0xFF408C45), // Thora sa lighter green taake background se alag nazar aaye
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 4,
            offset: const Offset(0, 4), // Halki si shadow 3D effect ke liye
          ),
        ],
      ),
      child: Theme(
        // ExpansionTile ke default borders hide karne ki technique
        data: ThemeData(dividerColor: Colors.transparent), 
        child: ExpansionTile(
          iconColor: Colors.white, // Expanded hone par arrow ka color
          collapsedIconColor: Colors.white, // Collapse hone par arrow ka color
          title: Text(
            question,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
              height: 1.3,
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 15.0),
              child: Text(
                answer,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
