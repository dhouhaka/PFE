import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:EduNex/services/user_service.dart';
import 'package:EduNex/services/auth_service.dart';


// ─── Design Tokens (mirrors NotificationsPage's _C) ───────────────────────────
class _C {

  static const bg = Color(0xFF0B0D14);
  static const bgCard = Color(0xFF13151F);

  static const border = Color(0xFF252838);
  static const textPrimary = Color(0xFFF1F3FF);
  static const textMuted = Color(0xFF6B7094);
  static const danger = Color(0xFFEF4444);
  static const dangerBg = Color(0x22EF4444);
  static const successBg = Color(0xFF052E1A);
  static const successBorder = Color(0xFF22C55E);
  static const successText = Color(0xFF86EFAC);
  static const errorBg = Color(0xFF2D0A0A);
  static const errorBorder = Color(0xFFEF4444);
  static const errorText = Color(0xFFFCA5A5);
  static const accentGreen = Color(0xFF22C55E);
  static const accentBlue = Color(0xFF3B82F6);
  static const accentPurple = Color(0xFFA855F7);
}

// "from-accent to-primary" gradient used across the React UI
const List<Color> _kAccentGradient = [Color(0xFF8B5CF6), Color(0xFF6366F1)];

// ─── Toast model (same pattern as NotificationsPage) ──────────────────────────
class _Toast {
  final String message;
  final bool isError;
  const _Toast(this.message, {this.isError = false});
}

// ─── Page ─────────────────────────────────────────────────────────────────────
class StudentProfilePage extends StatefulWidget {
  const StudentProfilePage({super.key});

  @override
  State<StudentProfilePage> createState() => _StudentProfilePageState();
}

