import 'package:intl/intl.dart';
import 'package:trippas/models/trip.dart';
import 'package:trippas/utils/dbhelper.dart';
import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/cupertino.dart';

class TripDetail extends StatefulWidget {
  final Trip trip;
  TripDetail(this.trip);

  @override
  _TripDetailState createState() => _TripDetailState(trip);
}

class _TripDetailState extends State<TripDetail> {
  Trip trip;
  _TripDetailState(this.trip);

  final tripTypes = ['Business', 'Vacation', 'Medical', 'Education'];

  TextEditingController depContr = TextEditingController();
  TextEditingController desContr = TextEditingController();
  TextEditingController date1Contr = TextEditingController();
  TextEditingController date2Contr = TextEditingController();
  TextEditingController time1Contr = TextEditingController();
  TextEditingController time2Contr = TextEditingController();
  TextEditingController tripContr = TextEditingController();

  @override
  Widget build(BuildContext context) {
    depContr.text = this.trip.departure;
    desContr.text = this.trip.destination;
    date1Contr.text = this.trip.depDate;
    date2Contr.text = this.trip.desDate;
    time1Contr.text = this.trip.depTime;
    time2Contr.text = this.trip.desTime;
    tripContr.text = this.trip.tripType;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon:Icon(Icons.arrow_back_ios), onPressed: () => Navigator.pop(context, false),),
        automaticallyImplyLeading: false,
        title: Text(
          'Create Trip',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData.fallback(),
        backgroundColor: Colors.white70,
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
        children: <Widget>[
          TextField(
            onChanged: (value) => this.trip.departure = depContr.text,
            controller: depContr,
            decoration: InputDecoration(labelText: 'Enter departure'),
            textCapitalization: TextCapitalization.words,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                  child: DateTimeField(
                      controller: date1Contr,
                      onShowPicker: (context, currentValue) async {
                        return await showDatePicker(
                            context: context,
                            firstDate: DateTime(1900),
                            initialDate: currentValue ?? DateTime.now(),
                            lastDate: DateTime(2100));
                      },
                      format: DateFormat.yMMMMd("en_US"),
                      decoration: InputDecoration(labelText: 'Enter date'),
                      onChanged: (dt) {
                        debugPrint('$dt');
                        this.trip.depDate =
                            DateFormat.yMMMMd("en_US").format(dt);
                        debugPrint(trip.depDate);
                        debugPrint(date1Contr.text);
                      })),
              SizedBox(
                width: 20,
              ),
              Expanded(
                child: DateTimeField(
                    controller: time1Contr,
                    onShowPicker: (context, currentValue) async {
                      final time = await showTimePicker(
                          context: context,
                          initialTime: currentValue ?? TimeOfDay.now());
                      return DateTimeField.convert(time);
                    },
                    format: DateFormat.jm(),
                    decoration: InputDecoration(labelText: 'Enter time'),
                    onChanged: (t) {
                      this.trip.depTime = DateFormat.jm().format(t);
                    }),
              ),
            ],
          ),
          TextField(
            onChanged: (value) => this.trip.destination = desContr.text,
            controller: desContr,
            decoration: InputDecoration(labelText: 'Enter destination'),
            textCapitalization: TextCapitalization.words,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                  child: DateTimeField(
                      controller: date2Contr,
                      onShowPicker: (context, currentValue) async {
                        return await showDatePicker(
                            context: context,
                            firstDate: DateTime(1900),
                            initialDate: currentValue ?? DateTime.now(),
                            lastDate: DateTime(2100));
                      },
                      format: DateFormat.yMMMMd("en_US"),
                      decoration: InputDecoration(labelText: 'Enter date'),
                      onChanged: (dt) {
                        debugPrint('$dt');
                        this.trip.desDate =
                            DateFormat.yMMMMd("en_US").format(dt);
                        debugPrint(trip.desDate);
                      })),
              SizedBox(
                width: 20,
              ),
              Expanded(
                child: DateTimeField(
                    controller: time2Contr,
                    onShowPicker: (context, currentValue) async {
                      final time = await showTimePicker(
                          context: context,
                          initialTime: currentValue ?? TimeOfDay.now());
                      return DateTimeField.convert(time);
                    },
                    format: DateFormat.jm(),
                    decoration: InputDecoration(labelText: 'Enter time'),
                    onChanged: (t) {
                      this.trip.desTime = DateFormat.jm().format(t);
                    }),
              ),
            ],
          ),
          DropdownButtonFormField<String>(
              items: tripTypes.map((String value) {
                return DropdownMenuItem<String>(
                  child: Text(value),
                  value: value,
                );
              }).toList(),
              hint: Text('Trip Type'),
              value: tripContr.text,
              onChanged: (value) => setState(() => this.trip.tripType = value)),
          Container(
              child: addUpdate(context, this.trip),
              margin: EdgeInsets.only(top: 20))
        ],
      ),
    );
  }
}

Widget addUpdate(context, Trip trip) {
  if (trip.id != null) {
    return RaisedButton(
        onPressed: () => update(context, trip),
        child: Text('Update Trip',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white
        )),
        color: Colors.blue[900]);
  }
  return RaisedButton(
      onPressed: () => add(context, trip),
      child: Text('Add Trip',
      style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white
        )),
      color: Colors.blue[900]);
}

DbHelper helper = DbHelper();
update(context, trip) async {
  await helper.updateTrip(trip);
  Navigator.pop(context, true);
}

add(context, Trip trip) async {
  await helper.insertTrip(trip);
  debugPrint(trip.depDate);
  Navigator.pop(context, true);
}
