// ============================================================
// FILE: admin_users.dart
// DESCRIPTION: Admin User Management Screen — Refined Dark Theme
//              Enhanced UI: animated toasts, micro-interactions,
//              better typography, glassmorphism, improved forms.
// ============================================================

import 'package:flutter/material.dart';

// ─────────────────────────────────────────────
// THEME CONSTANTS
// ─────────────────────────────────────────────

// Backgrounds — layered depth system
const Color kBgBase      = Color(0xFF080B14); // Deepest — page background
const Color kBgSurface   = Color(0xFF0E1220); // Cards, panels
const Color kBgElevated  = Color(0xFF141828); // Inputs, inner containers
const Color kBgHighlight = Color(0xFF1C2235); // Hover states, subtle lift

// Borders
const Color kBorderSubtle = Color(0xFF1E2540); // Very subtle dividers
const Color kBorderMid    = Color(0xFF252D45); // Standard borders
const Color kBorderFocus  = Color(0xFF3D4875); // Focused inputs

// Brand palette
const Color kIndigo  = Color(0xFF6366F1); // Primary brand indigo
const Color kViolet  = Color(0xFF8B5CF6); // Secondary violet
const Color kCyan    = Color(0xFF22D3EE); // Accent cyan

// Semantic colors
const Color kSuccess = Color(0xFF10B981); // Emerald green
const Color kWarning = Color(0xFFF59E0B); // Amber
const Color kError   = Color(0xFFF43F5E); // Rose red
const Color kInfo    = Color(0xFF3B82F6); // Blue

// Role colors
const Color kRoleAdmin    = Color(0xFFF43F5E); // Rose — admin
const Color kRoleTeacher  = Color(0xFF6366F1); // Indigo — teacher
const Color kRoleStudent  = Color(0xFF10B981); // Emerald — student

// Text
const Color kTextPrimary  = Color(0xFFEEF0F8);
const Color kTextSecond   = Color(0xFF9BA3BE);
const Color kTextMuted    = Color(0xFF5C6484);
const Color kTextDisabled = Color(0xFF3A4060);

// ── Gradients ──
const LinearGradient kBrandGrad = LinearGradient(
  colors: [kIndigo, kViolet],
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
);

const LinearGradient kCyanGrad = LinearGradient(
  colors: [kIndigo, kCyan],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

// ─────────────────────────────────────────────
// DATA MODELS
// ─────────────────────────────────────────────

class ClassModel {
  final String id;
  final String nom;
  final String annee;
  final String specialisation;
  const ClassModel({required this.id, required this.nom, required this.annee, required this.specialisation});
  String get label => '$nom · $annee · $specialisation';
  String get shortLabel => nom;
}

class UserModel {
  final String id;
  String nom, prenom, email, role, sexe;
  bool status;
  String? numTel, adresse, classeId, specialite, numTelEnseignant, adminCode;
  DateTime? dateDeNaissance, dateInscription, dateEmbauche;
  List<String> classes;

  UserModel({
    required this.id, required this.nom, required this.prenom,
    required this.email, required this.role, required this.sexe, required this.status,
    this.numTel, this.adresse, this.dateDeNaissance, this.classeId,
    this.dateInscription, this.specialite, this.dateEmbauche,
    this.numTelEnseignant, this.classes = const [], this.adminCode,
  });

  String get fullName => '$prenom $nom';
  String get initials {
    final f = prenom.isNotEmpty ? prenom[0] : '';
    final l = nom.isNotEmpty ? nom[0] : '';
    return '$f$l'.toUpperCase();
  }
}

// ─────────────────────────────────────────────
// MOCK DATA
// ─────────────────────────────────────────────

class MockDataService {
  static final List<ClassModel> mockClasses = [
    const ClassModel(id: 'c1', nom: 'Alpha', annee: '2024', specialisation: 'Science'),
    const ClassModel(id: 'c2', nom: 'Beta',  annee: '2024', specialisation: 'Arts'),
    const ClassModel(id: 'c3', nom: 'Gamma', annee: '2025', specialisation: 'Math'),
    const ClassModel(id: 'c4', nom: 'Delta', annee: '2025', specialisation: 'Tech'),
  ];

  static final List<UserModel> mockUsers = [
    UserModel(id: 'u1',  nom: 'Smith',    prenom: 'Alice',  email: 'alice.smith@school.com',     role: 'admin',      sexe: 'Femme', status: true,  adminCode: 'ADM-001'),
    UserModel(id: 'u2',  nom: 'Johnson',  prenom: 'Bob',    email: 'bob.johnson@school.com',     role: 'enseignant', sexe: 'Homme', status: true,  specialite: 'Mathematics', numTelEnseignant: '+216 22 333 444', dateEmbauche: DateTime(2020, 9, 1),  classes: ['c1', 'c3']),
    UserModel(id: 'u3',  nom: 'Williams', prenom: 'Carol',  email: 'carol.williams@school.com',  role: 'enseignant', sexe: 'Femme', status: true,  specialite: 'Physics',      numTelEnseignant: '+216 55 666 777', dateEmbauche: DateTime(2019, 3, 15), classes: ['c2']),
    UserModel(id: 'u4',  nom: 'Brown',    prenom: 'David',  email: 'david.brown@student.com',    role: 'etudiant',   sexe: 'Homme', status: true,  classeId: 'c1', numTel: '+216 11 222 333', adresse: '12 Rue de la Paix, Tunis',       dateDeNaissance: DateTime(2003, 5, 20),  dateInscription: DateTime(2022, 9, 1)),
    UserModel(id: 'u5',  nom: 'Davis',    prenom: 'Eva',    email: 'eva.davis@student.com',      role: 'etudiant',   sexe: 'Femme', status: false, classeId: 'c2', numTel: '+216 44 555 666', adresse: '5 Avenue Habib Bourguiba, Sfax', dateDeNaissance: DateTime(2004, 11, 3),  dateInscription: DateTime(2023, 9, 1)),
    UserModel(id: 'u6',  nom: 'Martinez', prenom: 'Frank',  email: 'frank.martinez@student.com', role: 'etudiant',   sexe: 'Homme', status: true,  classeId: 'c3', dateDeNaissance: DateTime(2002, 7, 14),  dateInscription: DateTime(2021, 9, 1)),
    UserModel(id: 'u7',  nom: 'Garcia',   prenom: 'Grace',  email: 'grace.garcia@student.com',   role: 'etudiant',   sexe: 'Femme', status: true,  classeId: 'c1', dateDeNaissance: DateTime(2003, 2, 28),  dateInscription: DateTime(2022, 9, 1)),
    UserModel(id: 'u8',  nom: 'Lee',      prenom: 'Henry',  email: 'henry.lee@student.com',      role: 'etudiant',   sexe: 'Homme', status: true,  classeId: 'c4', dateDeNaissance: DateTime(2004, 8, 10),  dateInscription: DateTime(2023, 9, 1)),
    UserModel(id: 'u9',  nom: 'Wilson',   prenom: 'Iris',   email: 'iris.wilson@student.com',    role: 'etudiant',   sexe: 'Femme', status: false, classeId: 'c2', dateDeNaissance: DateTime(2003, 12, 5),  dateInscription: DateTime(2022, 9, 1)),
    UserModel(id: 'u10', nom: 'Taylor',   prenom: 'Jack',   email: 'jack.taylor@student.com',    role: 'etudiant',   sexe: 'Homme', status: true,  classeId: 'c3', dateDeNaissance: DateTime(2002, 4, 17),  dateInscription: DateTime(2021, 9, 1)),
    UserModel(id: 'u11', nom: 'Anderson', prenom: 'Karen',  email: 'karen.anderson@student.com', role: 'etudiant',   sexe: 'Femme', status: true,  classeId: 'c4', dateDeNaissance: DateTime(2005, 1, 22),  dateInscription: DateTime(2023, 9, 1)),
    UserModel(id: 'u12', nom: 'Thomas',   prenom: 'Leo',    email: 'leo.thomas@student.com',     role: 'etudiant',   sexe: 'Homme', status: true,  classeId: 'c1', dateDeNaissance: DateTime(2003, 6, 9),   dateInscription: DateTime(2022, 9, 1)),
  ];
}

// ─────────────────────────────────────────────
// TOAST NOTIFICATION SYSTEM
// ─────────────────────────────────────────────

enum ToastType { success, error, warning, info }

class _ToastConfig {
  final Color bg, border, icon;
  final IconData iconData;
  final String prefix;
  const _ToastConfig({required this.bg, required this.border, required this.icon, required this.iconData, required this.prefix});
}

const _toastConfigs = {
  ToastType.success: _ToastConfig(bg: Color(0xFF0A1F18), border: Color(0xFF10B981), icon: kSuccess, iconData: Icons.check_circle_rounded, prefix: 'Success'),
  ToastType.error:   _ToastConfig(bg: Color(0xFF1F0A10), border: Color(0xFFF43F5E), icon: kError,   iconData: Icons.error_rounded,         prefix: 'Error'),
  ToastType.warning: _ToastConfig(bg: Color(0xFF1F160A), border: Color(0xFFF59E0B), icon: kWarning, iconData: Icons.warning_rounded,        prefix: 'Warning'),
  ToastType.info:    _ToastConfig(bg: Color(0xFF0A1020), border: Color(0xFF3B82F6), icon: kInfo,    iconData: Icons.info_rounded,           prefix: 'Info'),
};

class AppToast {
  static OverlayEntry? _current;

  static void show(BuildContext context, String message, {ToastType type = ToastType.success}) {
    _current?.remove();
    final cfg = _toastConfigs[type]!;

    _current = OverlayEntry(builder: (_) => _ToastWidget(message: message, config: cfg));
    Overlay.of(context).insert(_current!);

    Future.delayed(const Duration(milliseconds: 3200), () {
      _current?.remove();
      _current = null;
    });
  }
}

class _ToastWidget extends StatefulWidget {
  final String message;
  final _ToastConfig config;
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
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));

    _slide = Tween<double>(begin: -20, end: 0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic),
    );
    _fade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _ctrl, curve: const Interval(0, 0.6)),
    );
    _scale = Tween<double>(begin: 0.92, end: 1).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOutBack),
    );

    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cfg = widget.config;
    return Positioned(
      top: MediaQuery.of(context).padding.top + 12,
      left: 16,
      right: 16,
      child: Material(
        color: Colors.transparent,
        child: AnimatedBuilder(
          animation: _ctrl,
          builder: (_, child) => Transform.translate(
            offset: Offset(0, _slide.value),
            child: Opacity(
              opacity: _fade.value,
              child: Transform.scale(scale: _scale.value, child: child),
            ),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: cfg.bg,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: cfg.border.withOpacity(0.6), width: 1.5),
              boxShadow: [
                BoxShadow(color: cfg.border.withOpacity(0.2), blurRadius: 24, spreadRadius: -4),
                BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 16, offset: const Offset(0, 8)),
              ],
            ),
            child: Row(children: [
              // Animated icon container
              Container(
                width: 36, height: 36,
                decoration: BoxDecoration(
                  color: cfg.icon.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(cfg.iconData, color: cfg.icon, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                  Text(cfg.prefix, style: TextStyle(color: cfg.icon, fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
                  const SizedBox(height: 2),
                  Text(widget.message, style: const TextStyle(color: kTextPrimary, fontSize: 13, height: 1.3)),
                ]),
              ),
              // Progress bar / dismiss
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () { AppToast._current?.remove(); AppToast._current = null; },
                child: Container(
                  width: 24, height: 24,
                  decoration: BoxDecoration(color: cfg.border.withOpacity(0.12), borderRadius: BorderRadius.circular(6)),
                  child: Icon(Icons.close_rounded, size: 14, color: cfg.icon.withOpacity(0.7)),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// STAT COUNTER WIDGET (header summary cards)
// ─────────────────────────────────────────────

class _StatCard extends StatelessWidget {
  final String label;
  final int count;
  final Color color;
  final IconData icon;
  const _StatCard({required this.label, required this.count, required this.color, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.07),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.18)),
      ),
      child: Row(children: [
        Container(
          width: 36, height: 36,
          decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, size: 18, color: color),
        ),
        const SizedBox(width: 10),
        Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
          Text(
            '$count',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: color, height: 1.0),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(fontSize: 11, color: kTextMuted, fontWeight: FontWeight.w500),
          ),
        ]),
      ]),
    );
  }
}