class _StudentProfilePageState extends State<StudentProfilePage>
    with TickerProviderStateMixin {
  // ── Data ─────────────────────────────────────────────────────────────────
  Map<String, dynamic>? formData;
  Map<String, dynamic>? originalData;

  bool isLoading = true;
  bool isSaving = false;
  bool isEditing = false;

  // Avatar
  File? pickedImage;
  String? previewImageUrl;

  String _imageUrl(String filename) {
    // Backend stores files in: backend/public/images/<filename>
    // Keep same API_BASE_URL as ApiService.
    const baseUrl = 'http://192.168.1.211:5000';
    return '$baseUrl/images/$filename';
  }


  // Editable controllers
  final _prenomCtrl = TextEditingController();
  final _nomCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _numTelCtrl = TextEditingController();
  final _adresseCtrl = TextEditingController();
  DateTime? _dateNaissance;

  // Toast
  _Toast? _toast;
  Timer? _toastTimer;
  late AnimationController _toastController;
  late Animation<double> _toastAnim;

  @override
  void initState() {
    super.initState();
    _toastController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _toastAnim = CurvedAnimation(
      parent: _toastController,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeIn,
    );
    _loadProfile();
  }

  @override
  void dispose() {
    _toastTimer?.cancel();
    _toastController.dispose();
    _prenomCtrl.dispose();
    _nomCtrl.dispose();
    _emailCtrl.dispose();
    _numTelCtrl.dispose();
    _adresseCtrl.dispose();
    super.dispose();
  }

  // ── Data loading ─────────────────────────────────────────────────────────

  Future<void> _loadProfile() async {
    setState(() => isLoading = true);
    try {
      final user = await UserService.instance.getProfile();
      final data = user.toJson();


      setState(() {
        formData = data;
        originalData = Map<String, dynamic>.from(data);
        previewImageUrl = data['image_User'] != null
            ? _imageUrl(data['image_User'].toString())
            : null;

        _syncControllersFromData(data);
        isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() => isLoading = false);
        _showToast('Failed to load profile data', isError: true);
      }
    }
  }

  void _syncControllersFromData(Map<String, dynamic> data) {
    _prenomCtrl.text = data['prenom']?.toString() ?? '';
    _nomCtrl.text = data['nom']?.toString() ?? '';
    _emailCtrl.text = data['email']?.toString() ?? '';
    _numTelCtrl.text = data['NumTel']?.toString() ?? '';
    _adresseCtrl.text = data['Adresse']?.toString() ?? '';
    final dob = data['datedeNaissance'];
    _dateNaissance = dob != null ? DateTime.tryParse(dob.toString()) : null;
  }

  // ── Toast ────────────────────────────────────────────────────────────────

  void _showToast(String msg, {bool isError = false}) {
    _toastTimer?.cancel();
    setState(() => _toast = _Toast(msg, isError: isError));
    _toastController.forward(from: 0);
    _toastTimer = Timer(const Duration(milliseconds: 2200), () async {
      await _toastController.reverse();
      if (mounted) setState(() => _toast = null);
    });
  }

  // ── Image picking ────────────────────────────────────────────────────────

  Future<void> _pickImage() async {
    try {
      final picker = ImagePicker();
      final XFile? image =
          await picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
      if (image != null) {
        setState(() => pickedImage = File(image.path));
      }
    } catch (e) {
      _showToast('Could not open image picker', isError: true);
    }
  }

  // ── Save / Cancel ────────────────────────────────────────────────────────

  Future<void> _handleSave() async {
    if (formData == null) return;
    setState(() => isSaving = true);
    try {
      final updated = <String, dynamic>{
        'prenom': _prenomCtrl.text.trim(),
        'nom': _nomCtrl.text.trim(),
        'email': _emailCtrl.text.trim(),
        'NumTel': _numTelCtrl.text.trim(),
        'Adresse': _adresseCtrl.text.trim(),
        'datedeNaissance': _dateNaissance?.toIso8601String(),
      };

      await UserService.instance.updateProfile(
        id: formData!['_id'].toString(),
        data: updated,
      );


      _showToast('Profile updated successfully!');
      setState(() => isEditing = false);
      await _loadProfile();
    } catch (e) {
      _showToast('Failed to update profile', isError: true);
    } finally {
      if (mounted) setState(() => isSaving = false);
    }
  }

  void _handleCancel() {
    if (originalData == null) return;
    setState(() {
      formData = Map<String, dynamic>.from(originalData!);
      _syncControllersFromData(formData!);
      pickedImage = null;
      previewImageUrl = formData!['image_User'] != null
          ? _imageUrl(formData!['image_User'].toString())
          : null;

      isEditing = false;
    });
  }

  // ── Dialogs ──────────────────────────────────────────────────────────────

  void _openChangePasswordDialog() {
    showDialog(
      context: context,
      builder: (_) => _ChangePasswordDialog(
        userId: formData?['_id']?.toString() ?? '',
        onSuccess: () => _showToast('Password changed successfully!'),
        onError: (msg) => _showToast(msg, isError: true),
      ),
    );
  }

  void _openEmailPreferencesDialog() {
    showDialog(
      context: context,
      builder: (_) => _EmailPreferencesDialog(
        onSave: () => _showToast('Email preferences updated successfully!'),
      ),
    );
  }

  void _openDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (_) => _ConfirmDialog(
        title: 'Delete Account',
        descriptionWidget: const Text(
          'This action cannot be undone. This will permanently delete your '
          'account and remove all your data from our servers.',
          style: TextStyle(color: _C.textMuted, fontSize: 14, height: 1.5),
        ),
        warningText:
            '⚠️ Warning: All your data, including courses, grades, and '
            'personal information will be permanently deleted.',
        confirmLabel: 'Yes, Delete My Account',
        onConfirm: _handleDeleteAccount,
      ),
    );
  }

  Future<void> _handleDeleteAccount() async {
    try {
      await UserService.instance.deleteAccount(formData!['_id'].toString());

      if (mounted) {
        Navigator.of(context).pop();
        _showToast('Account deleted successfully. Redirecting...');
      }
      Timer(const Duration(seconds: 2), () async {
        await AuthService.instance.logout();
        if (mounted) {
          Navigator.of(context)
              .pushNamedAndRemoveUntil('/login', (route) => false);
        }
      });


    } catch (e) {
      if (mounted) Navigator.of(context).pop();
      _showToast('Failed to delete account', isError: true);
    }
  }

  // ── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _C.bg,
      body: Stack(
        children: [
          SafeArea(
            child: isLoading || formData == null
                ? const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: Color(0xFF8B5CF6),
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: _loadProfile,
                    color: const Color(0xFF8B5CF6),
                    backgroundColor: const Color(0xFF1A1D27),
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
                      children: [
                        _buildHeader(),
                        const SizedBox(height: 16),
                        _buildProfileHeaderCard(),
                        const SizedBox(height: 16),
                        _buildPersonalInfoCard(),
                        const SizedBox(height: 16),
                        _buildAcademicInfoCard(),
                        const SizedBox(height: 16),
                        _buildAccountStatusCard(),
                        const SizedBox(height: 16),
                        _buildAcademicOverviewCard(),
                        const SizedBox(height: 16),
                        _buildSettingsCard(),
                      ],
                    ),
                  ),
          ),
          if (_toast != null)
            Positioned(
              top: MediaQuery.of(context).padding.top + 12,
              left: 16,
              right: 16,
              child: FadeTransition(
      opacity: _toastAnim,


                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, -0.4),
                    end: Offset.zero,
                  ).animate(_toastAnim),
                  child: _ToastWidget(toast: _toast!),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ── Header ───────────────────────────────────────────────────────────────

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 12, 8, 0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.maybePop(context),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF1A1D27),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _C.border),
              ),
              child: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: _C.textMuted, size: 16),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: ShaderMask(
              shaderCallback: (r) => const LinearGradient(
                colors: [
                  Color(0xFF8B5CF6),
                  Color(0xFF6366F1),
                  Color(0xFF10B981),
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ).createShader(r),
              child: const Text(
                'My Profile',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.6,
                ),
              ),
            ),
          ),
          if (isEditing) ...[
            _SmallIconButton(
              icon: Icons.close_rounded,
              outlined: true,
              onTap: isSaving ? null : _handleCancel,
            ),
            const SizedBox(width: 8),
            _SmallIconButton(
              icon: Icons.check_rounded,
              gradient: true,
              loading: isSaving,
              onTap: isSaving ? null : _handleSave,
            ),
          ] else
            _SmallIconButton(
              icon: Icons.edit_outlined,
              gradient: true,
              onTap: () => setState(() => isEditing = true),
            ),
        ],
      ),
    );
  }

  // ── Profile header card ──────────────────────────────────────────────────

  Widget _buildProfileHeaderCard() {
    final data = formData!;
    final prenom = (data['prenom'] ?? '').toString();
    final nom = (data['nom'] ?? '').toString();
    final email = (data['email'] ?? '').toString();
    final classe = data['classe'] as Map<String, dynamic>?;
    final verified = data['verified'] == true;
    final status = data['Status'] == true;

    ImageProvider? avatarImage;
    if (pickedImage != null) {
      avatarImage = FileImage(pickedImage!);
    } else if (previewImageUrl != null) {
      avatarImage = NetworkImage(previewImageUrl!);
    }

    final initials =
        '${prenom.isNotEmpty ? prenom[0].toUpperCase() : ''}${nom.isNotEmpty ? nom[0].toUpperCase() : ''}';

    return _Section(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: _kAccentGradient,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    border: Border.all(color: _C.bgCard, width: 4),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x338B5CF6),
                        blurRadius: 16,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: avatarImage != null
                        ? Image(image: avatarImage, fit: BoxFit.cover)
                        : Center(
                            child: Text(
                              initials,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                  ),
                ),
                if (isEditing)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: const BoxDecoration(
                          color: Color(0xFF8B5CF6),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Color(0x668B5CF6),
                              blurRadius: 8,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: const Icon(Icons.camera_alt_rounded,
                            color: Colors.white, size: 16),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              '$prenom $nom'.trim(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: _C.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.mail_outline_rounded,
                    color: _C.textMuted, size: 14),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    email,
                    style: const TextStyle(color: _C.textMuted, fontSize: 13),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 8,
              runSpacing: 8,
              children: [
                const _Badge(
                  label: 'Student',
                  icon: Icons.school_outlined,
                  color: Color(0xFF8B5CF6),
                ),
                if (classe?['niveau'] != null)
                  _Badge(
                      label: classe!['niveau'].toString(),
                      color: _C.accentPurple),
                if (classe?['specialisation'] != null)
                  _Badge(
                      label: classe!['specialisation'].toString(),
                      color: _C.accentBlue),
                if (verified)
                  const _Badge(
                      label: '✓ Verified', color: _C.accentGreen),
                if (status)
                  const _Badge(label: '● Active', color: _C.accentBlue),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ── Personal information ────────────────────────────────────────────────

  Widget _buildPersonalInfoCard() {
    return _Section(
      title: 'Personal Information',
      subtitle: 'Update your personal details',
      icon: Icons.person_outline_rounded,
      iconColor: const Color(0xFF8B5CF6),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _LabeledField(
                  label: 'First Name',
                  controller: _prenomCtrl,
                  enabled: isEditing,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _LabeledField(
                  label: 'Last Name',
                  controller: _nomCtrl,
                  enabled: isEditing,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _LabeledField(
            label: 'Email Address',
            controller: _emailCtrl,
            enabled: isEditing,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _LabeledField(
                  label: 'Phone Number',
                  controller: _numTelCtrl,
                  enabled: isEditing,
                  keyboardType: TextInputType.phone,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _DateField(
                  label: 'Date of Birth',
                  date: _dateNaissance,
                  enabled: isEditing,
                  onPick: (d) => setState(() => _dateNaissance = d),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _LabeledField(
            label: 'Address',
            controller: _adresseCtrl,
            enabled: isEditing,
            maxLines: 3,
          ),
        ],
      ),
    );
  }

  // ── Academic information (read-only) ────────────────────────────────────

  Widget _buildAcademicInfoCard() {
    final classe = formData!['classe'] as Map<String, dynamic>?;
    final dateInscription = formData!['dateInscription']?.toString();

    return _Section(
      title: 'Academic Information',
      subtitle: 'Your enrollment and academic details (read-only)',
      icon: Icons.menu_book_outlined,
      iconColor: const Color(0xFF8B5CF6),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _LabeledField(
                  label: 'Class',
                  initialValue: classe?['nom']?.toString() ?? 'N/A',
                  enabled: false,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _LabeledField(
                  label: 'Academic Level',
                  initialValue: classe?['niveau']?.toString() ?? 'N/A',
                  enabled: false,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _LabeledField(
                  label: 'Specialization',
                  initialValue: classe?['specialisation']?.toString() ?? 'N/A',
                  enabled: false,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _LabeledField(
                  label: 'Academic Year',
                  initialValue: classe?['annee']?.toString() ?? 'N/A',
                  enabled: false,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _LabeledField(
            label: 'Enrollment Date',
            initialValue: dateInscription != null
                ? dateInscription.split('T').first
                : 'N/A',
            enabled: false,
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0x118B5CF6),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0x338B5CF6)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.workspace_premium_outlined,
                    color: Color(0xFF8B5CF6), size: 18),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    'Academic information is managed by your institution. '
                    'Contact administration for any changes.',
                    style: TextStyle(
                        color: _C.textMuted, fontSize: 12.5, height: 1.4),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Account status ───────────────────────────────────────────────────────

  Widget _buildAccountStatusCard() {
    final data = formData!;
    final verified = data['verified'] == true;
    final status = data['Status'] == true;
    final dateInscription = data['dateInscription'] != null
        ? DateTime.tryParse(data['dateInscription'].toString())
        : null;

    return _Section(
      title: 'Account Status',
      child: Column(
        children: [
          _StatusRow(label: 'Account Type', value: 'Student'),
          const _Divider(),
          _StatusRow(
            label: 'Verification',
            value: verified ? 'Verified' : 'Pending',
            color: verified ? _C.accentGreen : _C.textMuted,
          ),
          const _Divider(),
          _StatusRow(
            label: 'Status',
            value: status ? 'Active' : 'Inactive',
            color: status ? _C.accentGreen : _C.textMuted,
          ),
          const _Divider(),
          _StatusRow(
            label: 'Enrolled Since',
            value: dateInscription != null
                ? '${_monthName(dateInscription.month)} ${dateInscription.year}'
                : 'N/A',
          ),
        ],
      ),
    );
  }

  String _monthName(int m) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return months[(m - 1).clamp(0, 11)];
  }

  // ── Academic overview ────────────────────────────────────────────────────

  Widget _buildAcademicOverviewCard() {
    return _Section(
      title: 'Academic Overview',
      icon: Icons.workspace_premium_outlined,
      iconColor: const Color(0xFF8B5CF6),
      padContent: false,
      child: Column(
        children: const [
          _OverviewRow(
            icon: Icons.menu_book_outlined,
            iconColor: Color(0xFF8B5CF6),
            label: 'Active Courses',
            value: '6',
            badge: 'In Progress',
            badgeColor: Color(0xFF8B5CF6),
          ),
          _Divider(),
          _OverviewRow(
            icon: Icons.workspace_premium_outlined,
            iconColor: Color(0xFF6366F1),
            label: 'Completed',
            value: '12',
            badge: 'Courses',
            badgeColor: Color(0xFF6366F1),
          ),
          _Divider(),
          _OverviewRow(
            icon: Icons.school_outlined,
            iconColor: Color(0xFF22C55E),
            label: 'Current GPA',
            value: '3.8',
            badge: 'Excellent',
            badgeColor: Color(0xFF22C55E),
          ),
        ],
      ),
    );
  }

  // ── Settings ──────────────────────────────────────────────────────────────

  Widget _buildSettingsCard() {
    return _Section(
      title: 'Settings',
      child: Column(
        children: [
          _SettingsButton(
            icon: Icons.lock_outline_rounded,
            label: 'Change Password',
            onTap: _openChangePasswordDialog,
          ),
          const SizedBox(height: 10),
          _SettingsButton(
            icon: Icons.notifications_outlined,
            label: 'Email Preferences',
            onTap: _openEmailPreferencesDialog,
          ),
          const SizedBox(height: 10),
          _SettingsButton(
            icon: Icons.delete_outline_rounded,
            label: 'Delete Account',
            danger: true,
            onTap: _openDeleteAccountDialog,
          ),
        ],
      ),
    );
  }
}

// ─── Shared section/card wrapper ───────────────────────────────────────────
class _Section extends StatelessWidget {
  const _Section({
    required this.child,
    this.title,
    this.subtitle,
    this.icon,
    this.iconColor,
    this.padContent = true,
  });

  final Widget child;
  final String? title;
  final String? subtitle;
  final IconData? icon;
  final Color? iconColor;
  final bool padContent;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _C.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _C.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            Padding(
              padding: EdgeInsets.fromLTRB(18, 16, 18, subtitle != null ? 4 : 14),
              child: Row(
                children: [
                  if (icon != null) ...[
                    Icon(icon, color: iconColor ?? _C.textMuted, size: 18),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    title!,
                    style: const TextStyle(
                      color: _C.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          if (subtitle != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 0, 18, 14),
              child: Text(
                subtitle!,
                style: const TextStyle(color: _C.textMuted, fontSize: 12.5),
              ),
            ),
          Padding(
            padding: padContent
                ? EdgeInsets.fromLTRB(18, title == null ? 18 : 0, 18, 18)
                : EdgeInsets.zero,
            child: child,
          ),
        ],
      ),
    );
  }
}

// ─── Labeled text field ─────────────────────────────────────────────────────
class _LabeledField extends StatelessWidget {
  const _LabeledField({
    required this.label,
    this.controller,
    this.initialValue,
    this.enabled = true,
    this.maxLines = 1,
    this.keyboardType,
  });

  final String label;
  final TextEditingController? controller;
  final String? initialValue;
  final bool enabled;
  final int maxLines;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                color: _C.textMuted,
                fontSize: 12.5,
                fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          enabled: enabled,
          maxLines: maxLines,
          keyboardType: keyboardType,
          style: TextStyle(
            color: enabled ? _C.textPrimary : _C.textMuted,
            fontSize: 14,
          ),
          decoration: InputDecoration(
            isDense: true,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            filled: true,
            fillColor: enabled ? const Color(0xFF1A1D27) : const Color(0xFF111319),
            hintText: initialValue,
            hintStyle: const TextStyle(color: _C.textMuted, fontSize: 14),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: _C.border),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: _C.border),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: _C.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFF8B5CF6)),
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Date field with native picker ─────────────────────────────────────────
class _DateField extends StatelessWidget {
  const _DateField({
    required this.label,
    required this.date,
    required this.enabled,
    required this.onPick,
  });

  final String label;
  final DateTime? date;
  final bool enabled;
  final ValueChanged<DateTime> onPick;

  @override
  Widget build(BuildContext context) {
    final text = date != null
        ? '${date!.year}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}'
        : 'Select date';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                color: _C.textMuted,
                fontSize: 12.5,
                fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: enabled
              ? () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: date ?? DateTime(2005, 1, 1),
                    firstDate: DateTime(1950),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) onPick(picked);
                }
              : null,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              color: enabled ? const Color(0xFF1A1D27) : const Color(0xFF111319),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: _C.border),
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_today_outlined,
                    color: _C.textMuted, size: 15),
                const SizedBox(width: 10),
                Text(
                  text,
                  style: TextStyle(
                    color: enabled ? _C.textPrimary : _C.textMuted,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Badge ───────────────────────────────────────────────────────────────────
class _Badge extends StatelessWidget {
  const _Badge({required this.label, required this.color, this.icon});
  final String label;
  final Color color;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.4)),
        color: color.withOpacity(0.08),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, color: color, size: 12),
            const SizedBox(width: 4),
          ],
          Text(label,
              style: TextStyle(
                  color: color, fontSize: 11.5, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

// ─── Status row (Account Status card) ──────────────────────────────────────
class _StatusRow extends StatelessWidget {
  const _StatusRow({required this.label, required this.value, this.color});
  final String label;
  final String value;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: _C.textMuted, fontSize: 13)),
          Text(
            value,
            style: TextStyle(
              color: color ?? _C.textPrimary,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Overview row (Academic Overview card) ─────────────────────────────────
class _OverviewRow extends StatelessWidget {
  const _OverviewRow({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.badge,
    required this.badgeColor,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final String badge;
  final Color badgeColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(color: _C.textMuted, fontSize: 11.5)),
                Text(value,
                    style: TextStyle(
                        color: iconColor,
                        fontSize: 22,
                        fontWeight: FontWeight.w800)),
              ],
            ),
          ),
          _Badge(label: badge, color: badgeColor),
        ],
      ),
    );
  }
}

