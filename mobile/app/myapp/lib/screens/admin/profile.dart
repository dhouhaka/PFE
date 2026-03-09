// ============================================================
// FILE: admin_profile.dart
// DESCRIPTION: Admin Profile Screen — Flutter port of React AdminProfile
//              Dark theme matching admin_users.dart design system.
//              Mock data replaces all API calls.
// ============================================================

import 'package:flutter/material.dart';

// ─────────────────────────────────────────────
// THEME CONSTANTS  (same as admin_users.dart)
// ─────────────────────────────────────────────
const Color kBgBase      = Color(0xFF080B14);
const Color kBgSurface   = Color(0xFF0E1220);
const Color kBgElevated  = Color(0xFF141828);
const Color kBgHighlight = Color(0xFF1C2235);

const Color kBorderSubtle = Color(0xFF1E2540);
const Color kBorderMid    = Color(0xFF252D45);

const Color kIndigo  = Color(0xFF6366F1);
const Color kViolet  = Color(0xFF8B5CF6);
const Color kCyan    = Color(0xFF22D3EE);

const Color kSuccess = Color(0xFF10B981);
const Color kWarning = Color(0xFFF59E0B);
const Color kError   = Color(0xFFF43F5E);
const Color kInfo    = Color(0xFF3B82F6);

const Color kTextPrimary  = Color(0xFFEEF0F8);
const Color kTextSecond   = Color(0xFF9BA3BE);
const Color kTextMuted    = Color(0xFF5C6484);
const Color kTextDisabled = Color(0xFF3A4060);

const LinearGradient kBrandGrad = LinearGradient(
  colors: [kIndigo, kViolet],
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
);

// ─────────────────────────────────────────────
// MOCK ADMIN MODEL
// ─────────────────────────────────────────────

class AdminModel {
  String prenom;
  String nom;
  String email;
  String? numTel;
  String? adresse;
  DateTime? dateDeNaissance;
  String role;
  bool verified;
  bool status;
  DateTime createdAt;
  String? adminCode;

  AdminModel({
    required this.prenom,
    required this.nom,
    required this.email,
    this.numTel,
    this.adresse,
    this.dateDeNaissance,
    required this.role,
    required this.verified,
    required this.status,
    required this.createdAt,
    this.adminCode,
  });

  String get fullName => '$prenom $nom';
  String get initials => '${prenom.isNotEmpty ? prenom[0] : ''}${nom.isNotEmpty ? nom[0] : ''}'.toUpperCase();

  AdminModel copyWith({
    String? prenom, String? nom, String? email,
    String? numTel, String? adresse, DateTime? dateDeNaissance,
    String? adminCode,
  }) => AdminModel(
    prenom: prenom ?? this.prenom,
    nom: nom ?? this.nom,
    email: email ?? this.email,
    numTel: numTel ?? this.numTel,
    adresse: adresse ?? this.adresse,
    dateDeNaissance: dateDeNaissance ?? this.dateDeNaissance,
    role: role, verified: verified, status: status,
    createdAt: createdAt, adminCode: adminCode ?? this.adminCode,
  );
}

final _mockAdmin = AdminModel(
  prenom: 'Alice',
  nom: 'Smith',
  email: 'alice.smith@edunex.com',
  numTel: '+216 22 333 444',
  adresse: '12 Rue de la Paix, Tunis',
  dateDeNaissance: DateTime(1990, 5, 15),
  role: 'admin',
  verified: true,
  status: true,
  createdAt: DateTime(2022, 3, 10),
  adminCode: 'ADM-001',
);


// ─────────────────────────────────────────────
// MAIN SCREEN
// ─────────────────────────────────────────────

class AdminProfileScreen extends StatefulWidget {
  const AdminProfileScreen({super.key});
  @override
  State<AdminProfileScreen> createState() => _AdminProfileScreenState();
}

class _AdminProfileScreenState extends State<AdminProfileScreen> {
  late AdminModel _admin;
  late AdminModel _original;

  bool _isEditing = false;
  bool _loading    = false;

  // Form controllers
  late TextEditingController _prenomCtrl, _nomCtrl, _emailCtrl;
  late TextEditingController _telCtrl, _adresseCtrl, _adminCodeCtrl;
  DateTime? _dob;

  @override
  void initState() {
    super.initState();
    _admin    = _mockAdmin;
    _original = _mockAdmin;
    _initControllers(_admin);
  }

  void _initControllers(AdminModel a) {
    _prenomCtrl    = TextEditingController(text: a.prenom);
    _nomCtrl       = TextEditingController(text: a.nom);
    _emailCtrl     = TextEditingController(text: a.email);
    _telCtrl       = TextEditingController(text: a.numTel ?? '');
    _adresseCtrl   = TextEditingController(text: a.adresse ?? '');
    _adminCodeCtrl = TextEditingController(text: a.adminCode ?? '');
    _dob = a.dateDeNaissance;
  }

  void _disposeControllers() {
    for (final c in [_prenomCtrl, _nomCtrl, _emailCtrl, _telCtrl, _adresseCtrl, _adminCodeCtrl]) c.dispose();
  }

  @override
  void dispose() {
    _disposeControllers();
    super.dispose();
  }

  void _startEdit() => setState(() => _isEditing = true);

  void _cancelEdit() {
    setState(() {
      _isEditing = false;
      _disposeControllers();
      _initControllers(_original);
    });
  }

