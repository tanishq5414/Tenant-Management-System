// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class Property {
  String id;
  String ownerId;
  String name;
  String city;
  String state;
  String zip;
  List tenants;
  Property({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.city,
    required this.state,
    required this.zip,
    required this.tenants,
  });


  Property copyWith({
    String? id,
    String? ownerId,
    String? name,
    String? address,
    String? city,
    String? state,
    String? zip,
    String? createdAt,
    List? tenants,
  }) {
    return Property(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      name: name ?? this.name,
      city: city ?? this.city,
      state: state ?? this.state,
      zip: zip ?? this.zip,
      tenants: tenants ?? this.tenants,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'ownerId': ownerId,
      'name': name,
      'city': city,
      'state': state,
      'zip': zip,
      'tenants': tenants,
    };
  }

  factory Property.fromMap(Map<String, dynamic> map) {
    return Property(
      id: map['id'] as String,
      ownerId: map['ownerId'] as String,
      name: map['name'] as String,
      city: map['city'] as String,
      state: map['state'] as String,
      zip: map['zip'] as String,
      tenants: List.from((map['tenants'] as List),
    ));
  }

  String toJson() => json.encode(toMap());

  factory Property.fromJson(String source) => Property.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Property(id: $id, ownerId: $ownerId, name: $name, city: $city, state: $state, zip: $zip, tenants: $tenants)';
  }

  @override
  bool operator ==(covariant Property other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.ownerId == ownerId &&
      other.name == name &&
      other.city == city &&
      other.state == state &&
      other.zip == zip &&
      listEquals(other.tenants, tenants);
  }

  @override
  int get hashCode {
    return id.hashCode ^
      ownerId.hashCode ^
      name.hashCode ^
      city.hashCode ^
      state.hashCode ^
      zip.hashCode ^
      tenants.hashCode;
  }
}