// ─── Divider ─────────────────────────────────────────────────────────────────
class _Divider extends StatelessWidget {
  const _Divider();
  @override
  Widget build(BuildContext context) =>
      Container(height: 1, color: _C.border);
}

// ─── Settings list button ──────────────────────────────────────────────────
class _SettingsButton extends StatelessWidget {
  const _SettingsButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.danger = false,
  });
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    final color = danger ? _C.danger : _C.textPrimary;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        decoration: BoxDecoration(
          color: danger ? _C.dangerBg : const Color(0xFF1A1D27),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: danger ? _C.danger.withOpacity(0.3) : _C.border),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 10),
            Text(label,
                style: TextStyle(
                    color: color, fontSize: 14, fontWeight: FontWeight.w600)),
            const Spacer(),
            Icon(Icons.chevron_right_rounded, color: _C.textMuted, size: 18),
          ],
        ),
      ),
    );
  }
}

// ─── Small icon button (header Edit/Save/Cancel) ───────────────────────────
class _SmallIconButton extends StatelessWidget {
  const _SmallIconButton({
    required this.icon,
    required this.onTap,
    this.gradient = false,
    this.outlined = false,
    this.loading = false,
  });

  final IconData icon;
  final VoidCallback? onTap;
  final bool gradient;
  final bool outlined;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final child = loading
        ? const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
          )
        : Icon(icon,
            color: gradient ? Colors.white : _C.textPrimary, size: 18);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedOpacity(
        opacity: onTap == null ? 0.6 : 1,
        duration: const Duration(milliseconds: 150),
        child: Container(
          width: 40,
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: gradient
                ? const LinearGradient(colors: _kAccentGradient)
                : null,
            color: gradient ? null : const Color(0xFF1A1D27),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: outlined ? _C.border : Colors.transparent),
          ),
          child: child,
        ),
      ),
    );
  }
}