  Future<void> _saveEdit() async {
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 600));
    final updated = _original.copyWith(
      prenom:          _prenomCtrl.text.trim(),
      nom:             _nomCtrl.text.trim(),
      email:           _emailCtrl.text.trim(),
      numTel:          _telCtrl.text.trim().isEmpty ? null : _telCtrl.text.trim(),
      adresse:         _adresseCtrl.text.trim().isEmpty ? null : _adresseCtrl.text.trim(),
      dateDeNaissance: _dob,
      adminCode:       _adminCodeCtrl.text.trim().isEmpty ? null : _adminCodeCtrl.text.trim(),
    );
    setState(() {
      _admin    = updated;
      _original = updated;
      _isEditing = false;
      _loading   = false;
    });
    _showToast('Profile updated successfully!', ToastType.success);
  }

  void _showToast(String msg, ToastType type) => AppToast.show(context, msg, type: type);

  String _fmtDate(DateTime? d) {
    if (d == null) return 'N/A';
    const mo = ['','Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    return '${d.day.toString().padLeft(2,'0')} ${mo[d.month]} ${d.year}';
  }

  String _memberSince(DateTime d) {
    const mo = ['','Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    return '${mo[d.month]} ${d.year}';
  }

  Future<void> _pickDate() async {
    final d = await showDatePicker(
      context: context,
      initialDate: _dob ?? DateTime(1990),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.dark(primary: kIndigo, surface: kBgSurface, onSurface: kTextPrimary),
          dialogBackgroundColor: kBgSurface,
        ),
        child: child!,
      ),
    );
    if (d != null) setState(() => _dob = d);
  }

  // ─────────────────────────────────────────────
  // BUILD
  // ─────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgBase,
      appBar: _buildAppBar(),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: kIndigo))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                // Page title
                _buildPageHeader(),
                const SizedBox(height: 20),
                // Hero profile card
                _buildHeroCard(),
                const SizedBox(height: 16),
                // Responsive layout: on wide screens side-by-side, on narrow stacked
                LayoutBuilder(builder: (_, constraints) {
                  if (constraints.maxWidth >= 700) {
                    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Expanded(flex: 2, child: _buildLeftColumn()),
                      const SizedBox(width: 16),
                      Expanded(child: _buildRightColumn()),
                    ]);
                  }
                  return Column(children: [
                    _buildLeftColumn(),
                    const SizedBox(height: 16),
                    _buildRightColumn(),
                  ]);
                }),
                const SizedBox(height: 32),
              ]),
            ),
    );
  }

  // ── AppBar ──
  PreferredSizeWidget _buildAppBar() => AppBar(
    backgroundColor: kBgSurface,
    surfaceTintColor: Colors.transparent,
    elevation: 0,
    bottom: PreferredSize(
      preferredSize: const Size.fromHeight(1),
      child: Container(height: 1, color: kBorderSubtle),
    ),
    title: Row(children: [
      Container(
        width: 30, height: 30,
        decoration: BoxDecoration(gradient: kBrandGrad, borderRadius: BorderRadius.circular(8)),
        child: const Icon(Icons.manage_accounts_rounded, size: 16, color: Colors.white),
      ),
      const SizedBox(width: 10),
      const Text('Admin Profile', style: TextStyle(color: kTextPrimary, fontWeight: FontWeight.w700, fontSize: 17, letterSpacing: -0.2)),
    ]),
  );

  // ── Page header with edit/save/cancel buttons ──
  Widget _buildPageHeader() => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        ShaderMask(
          shaderCallback: (b) => kBrandGrad.createShader(b),
          child: const Text('Admin Profile', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: -0.5)),
        ),
        const SizedBox(height: 4),
        const Text('Manage your admin account & security', style: TextStyle(fontSize: 13, color: kTextMuted)),
      ])),
      const SizedBox(width: 12),
      if (_isEditing) ...[
        _OutlineBtn(label: 'Cancel', icon: Icons.close_rounded, color: kTextMuted, onTap: _cancelEdit),
        const SizedBox(width: 8),
        _GradientBtn(label: 'Save Changes', icon: Icons.save_rounded, onTap: _saveEdit),
      ] else
        _GradientBtn(label: 'Edit Profile', icon: Icons.edit_outlined, onTap: _startEdit),
    ],
  );

  // ── Hero card (avatar + name + badges) ──
  Widget _buildHeroCard() => _Card(
    child: Stack(children: [
      // Gradient background tint
      Positioned.fill(child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [kIndigo.withOpacity(0.08), Colors.transparent],
            begin: Alignment.topLeft, end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(14),
        ),
      )),
      Padding(
        padding: const EdgeInsets.all(20),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Avatar
          Stack(children: [
            Container(
              width: 88, height: 88,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(colors: [kIndigo, kViolet], begin: Alignment.topLeft, end: Alignment.bottomRight),
                border: Border.all(color: kIndigo.withOpacity(0.4), width: 2.5),
                boxShadow: [BoxShadow(color: kIndigo.withOpacity(0.3), blurRadius: 20, spreadRadius: -4)],
              ),
              alignment: Alignment.center,
              child: Text(_admin.initials, style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w900, color: Colors.white)),
            ),
            if (_isEditing) Positioned(
              bottom: 0, right: 0,
              child: Container(
                width: 26, height: 26,
                decoration: BoxDecoration(gradient: kBrandGrad, shape: BoxShape.circle, border: Border.all(color: kBgSurface, width: 2)),
                child: const Icon(Icons.camera_alt_rounded, size: 13, color: Colors.white),
              ),
            ),
          ]),
          const SizedBox(width: 20),
          // Info
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(_admin.fullName, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: kTextPrimary, letterSpacing: -0.4)),
            const SizedBox(height: 5),
            Row(children: [
              const Icon(Icons.email_outlined, size: 14, color: kTextMuted),
              const SizedBox(width: 5),
              Expanded(child: Text(_admin.email, style: const TextStyle(fontSize: 13, color: kTextSecond), overflow: TextOverflow.ellipsis)),
            ]),
            const SizedBox(height: 12),
            Wrap(spacing: 6, runSpacing: 6, children: [
              _Badge(label: 'Admin', color: kError, icon: Icons.shield_rounded),
              _Badge(label: 'Super Admin', color: kViolet, icon: Icons.star_rounded),
              if (_admin.verified) _Badge(label: 'Verified', color: kSuccess, icon: Icons.verified_rounded),
              if (_admin.status)   _Badge(label: 'Active',   color: kInfo,    icon: Icons.circle, dotOnly: true),
            ]),
          ])),
        ]),
      ),
    ]),
  );

  // ── Left column: Personal Info + Admin Settings ──
  Widget _buildLeftColumn() => Column(children: [
    // Personal Information card
    _SectionCard(
      title: 'Personal Information',
      subtitle: 'Update your personal details',
      icon: Icons.person_outline_rounded,
      iconColor: kIndigo,
      child: Column(children: [
        Row(children: [
          Expanded(child: _ProfileField(label: 'First Name', ctrl: _prenomCtrl, enabled: _isEditing)),
          const SizedBox(width: 12),
          Expanded(child: _ProfileField(label: 'Last Name',  ctrl: _nomCtrl,   enabled: _isEditing)),
        ]),
        const SizedBox(height: 14),
        _ProfileField(label: 'Email Address', ctrl: _emailCtrl, enabled: _isEditing, keyboard: TextInputType.emailAddress),
        const SizedBox(height: 14),
        Row(children: [
          Expanded(child: _ProfileField(label: 'Phone Number', ctrl: _telCtrl, enabled: _isEditing, keyboard: TextInputType.phone)),
          const SizedBox(width: 12),
          Expanded(child: _DateField(label: 'Date of Birth', date: _dob, enabled: _isEditing, onTap: _isEditing ? _pickDate : null)),
        ]),
        const SizedBox(height: 14),
        _ProfileField(label: 'Address', ctrl: _adresseCtrl, enabled: _isEditing, maxLines: 3),
      ]),
    ),
    const SizedBox(height: 16),
    // Admin Settings card
    _SectionCard(
      title: 'Admin Settings',
      subtitle: 'Platform-level info managed by administration',
      icon: Icons.settings_rounded,
      iconColor: kViolet,
      child: Column(children: [
        Row(children: [
          Expanded(child: _ReadonlyField(label: 'Role',         value: 'Administrator')),
          const SizedBox(width: 12),
          Expanded(child: _ReadonlyField(label: 'Member Since', value: _memberSince(_admin.createdAt))),
        ]),
        const SizedBox(height: 14),
        _ProfileField(label: 'Admin Code', ctrl: _adminCodeCtrl, enabled: _isEditing),
        const SizedBox(height: 14),
        // Info alert
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: kIndigo.withOpacity(0.07),
            border: Border.all(color: kIndigo.withOpacity(0.2)),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(children: [
            Icon(Icons.info_outline_rounded, size: 16, color: kIndigo.withOpacity(0.8)),
            const SizedBox(width: 10),
            const Expanded(child: Text(
              'Platform-level permissions are managed by administration. Contact the super-admin for changes.',
              style: TextStyle(fontSize: 12, color: kTextSecond, height: 1.5),
            )),
          ]),
        ),
      ]),
    ),
  ]);

  // ── Right column: Account Status + Overview + Security ──
  Widget _buildRightColumn() => Column(children: [
    // Account Status
    _SectionCard(
      title: 'Account Status',
      icon: Icons.account_circle_outlined,
      iconColor: kSuccess,
      child: Column(children: [
        _StatusRow(label: 'Account Type', value: 'Admin', valueColor: kError),
        _Divider(),
        _StatusRow(label: 'Verification', value: _admin.verified ? 'Verified' : 'Pending', valueColor: _admin.verified ? kSuccess : kWarning),
        _Divider(),
        _StatusRow(label: 'Status', value: _admin.status ? 'Active' : 'Inactive', valueColor: _admin.status ? kInfo : kTextMuted),
        _Divider(),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const Text('Member Since', style: TextStyle(fontSize: 13, color: kTextMuted)),
          Text(_memberSince(_admin.createdAt), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: kTextPrimary)),
        ]),
      ]),
    ),
    const SizedBox(height: 16),
    // Admin Overview
    _AdminOverviewCard(),
    const SizedBox(height: 16),
    // Security & Preferences
    _SecurityCard(
      onPasswordTap: () => _showPasswordDialog(),
      onEmailPrefTap: () => _showEmailPrefsDialog(),
      onDeleteTap: () => _showDeleteDialog(),
    ),
  ]);

  // ─────────────────────────────────────────────
  // DIALOGS
  // ─────────────────────────────────────────────

  void _showPasswordDialog() {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.7),
      builder: (_) => _PasswordDialog(
        onSuccess: () => _showToast('Password changed successfully!', ToastType.success),
        onError:   (msg) => _showToast(msg, ToastType.error),
      ),
    );
  }

  void _showEmailPrefsDialog() {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.7),
      builder: (_) => _EmailPrefsDialog(
        onSave: () => _showToast('Email preferences updated!', ToastType.success),
      ),
    );
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.7),
      builder: (_) => _DeleteAccountDialog(
        adminName: _admin.fullName,
        onConfirm: () => _showToast('Account deleted. Redirecting...', ToastType.success),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// ADMIN OVERVIEW CARD
// ─────────────────────────────────────────────

class _AdminOverviewCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Header
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [kIndigo.withOpacity(0.12), kViolet.withOpacity(0.08)],
              begin: Alignment.centerLeft, end: Alignment.centerRight,
            ),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(13)),
            border: Border(bottom: BorderSide(color: kBorderSubtle)),
          ),
          child: Row(children: [
            Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: kIndigo.withOpacity(0.15), borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.settings_rounded, size: 14, color: kIndigo)),
            const SizedBox(width: 8),
            const Text('Admin Overview', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: kTextPrimary)),
          ]),
        ),
        // Stats
        _OverviewStat(icon: Icons.people_rounded,    color: kIndigo,   label: 'Total Users',    value: '1,248', badge: 'Active'),
        Container(height: 1, color: kBorderSubtle),
        _OverviewStat(icon: Icons.book_rounded,      color: kSuccess,  label: 'Total Classes',  value: '52',    badge: 'Running'),
        Container(height: 1, color: kBorderSubtle),
        _OverviewStat(icon: Icons.key_rounded,       color: kInfo,     label: 'Admin Actions',  value: '847',   badge: 'This Month'),
      ]),
    );
  }
}

