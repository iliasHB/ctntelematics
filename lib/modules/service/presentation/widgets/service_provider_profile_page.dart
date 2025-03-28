import 'package:flutter/material.dart';

void main() {
  runApp(ServiceProviderProfilePage());
}

class ServiceProviderProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainProfileScreen(),
    );
  }
}

class MainProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Icon(Icons.arrow_back, color: Colors.green),
        title: Text(
          "Mechanic Profile",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          Icon(Icons.add, color: Colors.black),
          SizedBox(width: 20),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProfileSection(),
            SizedBox(height: 20),
            TabSection(),
            SizedBox(height: 20),
            SpecializationSection(),
            SizedBox(height: 20),
            CustomerReviewsSection(),
          ],
        ),
      ),
    );
  }
}

class ProfileSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 40,
          backgroundImage: AssetImage('assets/mechanic.jpg'), // Replace with your image
        ),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Daniel Johnson",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                "AC Technician / Wiring",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  Icon(Icons.location_on, size: 16, color: Colors.black54),
                  SizedBox(width: 4),
                  Text("Oregun, Ikeja, Lagos", style: TextStyle(fontSize: 14)),
                ],
              ),
              Text("12km away - 18mins", style: TextStyle(fontSize: 14)),
              Row(
                children: [
                  Icon(Icons.star, color: Colors.yellow, size: 18),
                  SizedBox(width: 4),
                  Text("4.8", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
        ),
        Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.green[200],
              child: Icon(Icons.call, color: Colors.white),
            ),
            SizedBox(width: 10),
            CircleAvatar(
              backgroundColor: Colors.green[200],
              child: Icon(Icons.message, color: Colors.white),
            ),
          ],
        ),
      ],
    );
  }
}

class TabSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.green[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          TabButton("About", true),
          TabButton("Specialization", false),
          TabButton("Reviews", false),
        ],
      ),
    );
  }
}

class TabButton extends StatelessWidget {
  final String label;
  final bool isActive;

  TabButton(this.label, this.isActive);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 16,
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          color: isActive ? Colors.black : Colors.grey[600],
        ),
      ),
    );
  }
}

class SpecializationSection extends StatelessWidget {
  final List<String> specializations = [
    "Engine Diagnostics & Repairs",
    "Electrical Systems",
    "Transmission Repairs",
    "Brake System Maintenance",
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Specialist in", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: specializations.map((spec) => SpecializationBadge(spec)).toList(),
        ),
      ],
    );
  }
}

class SpecializationBadge extends StatelessWidget {
  final String text;

  SpecializationBadge(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.green[200],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 14),
      ),
    );
  }
}

class CustomerReviewsSection extends StatelessWidget {
  final List<Map<String, String>> reviews = [
    {
      "name": "Michael Adeyemi",
      "service": "Engine Diagnostics and Tune-Up (Toyota Camry)",
      "rating": "4.8",
      "review":
      "Daniel did an amazing job on my Camry’s engine. He quickly identified the issue and got it running smoothly again. I really appreciated the detailed explanation and honest approach!",
    },
    {
      "name": "Sarah Olumide",
      "service": "Brake System Overhaul (Honda Accord)",
      "rating": "4.8",
      "review":
      "I felt safe driving my car again after Daniel worked on the brakes. He was thorough, efficient, and the service was very affordable. Highly recommended!",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Customers Review", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        Column(
          children: reviews.map((review) => ReviewCard(review)).toList(),
        ),
      ],
    );
  }
}

class ReviewCard extends StatelessWidget {
  final Map<String, String> review;

  ReviewCard(this.review);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: Colors.green[200],
            child: Icon(Icons.person, color: Colors.white),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(review["name"]!, style: TextStyle(fontWeight: FontWeight.bold)),
                Text(review["service"]!, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                SizedBox(height: 5),
                Text(review["review"]!),
              ],
            ),
          ),
          Column(
            children: [
              Icon(Icons.star, color: Colors.yellow),
              Text(review["rating"]!, style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}