// ─────────────────────────────────────────────
// APP ENTRY POINT
// ─────────────────────────────────────────────

void main() => runApp(const AdminUsersApp());

class AdminUsersApp extends StatelessWidget {
  const AdminUsersApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Admin Users',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: kBgBase,
        colorSchemeSeed: kIndigo,
        useMaterial3: true,
        fontFamily: 'SF Pro Display', dialogTheme: DialogThemeData(backgroundColor: kBgSurface),
      ),
      home: const AdminUsersScreen(),
    );
  }
}

// ─────────────────────────────────────────────
// MAIN SCREEN
// ─────────────────────────────────────────────

class AdminUsersScreen extends StatefulWidget {
  const AdminUsersScreen({super.key});
  @override
  State<AdminUsersScreen> createState() => _AdminUsersScreenState();
}

class _AdminUsersScreenState extends State<AdminUsersScreen> with TickerProviderStateMixin {
  late List<UserModel> _allUsers;
  late List<ClassModel> _allClasses;

  String _searchTerm  = '';
  String _roleFilter  = 'all';
  String _classFilter = 'all';
  int _currentPage  = 1;
  int _itemsPerPage = 10;

  final TextEditingController _searchCtrl = TextEditingController();
  final ScrollController _listScroll = ScrollController();
  bool _statsVisible = true;

  @override
  void initState() {
    super.initState();
    _allUsers   = List.from(MockDataService.mockUsers);
    _allClasses = MockDataService.mockClasses;
    _listScroll.addListener(_onScroll);
  }

  void _onScroll() {
    final shouldShow = _listScroll.offset <= 10;
    if (shouldShow != _statsVisible) {
      setState(() => _statsVisible = shouldShow);
    }
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _listScroll.removeListener(_onScroll);
    _listScroll.dispose();
    super.dispose();
  }

  // ── Stats ──
  int get _totalAdmins    => _allUsers.where((u) => u.role == 'admin').length;
  int get _totalTeachers  => _allUsers.where((u) => u.role == 'enseignant').length;
  int get _totalStudents  => _allUsers.where((u) => u.role == 'etudiant').length;
  int get _activeUsers    => _allUsers.where((u) => u.status).length;

  // ── Filtered / paginated ──
  List<UserModel> get _filtered {
    return _allUsers.where((u) {
      if (_roleFilter != 'all' && u.role != _roleFilter) return false;
      if (_roleFilter == 'etudiant' && _classFilter != 'all' && u.classeId != _classFilter) return false;
      if (_searchTerm.isNotEmpty) {
        final t = _searchTerm.toLowerCase();
        if (!u.fullName.toLowerCase().contains(t) && !u.email.toLowerCase().contains(t)) return false;
      }
      return true;
    }).toList();
  }

  int get _totalPages => (_filtered.length / _itemsPerPage).ceil().clamp(1, 9999);

  List<UserModel> get _pageUsers {
    final s = (_currentPage - 1) * _itemsPerPage;
    final e = (s + _itemsPerPage).clamp(0, _filtered.length);
    return _filtered.sublist(s, e);
  }

  // ── Helpers ──
  ClassModel? _classById(String? id) {
    if (id == null) return null;
    try { return _allClasses.firstWhere((c) => c.id == id); } catch (_) { return null; }
  }

  Color _roleColor(String r) {
    switch (r) {
      case 'admin':      return kRoleAdmin;
      case 'enseignant': return kRoleTeacher;
      case 'etudiant':   return kRoleStudent;
      default:           return kTextMuted;
    }
  }