class _OverviewStat extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label, value, badge;
  const _OverviewStat({required this.icon, required this.color, required this.label, required this.value, required this.badge});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    child: Row(children: [
      Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, size: 18, color: color),
      ),
      const SizedBox(width: 12),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: const TextStyle(fontSize: 11, color: kTextMuted)),
        Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: color, height: 1.1)),
      ])),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(color: color.withOpacity(0.1), border: Border.all(color: color.withOpacity(0.3)), borderRadius: BorderRadius.circular(20)),
        child: Text(badge, style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.w600)),
      ),
    ]),
  );
}

// ─────────────────────────────────────────────
// SECURITY CARD
// ─────────────────────────────────────────────

class _SecurityCard extends StatelessWidget {
  final VoidCallback onPasswordTap, onEmailPrefTap, onDeleteTap;
  const _SecurityCard({required this.onPasswordTap, required this.onEmailPrefTap, required this.onDeleteTap});

  @override
  Widget build(BuildContext context) => _SectionCard(
    title: 'Security & Preferences',
    icon: Icons.lock_outline_rounded,
    iconColor: kWarning,
    child: Column(children: [
      _SecurityBtn(icon: Icons.lock_rounded,   label: 'Change Password',   color: kIndigo,  onTap: onPasswordTap),
      const SizedBox(height: 8),
      _SecurityBtn(icon: Icons.notifications_rounded, label: 'Email Preferences', color: kSuccess, onTap: onEmailPrefTap),
      const SizedBox(height: 8),
      _SecurityBtn(icon: Icons.delete_forever_rounded, label: 'Delete Account', color: kError, onTap: onDeleteTap, danger: true),
    ]),
  );
}

