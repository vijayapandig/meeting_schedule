import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:meeting_schedule/Stepper.dart';

var starttime;
var endttime;
int hrtime=0;
int qty=2;
int qytup=2;
int qytdaily=2;
int qytweekly=2;
int qytmonthly=2;
int maxval=30;
int mintime=0;
 
// ignore: non_constant_identifier_names
TextEditingController _fnameController = TextEditingController();
TextEditingController _startController = TextEditingController();
TextEditingController _endController = TextEditingController();
TextEditingController _lnameController = TextEditingController();
TextEditingController _pfnameController = TextEditingController();
TextEditingController _plnameController = TextEditingController();
TextEditingController _codeController = TextEditingController();
String rndnumber = "ss";
String recurr = "Daily";
DateTime date = DateTime.now();
DateTime datex = DateTime.now();
DateTime dates = DateTime.now();
bool hideend = false;
bool hideends = false;
bool starttimeerror = false;
bool endtimeerror = false;
List userdata = [];
List daysofrecc=[];

final _formKeya = GlobalKey<FormState>();
var fff;
bool isSwitched = false;
var textValue = 'Switch is OFF';

enum BestTutorSite { Daily, Weekly, Monthly }
final format = DateFormat("yyyy-MM-dd hh:mm a");

class AddmeetingWidget extends StatefulWidget {
  final Color PrimaryColor;
  final String CancelButtonText;
  final  CancelButtonOnTap;
  final String SubmitButtonText;
  final SubmitButtonOnTap;
  const AddmeetingWidget({Key? key,  required this.PrimaryColor,
  required this.CancelButtonText,required this.CancelButtonOnTap,
  required this.SubmitButtonText,required this.SubmitButtonOnTap}) : super(key: key);
  @override
  _AddmeetingWidgetState createState() => _AddmeetingWidgetState();
}

class _AddmeetingWidgetState extends State<AddmeetingWidget> {
  var finalresultjson;
 
BestTutorSite _site = BestTutorSite.Daily;
void toggleSwitch(bool value) {

    if(isSwitched == false)
    {
      setState(() {
        isSwitched = true;
        textValue = 'Switch Button is ON';
      });
      print('Switch Button is ON');
    }
    else
    {
      setState(() {
        isSwitched = false;
        textValue = 'Switch Button is OFF';
      });
      print('Switch Button is OFF');
    }
  }
  @override
  void initState() {
    daysofrecc=[];
     fff=formatISOTime(DateTime.now());
 
    hideend = false;
    hideends = false;
    isSwitched=false;
    super.initState();
    print("loginssssssssssssss");
    print(fff);
  }

  @override
  void dispose() {
    _fnameController.clear();
    _startController.clear();
    _endController.clear();
    _pfnameController.clear();
    _plnameController.clear();
    endtimeerror=false;
    starttimeerror=false;
    super.dispose();
  }

 

