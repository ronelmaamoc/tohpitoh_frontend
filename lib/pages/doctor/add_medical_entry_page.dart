import 'package:flutter/material.dart';

class AddMedicalEntryPage extends StatefulWidget {
  const AddMedicalEntryPage({super.key});

  @override
  _AddMedicalEntryPageState createState() => _AddMedicalEntryPageState();
}

class _AddMedicalEntryPageState extends State<AddMedicalEntryPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _selectedType = 'consultation';
  DateTime _selectedDate = DateTime.now();

  final List<String> _entryTypes = [
    'consultation',
    'analyse',
    'prescription',
    'hospitalisation',
    'vaccination',
    'autre'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.95),
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
              ),
            ),
            child: const Icon(Icons.arrow_back_rounded, color: Color(0xFF4B5563)),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              colors: [
                Color(0xFF6366F1),
                Color(0xFFEC4899),
              ],
            ).createShader(bounds);
          },
          child: Text(
            'New Medical Entry',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          // Background elements
          ..._buildBackgroundElements(),
          
          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Glassmorphic form card
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 30,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(28),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(28),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Entry type
                              _buildDropdownField(),
                              const SizedBox(height: 20),
                              
                              // Title
                              _buildGlassTextField(
                                controller: _titleController,
                                label: 'Title',
                                icon: Icons.title_rounded,
                                validator: (value) => value!.isEmpty ? 'Title required' : null,
                              ),
                              const SizedBox(height: 20),
                              
                              // Description
                              _buildGlassTextField(
                                controller: _descriptionController,
                                label: 'Description',
                                icon: Icons.description_rounded,
                                maxLines: 5,
                                validator: (value) => value!.isEmpty ? 'Description required' : null,
                              ),
                              const SizedBox(height: 20),
                              
                              // Date
                              _buildDateField(),
                              const SizedBox(height: 20),
                              
                              // Additional sections based on type
                              if (_selectedType == 'prescription')
                                _buildPrescriptionSection(),
                              
                              if (_selectedType == 'analyse')
                                _buildAnalysisSection(),
                              
                              const SizedBox(height: 30),
                              
                              // Save button
                              SizedBox(
                                width: double.infinity,
                                height: 56,
                                child: ElevatedButton(
                                  onPressed: _saveEntry,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    elevation: 0,
                                    shadowColor: Colors.transparent,
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Color(0xFF6366F1),
                                          Color(0xFFEC4899),
                                        ],
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                      ),
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Color(0xFF6366F1).withOpacity(0.3),
                                          blurRadius: 10,
                                          spreadRadius: 2,
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Save Entry',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Entry Type',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF4B5563),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: DropdownButtonFormField<String>(
                  value: _selectedType,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    prefixIcon: Container(
                      margin: EdgeInsets.only(right: 12),
                      padding: const EdgeInsets.all(12),
                      child: Icon(
                        Icons.category_rounded,
                        color: Color(0xFF6366F1),
                      ),
                    ),
                  ),
                  items: _entryTypes
                      .map((type) => DropdownMenuItem(
                            value: type,
                            child: Text(
                              _getTypeLabel(type),
                              style: TextStyle(
                                color: Color(0xFF374151),
                              ),
                            ),
                          ))
                      .toList(),
                  onChanged: (value) => setState(() => _selectedType = value!),
                  icon: Icon(
                    Icons.arrow_drop_down_rounded,
                    color: Color(0xFF9CA3AF),
                  ),
                  dropdownColor: Colors.white.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGlassTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF4B5563),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: TextFormField(
                  controller: controller,
                  maxLines: maxLines,
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF374151),
                  ),
                  decoration: InputDecoration(
                    hintText: 'Enter $label',
                    hintStyle: TextStyle(color: Color(0xFF9CA3AF)),
                    prefixIcon: Container(
                      margin: EdgeInsets.only(right: 12),
                      padding: const EdgeInsets.all(12),
                      child: Icon(
                        icon,
                        color: Color(0xFF6366F1),
                      ),
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: maxLines > 1 ? 20 : 16,
                    ),
                  ),
                  validator: validator,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Date',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF4B5563),
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => _selectDate(context),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_today_rounded,
                        color: Color(0xFF6366F1),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                          style: TextStyle(
                            color: Color(0xFF374151),
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.arrow_drop_down_rounded,
                        color: Color(0xFF9CA3AF),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPrescriptionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Text(
          'Prescription Details',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 16),
        _buildGlassTextField(
          controller: TextEditingController(),
          label: 'Medications',
          icon: Icons.medication_rounded,
          maxLines: 3,
        ),
        const SizedBox(height: 16),
        _buildGlassTextField(
          controller: TextEditingController(),
          label: 'Dosage',
          icon: Icons.schedule_rounded,
        ),
        const SizedBox(height: 16),
        _buildGlassTextField(
          controller: TextEditingController(),
          label: 'Treatment Duration',
          icon: Icons.timelapse_rounded,
        ),
      ],
    );
  }

  Widget _buildAnalysisSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Text(
          'Analysis Results',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildGlassTextField(
                controller: TextEditingController(),
                label: 'Analysis Type',
                icon: Icons.biotech_rounded,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildGlassTextField(
                controller: TextEditingController(),
                label: 'Value',
                icon: Icons.analytics_rounded,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildGlassTextField(
          controller: TextEditingController(),
          label: 'Comments',
          icon: Icons.comment_rounded,
          maxLines: 3,
        ),
      ],
    );
  }

  List<Widget> _buildBackgroundElements() {
    return [
      Positioned(
        top: -50,
        right: -50,
        child: Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                Color(0xFFEC4899).withOpacity(0.1),
                Colors.transparent,
              ],
            ),
          ),
        ),
      ),
      Positioned(
        bottom: -50,
        left: -50,
        child: Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                Color(0xFF6366F1).withOpacity(0.1),
                Colors.transparent,
              ],
            ),
          ),
        ),
      ),
    ];
  }

  String _getTypeLabel(String type) {
    switch (type) {
      case 'consultation': return 'Consultation';
      case 'analyse': return 'Analysis/Result';
      case 'prescription': return 'Prescription';
      case 'hospitalisation': return 'Hospitalization';
      case 'vaccination': return 'Vaccination';
      default: return 'Other';
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Color(0xFF6366F1),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Color(0xFF374151),
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() => _selectedDate = picked);
    }
  }

  void _saveEntry() {
    if (_formKey.currentState!.validate()) {
      Navigator.pop(context);
    }
  }
}