class _SecurityBtn extends StatefulWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  final bool danger;
  const _SecurityBtn({required this.icon, required this.label, required this.color, required this.onTap, this.danger = false});
  @override
  State<_SecurityBtn> createState() => _SecurityBtnState();
}
class _SecurityBtnState extends State<_SecurityBtn> {
  bool _hov = false;
  @override
  Widget build(BuildContext context) => MouseRegion(
    onEnter: (_) => setState(() => _hov = true),
    onExit:  (_) => setState(() => _hov = false),
    child: GestureDetector(
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: _hov ? widget.color.withOpacity(widget.danger ? 0.1 : 0.07) : Colors.transparent,
          border: Border.all(color: widget.danger ? widget.color.withOpacity(0.3) : kBorderMid),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(children: [
          Icon(widget.icon, size: 16, color: widget.color),
          const SizedBox(width: 10),
          Text(widget.label, style: TextStyle(fontSize: 13, color: widget.danger ? widget.color : kTextPrimary, fontWeight: FontWeight.w500)),
          const Spacer(),
          Icon(Icons.chevron_right_rounded, size: 16, color: kTextMuted),
        ]),
      ),
    ),
  );
}

// ─────────────────────────────────────────────
// CHANGE PASSWORD DIALOG
// ─────────────────────────────────────────────

class _PasswordDialog extends StatefulWidget {
  final VoidCallback onSuccess;
  final Function(String) onError;
  const _PasswordDialog({required this.onSuccess, required this.onError});
  @override
  State<_PasswordDialog> createState() => _PasswordDialogState();
}

class _PasswordDialogState extends State<_PasswordDialog> with SingleTickerProviderStateMixin {
  final _currentCtrl = TextEditingController();
  final _newCtrl     = TextEditingController();
  final _confirmCtrl = TextEditingController();

  bool _showPwd  = false;
  bool _loading  = false;
  _FeedbackMsg? _feedback;