  String _roleLabel(String r) {
    switch (r) {
      case 'admin':      return 'Admin';
      case 'enseignant': return 'Teacher';
      case 'etudiant':   return 'Student';
      default:           return r;
    }
  }

  IconData _roleIcon(String r) {
    switch (r) {
      case 'admin':      return Icons.shield_rounded;
      case 'enseignant': return Icons.auto_stories_rounded;
      case 'etudiant':   return Icons.person_rounded;
      default:           return Icons.person_rounded;
    }
  }

  String _fmt(DateTime? d) {
    if (d == null) return '—';
    const mo = ['','Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    return '${d.day.toString().padLeft(2,'0')} ${mo[d.month]} ${d.year}';
  }

  // ── CRUD ──
  void _delete(String id) {
    setState(() {
      _allUsers.removeWhere((u) => u.id == id);
      if (_currentPage > _totalPages) _currentPage = _totalPages;
    });
    AppToast.show(context, 'User removed from the system.', type: ToastType.success);
  }

  void _create(UserModel u) {
    setState(() => _allUsers.add(u));
    AppToast.show(context, '${u.fullName} has been created.', type: ToastType.success);
  }

  void _update(UserModel u) {
    setState(() {
      final i = _allUsers.indexWhere((x) => x.id == u.id);
      if (i != -1) _allUsers[i] = u;
    });
    AppToast.show(context, '${u.fullName} updated successfully.', type: ToastType.success);
  }

  // ── Dialogs ──
  void _openDetails(UserModel user) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _UserDetailsSheet(
        user: user,
        allClasses: _allClasses,
        roleColor: _roleColor,
        roleLabel: _roleLabel,
        roleIcon: _roleIcon,
        fmtDate: _fmt,
        onEdit:   () { Navigator.pop(context); _openForm(user); },
        onDelete: () { Navigator.pop(context); _confirmDelete(user); },
      ),
    );
  }

  void _openForm([UserModel? existing]) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.7),
      builder: (_) => _UserFormDialog(
        allClasses: _allClasses,
        existingUser: existing,
        onSubmit: existing == null ? _create : _update,
        onError: (msg) => AppToast.show(context, msg, type: ToastType.error),
      ),
    );
  }

  void _confirmDelete(UserModel user) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.7),
      builder: (_) => _DeleteDialog(
        user: user,
        onConfirm: () { Navigator.pop(context); _delete(user.id); },
      ),
    );
  }

  // ─────────────────────────────────────────────
  // BUILD
  // ─────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final filtered  = _filtered;
    final pageUsers = _pageUsers;
    final startNum  = filtered.isEmpty ? 0 : (_currentPage - 1) * _itemsPerPage + 1;
    final endNum    = filtered.isEmpty ? 0 : (startNum + pageUsers.length - 1).clamp(1, filtered.length);

    return Scaffold(
      backgroundColor: kBgBase,
      appBar: _buildAppBar(),
      body: Column(children: [
        // ── Stats row (hides on scroll) ──
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 250),
            opacity: _statsVisible ? 1.0 : 0.0,
            child: _statsVisible ? _buildStatsRow() : const SizedBox.shrink(),
          ),
        ),

        // ── Filters ──
        _buildFilters(startNum, endNum, filtered.length),

        Container(height: 1, color: kBorderSubtle),

        // ── List ──
        Expanded(
          child: pageUsers.isEmpty
              ? _buildEmptyState()
              : ListView.separated(
                  controller: _listScroll,
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                  itemCount: pageUsers.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 6),
                  itemBuilder: (_, i) {
                    final u = pageUsers[i];
                    return _UserTile(
                      user: u,
                      classLabel: _classById(u.classeId)?.shortLabel,
                      roleColor: _roleColor,
                      roleLabel: _roleLabel,
                      roleIcon: _roleIcon,
                      onTap:    () => _openDetails(u),
                      onEdit:   () => _openForm(u),
                      onDelete: () => _confirmDelete(u),
                    );
                  },
                ),
        ),

        // ── Pagination ──
        if (_totalPages > 1) _buildPagination(),
      ]),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
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
        const Text(
          'User Management',
          style: TextStyle(color: kTextPrimary, fontWeight: FontWeight.w700, fontSize: 17, letterSpacing: -0.2),
        ),
      ]),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 14, top: 8, bottom: 8),
          child: _PrimaryButton(
            label: 'Add User',
            icon: Icons.person_add_rounded,
            onTap: () => _openForm(),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsRow() {
    return Container(
      color: kBgSurface,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Column(children: [
        Row(children: [
          Expanded(child: _StatCard(label: 'Total Users', count: _allUsers.length, color: kIndigo,      icon: Icons.people_rounded)),
          const SizedBox(width: 8),
          Expanded(child: _StatCard(label: 'Active',      count: _activeUsers,     color: kSuccess,     icon: Icons.check_circle_rounded)),
        ]),
        const SizedBox(height: 8),
        Row(children: [
          Expanded(child: _StatCard(label: 'Teachers',    count: _totalTeachers,   color: kRoleTeacher, icon: Icons.auto_stories_rounded)),
          const SizedBox(width: 8),
          Expanded(child: _StatCard(label: 'Students',    count: _totalStudents,   color: kRoleStudent, icon: Icons.school_rounded)),
        ]),
      ]),
    );
  }

  Widget _buildFilters(int startNum, int endNum, int total) {
    return Container(
      color: kBgSurface,
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
      child: Column(children: [
        // Search
        _SearchField(controller: _searchCtrl, onChanged: (v) => setState(() { _searchTerm = v; _currentPage = 1; })),
        const SizedBox(height: 10),
        Row(children: [
          Expanded(child: _DropdownField(
            value: _roleFilter,
            items: const {'all': 'All Roles', 'admin': 'Admin', 'enseignant': 'Teacher', 'etudiant': 'Student'},
            onChanged: (v) => setState(() { _roleFilter = v!; _classFilter = 'all'; _currentPage = 1; }),
            prefixIcon: Icons.tune_rounded,
          )),
          if (_roleFilter == 'etudiant') ...[
            const SizedBox(width: 8),
            Expanded(child: _DropdownField(
              value: _classFilter,
              items: {'all': 'All Classes', for (final c in _allClasses) c.id: c.shortLabel},
              onChanged: (v) => setState(() { _classFilter = v!; _currentPage = 1; }),
              prefixIcon: Icons.class_rounded,
            )),
          ],
        ]),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              total == 0 ? 'No results' : 'Showing $startNum–$endNum of $total users',
              style: const TextStyle(fontSize: 11, color: kTextMuted),
            ),
            Row(children: [
              const Text('Per page:', style: TextStyle(fontSize: 11, color: kTextMuted)),
              const SizedBox(width: 6),
              _CompactDropdown(
                value: _itemsPerPage,
                items: [5, 10, 20, 50],
                onChanged: (v) => setState(() { _itemsPerPage = v!; _currentPage = 1; }),
              ),
            ]),
          ],
        ),
      ]),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(
          width: 72, height: 72,
          decoration: BoxDecoration(
            color: kBgHighlight,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: kBorderMid),
          ),
          child: const Icon(Icons.search_off_rounded, size: 32, color: kTextMuted),
        ),
        const SizedBox(height: 16),
        const Text('No users found', style: TextStyle(color: kTextPrimary, fontSize: 16, fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        const Text('Try adjusting your filters or search term', style: TextStyle(color: kTextMuted, fontSize: 13)),
      ]),
    );
  }

  Widget _buildPagination() {
    return Container(
      decoration: const BoxDecoration(color: kBgSurface, border: Border(top: BorderSide(color: kBorderSubtle))),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: _PaginationBar(
        currentPage: _currentPage,
        totalPages: _totalPages,
        onPageChanged: (p) => setState(() => _currentPage = p),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// WIDGET: User List Tile
// ─────────────────────────────────────────────

class _UserTile extends StatefulWidget {
  final UserModel user;
  final String? classLabel;
  final Color Function(String) roleColor;
  final String Function(String) roleLabel;
  final IconData Function(String) roleIcon;
  final VoidCallback onTap, onEdit, onDelete;

  const _UserTile({
    required this.user,
    required this.classLabel,
    required this.roleColor,
    required this.roleLabel,
    required this.roleIcon,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  State<_UserTile> createState() => _UserTileState();
}

class _UserTileState extends State<_UserTile> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final rc = widget.roleColor(widget.user.role);
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        decoration: BoxDecoration(
          color: _hovered ? kBgHighlight : kBgSurface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _hovered ? kBorderMid : kBorderSubtle),
          boxShadow: _hovered ? [BoxShadow(color: kIndigo.withOpacity(0.06), blurRadius: 12, offset: const Offset(0, 4))] : [],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(12),
            splashColor: kIndigo.withOpacity(0.06),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
              child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                // Colored left accent line
                Container(width: 3, height: 54, decoration: BoxDecoration(color: rc, borderRadius: BorderRadius.circular(2))),
                const SizedBox(width: 12),
                // Avatar
                _Avatar(user: widget.user, size: 42, roleColor: rc),
                const SizedBox(width: 12),
                // Name + email — takes all available space
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(
                      widget.user.fullName,
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: kTextPrimary, letterSpacing: -0.1),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      widget.user.email,
                      style: const TextStyle(fontSize: 11, color: kTextSecond),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 7),
                    // Badges row below name
                    Wrap(spacing: 5, runSpacing: 4, children: [
                      _RoleBadge(label: widget.roleLabel(widget.user.role), color: rc, icon: widget.roleIcon(widget.user.role)),
                      if (widget.user.role == 'etudiant' && widget.classLabel != null)
                        _Tag(label: widget.classLabel!, color: kTextMuted),
                      _StatusBadge(active: widget.user.status),
                    ]),
                  ]),
                ),
                const SizedBox(width: 8),
                // Action buttons — fixed on the right
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  _ActionButton(icon: Icons.edit_outlined,  color: kInfo,  onTap: widget.onEdit,   tooltip: 'Edit'),
                  const SizedBox(height: 6),
                  _ActionButton(icon: Icons.delete_outline, color: kError, onTap: widget.onDelete, tooltip: 'Delete'),
                ]),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// WIDGET: User Details Bottom Sheet
