import 'package:flutter/material.dart';
import 'package:project1/Machanic.dart';
import 'package:table_calendar/table_calendar.dart';

class Appointment extends StatefulWidget {
  final String? selectedCarType;
  final String? servicetype;
  const Appointment({
    Key? key,
    required this.selectedCarType,
    required this.servicetype,
  }) : super(key: key);

  @override
  State<Appointment> createState() => _AppointmentState();
}

class _AppointmentState extends State<Appointment> {
  List<String> timeslot = [
    "9am-10am",
    "10am-11am",
    "11am-12pm",
    "12pm-1pm",
    "1pm-2pm",
    "2pm-3pm",
    "3pm-4pm",
    "4pm-5pm",
    "5pm-6pm",
  ];
  DateTime Today = DateTime.now();
  String? selectedTimeSlotIndex;
  String? selectedCarType;
  String? servicetype;

  @override
  Widget build(BuildContext context) {
    // Assign the context to the variable
    return Scaffold(
      backgroundColor: const Color(0xFFe8f7fb),
      appBar: AppBar(
        backgroundColor: const Color(0xFF519EB7),
        title: const Center(child: Text('Make Appointments')),
      ),
      body: SafeArea(
        child: Builder(
          builder: (BuildContext scaffoldContext) {
            // Use Builder to obtain the proper context
            return SingleChildScrollView(
              child: Column(
                children: [
                  const Align(
                    alignment: AlignmentDirectional.topStart,
                    child: Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Text(
                        'Pick A Date',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  TableCalendar(
                    focusedDay: Today,
                    selectedDayPredicate: (day) => isSameDay(day, Today),
                    firstDay: DateTime.utc(2024, 01, 01),
                    lastDay: DateTime.utc(2030, 01, 01),
                    onDaySelected: _onDaySelected,
                  ),
                  Text("Date is ${Today.toString().split(" ")[0]}"),
                  const SizedBox(height: 20),
                  const Divider(
                    thickness: 5,
                    height: 4,
                    color: Color(0xFF519EB7),
                  ),
                  const Align(
                    alignment: AlignmentDirectional.topStart,
                    child: Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Text(
                        'Pick A Time Slot',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Wrap(
                    spacing: 15.0,
                    runSpacing: 10.0,
                    children: List.generate(
                      timeslot.length, // Use timeslot.length here
                      (index) => InkWell(
                        onTap: () {
                          setState(() {
                            selectedTimeSlotIndex = timeslot[index];
                          });
                          print(
                              'Selected time slot: ${timeslot[index]}'); // Print the selected time slot value
                        },
                        child: Container(
                          height: 40,
                          width: 110,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: selectedTimeSlotIndex == timeslot[index]
                                ? Colors.blue
                                : const Color.fromARGB(255, 214, 211, 211),
                          ),
                          child: Center(child: Text(timeslot[index])),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: ElevatedButton(
                      onPressed: () {
                        
                        print(
                            'Selected time slot: $selectedTimeSlotIndex');
                            
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Machanic(
                              servicetype: widget.servicetype,
                              selectedCarType: widget.selectedCarType,
                              selectedTimeSlotIndex: selectedTimeSlotIndex,
                              Today: Today,
                            ), // Pass selectedTimeSlotIndex and today
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF130E4E),
                        fixedSize: const Size(223, 56),
                      ),
                      child: const Text(
                        'Submit',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      Today = day;
    });
    
  }
}