  late AnimationController _animCtrl;
  late Animation<double> _scale, _fade;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 280));
    _scale = Tween<double>(begin: 0.9, end: 1).animate(CurvedAnimation(parent: _animCtrl, curve: Curves.easeOutBack));
    _fade  = Tween<double>(begin: 0,   end: 1).animate(CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut));
    _animCtrl.forward();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    _currentCtrl.dispose(); _newCtrl.dispose(); _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _feedback = null);

    if (_currentCtrl.text.isEmpty || _newCtrl.text.isEmpty || _confirmCtrl.text.isEmpty) {
      setState(() => _feedback = _FeedbackMsg(false, 'Please fill in all password fields!'));
      return;
    }
    if (_newCtrl.text != _confirmCtrl.text) {
      setState(() => _feedback = _FeedbackMsg(false, "New passwords don't match!"));
      return;
    }
    if (_newCtrl.text.length < 8) {
      setState(() => _feedback = _FeedbackMsg(false, 'Password must be at least 8 characters!'));
      return;
    }
    if (!RegExp(r'^(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{8,}$').hasMatch(_newCtrl.text)) {
      setState(() => _feedback = _FeedbackMsg(false, 'Must include uppercase, lowercase & number.'));
      return;
    }

    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 800));
    setState(() { _loading = false; _feedback = _FeedbackMsg(true, 'Password changed successfully!'); });

    await Future.delayed(const Duration(milliseconds: 1200));
    if (mounted) { Navigator.pop(context); widget.onSuccess(); }
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _animCtrl,
    builder: (_, child) => Transform.scale(scale: _scale.value, child: Opacity(opacity: _fade.value, child: child)),
    child: Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 400,
        decoration: BoxDecoration(
          color: kBgSurface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: kBorderMid),
          boxShadow: [BoxShadow(color: kIndigo.withOpacity(0.1), blurRadius: 40, spreadRadius: -8), BoxShadow(color: Colors.black.withOpacity(0.6), blurRadius: 32)],
        ),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          // Header
          _DialogHeader(title: 'Change Password', subtitle: 'Enter your current password and choose a new one', icon: Icons.lock_rounded, color: kIndigo),
          // Body
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(children: [
              if (_feedback != null) ...[
                _FeedbackBanner(msg: _feedback!),
                const SizedBox(height: 14),
              ],
              _PwdField(label: 'Current Password', ctrl: _currentCtrl, show: _showPwd, onToggle: () => setState(() => _showPwd = !_showPwd), enabled: !_loading),
              const SizedBox(height: 12),
              _PwdField(label: 'New Password',     ctrl: _newCtrl,     show: _showPwd, onToggle: () => setState(() => _showPwd = !_showPwd), enabled: !_loading),
              const SizedBox(height: 12),
              _PwdField(label: 'Confirm New Password', ctrl: _confirmCtrl, show: _showPwd, onToggle: () => setState(() => _showPwd = !_showPwd), enabled: !_loading),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: kBgElevated, borderRadius: BorderRadius.circular(10), border: Border.all(color: kBorderSubtle)),
                child: Row(children: [
                  Icon(Icons.info_outline_rounded, size: 14, color: kTextMuted),
                  const SizedBox(width: 8),
                  const Expanded(child: Text('Min 8 characters with uppercase, lowercase & number.', style: TextStyle(fontSize: 11, color: kTextMuted))),
                ]),
              ),
            ]),
          ),
          // Footer
          _DialogFooter(
            onCancel: () => Navigator.pop(context),
            onConfirm: _submit,
            confirmLabel: _loading ? 'Updating…' : 'Update Password',
            loading: _loading,
          ),
        ]),
      ),
    ),
  );
}

// ─────────────────────────────────────────────
// EMAIL PREFERENCES DIALOG
// ─────────────────────────────────────────────

class _EmailPrefsDialog extends StatefulWidget {
  final VoidCallback onSave;
  const _EmailPrefsDialog({required this.onSave});
  @override
  State<_EmailPrefsDialog> createState() => _EmailPrefsDialogState();
}

class _EmailPrefsDialogState extends State<_EmailPrefsDialog> {
  bool _systemAlerts    = true;
  bool _userNotifs      = true;
  bool _weeklyReports   = false;

  @override
  Widget build(BuildContext context) => Dialog(
    backgroundColor: Colors.transparent,
    child: Container(
      width: 400,
      decoration: BoxDecoration(
        color: kBgSurface, borderRadius: BorderRadius.circular(20),
        border: Border.all(color: kBorderMid),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 32)],
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        _DialogHeader(title: 'Email Preferences', subtitle: 'Manage your email notification settings', icon: Icons.notifications_rounded, color: kSuccess),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(children: [
            _PrefToggle(
              title: 'System Alerts', sub: 'Critical system notifications',
              value: _systemAlerts, onChanged: (v) => setState(() => _systemAlerts = v),
            ),
            Container(height: 1, color: kBorderSubtle, margin: const EdgeInsets.symmetric(vertical: 12)),
            _PrefToggle(
              title: 'User Notifications', sub: 'Updates about user activities',
              value: _userNotifs, onChanged: (v) => setState(() => _userNotifs = v),
            ),
            Container(height: 1, color: kBorderSubtle, margin: const EdgeInsets.symmetric(vertical: 12)),
            _PrefToggle(
              title: 'Weekly Reports', sub: 'Platform statistics and reports',
              value: _weeklyReports, onChanged: (v) => setState(() => _weeklyReports = v),
            ),
          ]),
        ),
        _DialogFooter(
          onCancel: () => Navigator.pop(context),
          onConfirm: () { Navigator.pop(context); widget.onSave(); },
          confirmLabel: 'Save Preferences',
        ),
      ]),
    ),
  );
}

// ─────────────────────────────────────────────
// DELETE ACCOUNT DIALOG
// ─────────────────────────────────────────────

class _DeleteAccountDialog extends StatelessWidget {
  final String adminName;
  final VoidCallback onConfirm;
  const _DeleteAccountDialog({required this.adminName, required this.onConfirm});