// ─────────────────────────────────────────────

class _UserDetailsSheet extends StatelessWidget {
  final UserModel user;
  final List<ClassModel> allClasses;
  final Color Function(String) roleColor;
  final String Function(String) roleLabel;
  final IconData Function(String) roleIcon;
  final String Function(DateTime?) fmtDate;
  final VoidCallback onEdit, onDelete;

  const _UserDetailsSheet({
    required this.user, required this.allClasses, required this.roleColor,
    required this.roleLabel, required this.roleIcon, required this.fmtDate,
    required this.onEdit, required this.onDelete,
  });

  String _classLabel(String? id) {
    if (id == null) return '—';
    try { return allClasses.firstWhere((c) => c.id == id).label; } catch (_) { return id; }
  }

  @override
  Widget build(BuildContext context) {
    final rc = roleColor(user.role);
    final rl = roleLabel(user.role);
    final ri = roleIcon(user.role);

    return DraggableScrollableSheet(
      initialChildSize: 0.70,
      maxChildSize: 0.95,
      minChildSize: 0.4,
      builder: (_, sc) => Container(
        decoration: BoxDecoration(
          color: kBgSurface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border: const Border(
            top:   BorderSide(color: kBorderMid),
            left:  BorderSide(color: kBorderMid),
            right: BorderSide(color: kBorderMid),
          ),
        ),
        child: Column(children: [
          // Handle
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 4),
            child: Container(width: 36, height: 4, decoration: BoxDecoration(color: kBorderMid, borderRadius: BorderRadius.circular(2))),
          ),
          // Hero header
          Container(
            margin: const EdgeInsets.fromLTRB(16, 6, 16, 0),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [rc.withOpacity(0.12), kBgElevated],
                begin: Alignment.topLeft, end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: rc.withOpacity(0.25)),
            ),
            child: Row(children: [
              _Avatar(user: user, size: 62, roleColor: rc),
              const SizedBox(width: 16),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(user.fullName, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: kTextPrimary, letterSpacing: -0.3)),
                const SizedBox(height: 4),
                Text(user.email, style: const TextStyle(fontSize: 12, color: kTextSecond), overflow: TextOverflow.ellipsis),
                const SizedBox(height: 10),
                Wrap(spacing: 6, runSpacing: 6, children: [
                  _RoleBadge(label: rl, color: rc, icon: ri),
                  _StatusBadge(active: user.status),
                  _Tag(label: user.sexe == 'Homme' ? 'Male' : 'Female', color: kTextMuted),
                ]),
              ])),
            ]),
          ),
          // Body
          Expanded(
            child: ListView(
              controller: sc,
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
              children: [
                // Student
                if (user.role == 'etudiant') _DetailSection(
                  title: 'Student Details', icon: Icons.school_rounded, color: kRoleStudent,
                  children: [
                    _DetailGrid(items: [
                      _DetailItem(Icons.class_rounded,          'Class',         _classLabel(user.classeId)),
                      _DetailItem(Icons.phone_rounded,          'Phone',         user.numTel ?? '—'),
                      _DetailItem(Icons.cake_rounded,           'Date of Birth', fmtDate(user.dateDeNaissance)),
                      _DetailItem(Icons.calendar_month_rounded, 'Enrolled',      fmtDate(user.dateInscription)),
                    ]),
                    if (user.adresse != null) ...[
                      const SizedBox(height: 8),
                      _DetailItem(Icons.location_on_rounded, 'Address', user.adresse!, fullWidth: true),
                    ],
                  ],
                ),

                // Teacher
                if (user.role == 'enseignant') _DetailSection(
                  title: 'Teacher Details', icon: Icons.auto_stories_rounded, color: kRoleTeacher,
                  children: [
                    _DetailGrid(items: [
                      _DetailItem(Icons.auto_awesome_rounded,   'Specialty', user.specialite ?? '—'),
                      _DetailItem(Icons.phone_rounded,          'Phone',     user.numTelEnseignant ?? '—'),
                      _DetailItem(Icons.calendar_month_rounded, 'Hire Date', fmtDate(user.dateEmbauche), fullWidth: true),
                    ]),
                    if (user.classes.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      _SectionLabel(icon: Icons.class_rounded, label: 'Assigned Classes'),
                      const SizedBox(height: 8),
                      Wrap(spacing: 6, runSpacing: 6, children: user.classes.map((cid) {
                        final c = _classByIdLocal(cid);
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: kRoleTeacher.withOpacity(0.1),
                            border: Border.all(color: kRoleTeacher.withOpacity(0.3)),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(c?.shortLabel ?? cid, style: const TextStyle(fontSize: 11, color: kRoleTeacher, fontWeight: FontWeight.w600)),
                        );
                      }).toList()),
                    ],
                  ],
                ),

                // Admin
                if (user.role == 'admin') _DetailSection(
                  title: 'Admin Details', icon: Icons.shield_rounded, color: kRoleAdmin,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: kRoleAdmin.withOpacity(0.06),
                        border: Border.all(color: kRoleAdmin.withOpacity(0.2)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(children: [
                        Icon(Icons.security_rounded, size: 18, color: kRoleAdmin.withOpacity(0.8)),
                        const SizedBox(width: 10),
                        const Expanded(child: Text('Full system administrator privileges.', style: TextStyle(fontSize: 13, color: kTextSecond, height: 1.4))),
                      ]),
                    ),
                    if (user.adminCode != null && user.adminCode!.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      _DetailItem(Icons.key_rounded, 'Admin Code', user.adminCode!, fullWidth: true),
                    ],
                  ],
                ),

                const SizedBox(height: 8),
                // Actions
                Row(children: [
                  Expanded(
                    child: _OutlineButton(label: 'Delete', icon: Icons.delete_outline, color: kError, onTap: onDelete),
                  ),
                  const SizedBox(width: 10),
                  Expanded(flex: 2, child: _PrimaryButton(label: 'Edit User', icon: Icons.edit_outlined, onTap: onEdit, height: 44)),
                ]),
              ],
            ),
          ),
        ]),
      ),
    );
  }

  ClassModel? _classByIdLocal(String id) {
    try { return allClasses.firstWhere((c) => c.id == id); } catch (_) { return null; }
  }
}

