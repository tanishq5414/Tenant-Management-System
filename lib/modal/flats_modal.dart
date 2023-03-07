// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class FlatsModal {
  final String id;
  final String name;
  final String description;
  String tenantId;
  final String rent;
  final String deposit;
  final String due;
  final List complaints;
  final List payments;
  final String propertyId;
  final String ownerId;
  final String lastPaymentDate;
  FlatsModal({
    required this.id,
    required this.name,
    required this.description,
    required this.tenantId,
    required this.rent,
    required this.deposit,
    required this.due,
    required this.complaints,
    required this.payments,
    required this.propertyId,
    required this.ownerId,
    required this.lastPaymentDate,
  });

  FlatsModal copyWith({
    String? id,
    String? name,
    String? description,
    String? tenantId,
    String? rent,
    String? deposit,
    String? due,
    List? complaints,
    List? payments,
    String? propertyId,
    String? ownerId,
    String? lastPaymentDate,
  }) {
    return FlatsModal(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      tenantId: tenantId ?? this.tenantId,
      rent: rent ?? this.rent,
      deposit: deposit ?? this.deposit,
      due: due ?? this.due,
      complaints: complaints ?? this.complaints,
      payments: payments ?? this.payments,
      propertyId: propertyId ?? this.propertyId,
      ownerId: ownerId ?? this.ownerId,
      lastPaymentDate: lastPaymentDate ?? this.lastPaymentDate,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'description': description,
      'tenantId': tenantId,
      'rent': rent,
      'deposit': deposit,
      'due': due,
      'complaints': complaints,
      'payments': payments,
      'propertyId': propertyId,
      'ownerId': ownerId,
      'lastPaymentDate': lastPaymentDate,
    };
  }

  factory FlatsModal.fromMap(Map<String, dynamic> map) {
    return FlatsModal(
      id: map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
      tenantId: map['tenantId'] as String,
      rent: map['rent'] as String,
      deposit: map['deposit'] as String,
      due: map['due'] as String,
      complaints: List.from((map['complaints'] as List)),
      payments: List.from((map['payments'] as List)),
      propertyId: map['propertyId'] as String,
      ownerId: map['ownerId'] as String,
      lastPaymentDate: map['lastPaymentDate'] as String);
  }

  String toJson() => json.encode(toMap());

  factory FlatsModal.fromJson(String source) => FlatsModal.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'FlatsModal(id: $id, name: $name, description: $description, tenantId: $tenantId, rent: $rent, deposit: $deposit, due: $due, complaints: $complaints, payments: $payments, propertyId: $propertyId, ownerId: $ownerId, lastPaymentDate: $lastPaymentDate)';
  }

  @override
  bool operator ==(covariant FlatsModal other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.name == name &&
      other.description == description &&
      other.tenantId == tenantId &&
      other.rent == rent &&
      other.deposit == deposit &&
      other.due == due &&
      listEquals(other.complaints, complaints) &&
      listEquals(other.payments, payments) &&
      other.propertyId == propertyId &&
      other.ownerId == ownerId &&
      other.lastPaymentDate == lastPaymentDate;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      name.hashCode ^
      description.hashCode ^
      tenantId.hashCode ^
      rent.hashCode ^
      deposit.hashCode ^
      due.hashCode ^
      complaints.hashCode ^
      payments.hashCode ^
      propertyId.hashCode ^
      ownerId.hashCode ^
      lastPaymentDate.hashCode;
  }
}