  @override
  Widget build(BuildContext context) => Dialog(
    backgroundColor: Colors.transparent,
    child: Container(
      width: 400,
      decoration: BoxDecoration(
        color: kBgSurface, borderRadius: BorderRadius.circular(20),
        border: Border.all(color: kError.withOpacity(0.3)),
        boxShadow: [BoxShadow(color: kError.withOpacity(0.08), blurRadius: 40), BoxShadow(color: Colors.black.withOpacity(0.6), blurRadius: 32)],
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        _DialogHeader(title: 'Delete Account', subtitle: 'This action cannot be undone', icon: Icons.delete_forever_rounded, color: kError),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
          child: Column(children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: kError.withOpacity(0.07), border: Border.all(color: kError.withOpacity(0.25)), borderRadius: BorderRadius.circular(10)),
              child: Row(children: [
                Icon(Icons.warning_rounded, size: 18, color: kError.withOpacity(0.9)),
                const SizedBox(width: 10),
                const Expanded(child: Text(
                  '⚠️ All your data, including account information and admin logs, will be permanently deleted.',
                  style: TextStyle(fontSize: 12, color: kTextSecond, height: 1.5),
                )),
              ]),
            ),
            const SizedBox(height: 16),
            Row(children: [
              Expanded(child: _OutlineBtn(label: 'Cancel', icon: Icons.close_rounded, color: kTextMuted, onTap: () => Navigator.pop(context))),
              const SizedBox(width: 10),
              Expanded(child: FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: kError,
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () { Navigator.pop(context); onConfirm(); },
                icon: const Icon(Icons.delete_rounded, size: 16),
                label: const Text('Delete Account', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
              )),
            ]),
          ]),
        ),
      ]),
    ),
  );
}

// ─────────────────────────────────────────────
// TOAST SYSTEM  (same pattern as admin_users.dart)
// ─────────────────────────────────────────────

enum ToastType { success, error, warning, info }

class _ToastCfg {
  final Color bg, border, icon;
  final IconData iconData;
  final String prefix;
  const _ToastCfg({required this.bg, required this.border, required this.icon, required this.iconData, required this.prefix});
}

const _toastMap = {
  ToastType.success: _ToastCfg(bg: Color(0xFF0A1F18), border: kSuccess, icon: kSuccess, iconData: Icons.check_circle_rounded,  prefix: 'Success'),
  ToastType.error:   _ToastCfg(bg: Color(0xFF1F0A10), border: kError,   icon: kError,   iconData: Icons.error_rounded,          prefix: 'Error'),
  ToastType.warning: _ToastCfg(bg: Color(0xFF1F160A), border: kWarning, icon: kWarning, iconData: Icons.warning_rounded,         prefix: 'Warning'),
  ToastType.info:    _ToastCfg(bg: Color(0xFF0A1020), border: kInfo,    icon: kInfo,    iconData: Icons.info_rounded,            prefix: 'Info'),
};

class AppToast {
  static OverlayEntry? _current;

  static void show(BuildContext context, String message, {ToastType type = ToastType.success}) {
    _current?.remove();
    final cfg = _toastMap[type]!;
    _current = OverlayEntry(builder: (_) => _ToastWidget(message: message, config: cfg));
    Overlay.of(context).insert(_current!);
    Future.delayed(const Duration(milliseconds: 3200), () { _current?.remove(); _current = null; });
  }
}

class _ToastWidget extends StatefulWidget {
  final String message;
  final _ToastCfg config;
  const _ToastWidget({required this.message, required this.config});
  @override
  State<_ToastWidget> createState() => _ToastWidgetState();
}

class _ToastWidgetState extends State<_ToastWidget> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _slide, _fade, _scale;

  @override
  void initState() {
    super.initState();
    _ctrl  = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    _slide = Tween<double>(begin: -20, end: 0).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
    _fade  = Tween<double>(begin: 0,   end: 1).animate(CurvedAnimation(parent: _ctrl, curve: const Interval(0, 0.6)));
    _scale = Tween<double>(begin: 0.92,end: 1).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutBack));
    _ctrl.forward();
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final cfg = widget.config;
    return Positioned(
      top: MediaQuery.of(context).padding.top + 12,
      left: 16, right: 16,
      child: Material(
        color: Colors.transparent,
        child: AnimatedBuilder(
          animation: _ctrl,
          builder: (_, child) => Transform.translate(
            offset: Offset(0, _slide.value),
            child: Opacity(opacity: _fade.value, child: Transform.scale(scale: _scale.value, child: child)),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: cfg.bg,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: cfg.border.withOpacity(0.6), width: 1.5),
              boxShadow: [BoxShadow(color: cfg.border.withOpacity(0.2), blurRadius: 24, spreadRadius: -4), BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 16, offset: const Offset(0, 8))],
            ),
            child: Row(children: [
              Container(width: 36, height: 36, decoration: BoxDecoration(color: cfg.icon.withOpacity(0.15), borderRadius: BorderRadius.circular(10)), child: Icon(cfg.iconData, color: cfg.icon, size: 20)),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                Text(cfg.prefix, style: TextStyle(color: cfg.icon, fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
                const SizedBox(height: 2),
                Text(widget.message, style: const TextStyle(color: kTextPrimary, fontSize: 13, height: 1.3)),
              ])),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () { AppToast._current?.remove(); AppToast._current = null; },
                child: Container(width: 24, height: 24, decoration: BoxDecoration(color: cfg.border.withOpacity(0.12), borderRadius: BorderRadius.circular(6)), child: Icon(Icons.close_rounded, size: 14, color: cfg.icon.withOpacity(0.7))),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// SHARED SMALL WIDGETS
// ─────────────────────────────────────────────

// Generic dark card wrapper
class _Card extends StatelessWidget {
  final Widget child;
  const _Card({required this.child});
  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    decoration: BoxDecoration(
      color: kBgSurface,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: kBorderSubtle),
    ),
    child: child,
  );
}

