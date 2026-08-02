import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/medicine_model.dart';
import '../providers/medicine_provider.dart';
import '../services/notification_service.dart';

class EditMedicineScreen extends StatefulWidget {
  final MedicineModel medicine;

  const EditMedicineScreen({
    super.key,
    required this.medicine,
  });

  @override
  State<EditMedicineScreen> createState() => _EditMedicineScreenState();
}

class _EditMedicineScreenState extends State<EditMedicineScreen>
    with TickerProviderStateMixin {
  //================ COLORS ================//
  static const Color accent = Color(0xFF4DA3FF);
  static const Color glassWhite = Color.fromRGBO(255, 255, 255, .22);
  static const Color glassBorder = Color.fromRGBO(255, 255, 255, .35);
  static const Color textPrimary = Colors.white;

  //================ CONTROLLERS ================//
  late final TextEditingController nameController;
  late final TextEditingController dosageController;
  late final TextEditingController notesController;

  //================ VALUES ================//
  late String medicineType;
  late bool reminderEnabled;
  late TimeOfDay reminderTime;

  late final AnimationController animationController;
  late final Animation<double> backgroundAnimation;

  //================ TYPES ================//
  final List<_MedicineType> medicineTypes = const [
    _MedicineType("Tablet", CupertinoIcons.capsule_fill),
    _MedicineType("Capsule", CupertinoIcons.capsule),
    _MedicineType("Syrup", CupertinoIcons.drop_fill),
    _MedicineType("Injection", CupertinoIcons.bandage_fill),
    _MedicineType("Drops", CupertinoIcons.drop_triangle_fill),
    _MedicineType("Inhaler", CupertinoIcons.wind),
  ];

  //================ INIT =================//
  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(text: widget.medicine.name);
    notesController = TextEditingController(text: widget.medicine.notes);

    // Separate dosage from medicine type if stored like: "Tablet • 500 mg"
    final parts = widget.medicine.dosage.split("•");
    if (parts.length == 2) {
      medicineType = parts[0].trim();
      dosageController = TextEditingController(text: parts[1].trim());
    } else {
      medicineType = "Tablet";
      dosageController = TextEditingController(text: widget.medicine.dosage);
    }

    reminderEnabled = widget.medicine.reminderEnabled;

    if (widget.medicine.reminderDate != null) {
      reminderTime = TimeOfDay.fromDateTime(widget.medicine.reminderDate!);
    } else {
      reminderTime = TimeOfDay.now();
    }

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat(reverse: true);

    backgroundAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  //================ DISPOSE =================//
  @override
  void dispose() {
    animationController.dispose();
    nameController.dispose();
    dosageController.dispose();
    notesController.dispose();
    super.dispose();
  }

  //================ PICK TIME =================//
  Future<void> pickTime() async {
    final picked = await showCupertinoModalPopup<TimeOfDay>(
      context: context,
      builder: (context) {
        TimeOfDay temp = reminderTime;

        return Container(
          height: 300,
          decoration: const BoxDecoration(
            color: Color(0xff1B1B1B),
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(30),
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      child: const Text("Cancel"),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Spacer(),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      child: const Text("Done"),
                      onPressed: () => Navigator.pop(context, temp),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.time,
                  use24hFormat: false,
                  initialDateTime: DateTime(
                    2025,
                    1,
                    1,
                    reminderTime.hour,
                    reminderTime.minute,
                  ),
                  onDateTimeChanged: (date) {
                    temp = TimeOfDay.fromDateTime(date);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );

    if (picked != null) {
      setState(() {
        reminderTime = picked;
      });
    }
  }

  //================ UPDATE MEDICINE =================//
  Future<void> updateMedicine() async {
    if (nameController.text.trim().isEmpty ||
        dosageController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill all required fields"),
        ),
      );
      return;
    }

    final now = DateTime.now();
    DateTime reminderDate = DateTime(
      now.year,
      now.month,
      now.day,
      reminderTime.hour,
      reminderTime.minute,
    );

    if (reminderDate.isBefore(now)) {
      reminderDate = reminderDate.add(const Duration(days: 1));
    }

    final updatedMedicine = widget.medicine.copyWith(
      name: nameController.text.trim(),
      dosage: "$medicineType • ${dosageController.text.trim()}",
      time: reminderTime.format(context),
      reminderEnabled: reminderEnabled,
      reminderDate: reminderDate,
      notes: notesController.text.trim(),
    );

    try {
      await Provider.of<MedicineProvider>(
        context,
        listen: false,
      ).updateMedicine(updatedMedicine);

      if (reminderEnabled) {
        await NotificationService.instance
            .scheduleMedicineReminder(updatedMedicine);
      } else {
        await NotificationService.instance
            .cancelReminder(updatedMedicine.notificationId);
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Medicine updated successfully"),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  //================ GLASS CARD =================//
  Widget glassCard({
    required Widget child,
    EdgeInsets padding = const EdgeInsets.all(20),
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: glassWhite,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: glassBorder, width: 1.2),
          ),
          child: child,
        ),
      ),
    );
  }

  //================ GLASS TEXT FIELD =================//
  Widget glassTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    int lines = 1,
  }) {
    return glassCard(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
      child: TextField(
        controller: controller,
        maxLines: lines,
        style: const TextStyle(color: textPrimary, fontSize: 16),
        decoration: InputDecoration(
          border: InputBorder.none,
          icon: Icon(icon, color: Colors.white),
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white70),
        ),
      ),
    );
  }

  //================ MEDICINE SELECTOR =================//
  Widget medicineSelector() {
    return SizedBox(
      height: 105,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: medicineTypes.length,
        itemBuilder: (context, index) {
          final item = medicineTypes[index];
          final selected = medicineType == item.title;

          return GestureDetector(
            onTap: () {
              setState(() {
                medicineType = item.title;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
              width: 90,
              margin: const EdgeInsets.only(right: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: selected
                    ? Colors.white.withOpacity(.28)
                    : Colors.white.withOpacity(.12),
                border: Border.all(
                  color: selected ? Colors.white : Colors.white24,
                ),
                boxShadow: selected
                    ? [
                        BoxShadow(
                          color: Colors.white.withOpacity(.15),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ]
                    : [],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedScale(
                    scale: selected ? 1.15 : 1,
                    duration: const Duration(milliseconds: 250),
                    child: Icon(
                      item.icon,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    item.title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: selected ? FontWeight.bold : FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  //================ REMINDER CARD =================//
  Widget reminderCard() {
    return glassCard(
      child: Column(
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(.12),
              ),
              child: const Icon(
                CupertinoIcons.clock_fill,
                color: Colors.white,
              ),
            ),
            title: const Text(
              "Reminder Time",
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                reminderTime.format(context),
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 15,
                ),
              ),
            ),
            trailing: const Icon(
              CupertinoIcons.chevron_forward,
              color: Colors.white70,
            ),
            onTap: pickTime,
          ),
          const SizedBox(height: 12),
          Divider(color: Colors.white.withOpacity(.18), height: 1),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(.12),
                ),
                child: const Icon(
                  CupertinoIcons.bell_fill,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 15),
              const Expanded(
                child: Text(
                  "Daily Reminder",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              CupertinoSwitch(
                value: reminderEnabled,
                activeTrackColor: accent,
                onChanged: (value) {
                  setState(() {
                    reminderEnabled = value;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  //================ BUILD =================//
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0F172A),
      body: AnimatedBuilder(
        animation: backgroundAnimation,
        builder: (context, child) {
          return Stack(
            children: [
              //================ Animated Blobs =================//
              Positioned(
                top: -120 + (backgroundAnimation.value * 40),
                left: -80,
                child: Container(
                  width: 260,
                  height: 260,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.cyan.withOpacity(.22),
                  ),
                ),
              ),
              Positioned(
                top: 140 - (backgroundAnimation.value * 30),
                right: -110,
                child: Container(
                  width: 230,
                  height: 230,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue.withOpacity(.20),
                  ),
                ),
              ),
              Positioned(
                bottom: -90,
                left: 50 + (backgroundAnimation.value * 25),
                child: Container(
                  width: 270,
                  height: 270,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.purple.withOpacity(.18),
                  ),
                ),
              ),
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 90, sigmaY: 90),
                  child: Container(color: Colors.transparent),
                ),
              ),
              SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 22,
                    vertical: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(
                              CupertinoIcons.back,
                              color: Colors.white,
                            ),
                          ),
                          const Spacer(),
                          const Text(
                            "Edit Medicine",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          const SizedBox(width: 48),
                        ],
                      ),
                      const SizedBox(height: 35),
                      glassTextField(
                        controller: nameController,
                        hint: "Medicine Name",
                        icon: CupertinoIcons.capsule_fill,
                      ),
                      const SizedBox(height: 18),
                      glassTextField(
                        controller: dosageController,
                        hint: "Dosage",
                        icon: CupertinoIcons.bandage_fill,
                      ),
                      const SizedBox(height: 28),
                      const Text(
                        "Medicine Type",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 14),
                      medicineSelector(),
                      const SizedBox(height: 28),
                      reminderCard(),
                      const SizedBox(height: 28),
                      glassTextField(
                        controller: notesController,
                        hint: "Notes",
                        icon: CupertinoIcons.doc_text_fill,
                        lines: 4,
                      ),
                      const SizedBox(height: 38),
                      SizedBox(
                        width: double.infinity,
                        height: 62,
                        child: GestureDetector(
                          onTap: updateMedicine,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(28),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(
                                sigmaX: 25,
                                sigmaY: 25,
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(28),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(.35),
                                  ),
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.white.withOpacity(.28),
                                      Colors.white.withOpacity(.10),
                                    ],
                                  ),
                                ),
                                child: const Center(
                                  child: Text(
                                    "Update Medicine",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

//================ MEDICINE TYPE MODEL =================//
class _MedicineType {
  final String title;
  final IconData icon;

  const _MedicineType(this.title, this.icon);
}
