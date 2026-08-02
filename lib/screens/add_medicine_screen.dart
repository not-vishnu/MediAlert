import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/medicine_model.dart';
import '../providers/medicine_provider.dart';
import '../services/notification_service.dart';

class AddMedicineScreen extends StatefulWidget {
  const AddMedicineScreen({super.key});

  @override
  State<AddMedicineScreen> createState() => _AddMedicineScreenState();
}

class _AddMedicineScreenState extends State<AddMedicineScreen>
    with TickerProviderStateMixin {
  //================ COLORS ================//

  static const Color accent = Color(0xFF4DA3FF);
  static const Color glassWhite = Color.fromRGBO(255, 255, 255, .18);
  static const Color glassBorder = Color.fromRGBO(255, 255, 255, .28);

  //================ CONTROLLERS ================//

  final TextEditingController nameController = TextEditingController();
  final TextEditingController dosageController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  //================ VARIABLES ================//

  String medicineType = "Tablet";
  bool reminderEnabled = true;
  TimeOfDay reminderTime = TimeOfDay.now();

  late AnimationController animationController;
  late Animation<double> animation;

  //================ MEDICINE TYPES ================//

  final List<_MedicineType> medicineTypes = const [
    _MedicineType("Tablet", CupertinoIcons.capsule_fill),
    _MedicineType("Capsule", CupertinoIcons.capsule),
    _MedicineType("Syrup", CupertinoIcons.drop_fill),
    _MedicineType("Injection", CupertinoIcons.bandage_fill),
    _MedicineType("Drops", CupertinoIcons.drop_triangle_fill),
    _MedicineType("Inhaler", CupertinoIcons.wind),
  ];

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat(reverse: true);

    animation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    animationController.dispose();

    nameController.dispose();
    dosageController.dispose();
    notesController.dispose();

    super.dispose();
  }
  //================ PICK REMINDER TIME ================//

  Future<void> pickTime() async {
    final picked = await showCupertinoModalPopup<TimeOfDay>(
      context: context,
      builder: (context) {
        TimeOfDay tempTime = reminderTime;

        return Container(
          height: 300,
          decoration: const BoxDecoration(
            color: Color(0xFF1B1B1B),
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(30),
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
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
                      onPressed: () => Navigator.pop(context, tempTime),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.time,
                  use24hFormat: false,
                  onDateTimeChanged: (date) {
                    tempTime = TimeOfDay.fromDateTime(date);
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
  //================ SAVE MEDICINE ================//

  Future<void> saveMedicine() async {
    if (nameController.text.trim().isEmpty ||
        dosageController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill all required fields"),
        ),
      );
      return;
    }

    final notificationId =
        DateTime.now().millisecondsSinceEpoch.remainder(100000);

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

    final medicine = MedicineModel(
      id: "",
      name: nameController.text.trim(),
      dosage: "$medicineType • ${dosageController.text.trim()}",
      time: reminderTime.format(context),
      status: "Pending",
      reminderEnabled: reminderEnabled,
      notificationId: notificationId,
      reminderDate: reminderDate,
    );

    try {
      await context.read<MedicineProvider>().addMedicine(medicine);

      if (reminderEnabled) {
        await NotificationService.instance.scheduleMedicineReminder(
          medicine,
        );
      }

      if (!mounted) return;

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }
  //================ GLASS CARD ================//

  Widget glassCard({
    required Widget child,
    EdgeInsets padding = const EdgeInsets.all(20),
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 22,
          sigmaY: 22,
        ),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: glassWhite,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: glassBorder,
              width: 1.2,
            ),
          ),
          child: child,
        ),
      ),
    );
  }

  //================ GLASS TEXT FIELD ================//

  Widget glassTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    int maxLines = 1,
  }) {
    return glassCard(
      padding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 8,
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          icon: Icon(
            icon,
            color: Colors.white,
          ),
          hintText: hint,
          hintStyle: const TextStyle(
            color: Colors.white70,
          ),
        ),
      ),
    );
  }

  //================ SECTION TITLE ================//

  Widget sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  //================ GLASS BUTTON ================//

  Widget glassButton() {
    return GestureDetector(
      onTap: saveMedicine,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 25,
            sigmaY: 25,
          ),
          child: Container(
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: Colors.white.withOpacity(.35),
              ),
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(.25),
                  Colors.white.withOpacity(.08),
                ],
              ),
            ),
            child: const Center(
              child: Text(
                "Save Medicine",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  //================ MEDICINE TYPE SELECTOR ================//

  Widget medicineSelector() {
    return SizedBox(
      height: 105,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: medicineTypes.length,
        separatorBuilder: (_, __) => const SizedBox(width: 15),
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
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              width: 90,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: selected
                    ? Colors.white.withOpacity(.28)
                    : Colors.white.withOpacity(.10),
                border: Border.all(
                  color:
                      selected ? Colors.white : Colors.white.withOpacity(.18),
                  width: selected ? 1.5 : 1,
                ),
                boxShadow: selected
                    ? [
                        BoxShadow(
                          color: accent.withOpacity(.35),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ]
                    : [],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    item.icon,
                    size: 34,
                    color: Colors.white,
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

  //================ REMINDER CARD ================//

  Widget reminderCard() {
    return glassCard(
      child: Column(
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(.15),
                borderRadius: BorderRadius.circular(15),
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
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              reminderTime.format(context),
              style: const TextStyle(
                color: Colors.white70,
              ),
            ),
            trailing: const Icon(
              CupertinoIcons.chevron_right,
              color: Colors.white70,
            ),
            onTap: pickTime,
          ),
          const Divider(
            color: Colors.white24,
            height: 24,
          ),
          SwitchListTile(
            value: reminderEnabled,
            activeColor: Colors.white,
            activeTrackColor: accent,
            contentPadding: EdgeInsets.zero,
            secondary: const Icon(
              CupertinoIcons.bell_fill,
              color: Colors.white,
            ),
            title: const Text(
              "Daily Reminder",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            onChanged: (value) {
              setState(() {
                reminderEnabled = value;
              });
            },
          ),
        ],
      ),
    );
  }
  // ================= BUILD =================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0F172A),
      body: AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          return Stack(
            children: [
              // Animated Glass Background
              Positioned(
                top: -120 + (animation.value * 40),
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
                right: -120,
                top: 120 + (animation.value * -30),
                child: Container(
                  width: 240,
                  height: 240,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue.withOpacity(.20),
                  ),
                ),
              ),

              Positioned(
                bottom: -100,
                left: 40 + (animation.value * 20),
                child: Container(
                  width: 260,
                  height: 260,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.purple.withOpacity(.18),
                  ),
                ),
              ),

              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 90,
                    sigmaY: 90,
                  ),
                  child: Container(
                    color: Colors.transparent,
                  ),
                ),
              ),

              SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 22,
                    vertical: 18,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      const Text(
                        "Add Medicine",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        "Create a beautiful daily reminder",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
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
                      const SizedBox(height: 15),
                      medicineSelector(),
                      const SizedBox(height: 28),
                      reminderCard(),
                      const SizedBox(height: 25),
                      glassTextField(
                        controller: notesController,
                        hint: "Notes (Optional)",
                        icon: CupertinoIcons.doc_text_fill,
                        maxLines: 4,
                      ),
                      const SizedBox(height: 35),
                      SizedBox(
                        width: double.infinity,
                        child: glassButton(),
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

//================ MEDICINE TYPE MODEL ================//

class _MedicineType {
  final String title;
  final IconData icon;

  const _MedicineType(
    this.title,
    this.icon,
  );
}