// Section card with header + content
class _SectionCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final Color iconColor;
  final Widget child;
  const _SectionCard({required this.title, this.subtitle, required this.icon, required this.iconColor, required this.child});

  @override
  Widget build(BuildContext context) => _Card(
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
        child: Row(children: [
          Container(padding: const EdgeInsets.all(7), decoration: BoxDecoration(color: iconColor.withOpacity(0.12), borderRadius: BorderRadius.circular(9)), child: Icon(icon, size: 15, color: iconColor)),
          const SizedBox(width: 10),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: kTextPrimary)),
            if (subtitle != null) Text(subtitle!, style: const TextStyle(fontSize: 11, color: kTextMuted)),
          ])),
        ]),
      ),
      Container(height: 1, color: kBorderSubtle),
      Padding(padding: const EdgeInsets.all(16), child: child),
    ]),
  );
}

// Labelled text input field
class _ProfileField extends StatelessWidget {
  final String label;
  final TextEditingController ctrl;
  final bool enabled;
  final TextInputType? keyboard;
  final int maxLines;
  const _ProfileField({required this.label, required this.ctrl, required this.enabled, this.keyboard, this.maxLines = 1});

  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: kTextSecond)),
    const SizedBox(height: 5),
    TextFormField(
      controller: ctrl,
      enabled: enabled,
      maxLines: maxLines,
      keyboardType: keyboard,
      style: const TextStyle(fontSize: 13, color: kTextPrimary),
      decoration: _fieldDeco(),
    ),
  ]);
}

// Readonly display field
class _ReadonlyField extends StatelessWidget {
  final String label, value;
  const _ReadonlyField({required this.label, required this.value});
  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: kTextSecond)),
    const SizedBox(height: 5),
    Container(
      width: double.infinity, padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(color: kBgHighlight, border: Border.all(color: kBorderSubtle), borderRadius: BorderRadius.circular(10)),
      child: Text(value, style: const TextStyle(fontSize: 13, color: kTextMuted)),
    ),
  ]);
}

// Date picker display field
class _DateField extends StatelessWidget {
  final String label;
  final DateTime? date;
  final bool enabled;
  final VoidCallback? onTap;
  const _DateField({required this.label, required this.date, required this.enabled, this.onTap});

  String _fmt(DateTime d) {
    const mo = ['','Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    return '${d.day.toString().padLeft(2,'0')} ${mo[d.month]} ${d.year}';
  }

  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: kTextSecond)),
    const SizedBox(height: 5),
    GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        height: 42, padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: enabled ? kBgElevated : kBgHighlight,
          border: Border.all(color: kBorderMid),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(children: [
          Expanded(child: Text(date != null ? _fmt(date!) : 'Select date', style: TextStyle(fontSize: 13, color: date != null ? kTextPrimary : kTextMuted))),
          Icon(Icons.calendar_today_rounded, size: 14, color: enabled ? kTextMuted : kTextDisabled),
        ]),
      ),
    ),
  ]);
}

// Status row (label + value badge)
class _StatusRow extends StatelessWidget {
  final String label, value;
  final Color valueColor;
  const _StatusRow({required this.label, required this.value, required this.valueColor});
  @override
  Widget build(BuildContext context) => Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
    Text(label, style: const TextStyle(fontSize: 13, color: kTextMuted)),
    Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: valueColor.withOpacity(0.1), border: Border.all(color: valueColor.withOpacity(0.3)), borderRadius: BorderRadius.circular(20)),
      child: Text(value, style: TextStyle(fontSize: 11, color: valueColor, fontWeight: FontWeight.w700)),
    ),
  ]);
}

// Thin horizontal divider for status rows
class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(height: 1, color: kBorderSubtle, margin: const EdgeInsets.symmetric(vertical: 10));
}

// Role/status badge pill
class _Badge extends StatelessWidget {
  final String label;
  final Color color;
  final IconData icon;
  final bool dotOnly;
  const _Badge({required this.label, required this.color, required this.icon, this.dotOnly = false});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(color: color.withOpacity(0.12), border: Border.all(color: color.withOpacity(0.3)), borderRadius: BorderRadius.circular(20)),
    child: Row(mainAxisSize: MainAxisSize.min, children: [
      dotOnly
          ? Container(width: 6, height: 6, decoration: BoxDecoration(color: color, shape: BoxShape.circle))
          : Icon(icon, size: 11, color: color),
      const SizedBox(width: 5),
      Text(label, style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w700)),
    ]),
  );
}

// Gradient primary button
class _GradientBtn extends StatefulWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final double height;
  const _GradientBtn({required this.label, required this.icon, required this.onTap, this.height = 38});
  @override
  State<_GradientBtn> createState() => _GradientBtnState();
}
class _GradientBtnState extends State<_GradientBtn> {
  bool _pressed = false;
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTapDown: (_) => setState(() => _pressed = true),
    onTapUp:   (_) { setState(() => _pressed = false); widget.onTap(); },
    onTapCancel: () => setState(() => _pressed = false),
    child: AnimatedScale(
      scale: _pressed ? 0.96 : 1.0,
      duration: const Duration(milliseconds: 100),
      child: Container(
        height: widget.height,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          gradient: kBrandGrad, borderRadius: BorderRadius.circular(10),
          boxShadow: [BoxShadow(color: kIndigo.withOpacity(0.35), blurRadius: 12, offset: const Offset(0, 4))],
        ),
        alignment: Alignment.center,
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(widget.icon, size: 14, color: Colors.white),
          const SizedBox(width: 6),
          Text(widget.label, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700)),
        ]),
      ),
    ),
  );
}

