// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class OwnerModal {
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phone;
  final String? address;
  final String? city;
  final String? state;
  final String? zip;
  final String? country;
  final String? id;
  final List? propertyList;
  final List? tenantList;
  final List? flatList;
  final List? complaintList;
  final String? rentDue;
  final String? rentRecieved;
  OwnerModal({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.address,
    required this.city,
    required this.state,
    required this.zip,
    required this.country,
    required this.id,
    required this.propertyList,
    required this.tenantList,
    required this.flatList,
    required this.complaintList,
    required this.rentDue,
    required this.rentRecieved,
  });

  OwnerModal copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? address,
    String? city,
    String? state,
    String? zip,
    String? country,
    String? id,
    String? createdAt,
    List? propertyList,
    List? tenantList,
    List? flatList,
    List? complaintList,
    String? rentDue,
    String? rentRecieved,
  }) {
    return OwnerModal(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      city: city ?? this.city,
      state: state ?? this.state,
      zip: zip ?? this.zip,
      country: country ?? this.country,
      id: id ?? this.id,
      propertyList: propertyList ?? this.propertyList,
      tenantList: tenantList ?? this.tenantList,
      flatList: flatList ?? this.flatList,
      complaintList: complaintList ?? this.complaintList,
      rentDue: rentDue ?? this.rentDue,
      rentRecieved: rentRecieved ?? this.rentRecieved,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'address': address,
      'city': city,
      'state': state,
      'zip': zip,
      'country': country,
      'id': id,
      'propertyList': propertyList,
      'tenantList': tenantList,
      'flatList': flatList,
      'complaintList': complaintList,
      'rentDue': rentDue,
      'rentRecieved': rentRecieved,
    };
  }

  factory OwnerModal.fromMap(Map<String, dynamic> map) {
    return OwnerModal(
        firstName: map['firstName'] as String,
        lastName: map['lastName'] as String,
        email: map['email'] as String,
        phone: map['phone'] as String,
        address: map['address'] as String,
        city: map['city'] as String,
        state: map['state'] as String,
        zip: map['zip'] as String,
        country: map['country'] as String,
        id: map['id'] as String,
        flatList: List.from(
          (map['flatList'] as List),
        ),
        complaintList: List.from(
          (map['complaintList'] as List),
        ),
        rentDue: map['rentDue'] as String,
        rentRecieved: map['rentRecieved'] as String,
        propertyList: List.from(
          (map['propertyList'] as List),
        ),
        tenantList: List.from(
          (map['tenantList'] as List),
        ));

  }

  String toJson() => json.encode(toMap());

  factory OwnerModal.fromJson(String source) =>
      OwnerModal.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'OwnerModal(firstName: $firstName, lastName: $lastName, email: $email, phone: $phone, address: $address, city: $city, state: $state, zip: $zip, country: $country, id: $id, propertyList: $propertyList, tenantList: $tenantList)';
  }

  @override
  bool operator ==(covariant OwnerModal other) {
    if (identical(this, other)) return true;

    return other.firstName == firstName &&
        other.lastName == lastName &&
        other.email == email &&
        other.phone == phone &&
        other.address == address &&
        other.city == city &&
        other.state == state &&
        other.zip == zip &&
        other.country == country &&
        other.id == id &&
        listEquals(other.propertyList, propertyList) &&
        listEquals(other.tenantList, tenantList);
  }

  @override
  int get hashCode {
    return firstName.hashCode ^
        lastName.hashCode ^
        email.hashCode ^
        phone.hashCode ^
        address.hashCode ^
        city.hashCode ^
        state.hashCode ^
        zip.hashCode ^
        country.hashCode ^
        id.hashCode ^
        propertyList.hashCode ^
        tenantList.hashCode;
  }
}
