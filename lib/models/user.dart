import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String id;
  final String email;
  final String name;
  final String phone;
  final String address;
  final bool isEmailVerified;

  const UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.phone,
    required this.address,
    required this.isEmailVerified,
  });

  factory UserModel.fromFirestore(Map<String, dynamic> data, String id) {
    return UserModel(
      id: id,
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      phone: data['phone'] ?? '',
      address: data['address'] ?? '',
      isEmailVerified: data['isEmailVerified'] ?? false,
    );
  }

  @override
  List<Object?> get props => [id, email, name, phone, address, isEmailVerified];
}
