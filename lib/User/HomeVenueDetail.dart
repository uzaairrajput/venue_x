import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:venue_x/User/UserBooking.dart';
import 'package:venue_x/model.dart/venuedetailmodel.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VenueDetails extends StatefulWidget {
  final Venue venue;

  const VenueDetails({Key? key, required this.venue}) : super(key: key);

  @override
  _VenueDetailsState createState() => _VenueDetailsState();
}

class _VenueDetailsState extends State<VenueDetails> {
  late DateTime _selectedDate;
  late String _selectedEvent;
  late String _selectedCapacity;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _selectedEvent = 'Select Event';
    _selectedCapacity = 'Select Capacity';
  }

  // Function to add a new booking request to Firestore
  Future<void> _addBookingRequest() async {
    try {
      // Get the current user
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Use the current user's ID
        String userId = user.uid;

        // Add the booking request with the user's ID
        await FirebaseFirestore.instance.collection('bookingRequests').add({
          'venueName': widget.venue.name,
          'userId': userId,
          'selectedDate': _selectedDate,
          'selectedEvent': widget.venue.event_type,
          'selectedCapacity': widget.venue.capacity,
          'status': 'pending', // Initial status is pending
        });

        // Navigate to the booking screen after adding the request
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BookingScreen(
              venueName: widget.venue.name,
              selectedDate: _selectedDate,
              selectedEvent: widget.venue.event_type,
              selectedCapacity: widget.venue.capacity,
              userId: userId,
            ),
          ),
        );

        // Show a success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Booking request sent')),
        );
      }
    } catch (e) {
      // Show an error message if something goes wrong
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error sending booking request')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Venue Details'),
      ),
      body: ListView(
        children: [
          // Image
          Container(
            height: 200.0,
            child: Image.network(
              widget.venue.imagePath,
              fit: BoxFit.cover,
            ),
          ),
          // Name
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.venue.name,
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, fontFamily: 'Roboto'),
            ),
          ),
          // Description
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Text(
              widget.venue.description,
              style: TextStyle(fontSize: 16.0, fontFamily: 'OpenSans'),
            ),
          ),
          // Address
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Address: ${widget.venue.address}',
              style: TextStyle(fontSize: 16.0, fontFamily: 'OpenSans'),
            ),
          ),
          // Capacity
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Capacity: ${widget.venue.capacity}',
              style: TextStyle(fontSize: 16.0, fontFamily: 'OpenSans'),
            ),
          ),
          // Event Type
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Event Type: ${widget.venue.event_type}',
              style: TextStyle(fontSize: 16.0, fontFamily: 'OpenSans'),
            ),
          ),
          // Location
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Location: ${widget.venue.location}',
              style: TextStyle(fontSize: 16.0, fontFamily: 'OpenSans'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Available Dates:',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: widget.venue.dates.map((date) {
                        return Text(
                          DateFormat('yyyy-MM-dd').format(date),
                          style: const TextStyle(fontSize: 16),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Book Now Button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _addBookingRequest,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurpleAccent,
              ),
              child: Text(
                'Book Now',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}