import 'dart:async';

import 'package:flutter/material.dart';

import '../../models/demande_model.dart';
import '../../services/demande_service.dart';

class StudentDemandesPage extends StatefulWidget {
  final String? studentId;

  const StudentDemandesPage({
    super.key,
    this.studentId,
  });

  @override
  State<StudentDemandesPage> createState() => _StudentDemandesPageState();
}

class _StudentDemandesPageState extends State<StudentDemandesPage>
    with WidgetsBindingObserver {
  static const Color bg = Color(0xFF070B14);
  static const Color panel = Color(0xFF0E1625);
  static const Color panel2 = Color(0xFF131D2E);
  static const Color border = Color(0xFF263449);
  static const Color text = Color(0xFFF8FAFC);
  static const Color muted = Color(0xFF94A3B8);
  static const Color primary = Color(0xFF7C5CFC);
  static const Color secondary = Color(0xFF4F8CFF);
  static const Color danger = Color(0xFFF05252);

  final DemandeService _service = DemandeService.instance;
  final List<DemandeModel> _demandes = <DemandeModel>[];

  Timer? _timer;
  String? _resolvedStudentId;
  bool _routeArgumentsResolved = false;
  bool _loading = true;
  bool _refreshing = false;
  bool _processing = false;
  String _filter = 'all';

  ThemeData get _darkTheme => ThemeData(
        brightness: Brightness.dark,
        colorScheme: const ColorScheme.dark(
          primary: primary,
          secondary: secondary,
          surface: panel,
          error: danger,
        ),
        scaffoldBackgroundColor: bg,
        dialogTheme: const DialogThemeData(
          backgroundColor: panel,
          surfaceTintColor: Colors.transparent,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: panel2,
          hintStyle: const TextStyle(color: muted),
          labelStyle: const TextStyle(color: muted),
          prefixIconColor: muted,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(13),
            borderSide: const BorderSide(color: border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(13),
            borderSide: const BorderSide(color: primary, width: 1.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(13),
            borderSide: const BorderSide(color: danger),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(13),
            borderSide: const BorderSide(color: danger, width: 1.5),
          ),
        ),
      );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _timer = Timer.periodic(const Duration(seconds: 10), (_) {
      if (mounted && !_processing && !_refreshing) {
        _load(showLoader: false, silent: true);
      }
    });
  }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_routeArgumentsResolved) return;
    _routeArgumentsResolved = true;

    final Object? arguments = ModalRoute.of(context)?.settings.arguments;

    String? argumentStudentId;

    if (arguments is String) {
      argumentStudentId = arguments;
    } else if (arguments is Map) {
      argumentStudentId = (
        arguments['studentId'] ??
        arguments['userId'] ??
        arguments['id']
      )?.toString();
    }

    final String? constructorId = widget.studentId?.trim();

    _resolvedStudentId =
        constructorId != null && constructorId.isNotEmpty
            ? constructorId
            : argumentStudentId?.trim();

    _load();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _load(showLoader: false, silent: true);
    }
  }

  Future<void> _load({
    bool showLoader = true,
    bool silent = false,
  }) async {
    if (_refreshing) return;

    setState(() {
      _refreshing = true;
      if (showLoader) _loading = true;
    });

    try {
      final String? studentId = _resolvedStudentId;

      if (studentId == null || studentId.trim().isEmpty) {
        throw Exception('Student ID is missing');
      }

      final List<DemandeModel> result =
          await _service.getMyDemandes(studentId);

      result.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      if (!mounted) return;
      setState(() {
        _demandes
          ..clear()
          ..addAll(result);
      });
    } catch (error) {
      if (!silent && mounted) {
        _snack(_errorText(error), success: false);
      }
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
          _refreshing = false;
        });
      }
    }
  }

  String _normalized(String value) => DemandeModel.normalizeStatus(value);

  List<DemandeModel> get _visible {
    if (_filter == 'all') return List<DemandeModel>.from(_demandes);
    return _demandes
        .where((DemandeModel item) => _normalized(item.status) == _filter)
        .toList();
  }

  int _count(String status) => _demandes
      .where((DemandeModel item) => _normalized(item.status) == status)
      .length;

  Future<void> _openCreate() async {
    final bool? created = await showModalBottomSheet<bool>(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) => Theme(
        data: _darkTheme,
        child: _CreateSheet(
          studentId: _resolvedStudentId,
          onCreate: _create,
        ),
      ),
    );

    if (created == true && mounted) {
      _snack('Request created successfully.');
      await _load(showLoader: false);
    }
  }

  Future<void> _create({
    required String name,
    required String type,
    required String description,
  }) {
    return _service.createDemande(<String, dynamic>{
      'nom': name,
      'type': type,
      'description': description,
      if (_resolvedStudentId?.trim().isNotEmpty ?? false)
        'etudiant': _resolvedStudentId!.trim(),
    });
  }

  Future<void> _delete(DemandeModel demande) async {
    final bool confirmed = await _confirm(
      title: 'Delete Request',
      message:
          'Are you sure you want to delete "${demande.titre}"? This action cannot be undone.',
      confirmLabel: 'Delete',
    );

    if (!confirmed) return;

    setState(() => _processing = true);
    try {
      await _service.deleteDemande(demande.id);
      if (!mounted) return;
      setState(() {
        _demandes.removeWhere((DemandeModel item) => item.id == demande.id);
      });
      _snack('Request deleted.');
    } catch (error) {
      if (mounted) _snack(_errorText(error), success: false);
    } finally {
      if (mounted) setState(() => _processing = false);
    }
  }

  Future<void> _deleteAll() async {
    if (_demandes.isEmpty) return;

    final bool confirmed = await _confirm(
      title: 'Delete All Requests',
      message:
          'This will permanently delete all ${_demandes.length} requests.',
      confirmLabel: 'Delete All',
    );

    if (!confirmed) return;

    setState(() => _processing = true);
    int deleted = 0;

    try {
      for (final DemandeModel demande
          in List<DemandeModel>.from(_demandes)) {
        await _service.deleteDemande(demande.id);
        deleted++;
      }

      if (!mounted) return;
      setState(_demandes.clear);
      _snack('All requests deleted.');
    } catch (error) {
      if (!mounted) return;
      await _load(showLoader: false, silent: true);
      _snack(
        'Deleted $deleted request(s). ${_errorText(error)}',
        success: false,
      );
    } finally {
      if (mounted) setState(() => _processing = false);
    }
  }

  Future<bool> _confirm({
    required String title,
    required String message,
    required String confirmLabel,
  }) async {
    final bool? result = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) => Theme(
        data: _darkTheme,
        child: AlertDialog(
          backgroundColor: panel,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: border),
          ),
          title: Row(
            children: <Widget>[
              const Icon(Icons.warning_amber_rounded, color: danger),
              const SizedBox(width: 10),
              Expanded(child: Text(title)),
            ],
          ),
          content: Text(
            message,
            style: const TextStyle(color: muted, height: 1.4),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancel'),
            ),
            FilledButton.icon(
              style: FilledButton.styleFrom(backgroundColor: danger),
              onPressed: () => Navigator.pop(dialogContext, true),
              icon: const Icon(Icons.delete_outline_rounded),
              label: Text(confirmLabel),
            ),
          ],
        ),
      ),
    );

    return result ?? false;
  }

  void _details(DemandeModel demande) {
    final _StatusStyle status = _statusStyle(demande.status);

    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) => Theme(
        data: _darkTheme,
        child: AlertDialog(
          backgroundColor: panel,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: border),
          ),
          title: const Text('Request Details'),
          content: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    'Information about your request',
                    style: TextStyle(color: muted),
                  ),
                  const SizedBox(height: 22),
                  _Detail(label: 'Request Name', value: demande.titre),
                  const SizedBox(height: 15),
                  _Detail(label: 'Type', value: _typeLabel(demande.type)),
                  const SizedBox(height: 15),
                  const Text(
                    'Status',
                    style: TextStyle(
                      color: muted,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 7),
                  _StatusBadge(style: status),
                  const SizedBox(height: 15),
                  _Detail(
                    label: 'Submitted',
                    value: _dateTime(demande.createdAt),
                  ),
                  if (demande.description.trim().isNotEmpty) ...<Widget>[
                    const SizedBox(height: 18),
                    const Text(
                      'Description',
                      style: TextStyle(
                        color: muted,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _DarkBox(child: Text(demande.description)),
                  ],
                  if (demande.response?.trim().isNotEmpty ?? false) ...<Widget>[
                    const SizedBox(height: 18),
                    const Text(
                      'Administration Response',
                      style: TextStyle(
                        color: muted,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _DarkBox(child: Text(demande.response!.trim())),
                  ],
                  const SizedBox(height: 18),
                  _StatusMessage(status: _normalized(demande.status)),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Close'),
            ),
          ],
        ),
      ),
    );
  }

  void _snack(String message, {bool success = true}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          backgroundColor:
              success ? const Color(0xFF107C52) : const Color(0xFFA92E3B),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13),
          ),
          content: Row(
            children: <Widget>[
              Icon(
                success
                    ? Icons.check_circle_outline
                    : Icons.error_outline_rounded,
                color: Colors.white,
              ),
              const SizedBox(width: 10),
              Expanded(child: Text(message)),
            ],
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final List<DemandeModel> items = _visible;

    return Theme(
      data: _darkTheme,
      child: Scaffold(
        backgroundColor: bg,
        body: Stack(
          children: <Widget>[
            const Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.topRight,
                    radius: 1.1,
                    colors: <Color>[
                      Color(0x332F5AFF),
                      Color(0x00070B14),
                    ],
                  ),
                ),
              ),
            ),
            SafeArea(
              child: RefreshIndicator(
                color: primary,
                backgroundColor: panel2,
                onRefresh: () => _load(showLoader: false),
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(18, 20, 18, 34),
                  children: <Widget>[
                    _header(),
                    const SizedBox(height: 22),
                    _statistics(),
                    const SizedBox(height: 22),
                    if (_loading)
                      const _Loading()
                    else if (items.isEmpty)
                      _Empty(
                        filter: _filter,
                        onCreate: _openCreate,
                      )
                    else
                      ...items.map(
                        (DemandeModel demande) => Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: _RequestCard(
                            demande: demande,
                            status: _statusStyle(demande.status),
                            onDetails: () => _details(demande),
                            onDelete: () => _delete(demande),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            if (_processing)
              const Positioned.fill(
                child: ColoredBox(
                  color: Color(0x99000000),
                  child: Center(
                    child: CircularProgressIndicator(color: primary),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ShaderMask(
          blendMode: BlendMode.srcIn,
          shaderCallback: (Rect bounds) => const LinearGradient(
            colors: <Color>[Color(0xFFA78BFA), Color(0xFF60A5FA)],
          ).createShader(bounds),
          child: const Text(
            'My Requests',
            style: TextStyle(
              fontSize: 32,
              height: 1.05,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'View and manage your document requests',
          style: TextStyle(color: muted, fontSize: 14),
        ),
        const SizedBox(height: 18),
        Row(
          children: <Widget>[
            if (_demandes.isNotEmpty) ...<Widget>[
              Expanded(
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFFCA5A5),
                    side: const BorderSide(color: Color(0xFF7F3340)),
                    backgroundColor: const Color(0x332E1017),
                    minimumSize: const Size.fromHeight(49),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13),
                    ),
                  ),
                  onPressed: _processing ? null : _deleteAll,
                  icon: const Icon(Icons.delete_sweep_outlined),
                  label: const Text('Delete All'),
                ),
              ),
              const SizedBox(width: 10),
            ],
            Expanded(
              child: FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: primary,
                  minimumSize: const Size.fromHeight(49),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13),
                  ),
                ),
                onPressed: _processing ? null : _openCreate,
                icon: const Icon(Icons.add_rounded),
                label: const Text('New Request'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _statistics() {
    final List<_Stat> stats = <_Stat>[
      _Stat(
        keyName: 'all',
        label: 'Total Requests',
        value: _demandes.length,
        icon: Icons.description_outlined,
        color: const Color(0xFFA78BFA),
      ),
      _Stat(
        keyName: 'pending',
        label: 'Pending',
        value: _count('pending'),
        icon: Icons.schedule_rounded,
        color: const Color(0xFFFBBF24),
      ),
      _Stat(
        keyName: 'approved',
        label: 'Approved',
        value: _count('approved'),
        icon: Icons.check_circle_outline_rounded,
        color: const Color(0xFF34D399),
      ),
      _Stat(
        keyName: 'rejected',
        label: 'Rejected',
        value: _count('rejected'),
        icon: Icons.cancel_outlined,
        color: const Color(0xFFFB7185),
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: stats.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.42,
      ),
      itemBuilder: (BuildContext context, int index) {
        final _Stat stat = stats[index];
        return _StatCard(
          stat: stat,
          selected: _filter == stat.keyName,
          onTap: () => setState(() => _filter = stat.keyName),
        );
      },
    );
  }
}

class _RequestCard extends StatelessWidget {
  final DemandeModel demande;
  final _StatusStyle status;
  final VoidCallback onDetails;
  final VoidCallback onDelete;

  const _RequestCard({
    required this.demande,
    required this.status,
    required this.onDetails,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: _StudentDemandesPageState.panel,
      elevation: 0,
      borderRadius: BorderRadius.circular(18),
      clipBehavior: Clip.antiAlias,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: _StudentDemandesPageState.border),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          children: <Widget>[
            Container(
              height: 5,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: status.gradient),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: status.gradient),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(status.icon, color: Colors.white, size: 26),
                      ),
                      const SizedBox(width: 13),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              demande.titre.isEmpty
                                  ? 'Untitled request'
                                  : demande.titre,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: _StudentDemandesPageState.text,
                                fontSize: 17,
                                height: 1.2,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 7),
                            _StatusBadge(style: status),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: onDelete,
                        icon: const Icon(
                          Icons.delete_outline_rounded,
                          color: Color(0xFFFB7185),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Type: ${_typeLabel(demande.type)}',
                    style: const TextStyle(
                      color: _StudentDemandesPageState.muted,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 9),
                  Row(
                    children: <Widget>[
                      const Icon(
                        Icons.calendar_today_outlined,
                        size: 14,
                        color: _StudentDemandesPageState.muted,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Submitted: ${_date(demande.createdAt)}',
                        style: const TextStyle(
                          color: _StudentDemandesPageState.muted,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFFC4B5FD),
                        backgroundColor: const Color(0x227C5CFC),
                        side: const BorderSide(color: Color(0xFF51417D)),
                        minimumSize: const Size.fromHeight(44),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: onDetails,
                      child: const Text('View Details'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CreateSheet extends StatefulWidget {
  final String? studentId;
  final Future<void> Function({
    required String name,
    required String type,
    required String description,
  }) onCreate;

  const _CreateSheet({
    required this.studentId,
    required this.onCreate,
  });

  @override
  State<_CreateSheet> createState() => _CreateSheetState();
}

class _CreateSheetState extends State<_CreateSheet> {
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _description = TextEditingController();

  String? _type;
  bool _submitting = false;
  String? _error;

  static const List<Map<String, String>> _types = <Map<String, String>>[
    <String, String>{
      'value': 'attestation_presence',
      'label': 'Attendance Certificate',
    },
    <String, String>{
      'value': 'attestation_inscription',
      'label': 'Registration Certificate',
    },
    <String, String>{
      'value': 'attestation_reussite',
      'label': 'Success Certificate',
    },
    <String, String>{
      'value': 'releve de notes',
      'label': 'Transcript',
    },
    <String, String>{'value': 'stage', 'label': 'Internship'},
    <String, String>{'value': 'autre', 'label': 'Other'},
  ];

  @override
  void dispose() {
    _name.dispose();
    _description.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_form.currentState?.validate() ?? false)) return;

    setState(() {
      _submitting = true;
      _error = null;
    });

    try {
      await widget.onCreate(
        name: _name.text.trim(),
        type: _type!,
        description: _description.text.trim(),
      );
      if (mounted) Navigator.pop(context, true);
    } catch (error) {
      if (mounted) {
        setState(() => _error = _errorText(error));
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double keyboard = MediaQuery.viewInsetsOf(context).bottom;

    return Container(
      decoration: const BoxDecoration(
        color: _StudentDemandesPageState.panel,
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
        border: Border(
          top: BorderSide(color: _StudentDemandesPageState.border),
        ),
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(20, 12, 20, 24 + keyboard),
        child: Form(
          key: _form,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Container(
                  width: 45,
                  height: 5,
                  decoration: BoxDecoration(
                    color: const Color(0xFF42506A),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Create New Request',
                style: TextStyle(
                  color: _StudentDemandesPageState.text,
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Submit a new document request to the administration',
                style: TextStyle(color: _StudentDemandesPageState.muted),
              ),
              const SizedBox(height: 23),
              const _Label(text: 'Request Name', requiredField: true),
              const SizedBox(height: 8),
              TextFormField(
                controller: _name,
                decoration: const InputDecoration(
                  hintText: 'e.g., Attendance Certificate 2026',
                  prefixIcon: Icon(Icons.edit_note_rounded),
                ),
                validator: (String? value) =>
                    value == null || value.trim().isEmpty
                        ? 'Please enter a request name.'
                        : null,
              ),
              const SizedBox(height: 18),
              const _Label(text: 'Document Type', requiredField: true),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _type,
                dropdownColor: _StudentDemandesPageState.panel2,
                decoration: const InputDecoration(
                  hintText: 'Select document type',
                  prefixIcon: Icon(Icons.description_outlined),
                ),
                items: _types
                    .map(
                      (Map<String, String> item) =>
                          DropdownMenuItem<String>(
                        value: item['value'],
                        child: Text(item['label']!),
                      ),
                    )
                    .toList(),
                onChanged: _submitting
                    ? null
                    : (String? value) => setState(() => _type = value),
                validator: (String? value) =>
                    value == null ? 'Please select a document type.' : null,
              ),
              const SizedBox(height: 18),
              const _Label(text: 'Description'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _description,
                minLines: 4,
                maxLines: 6,
                decoration: const InputDecoration(
                  hintText: 'Add additional details or requirements...',
                  prefixIcon: Icon(Icons.notes_rounded),
                  alignLabelWithHint: true,
                ),
              ),
              if (_error != null) ...<Widget>[
                const SizedBox(height: 15),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0x332E1017),
                    border: Border.all(color: const Color(0xFF7F3340)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _error!,
                    style: const TextStyle(color: Color(0xFFFCA5A5)),
                  ),
                ),
              ],
              const SizedBox(height: 23),
              Row(
                children: <Widget>[
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(49),
                        side: const BorderSide(
                          color: _StudentDemandesPageState.border,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(13),
                        ),
                      ),
                      onPressed:
                          _submitting ? null : () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: FilledButton.icon(
                      style: FilledButton.styleFrom(
                        backgroundColor: _StudentDemandesPageState.primary,
                        minimumSize: const Size.fromHeight(49),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(13),
                        ),
                      ),
                      onPressed: _submitting ? null : _submit,
                      icon: _submitting
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Icon(Icons.add_rounded),
                      label: Text(
                        _submitting ? 'Creating...' : 'Create Request',
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

class _StatCard extends StatelessWidget {
  final _Stat stat;
  final bool selected;
  final VoidCallback onTap;

  const _StatCard({
    required this.stat,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: _StudentDemandesPageState.panel,
      borderRadius: BorderRadius.circular(17),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(17),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(17),
            border: Border.all(
              color: selected
                  ? stat.color
                  : _StudentDemandesPageState.border,
              width: selected ? 1.6 : 1,
            ),
            boxShadow: selected
                ? <BoxShadow>[
                    BoxShadow(
                      color: stat.color.withOpacity(0.16),
                      blurRadius: 16,
                    ),
                  ]
                : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      stat.label,
                      maxLines: 2,
                      style: const TextStyle(
                        color: _StudentDemandesPageState.muted,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Icon(stat.icon, color: stat.color, size: 26),
                ],
              ),
              Text(
                stat.value.toString(),
                style: TextStyle(
                  color: stat.color,
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final _StatusStyle style;

  const _StatusBadge({required this.style});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: style.background,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(color: style.border),
        ),
        child: Text(
          style.label,
          style: TextStyle(
            color: style.foreground,
            fontSize: 11.5,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

class _StatusMessage extends StatelessWidget {
  final String status;

  const _StatusMessage({required this.status});

  @override
  Widget build(BuildContext context) {
    late Color background;
    late Color border;
    late Color foreground;
    late IconData icon;
    late String message;

    if (status == 'approved') {
      background = const Color(0x33206446);
      border = const Color(0xFF256D4D);
      foreground = const Color(0xFF86E9BC);
      icon = Icons.check_circle_outline_rounded;
      message =
          'Your request has been approved. You can collect your document.';
    } else if (status == 'rejected') {
      background = const Color(0x332E1017);
      border = const Color(0xFF7F3340);
      foreground = const Color(0xFFFCA5A5);
      icon = Icons.cancel_outlined;
      message =
          'Your request has been rejected. Contact the administration for details.';
    } else {
      background = const Color(0x333D2C09);
      border = const Color(0xFF7A5B18);
      foreground = const Color(0xFFFCD77E);
      icon = Icons.schedule_rounded;
      message = 'Your request is pending administration review.';
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: background,
        border: Border.all(color: border),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(icon, color: foreground, size: 21),
          const SizedBox(width: 9),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: foreground, height: 1.35),
            ),
          ),
        ],
      ),
    );
  }
}

class _DarkBox extends StatelessWidget {
  final Widget child;

  const _DarkBox({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: _StudentDemandesPageState.panel2,
        border: Border.all(color: _StudentDemandesPageState.border),
        borderRadius: BorderRadius.circular(12),
      ),
      child: child,
    );
  }
}

class _Detail extends StatelessWidget {
  final String label;
  final String value;

  const _Detail({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: const TextStyle(
            color: _StudentDemandesPageState.muted,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          value,
          style: const TextStyle(
            color: _StudentDemandesPageState.text,
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _Label extends StatelessWidget {
  final String text;
  final bool requiredField;

  const _Label({
    required this.text,
    this.requiredField = false,
  });

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: text,
        children: <InlineSpan>[
          if (requiredField)
            const TextSpan(
              text: ' *',
              style: TextStyle(color: _StudentDemandesPageState.danger),
            ),
        ],
      ),
      style: const TextStyle(
        color: _StudentDemandesPageState.text,
        fontSize: 13,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _Empty extends StatelessWidget {
  final String filter;
  final VoidCallback onCreate;

  const _Empty({
    required this.filter,
    required this.onCreate,
  });

  @override
  Widget build(BuildContext context) {
    final bool all = filter == 'all';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 55),
      child: Column(
        children: <Widget>[
          Container(
            width: 88,
            height: 88,
            decoration: const BoxDecoration(
              color: Color(0x337C5CFC),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.description_outlined,
              color: Color(0xFFC4B5FD),
              size: 45,
            ),
          ),
          const SizedBox(height: 17),
          Text(
            all ? 'No requests yet' : 'No $filter requests',
            style: const TextStyle(
              color: _StudentDemandesPageState.muted,
              fontSize: 19,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (all) ...<Widget>[
            const SizedBox(height: 18),
            FilledButton.icon(
              onPressed: onCreate,
              icon: const Icon(Icons.add_rounded),
              label: const Text('Create Your First Request'),
            ),
          ],
        ],
      ),
    );
  }
}

class _Loading extends StatelessWidget {
  const _Loading();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 64),
      child: Column(
        children: <Widget>[
          CircularProgressIndicator(
            color: _StudentDemandesPageState.primary,
          ),
          SizedBox(height: 15),
          Text(
            'Loading requests...',
            style: TextStyle(color: _StudentDemandesPageState.muted),
          ),
        ],
      ),
    );
  }
}

class _Stat {
  final String keyName;
  final String label;
  final int value;
  final IconData icon;
  final Color color;

  const _Stat({
    required this.keyName,
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });
}

class _StatusStyle {
  final String label;
  final IconData icon;
  final List<Color> gradient;
  final Color background;
  final Color foreground;
  final Color border;

  const _StatusStyle({
    required this.label,
    required this.icon,
    required this.gradient,
    required this.background,
    required this.foreground,
    required this.border,
  });
}

_StatusStyle _statusStyle(String raw) {
  switch (DemandeModel.normalizeStatus(raw)) {
    case 'approved':
      return const _StatusStyle(
        label: 'Approved',
        icon: Icons.check_circle_outline_rounded,
        gradient: <Color>[Color(0xFF22C55E), Color(0xFF059669)],
        background: Color(0x33206446),
        foreground: Color(0xFF86E9BC),
        border: Color(0xFF256D4D),
      );
    case 'rejected':
      return const _StatusStyle(
        label: 'Rejected',
        icon: Icons.cancel_outlined,
        gradient: <Color>[Color(0xFFFB7185), Color(0xFFE11D48)],
        background: Color(0x332E1017),
        foreground: Color(0xFFFCA5A5),
        border: Color(0xFF7F3340),
      );
    default:
      return const _StatusStyle(
        label: 'Pending',
        icon: Icons.schedule_rounded,
        gradient: <Color>[Color(0xFFFBBF24), Color(0xFFF97316)],
        background: Color(0x333D2C09),
        foreground: Color(0xFFFCD77E),
        border: Color(0xFF7A5B18),
      );
  }
}

String _typeLabel(String raw) {
  const Map<String, String> values = <String, String>{
    'attestation_presence': 'Attendance Certificate',
    'attestation_inscription': 'Registration Certificate',
    'attestation_reussite': 'Success Certificate',
    'releve de notes': 'Transcript',
    'releve_de_notes': 'Transcript',
    'stage': 'Internship',
    'autre': 'Other',
    'absence': 'Absence',
    'document': 'Document',
  };

  final String key = raw.trim().toLowerCase();
  return values[key] ?? (raw.isEmpty ? 'Other' : raw);
}

String _date(DateTime value) {
  final DateTime local = value.toLocal();
  return '${_two(local.day)}/${_two(local.month)}/${local.year}';
}

String _dateTime(DateTime value) {
  final DateTime local = value.toLocal();
  return '${_date(local)} at ${_two(local.hour)}:${_two(local.minute)}';
}

String _two(int value) => value.toString().padLeft(2, '0');

String _errorText(Object error) {
  return error.toString().replaceFirst('Exception: ', '').trim();
}
