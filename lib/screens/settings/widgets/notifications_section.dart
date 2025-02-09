// lib/screens/settings/widget/notification_section.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:type_fast/services/notification_service.dart';
import 'package:type_fast/screens/settings/widgets/settings_section.dart';
import 'package:type_fast/screens/settings/widgets/settings_tile.dart';

class NotificationsSection extends StatefulWidget {
  const NotificationsSection({super.key});

  @override
  State<NotificationsSection> createState() => _NotificationsSectionState();
}

class _NotificationsSectionState extends State<NotificationsSection> {
  final NotificationService _notificationService = NotificationService();
  bool _isDailyReminder = false;
  TimeOfDay _reminderTime = const TimeOfDay(hour: 8, minute: 0);
  List<bool> _selectedDays = List.generate(7, (index) => true);

  // Keys for SharedPreferences
  static const String _keyIsDailyReminder = 'isDailyReminder';
  static const String _keyReminderTimeHour = 'reminderTimeHour';
  static const String _keyReminderTimeMinute = 'reminderTimeMinute';
  static const String _keySelectedDays = 'selectedDays';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final notificationStatus = await _notificationService.checkPermissions();

    setState(() {
      _isDailyReminder = prefs.getBool(_keyIsDailyReminder) ?? false;

      // Only enable notifications if we have both stored preference and system permission
      _isDailyReminder = _isDailyReminder && (notificationStatus ?? false);

      // Load reminder time
      final hour = prefs.getInt(_keyReminderTimeHour) ?? 8;
      final minute = prefs.getInt(_keyReminderTimeMinute) ?? 0;
      _reminderTime = TimeOfDay(hour: hour, minute: minute);

      // Load selected days
      final selectedDaysString = prefs.getString(_keySelectedDays);
      if (selectedDaysString != null) {
        _selectedDays =
            selectedDaysString.split(',').map((e) => e == 'true').toList();
      }
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsDailyReminder, _isDailyReminder);
    await prefs.setInt(_keyReminderTimeHour, _reminderTime.hour);
    await prefs.setInt(_keyReminderTimeMinute, _reminderTime.minute);
    await prefs.setString(
        _keySelectedDays, _selectedDays.map((e) => e.toString()).join(','));
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _reminderTime,
    );
    if (picked != null && picked != _reminderTime) {
      setState(() => _reminderTime = picked);
      await _updateNotificationSchedule();
      await _saveSettings();
    }
  }

  Future<void> _updateNotificationSchedule() async {
    if (_isDailyReminder) {
      await _notificationService.scheduleDailyNotifications(
          _reminderTime, _selectedDays);
    } else {
      await _notificationService.cancelAllNotifications();
    }
    await _saveSettings();
  }

  String _getSelectedDaysText() {
    final selectedCount = _selectedDays.where((day) => day).length;

    if (selectedCount == 0) {
      return 'None';
    } else if (selectedCount == 7) {
      return 'Everyday';
    }

    // Check for weekdays (Mon-Fri)
    bool isWeekdays = true;
    for (int i = 0; i < 5; i++) {
      if (!_selectedDays[i]) {
        isWeekdays = false;
        break;
      }
    }
    if (isWeekdays && !_selectedDays[5] && !_selectedDays[6]) {
      return 'Weekdays';
    }

    // Check for weekends (Sat-Sun)
    if (!_selectedDays.sublist(0, 5).contains(true) &&
        _selectedDays[5] &&
        _selectedDays[6]) {
      return 'Weekends';
    }

    // For custom selections, show selected day names
    final weekDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final selectedDays = <String>[];

    for (int i = 0; i < _selectedDays.length; i++) {
      if (_selectedDays[i]) {
        selectedDays.add(weekDays[i]);
      }
    }

    // If more than 3 days, just show count
    if (selectedDays.length > 3) {
      return '${selectedDays.length} days';
    }

    // For 1-3 days, show the actual days
    return selectedDays.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    return SettingsSection(
      title: 'Notifications',
      children: [
        SettingsTile(
          icon: Icons.notifications,
          title: 'Daily Reminder',
          trailing: Switch(
            value: _isDailyReminder,
            onChanged: _handleNotificationToggle,
          ),
        ),
        SettingsTile(
          icon: Icons.access_time,
          title: 'Reminder Time',
          enabled: _isDailyReminder,
          trailing: TextButton(
            onPressed: _isDailyReminder ? _selectTime : null,
            child: Text(
              _reminderTime.format(context),
              style: TextStyle(
                color: _isDailyReminder
                    ? Theme.of(context).primaryColor
                    : Colors.grey,
                fontSize: 16,
              ),
            ),
          ),
        ),
        SettingsTile(
          icon: Icons.calendar_today,
          title: 'Notification Days',
          enabled: _isDailyReminder,
          trailing: Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: Text(
              _getSelectedDaysText(),
              style: TextStyle(
                color: _isDailyReminder ? Colors.blue : Colors.grey,
                fontSize: 16,
              ),
            ),
          ),
        ),
        SizedBox(height: 4),
        DaySelector(
          selectedDays: _selectedDays,
          enabled: _isDailyReminder,
          onDayToggled: _onDayToggled,
        ),
        SizedBox(height: 16),
      ],
    );
  }

  Future<void> _handleNotificationToggle(bool value) async {
    if (value) {
      final granted = await _notificationService.requestPermissions();
      if (granted) {
        setState(() => _isDailyReminder = true);
        await _updateNotificationSchedule();
      } else {
        _showNotificationRequiredDialog();
      }
    } else {
      setState(() => _isDailyReminder = false);
      await _notificationService.cancelAllNotifications();
      await _saveSettings();
    }
  }

  Future<void> _onDayToggled(int index) async {
    setState(() => _selectedDays[index] = !_selectedDays[index]);
    await _updateNotificationSchedule();
    await _saveSettings();
  }

  void _showNotificationRequiredDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Notifications Required'),
        content: const Text(
            'Please enable notifications in your system settings to use this feature.'),
        actions: [
          TextButton(
            child: const Text('OK'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}

class DaySelector extends StatelessWidget {
  final List<bool> selectedDays;
  final bool enabled;
  final Function(int) onDayToggled;

  const DaySelector({
    super.key,
    required this.selectedDays,
    required this.enabled,
    required this.onDayToggled,
  });

  @override
  Widget build(BuildContext context) {
    final weekDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(
          7,
          (index) => _DayButton(
            day: weekDays[index],
            selected: selectedDays[index],
            enabled: enabled,
            onTap: () => onDayToggled(index),
          ),
        ),
      ),
    );
  }
}

class _DayButton extends StatelessWidget {
  final String day;
  final bool selected;
  final bool enabled;
  final VoidCallback onTap;

  const _DayButton({
    required this.day,
    required this.selected,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: enabled
              ? (selected ? Theme.of(context).primaryColor : Colors.transparent)
              : Colors.grey.withValues(alpha: 0.1),
          border: Border.all(
            color: enabled ? Theme.of(context).primaryColor : Colors.grey,
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            day,
            style: TextStyle(
              color: enabled
                  ? (selected ? Colors.white : Theme.of(context).primaryColor)
                  : Colors.grey,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