// ─── Toast widget (identical pattern to NotificationsPage) ─────────────────
class _ToastWidget extends StatelessWidget {
  const _ToastWidget({required this.toast});
  final _Toast toast;

  @override
  Widget build(BuildContext context) {
    final bg = toast.isError ? _C.errorBg : _C.successBg;
    final border = toast.isError ? _C.errorBorder : _C.successBorder;
    final fg = toast.isError ? _C.errorText : _C.successText;
    final icon =
        toast.isError ? Icons.cancel_outlined : Icons.check_circle_outline;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: border, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: border, size: 18),
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              toast.message,
              style: TextStyle(
                  color: fg, fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Generic confirm dialog (Delete account / etc.) ────────────────────────
class _ConfirmDialog extends StatefulWidget {
  const _ConfirmDialog({
    required this.title,
    required this.descriptionWidget,
    required this.confirmLabel,
    required this.onConfirm,
    this.warningText,
  });

  final String title;
  final Widget descriptionWidget;
  final String confirmLabel;
  final Future<void> Function() onConfirm;
  final String? warningText;

  @override
  State<_ConfirmDialog> createState() => _ConfirmDialogState();
}

class _ConfirmDialogState extends State<_ConfirmDialog> {
  bool _loading = false;

  Future<void> _confirm() async {
    setState(() => _loading = true);
    try {
      await widget.onConfirm();
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF13151F),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(color: _C.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.title,
                style: TextStyle(
                    color: widget.confirmLabel.toLowerCase().contains('delete')
                        ? _C.danger
                        : _C.textPrimary,
                    fontSize: 17,
                    fontWeight: FontWeight.w700)),
            const SizedBox(height: 10),
            widget.descriptionWidget,
            if (widget.warningText != null) ...[
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _C.errorBg,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: _C.errorBorder.withOpacity(0.4)),
                ),
                child: Text(
                  widget.warningText!,
                  style: const TextStyle(
                      color: _C.errorText, fontSize: 12.5, height: 1.4),
                ),
              ),
            ],
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: _C.border),
                      ),
                      alignment: Alignment.center,
                      child: const Text('Cancel',
                          style: TextStyle(
                              color: _C.textPrimary,
                              fontSize: 14,
                              fontWeight: FontWeight.w600)),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: _loading ? null : _confirm,
                    child: AnimatedOpacity(
                      opacity: _loading ? 0.6 : 1,
                      duration: const Duration(milliseconds: 200),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: _C.danger,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.center,
                        child: _loading
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2, color: Colors.white),
                              )
                            : Text(widget.confirmLabel,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Change password dialog ─────────────────────────────────────────────────
class _ChangePasswordDialog extends StatefulWidget {
  const _ChangePasswordDialog({
    required this.userId,
    required this.onSuccess,
    required this.onError,
  });

  final String userId;
  final VoidCallback onSuccess;
  final void Function(String) onError;

  @override
  State<_ChangePasswordDialog> createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<_ChangePasswordDialog> {
  final _currentCtrl = TextEditingController();
  final _newCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _showPassword = false;
  bool _loading = false;
  String? _errorMessage;
  bool _success = false;

  @override
  void dispose() {
    _currentCtrl.dispose();
    _newCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _errorMessage = null);

    if (_currentCtrl.text.isEmpty ||
        _newCtrl.text.isEmpty ||
        _confirmCtrl.text.isEmpty) {
      setState(() => _errorMessage = 'Please fill in all password fields!');
      return;
    }
    if (_newCtrl.text != _confirmCtrl.text) {
      setState(() => _errorMessage = "New passwords don't match!");
      return;
    }
    if (_newCtrl.text.length < 8) {
      setState(() =>
          _errorMessage = 'Password must be at least 8 characters long!');
      return;
    }

    setState(() => _loading = true);
    try {
      await UserService.instance.updatePassword(
        widget.userId,
        oldPassword: _currentCtrl.text,
        newPassword: _newCtrl.text,
      );
      setState(() {
        _success = true;
        _errorMessage = null;
      });
      Timer(const Duration(milliseconds: 1200), () {
        if (mounted) {
          widget.onSuccess();
          Navigator.of(context).pop();
        }
      });
    } catch (e) {
      setState(() => _errorMessage = 'Failed to change password');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF13151F),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(color: _C.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Change Password',
                  style: TextStyle(
                      color: _C.textPrimary,
                      fontSize: 17,
                      fontWeight: FontWeight.w700)),
              const SizedBox(height: 6),
              const Text(
                'Enter your current password and choose a new secure password',
                style: TextStyle(color: _C.textMuted, fontSize: 12.5, height: 1.4),
              ),
              if (_errorMessage != null || _success) ...[
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: _success ? _C.successBg : _C.errorBg,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: _success ? _C.successBorder : _C.errorBorder),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _success
                            ? Icons.check_circle_outline
                            : Icons.cancel_outlined,
                        color: _success ? _C.successBorder : _C.errorBorder,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _success
                              ? 'Password changed successfully!'
                              : _errorMessage!,
                          style: TextStyle(
                              color: _success ? _C.successText : _C.errorText,
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 16),
              _PasswordField(
                label: 'Current Password',
                controller: _currentCtrl,
                showPassword: _showPassword,
                onToggle: () => setState(() => _showPassword = !_showPassword),
                enabled: !_loading,
              ),
              const SizedBox(height: 12),
              _PasswordField(
                label: 'New Password',
                controller: _newCtrl,
                showPassword: _showPassword,
                enabled: !_loading,
              ),
              const SizedBox(height: 12),
              _PasswordField(
                label: 'Confirm New Password',
                controller: _confirmCtrl,
                showPassword: _showPassword,
                enabled: !_loading,
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1D27),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: _C.border),
                ),
                child: const Text(
                  'Password must be at least 8 characters long and contain '
                  'uppercase, lowercase, and numbers.',
                  style: TextStyle(color: _C.textMuted, fontSize: 11.5, height: 1.4),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: _loading ? null : () => Navigator.of(context).pop(),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: _C.border),
                        ),
                        alignment: Alignment.center,
                        child: const Text('Cancel',
                            style: TextStyle(
                                color: _C.textPrimary,
                                fontSize: 14,
                                fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: GestureDetector(
                      onTap: _loading ? null : _submit,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(colors: _kAccentGradient),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.center,
                        child: _loading
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2, color: Colors.white),
                              )
                            : const Text('Update Password',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PasswordField extends StatelessWidget {
  const _PasswordField({
    required this.label,
    required this.controller,
    required this.showPassword,
    this.onToggle,
    this.enabled = true,
  });

  final String label;
  final TextEditingController controller;
  final bool showPassword;
  final VoidCallback? onToggle;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                color: _C.textMuted, fontSize: 12.5, fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          enabled: enabled,
          obscureText: !showPassword,
          style: const TextStyle(color: _C.textPrimary, fontSize: 14),
          decoration: InputDecoration(
            isDense: true,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            filled: true,
            fillColor: const Color(0xFF1A1D27),
            suffixIcon: onToggle != null
                ? IconButton(
                    icon: Icon(
                      showPassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: _C.textMuted,
                      size: 18,
                    ),
                    onPressed: onToggle,
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: _C.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: _C.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFF8B5CF6)),
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Email preferences dialog ───────────────────────────────────────────────
class _EmailPreferencesDialog extends StatefulWidget {
  const _EmailPreferencesDialog({required this.onSave});
  final VoidCallback onSave;

  @override
  State<_EmailPreferencesDialog> createState() =>
      _EmailPreferencesDialogState();
}

class _EmailPreferencesDialogState extends State<_EmailPreferencesDialog> {
  bool newsletter = true;
  bool notifications = true;
  bool updates = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF13151F),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(color: _C.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Email Preferences',
                style: TextStyle(
                    color: _C.textPrimary,
                    fontSize: 17,
                    fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            const Text('Manage your email notification settings',
                style: TextStyle(color: _C.textMuted, fontSize: 12.5)),
            const SizedBox(height: 16),
            _PreferenceRow(
              title: 'Newsletter',
              subtitle: 'Receive our weekly newsletter',
              value: newsletter,
              onChanged: (v) => setState(() => newsletter = v),
            ),
            const _Divider(),
            _PreferenceRow(
              title: 'Course Notifications',
              subtitle: 'Updates about your courses',
              value: notifications,
              onChanged: (v) => setState(() => notifications = v),
            ),
            const _Divider(),
            _PreferenceRow(
              title: 'Grade Updates',
              subtitle: 'Get notified when grades are posted',
              value: updates,
              onChanged: (v) => setState(() => updates = v),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: _C.border),
                      ),
                      alignment: Alignment.center,
                      child: const Text('Cancel',
                          style: TextStyle(
                              color: _C.textPrimary,
                              fontSize: 14,
                              fontWeight: FontWeight.w600)),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      widget.onSave();
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: _kAccentGradient),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.center,
                      child: const Text('Save Preferences',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PreferenceRow extends StatelessWidget {
  const _PreferenceRow({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        color: _C.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(subtitle,
                    style: const TextStyle(color: _C.textMuted, fontSize: 12)),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: const Color(0xFF8B5CF6),
          ),
        ],
      ),
    );
  }
}