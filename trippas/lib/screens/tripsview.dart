import 'package:trippas/models/trip.dart';
import 'package:trippas/utils/dbhelper.dart';
import 'package:flutter/material.dart';
import 'package:trippas/screens/detailview.dart';

class TripList extends StatefulWidget {
  @override
  _TripListState createState() => _TripListState();
}

class _TripListState extends State<TripList> {
  List<Trip> trip;
  int count;
  DbHelper helper = DbHelper();

  List<String> choices = ['Update', 'Delete'];
  static const meUpd = 'Update';
  static const meDel = 'Delete';

  select(String choice, index) async {
    switch (choice) {
      case meUpd:
        return navigator(this.trip[index]);
        break;
      case meDel:
        if (this.trip[index].id != null) {
          final result = await helper.deleteTrip(trip[index].id);
          if (result == 1) {
            AlertDialog alert = AlertDialog(
              title: Text('Deleted'),
              content: Text('Trip sucessfully deleted'),
              elevation: 20,
              actions: <Widget>[
                IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      Navigator.pop(context);
                      getTrip();
                    })
              ],
            );
            showDialog(
                context: context, barrierDismissible: false, child: alert);
          }
          break;
        }
    }
  }

  void getTrip() {
    final dbFuture = helper.intializeDb();
    dbFuture.then((result) {
      final tripsFuture = helper.getTrips();
      tripsFuture.then((result) {
        count = result.length;
        List<Trip> tripList = List<Trip>();
        for (int i = 0; i < count; i++) {
          tripList.add(Trip.fromObject(result[i]));
          debugPrint(tripList[i].id.toString());
          debugPrint(tripList[i].depDate);
        }
        setState(() {
          count = count;
          trip = tripList;
          debugPrint('item' + count.toString());
        });
      });
    });
  }

  ListView tripListView() {
  
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        return Card(
          //margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Column(
              children: <Widget>[
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        flex: 2,
                        child: Text(this.trip[index].departure,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15.0)),
                      ),
                      Expanded(
                        flex: 1,
                        child: Transform.rotate(
                            angle: 90 * 3.142 / 180,
                            child: Icon(
                              Icons.airplanemode_active,
                              size: 16,
                            )),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(this.trip[index].destination,
                            textAlign: TextAlign.right,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15.0)),
                      ),
                    ]),
                Padding(
                  padding: const EdgeInsets.only(top: 3.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(this.trip[index].depDate,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 10.0)),
                        Text(this.trip[index].desDate,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 10.0)),
                      ]),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 3.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(this.trip[index].depTime,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 10.0)),
                        Text(this.trip[index].desTime,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 10.0)),
                      ]),
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        decoration: BoxDecoration(
                            color: getColor(this.trip[index]),
                            borderRadius: BorderRadius.circular(1)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 2, horizontal: 8),
                          child: Text(this.trip[index].tripType,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10.0)),
                        ),
                      ),
                      PopupMenuButton(
                        onSelected: (String choice) => select(choice, index),
                        itemBuilder: (BuildContext context) =>
                            choices.map((value) {
                          return PopupMenuItem(
                              child: Text(value), value: value);
                        }).toList(),
                      )
                    ])
              ],
            ),
          ),
        );
      },
      itemCount: count,
    );
  }

  Color getColor(Trip trip) {
    switch (trip.tripType) {
      case "Education":
        return Colors.cyanAccent[700];
        break;
      case "Vacation":
        return Colors.yellow[400];
        break;
      case "Medical":
        return Colors.pinkAccent[400];
        break;
      case "Business":
        return Colors.blue[900];
        break;

      default:
        return Colors.white;
    }
  }

  void navigator(Trip trip) async {
    bool result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => TripDetail(trip)));
    if (result == true) {
      getTrip();
    }
  }

  state(){
    setState(() {
      getTrip();
    });
    return Container(
      color: Colors.cyanAccent,
      child:Center(child: Text('WELCOME',style: TextStyle(
      color: Colors.blueAccent,
      fontSize: 50.0,
      fontWeight: FontWeight.bold
    ),)));
    
  }

  @override
  Widget build(BuildContext context) {
    
   
    return trip == null ? state() : Scaffold(
      body: SafeArea(
        minimum: EdgeInsets.only(top: 50),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Hello, Jude',
                    style:
                        TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                    decoration: BoxDecoration(
                        color: Colors.blue[900],
                        borderRadius: BorderRadius.circular(20)),
                    child: Text(
                      '$count trips',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.fromLTRB(0, 10, 0, 30),
                child: Text(
                  'Create your\ntrips with us',
                  style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: tripListView(),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () => navigator(Trip('', '', '', '', '', '', 'Business')),
          tooltip: 'Add a new trip',
          child: Icon(Icons.add)),
    );
  }
}
