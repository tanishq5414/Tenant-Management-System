// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class Tenant {
  String? id;
  String? firstName;
  String? lastName;
  String? email;
  String? phone;
  String? address;
  String? city;
  String? state;
  String? zip;
  String? country;
  String? createdAt;
  List? transactions;
  List? complaints;
  Tenant({
    this.id,
    this.firstName,
    this.lastName,
    this.phone,
    this.address,
    this.email,
    this.city,
    this.state,
    this.zip,
    this.country,
    this.createdAt,
    this.transactions,
    this.complaints,
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
      createdAt: createdAt ?? this.createdAt,
      transactions: transactions ?? this.transactions,
      complaints: complaints ?? this.complaints,
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
      'createdAt': createdAt,
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
        createdAt: map['createdAt'] as String,
        transactions: List.from(
          (map['transactions'] as List),
        ),
        complaints: List.from(
          (map['complaints'] as List),
        ));
  }

  String toJson() => json.encode(toMap());

  factory Tenant.fromJson(String source) =>
      Tenant.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Tenant(id: $id, firstName: $firstName, lastName: $lastName, email: $email, phone: $phone, address: $address, city: $city, state: $state, zip: $zip, country: $country, createdAt: $createdAt, transactions: $transactions, complaints: $complaints)';
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
        other.createdAt == createdAt &&
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
        createdAt.hashCode ^
        transactions.hashCode ^
        complaints.hashCode;
  }
}
