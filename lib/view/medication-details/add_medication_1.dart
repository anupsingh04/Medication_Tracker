import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'add_medication_2.dart';
import 'InputValidation.dart';
import '../../model/medication.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddMedication1 extends StatefulWidget {
  final Medication? medication; // Optional for edit mode
  final int? editIndex; // Index to update if editing
  const AddMedication1({Key? key, this.medication, this.editIndex}) : super(key: key);

  @override
  _AddMedication1State createState() => _AddMedication1State();
}

class _AddMedication1State extends State<AddMedication1>
    with InputValidationMixin {
  late TextEditingController formInputController1; // Name
  late TextEditingController formInputController2; // Nickname
  late TextEditingController formInputController3; // Provider

  String? dropDownValue1 = 'Pills';
  String? imagePath;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // Pre-fill if editing
    formInputController1 = TextEditingController(text: widget.medication?.medName ?? '');
    formInputController2 = TextEditingController(text: widget.medication?.medNickName ?? '');
    formInputController3 = TextEditingController(text: widget.medication?.medProvider ?? '');
    if (widget.medication?.medType != null) {
      dropDownValue1 = widget.medication!.medType;
    }
    if (widget.medication?.imagePath != null && widget.medication!.imagePath!.isNotEmpty) {
      imagePath = widget.medication!.imagePath;
    }
  }

  @override
  void dispose() {
    formInputController1.dispose();
    formInputController2.dispose();
    formInputController3.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      setState(() {
        imagePath = image.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Scaffold(
          key: scaffoldKey,
          backgroundColor: Colors.white,
          body: SafeArea(
            child: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            10, 10, 10, 10),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // Back button
                            Material(
                              color: Colors.transparent,
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Container(
                                width: 42,
                                height: 42,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF809BCE),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      1, 0, 0, 0),
                                  child: IconButton(
                                    iconSize: 60,
                                    color: const Color(0x00FCFCFC),
                                    icon: const Icon(
                                      Icons.arrow_back_ios_rounded,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  20, 0, 0, 0),
                              child: Text(
                                widget.medication == null ? 'Add Medication' : 'Edit Medication',
                                textAlign: TextAlign.start,
                                style: GoogleFonts.fredoka(
                                  color: Colors.black,
                                  fontSize: 22,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // ... (rest of the UI is same as before, skipping redundant paste for brevity if I could, but I must provide full block)
                      // I will paste the full content to be safe and ensure everything is correct.
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(10, 20, 10, 0),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text(
                                    '[1/3] : General Details',
                                    style: GoogleFonts.signikaNegative(
                                      color: Colors.black,
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0, 10, 0, 0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(0, 20, 0, 0),
                                          child: Text(
                                            'STEP 1: Medication Name',
                                            style: GoogleFonts.signikaNegative(
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(0, 5, 0, 0),
                                            child: TextFormField(
                                                controller: formInputController1,
                                                obscureText: false,
                                                style:
                                                    GoogleFonts.signikaNegative(
                                                  color:
                                                      const Color(0xFF57636C),
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                                decoration: InputDecoration(
                                                  hintText:
                                                      'Enter Medication Name',
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide:
                                                        const BorderSide(
                                                      color: Color(0xFFDBE2E7),
                                                      width: 2,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide:
                                                        const BorderSide(
                                                      color: Color(0xFFDBE2E7),
                                                      width: 2,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  filled: true,
                                                  fillColor:
                                                      const Color(0xFFE7E0EC),
                                                  contentPadding:
                                                      const EdgeInsetsDirectional
                                                          .fromSTEB(
                                                          20, 0, 20, 0),
                                                ),
                                                validator: (String? value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return 'Enter Medication Name';
                                                  } else {
                                                    if (isName(value)) {
                                                      return null;
                                                    } else {
                                                      return 'Please enter a valid Medication Name';
                                                    }
                                                  }
                                                }),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(0, 20, 0, 0),
                                          child: Text(
                                            'STEP 2: Medication Nickname (optional)',
                                            style: GoogleFonts.signikaNegative(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(0, 5, 0, 0),
                                            child: TextFormField(
                                              controller: formInputController2,
                                              obscureText: false,
                                              style:
                                                  GoogleFonts.signikaNegative(
                                                color: const Color(0xFF57636C),
                                                fontSize: 14,
                                                fontWeight: FontWeight.normal,
                                              ),
                                              decoration: InputDecoration(
                                                hintText:
                                                    'Enter Medication Nickname',
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                    color: Color(0xFFDBE2E7),
                                                    width: 2,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                    color: Color(0xFFDBE2E7),
                                                    width: 2,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                filled: true,
                                                fillColor:
                                                    const Color(0xFFE7E0EC),
                                                contentPadding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(20, 0, 20, 0),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(0, 20, 0, 0),
                                          child: Text(
                                            'STEP 3: Medication Type',
                                            style: GoogleFonts.signikaNegative(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(0, 5, 0, 0),
                                          child: Container(
                                            width: 500,
                                            height: 100,
                                            constraints: BoxConstraints(
                                              maxWidth: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.89,
                                              maxHeight: 50,
                                            ),
                                            decoration: const BoxDecoration(
                                              color: Color(0xFFE7E0EC),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8)),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(15, 0, 10, 0),
                                              child: DropdownButton<String>(
                                                  value: dropDownValue1,
                                                  icon: const Icon(Icons
                                                      .keyboard_arrow_down),
                                                  items: <String>[
                                                    'Pills',
                                                    'Solution',
                                                    'Drops',
                                                    'Injections',
                                                    'Powder',
                                                    'Others'
                                                  ]
                                                      .map<
                                                              DropdownMenuItem<
                                                                  String>>(
                                                          (String value) {
                                                    return DropdownMenuItem<
                                                        String>(
                                                      value: value,
                                                      child: Text(value),
                                                    );
                                                  }).toList(),
                                                  onChanged: (String? val) {
                                                    setState(() {
                                                      dropDownValue1 = val!;
                                                    });
                                                  },
                                                  style:
                                                      GoogleFonts
                                                          .signikaNegative(
                                                    color: Colors.black,
                                                  ),
                                                  hint: const Text(
                                                      'Choose Medication Type'),
                                                  dropdownColor:
                                                      const Color(0xFFE7E0EC),
                                                  focusColor: Colors.red,
                                                  isExpanded: true,
                                                  elevation: 2,
                                                  underline: Container(
                                                    color:
                                                        const Color(0xFFE7E0EC),
                                                  )
                                                  ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(0, 20, 0, 0),
                                          child: Text(
                                            'STEP 4: Photo of Medication',
                                            style: GoogleFonts.signikaNegative(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (imagePath != null)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 10),
                                        child: Image.file(File(imagePath!), height: 100),
                                      ),
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              0, 10, 0, 0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Row(
                                            children: [
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        const Color(0xFF809BCE),
                                                    minimumSize:
                                                        const Size(140, 35),
                                                    shape:
                                                        const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  20)),
                                                    )),
                                                onPressed: () => _pickImage(ImageSource.gallery),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    const Icon(
                                                      Icons.upload_sharp,
                                                      size: 20,
                                                    ),
                                                    Padding(
                                                        padding:
                                                            const EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                10, 0, 0, 0),
                                                        child: Text(
                                                          'Upload',
                                                          style: GoogleFonts
                                                              .signikaNegative(
                                                            color: Colors.white,
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                          ),
                                                        )),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        const Color(0xFF809BCE),
                                                    minimumSize:
                                                        const Size(140, 35),
                                                    shape:
                                                        const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  20)),
                                                    )),
                                                onPressed: () => _pickImage(ImageSource.camera),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    const Icon(
                                                      Icons.photo_camera,
                                                      size: 20,
                                                    ),
                                                    Padding(
                                                        padding:
                                                            const EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                10, 0, 0, 0),
                                                        child: Text(
                                                          'Take Photo',
                                                          style: GoogleFonts
                                                              .signikaNegative(
                                                            color: Colors.white,
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                          ),
                                                        )),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(0, 20, 0, 0),
                                          child: Text(
                                            'STEP 5: Medication Provider Name',
                                            style: GoogleFonts.signikaNegative(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(0, 5, 0, 0),
                                            child: TextFormField(
                                                controller: formInputController3,
                                                obscureText: false,
                                                style:
                                                    GoogleFonts.signikaNegative(
                                                  color:
                                                      const Color(0xFF57636C),
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                                decoration: InputDecoration(
                                                  hintText:
                                                      'Enter Provider Name',
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide:
                                                        const BorderSide(
                                                      color: Color(0xFFDBE2E7),
                                                      width: 2,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide:
                                                        const BorderSide(
                                                      color: Color(0xFFDBE2E7),
                                                      width: 2,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  filled: true,
                                                  fillColor:
                                                      const Color(0xFFE7E0EC),
                                                  contentPadding:
                                                      const EdgeInsetsDirectional
                                                          .fromSTEB(
                                                          20, 0, 20, 0),
                                                ),
                                                validator: (String? value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return 'Enter Provider Name';
                                                  } else {
                                                    if (isName(value)) {
                                                      return null;
                                                    } else {
                                                      return 'Please enter a valid Provider Name';
                                                    }
                                                  }
                                                }),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              20, 40, 20, 0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Row(
                                            children: [
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        const Color(0xFF809BCE),
                                                    minimumSize:
                                                        const Size(300, 40),
                                                    elevation: 5,
                                                    shape:
                                                        const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10)),
                                                    )),
                                                onPressed: () {
                                                  if (formKey.currentState!
                                                      .validate()) {
                                                    formKey.currentState
                                                        ?.save();

                                                    // Use existing medication object if editing, or create new
                                                    Medication med = widget.medication ?? Medication(medName: '');

                                                    med.medName = formInputController1.text;
                                                    med.medNickName = formInputController2.text;
                                                    med.medType = dropDownValue1;
                                                    med.medProvider = formInputController3.text;
                                                    med.imagePath = imagePath; // Save Image Path

                                                    // Pass editIndex to next screen
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                AddMedication2(medication: med, editIndex: widget.editIndex)));
                                                  }
                                                },
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Padding(
                                                        padding:
                                                            const EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                15, 0, 0, 0),
                                                        child: Text(
                                                          'NEXT',
                                                          style: GoogleFonts
                                                              .signikaNegative(
                                                            color: Colors.white,
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                          ),
                                                        )),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )),
    );
  }
}
