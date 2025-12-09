import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'InputValidation.dart';
import 'Profile.dart';
import 'SubmitButton.dart';


// Input Values
Map<String, String> input = {
  'Full Name' : 'John Doe',
  'Email' : 'example@gmail.com',
  'Date of Birth' : '01/12/1984',
  'Gender' : 'Male',
  'Drug Allergies' : 'Penicillin'
};
final List<String> questions = input.keys.toList();
final List<String> answers = input.values.toList();


// Profile Tab
class ProfileTab extends StatefulWidget {
  const ProfileTab({Key? key}) : super(key: key);

  @override
  _ProfileTabState createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> with InputValidationMixin { 

  //Form Input
  final profileformKey = GlobalKey < FormState > ();
  List<TextEditingController> myController = List.generate(questions.length, (i) => TextEditingController());
  @override
  void initState() {
    super.initState();
    for (int i=0; i<questions.length; i++){
      myController[i] = TextEditingController (text: answers[i]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: isEditable,
      builder: (context, value, widget) {
    return Form(
      key: profileformKey,
      child: SafeArea(
      top: false,
      bottom: false,
      child: Builder(
        builder: (BuildContext context) {
          return CustomScrollView(
            slivers: [
              SliverOverlapInjector(
                handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              ),
              SliverPadding(
                padding: const EdgeInsetsDirectional.fromSTEB(16, 10, 16, 0),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate ((BuildContext context, int index){
                    return cardWidget(input1: questions[index], input2: answers[index], index: index, editable: value);
                  },
                  childCount: questions.length,
                ))
              ),
              if (value == true)...[
                SliverToBoxAdapter(
                  child: SubButton(FormKey: profileformKey),
                )
              ]
            ],
          );
        }
      )));
    });
  }
  
  //Display Values
  Widget cardWidget({required String input1, required input2, required int index, required editable}) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 5),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 12, 0),
                child: Text(
                input1,
                style: GoogleFonts.signikaNegative(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.black),
                ),
              ),
            ],
          ),
        ),

        //'Full Name'
        if (input1 == 'Full Name') ...[
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
          child: Stack(
            children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 49,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              border: Border.all(
                color: Colors.black,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(10, 0, 10, 0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Flexible(
                child: TextFormField(
                  enabled: editable,
                  focusNode: FocusNode(),
                  enableInteractiveSelection: editable,
                  keyboardType: TextInputType.text,
                  controller: myController[index],
                  style: GoogleFonts.signikaNegative(fontSize: 18,color: Colors.black),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Please enter your ${input1.toLowerCase()}',
                  ),
                  onSaved: (String? value) {
                    //save
                    print("saved");
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your ${input1.toLowerCase()}';
                    } else {
                      if (isName(value)) {
                        return null;
                      } else {
                        return 'Please enter a valid ${input1.toLowerCase()}';
                      }
                    }
                  }
                )),
              ],
            )),
          ]))
        ]

        //'Email'
        else if (input1 == 'Email') ...[
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
          child: Stack(
            children:[ 
          Container(
            width: MediaQuery.of(context).size.width,
            height: 49,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              border: Border.all(
                color: Colors.black,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(10, 0, 10, 0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Flexible(
                child: TextFormField(
                  enabled: editable,
                  focusNode: FocusNode(),
                  enableInteractiveSelection: editable,
                  keyboardType: TextInputType.text,
                  controller: myController[index],
                  style: GoogleFonts.signikaNegative(fontSize: 18,color: Colors.black),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Please enter your ${input1.toLowerCase()}',
                  ),
                  onSaved: (String? value) {
                    //save
                    print("saved");
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your ${input1.toLowerCase()}';
                    } else {
                      if (isEmail(value)) {
                        return null;
                      } else {
                        return 'Please enter a valid ${input1.toLowerCase()}';
                      }
                    }
                  }
                )),
              ],
            )),
          ]))
        ]

        // Date of Birth
        else if (input1 == 'Date of Birth') ...[
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
          child: Stack(
          children:[ 
            Container(
              width: MediaQuery.of(context).size.width,
              height: 49,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                border: Border.all(
                  color: Colors.black,
                ),
              )
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(10, 0, 10, 0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Flexible(
                    child: TextFormField(
                      enabled: editable,
                      focusNode: FocusNode(),
                      enableInteractiveSelection: editable,
                      controller: myController[index],
                      style: GoogleFonts.signikaNegative(fontSize: 18,color: Colors.black),
                      decoration: InputDecoration(
                        hintText: 'Please enter your ${input1.toLowerCase()}',
                        border: InputBorder.none,
                      ),
                      onTap: () async{
                        FocusScope.of(context).requestFocus(FocusNode());
                        var date = await showDatePicker(
                          context: context, 
                          initialDate:DateFormat("dd/MM/yyyy").parse(input2),
                          firstDate:DateTime(1900),
                          lastDate: DateTime.now()
                        );
                        if (date != null){
                          myController[index].text = DateFormat("dd/MM/yyyy").format(date);
                        }
                      },
                      onSaved: (String? value) {
                        //save
                        print("saved");
                      },
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a valid ${input1.toLowerCase()}';
                        }
                        return null; 
                      }
                    )),
                  ],
                )
              ),
            ])
          )
        ]

        // Gender
        else if (input1 == 'Gender') ...[
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 49,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              border: Border.all(
                color: Colors.black,
              ),
            ),
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(10, 0, 10, 0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  // Flexible(
                    if (editable == false)...[
                      Text(
                        myController[index].text,
                        style: GoogleFonts.signikaNegative(fontSize: 18,color: Colors.black),
                      ),
                    ]
                    else...[
                    Flexible(
                    child: DropdownButtonHideUnderline(
                      child:DropdownButton<String>(
                      isExpanded: true,
                      value: myController[index].text,
                      style: GoogleFonts.signikaNegative(fontSize: 18,color: Colors.black),
                      icon: const Icon(Icons.keyboard_arrow_down),
                      onChanged: (String? newValue){
                        setState(() {
                           myController[index].text = newValue!;
                        });
                      },
                      items: <String>['Male','Female']
                        .map<DropdownMenuItem<String>>((String value){
                        return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                    )))
                  ]
                ],
              ),
            ),
          ))
        ]

        // Drug Allergies
        else if (input1 == 'Drug Allergies') ...[
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 229,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              border: Border.all(
                color: Colors.black,
              ),
            ),
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(10, 0, 10, 0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Flexible(
                  child: TextFormField(
                    enabled: editable,
                    focusNode: FocusNode(),
                    enableInteractiveSelection: editable,
                    controller:  myController[index],
                    style: GoogleFonts.signikaNegative(fontSize: 18,color: Colors.black),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter in any Allergies that you have',
                    ),
                    onSaved: (String? value) {
                      //save
                      print("saved");
                    },
                  )),
                ],
              ),
            ),
          ))
        ]
      ]
    );
  }
}