// Outline button
class _OutlineBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _OutlineBtn({required this.label, required this.icon, required this.color, required this.onTap});
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      height: 38, padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(color: color.withOpacity(0.05), border: Border.all(color: color.withOpacity(0.3)), borderRadius: BorderRadius.circular(10)),
      alignment: Alignment.center,
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 6),
        Text(label, style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w600)),
      ]),
    ),
  );
}

// Dialog header with icon + title + subtitle
class _DialogHeader extends StatelessWidget {
  final String title, subtitle;
  final IconData icon;
  final Color color;
  const _DialogHeader({required this.title, required this.subtitle, required this.icon, required this.color});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.fromLTRB(20, 20, 16, 16),
    decoration: BoxDecoration(border: Border(bottom: BorderSide(color: kBorderSubtle))),
    child: Row(children: [
      Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(10)), child: Icon(icon, size: 18, color: color)),
      const SizedBox(width: 12),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: kTextPrimary, letterSpacing: -0.2)),
        const SizedBox(height: 2),
        Text(subtitle, style: const TextStyle(fontSize: 12, color: kTextMuted)),
      ])),
      IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close_rounded, size: 18, color: kTextMuted), style: IconButton.styleFrom(backgroundColor: kBgHighlight, minimumSize: const Size(30, 30), padding: EdgeInsets.zero)),
    ]),
  );
}

// Dialog footer with cancel + confirm
class _DialogFooter extends StatelessWidget {
  final VoidCallback onCancel, onConfirm;
  final String confirmLabel;
  final bool loading;
  const _DialogFooter({required this.onCancel, required this.onConfirm, required this.confirmLabel, this.loading = false});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
    decoration: BoxDecoration(border: Border(top: BorderSide(color: kBorderSubtle))),
    child: Row(children: [
      Expanded(child: _OutlineBtn(label: 'Cancel', icon: Icons.close_rounded, color: kTextMuted, onTap: onCancel)),
      const SizedBox(width: 10),
      Expanded(flex: 2, child: _GradientBtn(label: confirmLabel, icon: loading ? Icons.hourglass_top_rounded : Icons.check_rounded, onTap: onConfirm, height: 44)),
    ]),
  );
}

// Password text field with visibility toggle
class _PwdField extends StatelessWidget {
  final String label;
  final TextEditingController ctrl;
  final bool show, enabled;
  final VoidCallback onToggle;
  const _PwdField({required this.label, required this.ctrl, required this.show, required this.onToggle, required this.enabled});
  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: kTextSecond)),
    const SizedBox(height: 5),
    TextFormField(
      controller: ctrl,
      obscureText: !show,
      enabled: enabled,
      style: const TextStyle(fontSize: 13, color: kTextPrimary),
      decoration: _fieldDeco(suffix: IconButton(
        onPressed: onToggle,
        icon: Icon(show ? Icons.visibility_off_outlined : Icons.visibility_outlined, size: 17, color: kTextMuted),
      )),
    ),
  ]);
}

// Preference toggle row
class _PrefToggle extends StatelessWidget {
  final String title, sub;
  final bool value;
  final ValueChanged<bool> onChanged;
  const _PrefToggle({required this.title, required this.sub, required this.value, required this.onChanged});
  @override
  Widget build(BuildContext context) => Row(children: [
    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: kTextPrimary)),
      const SizedBox(height: 2),
      Text(sub,   style: const TextStyle(fontSize: 11, color: kTextMuted)),
    ])),
    Switch(
      value: value,
      onChanged: onChanged,
      activeColor: kIndigo,
      activeTrackColor: kIndigo.withOpacity(0.3),
      inactiveTrackColor: kBgHighlight,
      inactiveThumbColor: kTextMuted,
    ),
  ]);
}

// Feedback banner (success / error) inside dialogs
class _FeedbackMsg {
  final bool success;
  final String message;
  const _FeedbackMsg(this.success, this.message);
}

class _FeedbackBanner extends StatelessWidget {
  final _FeedbackMsg msg;
  const _FeedbackBanner({required this.msg});
  @override
  Widget build(BuildContext context) {
    final color = msg.success ? kSuccess : kError;
    final icon  = msg.success ? Icons.check_circle_rounded : Icons.error_rounded;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: color.withOpacity(0.08), border: Border.all(color: color.withOpacity(0.35)), borderRadius: BorderRadius.circular(10)),
      child: Row(children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 10),
        Expanded(child: Text(msg.message, style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w600))),
      ]),
    );
  }
}

// Shared input decoration
InputDecoration _fieldDeco({String? hint, Widget? suffix}) => InputDecoration(
  hintText: hint,
  hintStyle: const TextStyle(color: kTextDisabled, fontSize: 13),
  suffixIcon: suffix,
  filled: true,
  fillColor: kBgElevated,
  isDense: true,
  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
  border:             OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: kBorderMid)),
  enabledBorder:      OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: kBorderMid)),
  disabledBorder:     OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: kBorderSubtle)),
  focusedBorder:      OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: kIndigo, width: 1.5)),
  errorBorder:        OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: kError)),
  focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: kError, width: 1.5)),
  errorStyle: const TextStyle(fontSize: 11, color: kError),
);

// Shared border color (needed outside const context)
const Color green = Color(0xFF252D45);