class Trip{

  int id;
  String departure;
  String depDate;
  String depTime;
  String destination;
  String desDate;
  String desTime;
  String tripType;

  Trip(this.departure,this.depDate, this.depTime, this.destination, this.desDate, this.desTime, this.tripType);

  Trip.withId(this.id,this.departure, this.depDate, this.depTime, this.destination, this.desDate, this.desTime, this.tripType);

  Map<String, dynamic> toMap(){
    var map = Map<String, dynamic>();
    map['departure'] = departure;
    map['depDate'] = depDate;
    map['depTime'] = depTime;
    map['destination'] = destination;
    map['desDate'] = desDate;
    map['desTime'] = desTime;
    map['triptype'] = tripType;
    if(id != null){
      map['id'] = id;
    }
    return map;
  }

  Trip.fromObject(dynamic o){
    id = o['id'];
    departure = o['departure'];
    depDate = o['depDate'];
    depTime = o['depTime'];
    destination = o['destination'];
    desTime = o['desTime'];
    desDate = o['desDate'];
    tripType = o['tripType'];
  }

  

}