// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class Tenant {
  final String id;
  final String lastName;
  final String firstName;
  final String email;
  final String phone;
  final String address;
  final String city;
  final String state;
  final String zip;
  final String country;
  final List transactions;
  final List complaints;
  final String flatId;
  Tenant({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.address,
    required this.email,
    required this.city,
    required this.state,
    required this.zip,
    required this.country,
    required this.transactions,
    required this.complaints,
    required this.flatId,
  });

  Tenant copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? address,
    String? city,
    String? state,
    String? zip,
    String? country,
    String? createdAt,
    List? transactions,
    List? complaints,
    String? flatId,
  }) {
    return Tenant(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      city: city ?? this.city,
      state: state ?? this.state,
      zip: zip ?? this.zip,
      country: country ?? this.country,
      transactions: transactions ?? this.transactions,
      complaints: complaints ?? this.complaints,
      flatId: flatId ?? this.flatId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'address': address,
      'city': city,
      'state': state,
      'zip': zip,
      'country': country,
      'transactions': transactions,
      'complaints': complaints,
    };
  }

  factory Tenant.fromMap(Map<String, dynamic> map) {
    return Tenant(
        id: map['id'] as String,
        firstName: map['firstName'] as String,
        lastName: map['lastName'] as String,
        email: map['email'] as String,
        phone: map['phone'] as String,
        address: map['address'] as String,
        city: map['city'] as String,
        state: map['state'] as String,
        zip: map['zip'] as String,
        country: map['country'] as String,
        transactions: List.from(
          (map['transactions'] as List),
        ),
        complaints: List.from(
          (map['complaints'] as List),
        ),
        flatId: map['flatId'] as String);
  }

  String toJson() => json.encode(toMap());

  factory Tenant.fromJson(String source) =>
      Tenant.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Tenant(id: $id, firstName: $firstName, lastName: $lastName, email: $email, phone: $phone, address: $address, city: $city, state: $state, zip: $zip, country: $country, transactions: $transactions, complaints: $complaints)';
  }

  @override
  bool operator ==(covariant Tenant other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.email == email &&
        other.phone == phone &&
        other.address == address &&
        other.city == city &&
        other.state == state &&
        other.zip == zip &&
        other.country == country &&
        listEquals(other.transactions, transactions) &&
        listEquals(other.complaints, complaints);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        firstName.hashCode ^
        lastName.hashCode ^
        email.hashCode ^
        phone.hashCode ^
        address.hashCode ^
        city.hashCode ^
        state.hashCode ^
        zip.hashCode ^
        country.hashCode ^
        transactions.hashCode ^
        complaints.hashCode;
  }
}
