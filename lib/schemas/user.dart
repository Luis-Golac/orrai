import 'dart:ffi';

class User {
  String? user_id;
  String? username;
  String? email;
  String? phone_number;
  String? password;
  Array? location;
  String? is_client;
  Array? favorites;
  String? direction;
  User({
    this.user_id,
    this.username,
    this.email,
    this.phone_number,
    this.password,
    this.location,
    this.is_client,
    this.favorites,
    this.direction,
  });
}