// Detail Section Card
class _DetailSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final List<Widget> children;
  const _DetailSection({required this.title, required this.icon, required this.color, required this.children});

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: kBgElevated,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: kBorderSubtle),
    ),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Container(
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(9)),
          child: Icon(icon, size: 15, color: color),
        ),
        const SizedBox(width: 10),
        Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: kTextPrimary)),
      ]),
      const SizedBox(height: 14),
      Container(height: 1, color: kBorderSubtle),
      const SizedBox(height: 12),
      ...children,
    ]),
  );
}

class _SectionLabel extends StatelessWidget {
  final IconData icon;
  final String label;
  const _SectionLabel({required this.icon, required this.label});
  @override
  Widget build(BuildContext context) => Row(children: [
    Icon(icon, size: 13, color: kTextMuted),
    const SizedBox(width: 6),
    Text(label, style: const TextStyle(fontSize: 12, color: kTextMuted, fontWeight: FontWeight.w600)),
  ]);
}

class _DetailGrid extends StatelessWidget {
  final List<_DetailItem> items;
  const _DetailGrid({required this.items});

  @override
  Widget build(BuildContext context) {
    final regular   = items.where((i) => !i.fullWidth).toList();
    final fullWidth = items.where((i) => i.fullWidth).toList();
    final rows = <Widget>[];
    for (int i = 0; i < regular.length; i += 2) {
      rows.add(Row(children: [
        Expanded(child: regular[i]),
        const SizedBox(width: 8),
        Expanded(child: i + 1 < regular.length ? regular[i + 1] : const SizedBox.shrink()),
      ]));
      if (i + 2 < regular.length) rows.add(const SizedBox(height: 8));
    }
    for (final fw in fullWidth) {
      if (rows.isNotEmpty) rows.add(const SizedBox(height: 8));
      rows.add(fw);
    }
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: rows);
  }
}

class _DetailItem extends StatelessWidget {
  final IconData icon;
  final String label, value;
  final bool fullWidth;
  const _DetailItem(this.icon, this.label, this.value, {this.fullWidth = false});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(color: kBgSurface, borderRadius: BorderRadius.circular(10), border: Border.all(color: kBorderSubtle)),
    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(color: kIndigo.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
        child: Icon(icon, size: 12, color: kIndigo),
      ),
      const SizedBox(width: 8),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: const TextStyle(fontSize: 10, color: kTextMuted, fontWeight: FontWeight.w500, letterSpacing: 0.3)),
        const SizedBox(height: 3),
        Text(value, style: const TextStyle(fontSize: 13, color: kTextPrimary, fontWeight: FontWeight.w500), maxLines: 2, overflow: TextOverflow.ellipsis),
      ])),
    ]),
  );
}

// ─────────────────────────────────────────────
// WIDGET: Delete Confirmation Dialog
// ─────────────────────────────────────────────

class _DeleteDialog extends StatefulWidget {
  final UserModel user;
  final VoidCallback onConfirm;
  const _DeleteDialog({required this.user, required this.onConfirm});
  @override
  State<_DeleteDialog> createState() => _DeleteDialogState();
}

class _DeleteDialogState extends State<_DeleteDialog> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale, _fade;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    _scale = Tween<double>(begin: 0.88, end: 1).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutBack));
    _fade  = Tween<double>(begin: 0,    end: 1).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
    _ctrl.forward();
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, child) => Transform.scale(
        scale: _scale.value,
        child: Opacity(opacity: _fade.value, child: child),
      ),
      child: Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          width: 360,
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: kBgSurface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: kError.withOpacity(0.25)),
            boxShadow: [
              BoxShadow(color: kError.withOpacity(0.08), blurRadius: 40, spreadRadius: -4),
              BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 24),
            ],
          ),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            // Icon
            Container(
              width: 64, height: 64,
              decoration: BoxDecoration(
                color: kError.withOpacity(0.1),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: kError.withOpacity(0.25)),
              ),
              child: const Icon(Icons.delete_forever_rounded, color: kError, size: 30),
            ),
            const SizedBox(height: 20),
            const Text('Delete User', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: kTextPrimary, letterSpacing: -0.3)),
            const SizedBox(height: 10),
            Text(
              'This will permanently remove ${widget.user.fullName} from the system. This action cannot be undone.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, color: kTextSecond, height: 1.6),
            ),
            // User preview chip
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: kBgElevated,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: kBorderMid),
              ),
              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                _Avatar(user: widget.user, size: 28, roleColor: kError),
                const SizedBox(width: 10),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(widget.user.fullName, style: const TextStyle(fontSize: 13, color: kTextPrimary, fontWeight: FontWeight.w600)),
                  Text(widget.user.email,    style: const TextStyle(fontSize: 11, color: kTextMuted)),
                ]),
              ]),
            ),
            const SizedBox(height: 24),
            Row(children: [
              Expanded(
                child: _OutlineButton(label: 'Cancel', icon: Icons.close_rounded, color: kTextMuted, onTap: () => Navigator.pop(context)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: kError,
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: widget.onConfirm,
                  icon: const Icon(Icons.delete_rounded, size: 16),
                  label: const Text('Delete', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                ),
              ),
            ]),
          ]),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// WIDGET: Create / Edit Form Dialog
// ─────────────────────────────────────────────

class _UserFormDialog extends StatefulWidget {
  final List<ClassModel> allClasses;
  final UserModel? existingUser;
  final Function(UserModel) onSubmit;
  final Function(String) onError;

  const _UserFormDialog({required this.allClasses, this.existingUser, required this.onSubmit, required this.onError});

  @override
  State<_UserFormDialog> createState() => _UserFormDialogState();
}

class _UserFormDialogState extends State<_UserFormDialog> {
  bool get _isEdit => widget.existingUser != null;
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nomCtrl, _prenomCtrl, _emailCtrl, _passwordCtrl;
  late TextEditingController _numTelCtrl, _adresseCtrl, _specialiteCtrl, _numTelEnsCtrl, _adminCodeCtrl;

