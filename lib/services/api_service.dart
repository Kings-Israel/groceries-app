// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/category.dart';
import '../models/grocery.dart';
import '../models/user.dart';
import '../models/order.dart';

class ApiService {
  static const String baseUrl = 'https://loandisk.kingsisrael.com/api';

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  Future<void> _removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  Map<String, String> _getHeaders() {
    final headers = {'Content-Type': 'application/json'};
    return headers;
  }

  Future<Map<String, String>> _getAuthHeaders() async {
    final token = await _getToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // Categories
  Future<List<Category>> getCategories() async {
    final response = await http.get(
      Uri.parse('$baseUrl/categories'),
      headers: _getHeaders(),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['categories'] as List)
          .map((cat) => Category.fromJson(cat))
          .toList();
    }
    throw Exception('Failed to load categories');
  }

  // Groceries
  Future<List<Grocery>> getGroceries({int? categoryId}) async {
    String url = '$baseUrl/groceries';
    if (categoryId != null && categoryId != 0) {
      url += '?category_id=$categoryId';
    }

    final response = await http.get(Uri.parse(url), headers: _getHeaders());

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['groceries'] as List)
          .map((item) => Grocery.fromJson(item))
          .toList();
    }
    throw Exception('Failed to load groceries');
  }

  // Auth
  Future<Map<String, dynamic>> register({
    required String name,
    required String phone,
    String? email,
    required String location,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: _getHeaders(),
      body: json.encode({
        'name': name,
        'phone': phone,
        'email': email,
        'location': location,
        'password': password,
      }),
    );

    if (response.statusCode == 201) {
      return json.decode(response.body);
    }
    throw Exception(
      json.decode(response.body)['message'] ?? 'Registration failed',
    );
  }

  Future<Map<String, dynamic>> verifyOtp({
    required int userId,
    required String otp,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/verify-otp'),
      headers: _getHeaders(),
      body: json.encode({'user_id': userId, 'otp': otp}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      await _saveToken(data['token']);
      return data;
    }
    throw Exception(
      json.decode(response.body)['message'] ?? 'Verification failed',
    );
  }

  Future<Map<String, dynamic>> login({
    required String phone,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: _getHeaders(),
      body: json.encode({'phone': phone, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      await _saveToken(data['token']);
      return data;
    }
    throw Exception(json.decode(response.body)['message'] ?? 'Login failed');
  }

  Future<void> logout() async {
    await _removeToken();
  }

  Future<User> updateProfile({
    String? name,
    String? phone,
    String? email,
    String? location,
  }) async {
    final response = await http.put(
      Uri.parse('$baseUrl/profile'),
      headers: await _getAuthHeaders(),
      body: json.encode({
        if (name != null) 'name': name,
        if (phone != null) 'phone': phone,
        if (email != null) 'email': email,
        if (location != null) 'location': location,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return User.fromJson(data['user']);
    }
    throw Exception('Failed to update profile');
  }

  // Orders
  Future<Order> createOrder({
    required List<Map<String, dynamic>> items,
    required String deliveryLocation,
    String? notes,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/orders'),
      headers: await _getAuthHeaders(),
      body: json.encode({
        'items': items,
        'delivery_location': deliveryLocation,
        'notes': notes,
      }),
    );

    if (response.statusCode == 201) {
      final data = json.decode(response.body);
      return Order.fromJson(data['order']);
    }
    throw Exception(
      json.decode(response.body)['message'] ?? 'Failed to create order',
    );
  }

  Future<List<Order>> getMyOrders() async {
    final response = await http.get(
      Uri.parse('$baseUrl/orders'),
      headers: await _getAuthHeaders(),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['orders'] as List)
          .map((order) => Order.fromJson(order))
          .toList();
    }
    throw Exception('Failed to load orders');
  }

  Future<Order> getOrder(int id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/orders/$id'),
      headers: await _getAuthHeaders(),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Order.fromJson(data['order']);
    }
    throw Exception('Failed to load order');
  }

  Future<void> rateOrder({
    required int orderId,
    required int rating,
    String? review,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/orders/$orderId/rate'),
      headers: await _getAuthHeaders(),
      body: json.encode({'rating': rating, 'review': review}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to submit rating');
    }
  }

  Future<Map<String, dynamic>> checkAvailability({
    required List<Map<String, dynamic>> items,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/groceries/check-availability'),
      headers: await _getAuthHeaders(),
      body: json.encode({'items': items}),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    throw Exception('Failed to check availability');
  }
}
