// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Transaction {
  String id;
  String tenantId;
  String ownerId;
  String propertyId;
  String amount;
  String createdAt;
  String status;
  String paymentMethod;
  Transaction({
    required this.id,
    required this.tenantId,
    required this.ownerId,
    required this.propertyId,
    required this.amount,
    required this.createdAt,
    required this.status,
    required this.paymentMethod,
  });

  Transaction copyWith({
    String? id,
    String? tenantId,
    String? ownerId,
    String? propertyId,
    String? amount,
    String? createdAt,
    String? status,
    String? paymentMethod,
  }) {
    return Transaction(
      id: id ?? this.id,
      tenantId: tenantId ?? this.tenantId,
      ownerId: ownerId ?? this.ownerId,
      propertyId: propertyId ?? this.propertyId,
      amount: amount ?? this.amount,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
      paymentMethod: paymentMethod ?? this.paymentMethod,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'tenantId': tenantId,
      'ownerId': ownerId,
      'propertyId': propertyId,
      'amount': amount,
      'createdAt': createdAt,
      'status': status,
      'paymentMethod': paymentMethod,
    };
  }

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'] as String,
      tenantId: map['tenantId'] as String,
      ownerId: map['ownerId'] as String,
      propertyId: map['propertyId'] as String,
      amount: map['amount'] as String,
      createdAt: map['createdAt'] as String,
      status: map['status'] as String,
      paymentMethod: map['paymentMethod'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Transaction.fromJson(String source) =>
      Transaction.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Transaction(id: $id, tenantId: $tenantId, ownerId: $ownerId, propertyId: $propertyId, amount: $amount, createdAt: $createdAt, status: $status, paymentMethod: $paymentMethod)';
  }

  @override
  bool operator ==(covariant Transaction other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.tenantId == tenantId &&
        other.ownerId == ownerId &&
        other.propertyId == propertyId &&
        other.amount == amount &&
        other.createdAt == createdAt &&
        other.status == status &&
        other.paymentMethod == paymentMethod;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        tenantId.hashCode ^
        ownerId.hashCode ^
        propertyId.hashCode ^
        amount.hashCode ^
        createdAt.hashCode ^
        status.hashCode ^
        paymentMethod.hashCode;
  }
}