  late String _role, _sexe;
  String? _classeId;
  List<String> _selClasses = [];
  DateTime? _dob, _dIns, _dEmb;
  bool _showPwd = false;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    final u = widget.existingUser;
    _nomCtrl        = TextEditingController(text: u?.nom ?? '');
    _prenomCtrl     = TextEditingController(text: u?.prenom ?? '');
    _emailCtrl      = TextEditingController(text: u?.email ?? '');
    _passwordCtrl   = TextEditingController();
    _numTelCtrl     = TextEditingController(text: u?.numTel ?? '');
    _adresseCtrl    = TextEditingController(text: u?.adresse ?? '');
    _specialiteCtrl = TextEditingController(text: u?.specialite ?? '');
    _numTelEnsCtrl  = TextEditingController(text: u?.numTelEnseignant ?? '');
    _adminCodeCtrl  = TextEditingController(text: u?.adminCode ?? '');
    _role       = u?.role ?? 'etudiant';
    _sexe       = u?.sexe ?? 'Homme';
    _classeId   = u?.classeId;
    _selClasses = List.from(u?.classes ?? []);
    _dob  = u?.dateDeNaissance;
    _dIns = u?.dateInscription;
    _dEmb = u?.dateEmbauche;
  }

  @override
  void dispose() {
    for (final c in [_nomCtrl, _prenomCtrl, _emailCtrl, _passwordCtrl, _numTelCtrl, _adresseCtrl, _specialiteCtrl, _numTelEnsCtrl, _adminCodeCtrl]) {
      c.dispose();
    }
    super.dispose();
  }

  void _changeRole(String r) {
    setState(() {
      _role = r; _classeId = null; _selClasses = [];
      _dob = null; _dIns = null; _dEmb = null;
      for (final c in [_numTelCtrl, _adresseCtrl, _specialiteCtrl, _numTelEnsCtrl, _adminCodeCtrl]) {
        c.clear();
      }
    });
  }

  void _toggleClass(String id) => setState(() {
    _selClasses.contains(id) ? _selClasses.remove(id) : _selClasses.add(id);
  });

  Future<void> _pickDate(DateTime? init, ValueChanged<DateTime> onPick) async {
    final d = await showDatePicker(
      context: context,
      initialDate: init ?? DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.dark(primary: kIndigo, surface: kBgSurface, onSurface: kTextPrimary), dialogTheme: DialogThemeData(backgroundColor: kBgSurface),
        ),
        child: child!,
      ),
    );
    if (d != null) onPick(d);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      widget.onError('Please fix the errors in the form.');
      return;
    }
    setState(() => _submitting = true);
    await Future.delayed(const Duration(milliseconds: 300)); // simulate async

    final id = _isEdit ? widget.existingUser!.id : 'u_${DateTime.now().millisecondsSinceEpoch}';
    final user = UserModel(
      id: id,
      nom: _nomCtrl.text.trim(),
      prenom: _prenomCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      role: _role, sexe: _sexe,
      status: _isEdit ? widget.existingUser!.status : true,
      numTel: _role == 'etudiant' && _numTelCtrl.text.trim().isNotEmpty ? _numTelCtrl.text.trim() : null,
      adresse: _role == 'etudiant' && _adresseCtrl.text.trim().isNotEmpty ? _adresseCtrl.text.trim() : null,
      dateDeNaissance: _dob,
      classeId: _role == 'etudiant' ? _classeId : null,
      dateInscription: _role == 'etudiant' ? _dIns : null,
      specialite: _role == 'enseignant' ? _specialiteCtrl.text.trim() : null,
      dateEmbauche: _role == 'enseignant' ? _dEmb : null,
      numTelEnseignant: _role == 'enseignant' && _numTelEnsCtrl.text.trim().isNotEmpty ? _numTelEnsCtrl.text.trim() : null,
      classes: _role == 'enseignant' ? List.from(_selClasses) : [],
      adminCode: _role == 'admin' && _adminCodeCtrl.text.trim().isNotEmpty ? _adminCodeCtrl.text.trim() : null,
    );

    if (mounted) Navigator.pop(context);
    widget.onSubmit(user);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 520, maxHeight: 700),
        decoration: BoxDecoration(
          color: kBgSurface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: kBorderMid),
          boxShadow: [
            BoxShadow(color: kIndigo.withOpacity(0.1), blurRadius: 40, spreadRadius: -8),
            BoxShadow(color: Colors.black.withOpacity(0.6), blurRadius: 32),
          ],
        ),
        child: Column(children: [
          // Header
          Container(
            padding: const EdgeInsets.fromLTRB(20, 16, 12, 16),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: kBorderSubtle)),
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Row(children: [
              Container(
                width: 32, height: 32,
                decoration: BoxDecoration(gradient: kBrandGrad, borderRadius: BorderRadius.circular(9)),
                child: Icon(_isEdit ? Icons.edit_rounded : Icons.person_add_rounded, color: Colors.white, size: 16),
              ),
              const SizedBox(width: 10),
              Text(_isEdit ? 'Update User' : 'Create User', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: kTextPrimary, letterSpacing: -0.2)),
              const Spacer(),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close_rounded, size: 20, color: kTextMuted),
                style: IconButton.styleFrom(
                  backgroundColor: kBgHighlight,
                  minimumSize: const Size(32, 32),
                  padding: EdgeInsets.zero,
                ),
              ),
            ]),
          ),

          // Form body
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                  _FormSection('Basic Information', icon: Icons.person_outline_rounded),
                  const SizedBox(height: 12),

                  Row(children: [
                    Expanded(child: _Field(label: 'First Name', ctrl: _prenomCtrl, hint: 'John', required: true, validator: (v) => v!.trim().isEmpty ? 'Required' : null)),
                    const SizedBox(width: 10),
                    Expanded(child: _Field(label: 'Last Name',  ctrl: _nomCtrl,   hint: 'Doe',  required: true, validator: (v) => v!.trim().isEmpty ? 'Required' : null)),
                  ]),
                  const SizedBox(height: 12),
                  _Field(
                    label: 'Email Address', ctrl: _emailCtrl, hint: 'john.doe@example.com',
                    required: true, keyboard: TextInputType.emailAddress,
                    validator: (v) {
                      if (v!.trim().isEmpty) return 'Email is required';
                      if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(v)) return 'Invalid email format';
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  // Password
                  _FieldLabel('Password', required: !_isEdit, note: _isEdit ? 'Leave blank to keep current' : null),
                  const SizedBox(height: 4),
                  TextFormField(
                    controller: _passwordCtrl,
                    obscureText: !_showPwd,
                    style: const TextStyle(fontSize: 13, color: kTextPrimary),
                    decoration: _fieldDeco(
                      hint: '••••••••',
                      suffix: IconButton(
                        onPressed: () => setState(() => _showPwd = !_showPwd),
                        icon: Icon(_showPwd ? Icons.visibility_off_outlined : Icons.visibility_outlined, size: 18, color: kTextMuted),
                      ),
                    ),
                    validator: (v) {
                      if (!_isEdit && (v == null || v.isEmpty)) return 'Password is required';
                      if (v != null && v.isNotEmpty && !RegExp(r'^(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{8,}$').hasMatch(v)) {
                        return 'Min 8 chars with uppercase, lowercase & number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  Row(children: [
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      const _FieldLabel('Role', required: true),
                      const SizedBox(height: 4),
                      _DropdownField(
                        value: _role,
                        items: const {'etudiant': 'Student', 'enseignant': 'Teacher', 'admin': 'Admin'},
                        onChanged: (v) => _changeRole(v!),
                        prefixIcon: Icons.badge_rounded,
                      ),
                    ])),
                    const SizedBox(width: 10),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      const _FieldLabel('Gender', required: true),
                      const SizedBox(height: 4),
                      _DropdownField(
                        value: _sexe,
                        items: const {'Homme': 'Male', 'Femme': 'Female'},
                        onChanged: (v) => setState(() => _sexe = v!),
                        prefixIcon: Icons.wc_rounded,
                      ),
                    ])),
                  ]),

                  // Student
                  if (_role == 'etudiant') ...[
                    const SizedBox(height: 20),
                    _FormSection('Student Information', icon: Icons.school_rounded, color: kRoleStudent),
                    const SizedBox(height: 12),
                    const _FieldLabel('Class', required: true),
                    const SizedBox(height: 4),
                    DropdownButtonFormField<String>(
                      initialValue: _classeId,
                      dropdownColor: kBgElevated,
                      style: const TextStyle(fontSize: 13, color: kTextPrimary),
                      decoration: _fieldDeco(hint: 'Select class'),
                      hint: const Text('Select a class', style: TextStyle(fontSize: 13, color: kTextMuted)),
                      items: widget.allClasses.map((c) => DropdownMenuItem(value: c.id, child: Text(c.label, style: const TextStyle(fontSize: 13)))).toList(),
                      onChanged: (v) => setState(() => _classeId = v),
                      validator: (v) => v == null ? 'Please select a class' : null,
                    ),
                    const SizedBox(height: 12),
                    Row(children: [
                      Expanded(child: _Field(label: 'Phone', ctrl: _numTelCtrl, hint: '+216 XX XXX XXX', keyboard: TextInputType.phone)),
                      const SizedBox(width: 10),
                      Expanded(child: _DatePicker(label: 'Date of Birth', date: _dob, onTap: () => _pickDate(_dob, (d) => setState(() => _dob = d)))),
                    ]),
                    const SizedBox(height: 12),
                    _Field(label: 'Address', ctrl: _adresseCtrl, hint: '123 Main St, City'),
                    const SizedBox(height: 12),
                    _DatePicker(label: 'Enrollment Date', date: _dIns, onTap: () => _pickDate(_dIns, (d) => setState(() => _dIns = d))),
                  ],

                  // Teacher
                  if (_role == 'enseignant') ...[
                    const SizedBox(height: 20),
                    _FormSection('Teacher Information', icon: Icons.auto_stories_rounded, color: kRoleTeacher),
                    const SizedBox(height: 12),
                    _Field(label: 'Specialty', ctrl: _specialiteCtrl, hint: 'e.g. Mathematics, Physics', required: true, validator: (v) => v!.trim().isEmpty ? 'Required' : null),
                    const SizedBox(height: 12),
                    Row(children: [
                      Expanded(child: _Field(label: 'Phone', ctrl: _numTelEnsCtrl, hint: '+216 XX XXX XXX', keyboard: TextInputType.phone)),
                      const SizedBox(width: 10),
                      Expanded(child: _DatePicker(label: 'Hire Date', date: _dEmb, onTap: () => _pickDate(_dEmb, (d) => setState(() => _dEmb = d)))),
                    ]),
                    const SizedBox(height: 12),
                    const _FieldLabel('Assigned Classes'),
                    const SizedBox(height: 4),
                    Container(
                      decoration: BoxDecoration(color: kBgElevated, border: Border.all(color: kBorderMid), borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        children: widget.allClasses.map((c) {
                          final selected = _selClasses.contains(c.id);
                          return InkWell(
                            onTap: () => _toggleClass(c.id),
                            borderRadius: BorderRadius.circular(10),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              child: Row(children: [
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 150),
                                  width: 18, height: 18,
                                  decoration: BoxDecoration(
                                    color: selected ? kIndigo : Colors.transparent,
                                    border: Border.all(color: selected ? kIndigo : kBorderMid, width: 1.5),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: selected ? const Icon(Icons.check_rounded, size: 12, color: Colors.white) : null,
                                ),
                                const SizedBox(width: 10),
                                Expanded(child: Text(c.label, style: const TextStyle(fontSize: 12, color: kTextPrimary))),
                              ]),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],

                  // Admin
                  if (_role == 'admin') ...[
                    const SizedBox(height: 20),
                    _FormSection('Admin Information', icon: Icons.shield_rounded, color: kRoleAdmin),
                    const SizedBox(height: 12),
                    _Field(label: 'Admin Code', ctrl: _adminCodeCtrl, hint: 'e.g. ADM-001'),
                  ],
                ]),
              ),
            ),
          ),

          // Footer
          Container(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
            decoration: const BoxDecoration(border: Border(top: BorderSide(color: kBorderSubtle))),
            child: Row(children: [
              Expanded(
                child: _OutlineButton(label: 'Cancel', icon: Icons.close_rounded, color: kTextMuted, onTap: () => Navigator.pop(context)),
              ),
              const SizedBox(width: 10),
              Expanded(flex: 2, child: _PrimaryButton(
                label: _submitting ? 'Saving…' : (_isEdit ? 'Update User' : 'Create User'),
                icon: _isEdit ? Icons.save_rounded : Icons.person_add_rounded,
                onTap: _submitting ? () {} : _submit,
                height: 46,
              )),
            ]),
          ),
        ]),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// FORM HELPERS