  randgen() {
    rndnumber = "";
    var rnd = new Random();
    for (var i = 0; i < 5; i++) {
      rndnumber = rndnumber + rnd.nextInt(9).toString();
    }
 
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return   Scaffold(
      appBar: AppBar(title: Text('Meeeting'),),
      body: SingleChildScrollView(
        child: Form(
      key: _formKeya,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: size.height * 0.03),
          Padding(
            padding: const EdgeInsets.only(left: 25.0,bottom: 8),
            child: Text('Meeting Topic',style: TextStyle(fontSize: 16),),
          ),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.symmetric(horizontal: 30),
            child: TextFormField(
              validator: (value) {
                return value!.isEmpty ? ' +Enter Purpose' : null;
              },
              inputFormatters: [
                NoLeadingSpaceFormatter(),
                LengthLimitingTextInputFormatter(80),
              ],
              maxLength: 80,
              controller: _fnameController,
              decoration: new InputDecoration(
                  border: new OutlineInputBorder(
                      borderSide: new BorderSide(color: Colors.grey)),
                  hintText: 'Enter Meeting Topic',

                  prefixText: ' ',
                  suffixStyle: const TextStyle(color: Colors.grey)),
            ),
          ),
         SizedBox(height: 10),
         Container(
            alignment: Alignment.center,
            margin: EdgeInsets.symmetric(horizontal: 40),
            child: Row(
              mainAxisAlignment : MainAxisAlignment.spaceBetween,
              mainAxisSize : MainAxisSize.max,
              crossAxisAlignment :CrossAxisAlignment.center,
              children: [
                Text(
                  'Recurring ',
              style: TextStyle(fontSize: 16),
                ),
                Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children:[
                      Transform.scale(
                          scale: 1,
                          child: Switch(
                            onChanged: toggleSwitch,
                            value: isSwitched,
                            activeColor: widget.PrimaryColor ,
                            activeTrackColor: Colors.grey,
                            inactiveThumbColor: widget.PrimaryColor,
                            inactiveTrackColor: Colors.grey,
                          )
                      ),

                    ])
              ],
            ),),
          if(isSwitched)
            Column(
              children: [
                Column(
             
                  children: [
                     Container(


                            margin: EdgeInsets.symmetric(horizontal: 40),
                            child:  Row(
                              children: [
                                Text(
                                  'Select Days',

                                ),
                              ],
                            ),
                       
                            ),
                                 Padding(padding: EdgeInsets.all(8.0),
                        child:Container(
                          margin: EdgeInsets.symmetric(horizontal: 40),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                            InkWell(
                              onTap: (){
                                if(daysofrecc.contains('Sunday')){
                               setState(() {
                                  daysofrecc.remove('Sunday');
                                });
                                }
                                else{
                                  setState(() {
                                  daysofrecc.add('Sunday');
                                });
                                }
                              
                              },
                              child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: daysofrecc.contains('Sunday') ? widget.PrimaryColor:Colors.grey
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Text('S',style: TextStyle(color: Colors.white),),
                              )),
                            ),
                            InkWell(
                              onTap: (){
                                if(daysofrecc.contains('Monday')){
                               setState(() {
                                  daysofrecc.remove('Monday');
                                });
                                }
                                else{
                                  setState(() {
                                  daysofrecc.add('Monday');
                                });
                                }
                              
                              },
                              child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: daysofrecc.contains('Monday') ? widget.PrimaryColor:Colors.grey
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Text('M',style: TextStyle(color: Colors.white),),
                              )),
                            ),
                       InkWell(
                              onTap: (){
                                if(daysofrecc.contains('Tuesday')){
                               setState(() {
                                  daysofrecc.remove('Tuesday');
                                });
                                }
                                else{
                                  setState(() {
                                  daysofrecc.add('Tuesday');
                                });
                                }
                              
                              },
                              child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: daysofrecc.contains('Tuesday') ? widget.PrimaryColor:Colors.grey
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Text('T',style: TextStyle(color: Colors.white),),
                              )),
                            ),
                            InkWell(
                              onTap: (){
                                if(daysofrecc.contains('Wednesday')){
                               setState(() {
                                  daysofrecc.remove('Wednesday');
                                });
                                }
                                else{
                                  setState(() {
                                  daysofrecc.add('Wednesday');
                                });
                                }
                              
                              },
                              child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: daysofrecc.contains('Wednesday') ? widget.PrimaryColor:Colors.grey
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Text('W',style: TextStyle(color: Colors.white),),
                              )),
                            ),
                       InkWell(
                              onTap: (){
                                if(daysofrecc.contains('Thursday')){
                               setState(() {
                                  daysofrecc.remove('Thursday');
                                });
                                }
                                else{
                                  setState(() {
                                  daysofrecc.add('Thursday');
                                });
                                }
                              
                              },
                              child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: daysofrecc.contains('Thursday') ? widget.PrimaryColor:Colors.grey
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Text('T',style: TextStyle(color: Colors.white),),
                              )),
                            ),
                      InkWell(
                              onTap: (){
                                if(daysofrecc.contains('Friday')){
                               setState(() {
                                  daysofrecc.remove('Friday');
                                });
                                }
                                else{
                                  setState(() {
                                  daysofrecc.add('Friday');
                                });
                                }
                              
                              },
                              child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: daysofrecc.contains('Friday') ? widget.PrimaryColor:Colors.grey
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Text('F',style: TextStyle(color: Colors.white),),
                              )),
                            ),
                       InkWell(
                              onTap: (){
                                if(daysofrecc.contains('Saturday')){
                               setState(() {
                                  daysofrecc.remove('Saturday');
                                });
                                }
                                else{
                                  setState(() {
                                  daysofrecc.add('Saturday');
                                });
                                }
                              
                              },
                              child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: daysofrecc.contains('Saturday') ? widget.PrimaryColor:Colors.grey
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Text('S',style: TextStyle(color: Colors.white),),
                              )),
                            ),
                      
                          ],),
                        )
                        
                        ),
                  ],
                ),
                      Column(

                        children: [
                        
                          Container(


                            margin: EdgeInsets.symmetric(horizontal: 40),
                            child:  Text(
                              'Repeat for weeks',

                            ),),
                               Padding(padding: EdgeInsets.all(8.0),
                        child: Center(
                          child:AnimatedPadding(
                              padding: EdgeInsets.all(2.0),
                              duration: Duration(seconds: 2),
                              child: ValStepper(
                                  defaultValue:1 ,
                                  actionButtonColor:widget.PrimaryColor,
                                  actionIconColor:Colors.white,
                                  disableInput: true,
                                  max : 52,
                                  min: 1,
                                  onChange: (value) {
                                    print(value);
                                    setState((){
                                      qytmonthly=value;
                                    });
                                  })
                          ),
                        ),),
                
                   
                        ],
                      ),
                      
                  ],
            ),
         
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 25.0,bottom: 8),
            child: Text('Date / Time',style: TextStyle(fontSize: 16),),
          ),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: [
                DateTimeField(
                  validator: (value) {
                    return hideend == false ? 'starts' : null;
                  },
                  decoration: new InputDecoration(
                      border: new OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.grey)),
                      hintText: 'Starts',


                      suffixStyle: const TextStyle(color: Colors.grey)),
                  controller: _startController,
                  format: format,
                  onShowPicker: (context, currentValue) async {
                    final  date = await showDatePicker(
                        context: context,
                        firstDate: DateTime.now(),
                        initialDate:currentValue==null? datex:currentValue,
                        lastDate: DateTime(2100));

                    if (date != null) {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(
                          currentValue==null? datex:currentValue,),
                      );
                      setState(() {
                        hideend = true;
                      });
                      print("datessssssssssssss");
                      print(DateTimeField.combine(date, time));
                      setState(() {

                        starttime=(DateTimeField.combine(date, time)).millisecondsSinceEpoch;
                      });
                      print("starttime");
                      print(starttime);
                      return DateTimeField.combine(date, time);
                    }
                    else {
                      setState(() {
                        _endController.clear();
                        hideend = true;
                      });
                      return currentValue;
                    }
                  },
                ),
                if(starttimeerror)
                Text("Please Enter valid Time",style: TextStyle(color: Colors.red,fontSize: 10),),
              ],
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(left: 25.0,bottom: 8),
            child: Text('Meeting Duration',style: TextStyle(fontSize: 16),),
          ),
          Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    children: [
                      DateTimeField(
                        decoration: new InputDecoration(
                            border: new OutlineInputBorder(
                                borderSide: new BorderSide(color: Colors.grey)),
                            hintText: 'Duration',
                            labelText: 'Duration',
                            prefixText: ' ',
                            suffixStyle: const TextStyle(color: Colors.grey)),
                        controller: _endController,
                        format: format,
                        validator: (value) {


                        },
                        onShowPicker: (context, currentValue) async {

                          showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (BuildContext context) {
                                int value=15;
                                int hr=0;
                                int min=0;
                                int lowerLimit=5;
                                int stepValue=5;

                                int upperlimit=3600;
                                Timer _timer;

                                int minutes = 15;
                                int hours = 0;
                                String correct='0 Hrs :15 Mins';
                                return StatefulBuilder(builder:
                                    (BuildContext context, StateSetter setState) {

                                  return WillPopScope(
                                      onWillPop: () => Future.value(false),
                                      child: AlertDialog(
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                          contentPadding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                                          content: Container(

                                              child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  mainAxisSize: MainAxisSize.min,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Text("Duration"),
                                                    ),
                                                    Center(
                                                      child: Row(
                                                        mainAxisAlignment : MainAxisAlignment.center,
                                                        mainAxisSize : MainAxisSize.max,
                                                        crossAxisAlignment : CrossAxisAlignment.center,
                                                        children: [
                                                          RawMaterialButton(
                                                            constraints: BoxConstraints.tightFor(width: 35, height: 35),
                                                            elevation: 6.0,
                                                            onPressed:(){
                                                              setState(() {

                                                                if(minutes==15 && hours==0)
                                                                {

                                                                  }
                                                                else {
                                                                  if (minutes == 60) {
                                                                    if(hours>0){
                                                                      hours = hours - 1;
                                                                      minutes = minutes - 15;
                                                                    }
                                                                    else{
                                                                      minutes = minutes - 15;
                                                                    }
                                                                   /* minutes = minutes - 15;*/
                                                                  }
                                                                  else{
                                                                    if(minutes==0){
                                                                      if(hours>0){
                                                                        hours = hours - 1;
                                                                        minutes =45;
                                                                      }
                                                                    }
                                                                    else{
                                                                    minutes = minutes - 15;
                                                                  }
                                                                  }
                                                                  print(hours);
                                                                  print(minutes);
                                                                  correct="${hours} Hrs :${minutes} Mins";
                                                                  print(correct);

                                                                }
                                                               /* if(minutes==0){
                                                                  if(hours>0){
                                                                    hours = hours - 1;
                                                                    minutes =45;
                                                                  }
                                                                }*/
                                                              });

                                                            },

                                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                                            fillColor: widget.PrimaryColor,
                                                            child: Icon(
                                                                Icons.remove,
                                                                color: Colors.white,
                                                                size: 20
                                                            ),
                                                          ),
                                                          Container(
                                                            width:100,
                                                            child: Text(
                                                              '${correct}',
                                                              style: TextStyle(
                                                                fontSize:14,
                                                              ),
                                                              textAlign: TextAlign.center,
                                                            ),
                                                          ),
                                                          RawMaterialButton(
                                                            constraints: BoxConstraints.tightFor(width: 35, height: 35),
                                                            elevation: 6.0,
                                                            onPressed:(){
                                                              setState(() {
                                                                if(hours<8) {
                                                                  if (minutes >
                                                                      59) {
                                                                    hours =
                                                                        hours +
                                                                            1;
                                                                    minutes =
                                                                    15;
                                                                  } else {
                                                                    minutes =
                                                                        minutes +
                                                                            15;
                                                                  }
                                                                  print(
                                                                      hours);
                                                                  print(
                                                                      minutes);
                                                                  correct =
                                                                  "${hours} Hrs :${minutes} Mins";
                                                                }
                                                              });
                                                            },
                                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                                            fillColor: widget.PrimaryColor,
                                                            child: Icon(
                                                                Icons.add,
                                                                color: Colors.white,
                                                                size: 20
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(height: 20,),
                                                    Row(
                                                      mainAxisAlignment : MainAxisAlignment.spaceEvenly ,
                                                      mainAxisSize : MainAxisSize.max,
                                                      crossAxisAlignment : CrossAxisAlignment.center,
                                                      children: [
                                                          StatefulBuilder(builder:
                                                              (BuildContext context, StateSetter setState) {
                                                            return TextButton(
                                                                onPressed: (){
                                                              Navigator.of(context).pop(null);
                                                            },
                                                              child: Container(
                                                                  decoration: new BoxDecoration(
                                                                      borderRadius: BorderRadius.circular(5),
                                                                      gradient: new LinearGradient(colors: [

                                                                        widget.PrimaryColor,
                                                                        widget.PrimaryColor,
                                                                      ])),
                                                                  padding: const EdgeInsets.symmetric(vertical:8,horizontal: 20),
                                                                  child: Text('Cancel',style: TextStyle(color: Colors.white),)),); }),
                                                        StatefulBuilder(builder:
                                                            (BuildContext context, StateSetter setState) {
                                                          return TextButton(onPressed: () {
                                                            setState((){
                                                              _endController.text=correct;
                                                              hrtime=hours;
                                                              mintime=minutes;
                                                              Navigator.of(context).pop(null);
                                                            });
                                                          }, child: Container(
                                                              decoration: new BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(5),
                                                                  gradient: new LinearGradient(colors: [

                                                                    widget.PrimaryColor,
                                                                    widget.PrimaryColor,
                                                                  ])),
                                                              padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 25),
                                                              child: Text('Save',style: TextStyle(color: Colors.white),))); }),
                                                      ],
                                                    ),
                                                    SizedBox(height: 20,),


                                                  ]))));
                                });
                              });
                        },
                      ),
                      if(endtimeerror)
                        Text("Please Enter valid Time",style: TextStyle(color: Colors.red,fontSize: 10),),

                    ],
                  ),
                ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(left: 25.0,bottom: 8),
            child: Text('Meeting Link / Place',style: TextStyle(fontSize: 16),),
          ),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.symmetric(horizontal: 30),
            child: TextFormField(
              inputFormatters: [
                NoLeadingSpaceFormatter(),
              ],
            /*  validator: (value) {
                return value!.length == 0 ? 'Place / Link' : null;
              },*/
              maxLines: 3,
              controller: _pfnameController,
              keyboardType: TextInputType.multiline,
              maxLength: 1000,
              decoration: new InputDecoration(
                  border: new OutlineInputBorder(
                      borderSide: new BorderSide(color: Colors.grey)),
                  hintText: 'Place / Link',

                  prefixText: ' ',
                  suffixStyle: const TextStyle(color: Colors.grey)),
            ),
          ),
          SizedBox(height: 0),
          Padding(
            padding: const EdgeInsets.only(left: 25.0,bottom: 8),
            child: Text('Notes',style: TextStyle(fontSize: 16),),
          ),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.symmetric(horizontal: 30),
            child: TextFormField(
              inputFormatters: [
                NoLeadingSpaceFormatter(),
              ],
             /* validator: (value) {
                return value!.length == 0 ? ' Enter Notes' : null;
              },*/
              maxLines: 3,
              keyboardType: TextInputType.multiline,
              maxLength: 1000,
              controller: _plnameController,
              decoration: new InputDecoration(
                  border: new OutlineInputBorder(
                      borderSide: new BorderSide(color: Colors.grey)),
                  hintText: 'Notes',

                  prefixText: ' ',
                  suffixStyle: const TextStyle(color: Colors.grey)),
            ),
          ),
         
         SizedBox(height: 15,),
           
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              InkWell(
                onTap:    () async {
                     widget.CancelButtonOnTap();
                },
                child: Container(
                    decoration: new BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.grey)
                    ),
                    padding: const EdgeInsets.symmetric(vertical:8,horizontal: 20),

                    child: Text(widget.CancelButtonText,style: TextStyle( fontSize: 14),)),
              ),
              SizedBox(width: 15,),
              InkWell(
                onTap: () async {
               
             ScheduleMeetOntap();
        
                },

                child: Container(
                    decoration: new BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                      color: widget.PrimaryColor,
                        ),
                    padding: const EdgeInsets.symmetric(vertical:8,horizontal: 20),
                    child: Text(widget.SubmitButtonText,style: TextStyle(color: Colors.white,fontSize: 14),)),
              ),
            ],
          ),
          SizedBox(height: 50,)
        ],
      ),
    )));
  }
  static String formatISOTime(DateTime date) {
    var duration = date.timeZoneOffset;
    print("duration");
    print(duration);

    if (duration.isNegative) {
      print("duration.inHours");
      print(duration.inHours);
      if(duration.inHours>-9){
        var st=duration.inHours.toString();
        print("duration.inHours--------.");
        print("-0${st[1]}:${(duration
            .inMinutes - (duration.inHours * 60)).toString().padLeft(2, '0')}");
        return ("-0${st[1]}:${(duration
            .inMinutes - (duration.inHours * 60)).toString().padLeft(2, '0')}");
      }else{
        var st=duration.inHours.toString();
        return ("-${st[1]}${st[2]}:${(duration
            .inMinutes - (duration.inHours * 60)).toString().padLeft(2, '0')}");
      }
    }
    else
      return ( "+${duration.inHours.toString().padLeft(2, '0')}:${(duration.inMinutes - (duration.inHours * 60)).toString().padLeft(2, '0')}");
  }
  
