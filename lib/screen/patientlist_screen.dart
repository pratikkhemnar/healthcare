import 'package:flutter/material.dart';
import 'package:healthcare/screen/patientdetails_screen.dart';

class PatientListScreen extends StatefulWidget {
  const PatientListScreen({super.key});

  @override
  State<PatientListScreen> createState() => _PatientListScreenState();
}

class _PatientListScreenState extends State<PatientListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _filter = 'All'; // Filter option
  final List<Map<String, String>> _patients = [
    {
      'name': 'John Doe',
      'bed': '101',
      'condition': 'Stable',
      'lastAlert': '2 hrs ago'
    },
    {
      'name': 'Jane Smith',
      'bed': '102',
      'condition': 'Critical',
      'lastAlert': '10 mins ago'
    },
    {
      'name': 'Alice Johnson',
      'bed': '103',
      'condition': 'Improving',
      'lastAlert': '1 day ago'
    },
    {
      'name': 'Bob Brown',
      'bed': '104',
      'condition': 'Critical',
      'lastAlert': '5 mins ago'
    },

  ];

  List<Map<String, String>> get filteredPatients {
    List<Map<String, String>> filtered = _patients;

    // Apply filter
    if (_filter != 'All') {
      filtered = filtered
          .where((patient) => patient['condition'] == _filter)
          .toList();
    }

    // Apply search
    if (_searchController.text.isNotEmpty) {
      filtered = filtered
          .where((patient) => patient['name']!
          .toLowerCase()
          .contains(_searchController.text.toLowerCase()))
          .toList();
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patient List'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade300, Colors.blue.shade100],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {});
                },
                decoration: InputDecoration(
                  labelText: 'Search Patient',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            // Filter Dropdown
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: DropdownButton<String>(
                value: _filter,
                isExpanded: true,
                items: ['All', 'Stable', 'Critical', 'Improving']
                    .map((condition) => DropdownMenuItem(
                  value: condition,
                  child: Text(condition),
                ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _filter = value!;
                  });
                },
                style: const TextStyle(fontSize: 16, color: Colors.black87),
                underline: Container(
                  height: 2,
                  color: Colors.blueAccent,
                ),
              ),
            ),
            // Patient List
            Expanded(
              child: ListView.builder(
                itemCount: filteredPatients.length,
                itemBuilder: (context, index) {
                  final patient = filteredPatients[index];
                  return Card(
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    shadowColor: Colors.blueAccent.withOpacity(0.3),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      leading: CircleAvatar(
                        backgroundColor: Colors.blueAccent,
                        radius: 30,
                        child: Text(
                          patient['bed']!,
                          style: const TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                      title: Text(
                        patient['name']!,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Condition: ${patient['condition']}',
                            style: const TextStyle(fontSize: 14),
                          ),
                          Text(
                            'Last Alert: ${patient['lastAlert']}',
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                      trailing: Icon(
                        Icons.info,
                        color: Colors.blueAccent,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                PatientDetailsScreen(patient: patient),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