// ─────────────────────────────────────────────

InputDecoration _fieldDeco({String? hint, Widget? suffix, Widget? prefix}) => InputDecoration(
  hintText: hint,
  hintStyle: const TextStyle(color: kTextDisabled, fontSize: 13),
  prefixIcon: prefix,
  suffixIcon: suffix,
  filled: true,
  fillColor: kBgElevated,
  isDense: true,
  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
  border:             OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: kBorderMid)),
  enabledBorder:      OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: kBorderMid)),
  focusedBorder:      OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: kIndigo, width: 1.5)),
  errorBorder:        OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: kError)),
  focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: kError, width: 1.5)),
  errorStyle: const TextStyle(fontSize: 11, color: kError, height: 1.2),
);

class _FormSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  const _FormSection(this.title, {required this.icon, this.color = kIndigo});

  @override
  Widget build(BuildContext context) => Row(children: [
    Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(7)),
      child: Icon(icon, size: 14, color: color),
    ),
    const SizedBox(width: 8),
    Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: kTextPrimary, letterSpacing: -0.1)),
    const SizedBox(width: 10),
    Expanded(child: Container(height: 1, color: kBorderSubtle)),
  ]);
}

class _FieldLabel extends StatelessWidget {
  final String text;
  final bool required;
  final String? note;
  const _FieldLabel(this.text, {this.required = false, this.note});

  @override
  Widget build(BuildContext context) => Row(children: [
    Text(text, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: kTextSecond)),
    if (required) const Text(' *', style: TextStyle(fontSize: 12, color: kError, fontWeight: FontWeight.w600)),
    if (note != null) ...[
      const SizedBox(width: 6),
      Text('($note)', style: const TextStyle(fontSize: 11, color: kTextMuted)),
    ],
  ]);
}

class _Field extends StatelessWidget {
  final String label;
  final TextEditingController ctrl;
  final String? hint;
  final TextInputType? keyboard;
  final bool required;
  final String? Function(String?)? validator;

  const _Field({required this.label, required this.ctrl, this.hint, this.keyboard, this.required = false, this.validator});

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _FieldLabel(label, required: required),
      const SizedBox(height: 5),
      TextFormField(
        controller: ctrl,
        keyboardType: keyboard,
        validator: validator,
        style: const TextStyle(fontSize: 13, color: kTextPrimary),
        decoration: _fieldDeco(hint: hint),
      ),
    ],
  );
}

class _DropdownField extends StatelessWidget {
  final String value;
  final Map<String, String> items;
  final ValueChanged<String?> onChanged;
  final IconData? prefixIcon;

  const _DropdownField({required this.value, required this.items, required this.onChanged, this.prefixIcon});

  @override
  Widget build(BuildContext context) => Container(
    height: 42,
    padding: const EdgeInsets.symmetric(horizontal: 10),
    decoration: BoxDecoration(
      color: kBgElevated,
      border: Border.all(color: kBorderMid),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Row(children: [
      if (prefixIcon != null) ...[Icon(prefixIcon, size: 16, color: kTextMuted), const SizedBox(width: 6)],
      Expanded(
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: value,
            isExpanded: true,
            dropdownColor: kBgElevated,
            style: const TextStyle(fontSize: 13, color: kTextPrimary),
            icon: const Icon(Icons.keyboard_arrow_down_rounded, color: kTextMuted, size: 18),
            items: items.entries.map((e) => DropdownMenuItem(value: e.key, child: Text(e.value))).toList(),
            onChanged: onChanged,
          ),
        ),
      ),
    ]),
  );
}

class _DatePicker extends StatelessWidget {
  final String label;
  final DateTime? date;
  final VoidCallback onTap;
  const _DatePicker({required this.label, required this.date, required this.onTap});

  String _fmt(DateTime d) {
    const mo = ['','Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    return '${d.day.toString().padLeft(2,'0')} ${mo[d.month]} ${d.year}';
  }

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _FieldLabel(label),
      const SizedBox(height: 5),
      GestureDetector(
        onTap: onTap,
        child: Container(
          height: 42,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: kBgElevated,
            border: Border.all(color: kBorderMid),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(children: [
            const Icon(Icons.calendar_today_rounded, size: 15, color: kTextMuted),
            const SizedBox(width: 8),
            Expanded(child: Text(
              date != null ? _fmt(date!) : 'Pick a date',
              style: TextStyle(fontSize: 13, color: date != null ? kTextPrimary : kTextMuted),
            )),
            if (date != null) const Icon(Icons.close_rounded, size: 14, color: kTextMuted),
          ]),
        ),
      ),
    ],
  );
}

// Compact perpage dropdown
class _CompactDropdown extends StatelessWidget {
  final int value;
  final List<int> items;
  final ValueChanged<int?> onChanged;
  const _CompactDropdown({required this.value, required this.items, required this.onChanged});