ScheduleMeetOntap( )  async{
 
                        if(_formKeya.currentState!.validate()) {
                          
                         
                          if((_startController.text).length>2 ) {
                            if((_endController.text).length>2){
                              if(!isSwitched){
                                finalresultjson=jsonEncode({
                                "meet_purpose": _fnameController.text,
                                "meet_timestampfrom": _startController.text,
                                "meet_timestampto": _endController.text,
                                "meet_place": _pfnameController.text,
                                "meet_notes": _plnameController.text,
                                "meet_timestamp":starttime,
                                "meet_end_hour":hrtime,
                                "meet_end_minute":mintime,
                                "meet_repeat":isSwitched ,
                                if(isSwitched)
                                "meet_selected_days":daysofrecc,
                                if(isSwitched)
                                  "meet_repeat_for":qytmonthly,
                                
                              });
                                 Navigator.pop(context, finalresultjson);
                              }
                              else{
                                if(daysofrecc.length==0){
                                    final snackBar = SnackBar(
                              duration: const Duration(seconds: 2),
                              content: Container(
                                height: 15.0,
                                child: Center(
                                  child: Text(
                                    'Please Select a day',
                                    style: const TextStyle(fontSize: 12.0,color: Colors.white),
                                  ),
                                ),
                              ),
                              backgroundColor: Colors.red,
                            );
                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(snackBar);
                                }else{
                                 
                               finalresultjson=jsonEncode({
                                "meet_purpose": _fnameController.text,
                                "meet_timestampfrom": _startController.text,
                                "meet_timestampto": _endController.text,
                                "meet_place": _pfnameController.text,
                                "meet_notes": _plnameController.text,
                                "meet_timestamp":starttime,
                                "meet_end_hour":hrtime,
                                "meet_end_minute":mintime,
                                "meet_repeat":isSwitched ,
                                if(isSwitched)
                                "meet_selected_days":daysofrecc,
                                if(isSwitched)
                                  "meet_repeat_for":qytmonthly,
                                
                                
                               
                              });
                                
                          Navigator.pop(context, finalresultjson);
                          
                             
                                }
                              }
                              }
                            else{
                              final snackBar = SnackBar(
                                duration: const Duration(seconds: 2),
                                content: Container(
                                  height: 15.0,
                                  child: Center(
                                    child: Text(
                                      'Please Enter Duration',
                                      style: const TextStyle(fontSize: 12.0,color: Colors.white),
                                    ),
                                  ),
                                ),
                                backgroundColor: Colors.red,
                              );
                              ScaffoldMessenger.of(context)
                                ..hideCurrentSnackBar()
                                ..showSnackBar(snackBar);
                            }
                        }
                          else{
                          
                              starttimeerror=true;
                            

                          }
                        }
     
    }

}

class NoLeadingSpaceFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.startsWith(' ')) {
      final String trimedText = newValue.text.trimLeft();

      return TextEditingValue(
        text: trimedText,
        selection: TextSelection(
          baseOffset: trimedText.length,
          extentOffset: trimedText.length,
        ),
      );
    }

    return newValue;
  }

}
 