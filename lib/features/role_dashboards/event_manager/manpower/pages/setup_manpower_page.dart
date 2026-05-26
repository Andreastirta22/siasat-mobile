import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SetupManpowerPage extends StatefulWidget {
  final String eventId;

  const SetupManpowerPage({super.key, required this.eventId});

  @override
  State<SetupManpowerPage> createState() => _SetupManpowerPageState();
}

class _SetupManpowerPageState extends State<SetupManpowerPage>
    with TickerProviderStateMixin {
  final SupabaseClient supabase = Supabase.instance.client;

  // ─── Controllers ────────────────────────────────────────────────────────────
  final TextEditingController crewNeededController = TextEditingController();
  final TextEditingController coachNeededController = TextEditingController();
  final TextEditingController ringGuardController = TextEditingController();
  final TextEditingController medicController = TextEditingController();
  final TextEditingController cashierController = TextEditingController();
  final TextEditingController crewTopUpController = TextEditingController();
  final TextEditingController operationalHoursController =
      TextEditingController();

  // ─── State ──────────────────────────────────────────────────────────────────
  bool enableMedic = false;
  bool enableCashier = false;
  bool isLoading = false;
  Map<String, dynamic>? eventData;

  // ─── Animation ──────────────────────────────────────────────────────────────
  late AnimationController _pageAnimCtrl;
  late AnimationController _saveAnimCtrl;
  late Animation<double> _pageFade;
  late Animation<Offset> _pageSlide;
  late Animation<double> _saveScale;

  @override
  void initState() {
    super.initState();

    _pageAnimCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );
    _saveAnimCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      lowerBound: 0,
      upperBound: 1,
    );

    _pageFade = CurvedAnimation(parent: _pageAnimCtrl, curve: Curves.easeOut);
    _pageSlide = Tween<Offset>(begin: const Offset(0, 0.06), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _pageAnimCtrl, curve: Curves.easeOutCubic),
        );

    _saveScale = Tween<double>(
      begin: 1.0,
      end: 0.96,
    ).animate(CurvedAnimation(parent: _saveAnimCtrl, curve: Curves.easeIn));

    loadEvent();
  }

  @override
  void dispose() {
    _pageAnimCtrl.dispose();
    _saveAnimCtrl.dispose();
    crewNeededController.dispose();
    coachNeededController.dispose();
    ringGuardController.dispose();
    medicController.dispose();
    cashierController.dispose();
    crewTopUpController.dispose();
    operationalHoursController.dispose();
    super.dispose();
  }

  // ─── Load Event ─────────────────────────────────────────────────────────────
  Future<void> loadEvent() async {
    try {
      final response = await supabase
          .from('events')
          .select('''
            id,
            name,
            event_type,
            start_date,
            status,
            venues!venues_event_id_fkey (
              name,
              address
            ),
            profiles!events_headcrew_id_fkey (
              full_name,
              employee_id
            )
          ''')
          .eq('id', widget.eventId)
          .single();

      setState(() => eventData = response);
      _pageAnimCtrl.forward();
    } catch (e) {
      debugPrint('Load Event Error: $e');
    }
  }

  // ─── Save Manpower ───────────────────────────────────────────────────────────
  Future<void> setupManpower() async {
    try {
      setState(() => isLoading = true);

      final String eventType = (eventData?['event_type'] ?? '').toString();
      final int crewNeeded =
          int.tryParse(crewNeededController.text.trim()) ?? 0;
      final int coachNeeded =
          int.tryParse(coachNeededController.text.trim()) ?? 0;
      final int ringGuardNeeded =
          int.tryParse(ringGuardController.text.trim()) ?? 0;
      final int medicNeeded = int.tryParse(medicController.text.trim()) ?? 0;
      final int cashierNeeded =
          int.tryParse(cashierController.text.trim()) ?? 0;
      final int crewTopUpNeeded =
          int.tryParse(crewTopUpController.text.trim()) ?? 0;
      final int operationalHours =
          int.tryParse(operationalHoursController.text.trim()) ?? 0;

      await supabase.from('event_manpower').insert({
        'event_id': widget.eventId,
        'crew_needed': crewNeeded,
        'coach_needed': eventType == 'ice_skating' ? coachNeeded : 0,
        'ring_guard_needed': eventType == 'ice_skating' ? ringGuardNeeded : 0,
        'crew_top_up_needed':
            (eventType == 'playground' || eventType == 'snow_playground')
            ? crewTopUpNeeded
            : 0,
        'medic_needed': enableMedic ? medicNeeded : 0,
        'cashier_needed': enableCashier ? cashierNeeded : 0,
        'operational_hours': operationalHours,
        'created_at': DateTime.now().toIso8601String(),
      });

      await supabase
          .from('events')
          .update({'status': 'manpower_planning'})
          .eq('id', widget.eventId);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle_rounded, color: Colors.white, size: 18),
              SizedBox(width: 10),
              Text('Manpower planning successfully created'),
            ],
          ),
          backgroundColor: const Color(0xFF22C55E),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      debugPrint('Setup Manpower Error: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed: $e'),
          backgroundColor: const Color(0xFFEF4444),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  // ─── Build ──────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final venue = eventData?['venues'] != null ? eventData!['venues'][0] : null;
    final headcrew = eventData?['profiles'];
    final String eventType = (eventData?['event_type'] ?? '').toString();

    return Scaffold(
      backgroundColor: const Color(0xFF060D1F),
      appBar: _buildAppBar(),
      body: eventData == null
          ? _buildShimmerLoader()
          : SlideTransition(
              position: _pageSlide,
              child: FadeTransition(
                opacity: _pageFade,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Event Info ───────────────────────────────────────
                      _sectionLabel(
                        'Operational Event Information',
                        Icons.info_outline_rounded,
                      ),
                      const SizedBox(height: 16),
                      _buildEventInfoCard(venue, headcrew, eventType),

                      const SizedBox(height: 32),

                      // ── Manpower Planning ────────────────────────────────
                      _sectionLabel(
                        'Manpower Planning',
                        Icons.people_alt_rounded,
                      ),
                      const SizedBox(height: 16),

                      _buildInputCard(
                        children: [
                          _buildInputField(
                            label: 'Crew Needed',
                            controller: crewNeededController,
                            icon: Icons.groups_rounded,
                            color: const Color(0xFF3B82F6),
                          ),
                          if (eventType == 'ice_skating') ...[
                            _buildInputField(
                              label: 'Coach Needed',
                              controller: coachNeededController,
                              icon: Icons.sports_rounded,
                              color: const Color(0xFF6366F1),
                            ),
                            _buildInputField(
                              label: 'Ring Guard',
                              controller: ringGuardController,
                              icon: Icons.shield_rounded,
                              color: const Color(0xFF8B5CF6),
                              isLast: true,
                            ),
                          ],
                          if (eventType == 'playground' ||
                              eventType == 'snow_playground')
                            _buildInputField(
                              label: 'Crew Top Up',
                              controller: crewTopUpController,
                              icon: Icons.group_add_rounded,
                              color: const Color(0xFF14B8A6),
                              isLast: true,
                            ),
                        ],
                      ),

                      const SizedBox(height: 32),

                      // ── Optional Support ─────────────────────────────────
                      _sectionLabel(
                        'Optional Operational Support',
                        Icons.tune_rounded,
                      ),
                      const SizedBox(height: 16),

                      _buildOptionalCard(eventType),

                      const SizedBox(height: 32),

                      // ── Operational Hours ────────────────────────────────
                      _sectionLabel(
                        'Operational Hours',
                        Icons.schedule_rounded,
                      ),
                      const SizedBox(height: 16),

                      _buildInputCard(
                        children: [
                          _buildInputField(
                            label: 'Total Operational Hours',
                            controller: operationalHoursController,
                            icon: Icons.access_time_rounded,
                            color: const Color(0xFFF59E0B),
                            isLast: true,
                          ),
                        ],
                      ),

                      const SizedBox(height: 36),

                      // ── Save Button ──────────────────────────────────────
                      _buildSaveButton(),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFF060D1F),
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      leading: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFF111827),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
            size: 16,
          ),
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Setup Manpower',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 18,
              letterSpacing: -0.3,
            ),
          ),
          if (eventData != null)
            Text(
              eventData!['name'] ?? '',
              style: const TextStyle(
                color: Colors.white38,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildShimmerLoader() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 44,
            height: 44,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              color: const Color(0xFF3B82F6),
              backgroundColor: const Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Loading event data...',
            style: TextStyle(color: Colors.white38, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _sectionLabel(String title, IconData icon) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: const Color(0xFF3B82F6).withOpacity(0.15),
            borderRadius: BorderRadius.circular(9),
          ),
          child: Icon(icon, color: const Color(0xFF3B82F6), size: 17),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.2,
          ),
        ),
      ],
    );
  }

  Widget _buildEventInfoCard(
    dynamic venue,
    dynamic headcrew,
    String eventType,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        children: [
          _infoRow(
            icon: Icons.event_rounded,
            iconColor: const Color(0xFF3B82F6),
            label: 'Event Name',
            value: eventData?['name'] ?? '-',
            isFirst: true,
          ),
          _divider(),
          _infoRow(
            icon: Icons.category_rounded,
            iconColor: const Color(0xFF6366F1),
            label: 'Event Type',
            value: eventType.replaceAll('_', ' ').toUpperCase(),
          ),
          _divider(),
          _infoRow(
            icon: Icons.location_on_rounded,
            iconColor: const Color(0xFF14B8A6),
            label: 'Venue',
            value: venue?['name'] ?? '-',
          ),
          _divider(),
          _infoRow(
            icon: Icons.manage_accounts_rounded,
            iconColor: const Color(0xFFF59E0B),
            label: 'Operational PIC',
            value: headcrew?['full_name'] ?? '-',
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _infoRow({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, isFirst ? 16 : 12, 16, isLast ? 16 : 12),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(color: Colors.white38, fontSize: 12),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Divider(
      height: 1,
      color: Colors.white.withOpacity(0.05),
      indent: 68,
    );
  }

  Widget _buildInputCard({required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Column(children: children),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required Color color,
    bool isLast = false,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 18),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: TextField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: InputDecoration(
                    labelText: label,
                    labelStyle: const TextStyle(
                      color: Colors.white38,
                      fontSize: 13,
                    ),
                    isDense: true,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                  cursorColor: color,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'persons',
                  style: TextStyle(
                    color: color,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (!isLast) Divider(height: 1, color: Colors.white.withOpacity(0.05)),
      ],
    );
  }

  Widget _buildOptionalCard(String eventType) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        children: [
          // ── Medic ──────────────────────────────────────────────────────────
          _buildToggleRow(
            icon: Icons.local_hospital_rounded,
            iconColor: const Color(0xFFEF4444),
            label: 'Need Medic',
            subtitle: 'Add medical personnel',
            value: enableMedic,
            onChanged: (v) => setState(() => enableMedic = v),
            isFirst: true,
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 280),
            curve: Curves.easeInOut,
            child: enableMedic
                ? Column(
                    children: [
                      Divider(
                        height: 1,
                        color: Colors.white.withOpacity(0.05),
                        indent: 68,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                        child: _buildInputField(
                          label: 'Medic Needed',
                          controller: medicController,
                          icon: Icons.medical_services_rounded,
                          color: const Color(0xFFEF4444),
                          isLast: true,
                        ),
                      ),
                    ],
                  )
                : const SizedBox.shrink(),
          ),

          Divider(height: 1, color: Colors.white.withOpacity(0.05)),

          // ── Cashier ────────────────────────────────────────────────────────
          _buildToggleRow(
            icon: Icons.point_of_sale_rounded,
            iconColor: const Color(0xFF22C55E),
            label: 'Need Cashier',
            subtitle: 'Add cashier personnel',
            value: enableCashier,
            onChanged: (v) => setState(() => enableCashier = v),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 280),
            curve: Curves.easeInOut,
            child: enableCashier
                ? Column(
                    children: [
                      Divider(
                        height: 1,
                        color: Colors.white.withOpacity(0.05),
                        indent: 68,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                        child: _buildInputField(
                          label: 'Cashier Needed',
                          controller: cashierController,
                          icon: Icons.attach_money_rounded,
                          color: const Color(0xFF22C55E),
                          isLast: true,
                        ),
                      ),
                    ],
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleRow({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    bool isFirst = false,
  }) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, isFirst ? 14 : 12, 12, 14),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.white38, fontSize: 12),
                ),
              ],
            ),
          ),
          Transform.scale(
            scale: 0.85,
            child: Switch(
              value: value,
              onChanged: onChanged,
              activeColor: iconColor,
              trackColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return iconColor.withOpacity(0.3);
                }
                return Colors.white12;
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return GestureDetector(
      onTapDown: (_) => _saveAnimCtrl.forward(),
      onTapUp: (_) {
        _saveAnimCtrl.reverse();
        if (!isLoading) setupManpower();
      },
      onTapCancel: () => _saveAnimCtrl.reverse(),
      child: ScaleTransition(
        scale: _saveScale,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            gradient: isLoading
                ? null
                : const LinearGradient(
                    colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
            color: isLoading ? const Color(0xFF1E293B) : null,
            borderRadius: BorderRadius.circular(16),
            boxShadow: isLoading
                ? []
                : [
                    BoxShadow(
                      color: const Color(0xFF3B82F6).withOpacity(0.45),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
          ),
          child: Center(
            child: isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: Colors.white54,
                    ),
                  )
                : const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.save_rounded, color: Colors.white, size: 20),
                      SizedBox(width: 10),
                      Text(
                        'Save Manpower Planning',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