  @override
  Widget build(BuildContext context) => Container(
    height: 28,
    padding: const EdgeInsets.symmetric(horizontal: 8),
    decoration: BoxDecoration(color: kBgElevated, border: Border.all(color: kBorderMid), borderRadius: BorderRadius.circular(6)),
    child: DropdownButtonHideUnderline(
      child: DropdownButton<int>(
        value: value,
        isDense: true,
        dropdownColor: kBgElevated,
        style: const TextStyle(fontSize: 12, color: kTextPrimary),
        icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 14, color: kTextMuted),
        items: items.map((n) => DropdownMenuItem(value: n, child: Text('$n'))).toList(),
        onChanged: onChanged,
      ),
    ),
  );
}

// Search field
class _SearchField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  const _SearchField({required this.controller, required this.onChanged});

  @override
  Widget build(BuildContext context) => TextField(
    controller: controller,
    onChanged: onChanged,
    style: const TextStyle(fontSize: 14, color: kTextPrimary),
    decoration: InputDecoration(
      hintText: 'Search by name or email…',
      hintStyle: const TextStyle(color: kTextMuted, fontSize: 13),
      prefixIcon: const Icon(Icons.search_rounded, size: 20, color: kTextMuted),
      filled: true,
      fillColor: kBgElevated,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(vertical: 12),
      border:        OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: kBorderMid)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: kBorderMid)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: kIndigo, width: 1.5)),
    ),
  );
}

// ─────────────────────────────────────────────
// PAGINATION
// ─────────────────────────────────────────────

class _PaginationBar extends StatelessWidget {
  final int currentPage, totalPages;
  final ValueChanged<int> onPageChanged;
  const _PaginationBar({required this.currentPage, required this.totalPages, required this.onPageChanged});

  List<dynamic> get _pages {
    if (totalPages <= 5) return List.generate(totalPages, (i) => i + 1);
    if (currentPage <= 3) return [1, 2, 3, 4, '...', totalPages];
    if (currentPage >= totalPages - 2) return [1, '...', totalPages-3, totalPages-2, totalPages-1, totalPages];
    return [1, '...', currentPage-1, currentPage, currentPage+1, '...', totalPages];
  }

  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      _PgBtn(icon: Icons.first_page_rounded,    onTap: currentPage > 1 ? () => onPageChanged(1) : null),
      _PgBtn(icon: Icons.chevron_left_rounded,  onTap: currentPage > 1 ? () => onPageChanged(currentPage - 1) : null),
      const SizedBox(width: 4),
      ..._pages.map((p) {
        if (p == '...') return const Padding(padding: EdgeInsets.symmetric(horizontal: 4), child: Text('…', style: TextStyle(color: kTextMuted)));
        final n = p as int;
        final active = n == currentPage;
        return GestureDetector(
          onTap: () => onPageChanged(n),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            margin: const EdgeInsets.symmetric(horizontal: 2),
            width: 32, height: 32,
            decoration: BoxDecoration(
              gradient: active ? kBrandGrad : null,
              color: active ? null : kBgElevated,
              border: Border.all(color: active ? Colors.transparent : kBorderMid),
              borderRadius: BorderRadius.circular(8),
              boxShadow: active ? [BoxShadow(color: kIndigo.withOpacity(0.35), blurRadius: 10, offset: const Offset(0, 3))] : [],
            ),
            alignment: Alignment.center,
            child: Text('$n', style: TextStyle(fontSize: 12, color: active ? Colors.white : kTextSecond, fontWeight: active ? FontWeight.w800 : FontWeight.normal)),
          ),
        );
      }),
      const SizedBox(width: 4),
      _PgBtn(icon: Icons.chevron_right_rounded, onTap: currentPage < totalPages ? () => onPageChanged(currentPage + 1) : null),
      _PgBtn(icon: Icons.last_page_rounded,     onTap: currentPage < totalPages ? () => onPageChanged(totalPages) : null),
    ],
  );
}

class _PgBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  const _PgBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      width: 32, height: 32,
      decoration: BoxDecoration(color: kBgElevated, border: Border.all(color: kBorderMid), borderRadius: BorderRadius.circular(8)),
      alignment: Alignment.center,
      child: Icon(icon, size: 17, color: onTap == null ? kTextDisabled : kTextMuted),
    ),
  );
}

// ─────────────────────────────────────────────
// MICRO WIDGETS
// ─────────────────────────────────────────────

// Gradient avatar with initials
class _Avatar extends StatelessWidget {
  final UserModel user;
  final double size;
  final Color roleColor;
  const _Avatar({required this.user, this.size = 40, required this.roleColor});

  @override
  Widget build(BuildContext context) => Stack(
    children: [
      Container(
        width: size, height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [roleColor.withOpacity(0.8), roleColor.withOpacity(0.4)],
            begin: Alignment.topLeft, end: Alignment.bottomRight,
          ),
          border: Border.all(color: roleColor.withOpacity(0.3), width: 1.5),
        ),
        alignment: Alignment.center,
        child: Text(user.initials, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: size * 0.36)),
      ),
    ],
  );
}

// Role badge with icon
class _RoleBadge extends StatelessWidget {
  final String label;
  final Color color;
  final IconData icon;
  const _RoleBadge({required this.label, required this.color, required this.icon});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
    decoration: BoxDecoration(
      color: color.withOpacity(0.1),
      border: Border.all(color: color.withOpacity(0.3)),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(icon, size: 10, color: color),
      const SizedBox(width: 4),
      Text(label, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 0.2)),
    ]),
  );
}

// Status active/inactive badge
class _StatusBadge extends StatelessWidget {
  final bool active;
  const _StatusBadge({required this.active});

  @override
  Widget build(BuildContext context) {
    final color = active ? kSuccess : kTextMuted;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        border: Border.all(color: color.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Container(width: 5, height: 5, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 5),
        Text(active ? 'Active' : 'Inactive', style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w600)),
      ]),
    );
  }
}

// Simple text tag
class _Tag extends StatelessWidget {
  final String label;
  final Color color;
  const _Tag({required this.label, required this.color});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
    decoration: BoxDecoration(
      color: color.withOpacity(0.07),
      border: Border.all(color: color.withOpacity(0.2)),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(label, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w500)),
  );
}

// Tooltip icon action button
class _ActionButton extends StatefulWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final String tooltip;
  const _ActionButton({required this.icon, required this.color, required this.onTap, required this.tooltip});
  @override
  State<_ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<_ActionButton> {
  bool _hov = false;
  @override
  Widget build(BuildContext context) => Tooltip(
    message: widget.tooltip,
    child: MouseRegion(
      onEnter: (_) => setState(() => _hov = true),
      onExit:  (_) => setState(() => _hov = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: 30, height: 30,
          decoration: BoxDecoration(
            color: _hov ? widget.color.withOpacity(0.2) : widget.color.withOpacity(0.08),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: _hov ? widget.color.withOpacity(0.5) : Colors.transparent),
          ),
          alignment: Alignment.center,
          child: Icon(widget.icon, size: 14, color: widget.color),
        ),
      ),
    ),
  );
}

// Gradient primary button
class _PrimaryButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final double height;
  const _PrimaryButton({required this.label, required this.icon, required this.onTap, this.height = 36});
  @override
  State<_PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<_PrimaryButton> {
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
        decoration: BoxDecoration(
          gradient: kBrandGrad,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [BoxShadow(color: kIndigo.withOpacity(0.35), blurRadius: 12, offset: const Offset(0, 4))],
        ),
        alignment: Alignment.center,
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(widget.icon, size: 14, color: Colors.white),
          const SizedBox(width: 6),
          Text(widget.label, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700, letterSpacing: 0.1)),
        ]),
      ),
    ),
  );
}

// Outline button
class _OutlineButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _OutlineButton({required this.label, required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      height: 44,
      decoration: BoxDecoration(
        color: color.withOpacity(0.06),
        border: Border.all(color: color.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(10),
      ),
      alignment: Alignment.center,
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 6),
        Text(label, style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w600)),
      ]),
    ),
  );
}