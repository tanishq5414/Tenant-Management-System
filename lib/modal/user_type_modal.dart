// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserType {
  final String id;
  final String user_type;
  UserType({
    required this.id,
    required this.user_type,
  });

  UserType copyWith({
    String? id,
    String? user_type,
  }) {
    return UserType(
      id: id ?? this.id,
      user_type: user_type ?? this.user_type,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'user_type': user_type,
    };
  }

  factory UserType.fromMap(Map<String, dynamic> map) {
    return UserType(
      id: map['id'] as String,
      user_type: map['user_type'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserType.fromJson(String source) => UserType.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'UserType(id: $id, user_type: $user_type)';

  @override
  bool operator ==(covariant UserType other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.user_type == user_type;
  }

  @override
  int get hashCode => id.hashCode ^ user_type.hashCode;
}
