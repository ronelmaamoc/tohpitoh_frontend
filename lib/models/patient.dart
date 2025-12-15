class Patient {
  final String id;
  final String uniqueCode;
  final String fullName;
  final String? dateOfBirth;
  final String? gender;
  final String? phoneNumber;
  final String? email;
  final String? emergencyContact;
  final String? address;
  final String? createdAt;
  final String? updatedAt;

  Patient({
    required this.id,
    required this.uniqueCode,
    required this.fullName,
    this.dateOfBirth,
    this.gender,
    this.phoneNumber,
    this.email,
    this.emergencyContact,
    this.address,
    this.createdAt,
    this.updatedAt,
  });

  factory Patient.fromJson(Map<String, dynamic> json) {
    // Gérer le format de date ISO
    String? formatDate(String? isoDate) {
      if (isoDate == null) return null;
      
      try {
        final date = DateTime.parse(isoDate);
        return "${date.day.toString().padLeft(2, '0')}/"
               "${date.month.toString().padLeft(2, '0')}/"
               "${date.year}";
      } catch (e) {
        print('Erreur format date: $e pour $isoDate');
        return isoDate; // Retourner la date originale si erreur
      }
    }

    return Patient(
      id: json['id']?.toString() ?? '',
      uniqueCode: json['unique_code'] ?? json['code'] ?? '',
      fullName: json['full_name'] ?? '',
      dateOfBirth: formatDate(json['date_of_birth']),
      gender: json['gender'],
      phoneNumber: json['phone_number']?.toString(),
      email: json['email'],
      emergencyContact: json['emergency_contact']?.toString(),
      address: json['address'],
      createdAt: formatDate(json['created_at']),
      updatedAt: formatDate(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'unique_code': uniqueCode,
      'full_name': fullName,
      'date_of_birth': dateOfBirth,
      'gender': gender,
      'phone_number': phoneNumber,
      'email': email,
      'emergency_contact': emergencyContact,
      'address': address,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}