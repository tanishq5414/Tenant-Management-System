// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class FlatsModal {
  final String id;
  final String name;
  final String description;
  final String TenantId;
  final String Rent;
  final String Deposit;
  final String Due;
  final List Complaints;
  final List Payments;
  FlatsModal({
    required this.id,
    required this.name,
    required this.description,
    required this.TenantId,
    required this.Rent,
    required this.Deposit,
    required this.Due,
    required this.Complaints,
    required this.Payments,
  });

  FlatsModal copyWith({
    String? id,
    String? name,
    String? description,
    String? TenantId,
    String? Rent,
    String? Deposit,
    String? Due,
    List? Complaints,
    List? Payments,
  }) {
    return FlatsModal(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      TenantId: TenantId ?? this.TenantId,
      Rent: Rent ?? this.Rent,
      Deposit: Deposit ?? this.Deposit,
      Due: Due ?? this.Due,
      Complaints: Complaints ?? this.Complaints,
      Payments: Payments ?? this.Payments,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'description': description,
      'TenantId': TenantId,
      'Rent': Rent,
      'Deposit': Deposit,
      'Due': Due,
      'Complaints': Complaints,
      'Payments': Payments,
    };
  }

  factory FlatsModal.fromMap(Map<String, dynamic> map) {
    return FlatsModal(
      id: map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
      TenantId: map['TenantId'] as String,
      Rent: map['Rent'] as String,
      Deposit: map['Deposit'] as String,
      Due: map['Due'] as String,
      Complaints: List.from((map['Complaints'] as List),),
      Payments: List.from((map['Payments'] as List),),
    );
  }

  String toJson() => json.encode(toMap());

  factory FlatsModal.fromJson(String source) => FlatsModal.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'FlatsModal(id: $id, name: $name, description: $description, TenantId: $TenantId, Rent: $Rent, Deposit: $Deposit, Due: $Due, Complaints: $Complaints, Payments: $Payments)';
  }

  @override
  bool operator ==(covariant FlatsModal other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.name == name &&
      other.description == description &&
      other.TenantId == TenantId &&
      other.Rent == Rent &&
      other.Deposit == Deposit &&
      other.Due == Due &&
      listEquals(other.Complaints, Complaints) &&
      listEquals(other.Payments, Payments);
  }

  @override
  int get hashCode {
    return id.hashCode ^
      name.hashCode ^
      description.hashCode ^
      TenantId.hashCode ^
      Rent.hashCode ^
      Deposit.hashCode ^
      Due.hashCode ^
      Complaints.hashCode ^
      Payments.hashCode;
  }
}
