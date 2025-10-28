import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationSearchService {
  // Search for places using geocoding
  static Future<List<Map<String, dynamic>>> searchPlaces(String query) async {
    if (query.isEmpty) return [];

    try {
      // Get locations from query
      List<Location> locations = await locationFromAddress(query);
      
      List<Map<String, dynamic>> results = [];
      
      for (var location in locations) {
        // Get placemarks (address details) for each location
        List<Placemark> placemarks = await placemarkFromCoordinates(
          location.latitude,
          location.longitude,
        );
        
        if (placemarks.isNotEmpty) {
          var placemark = placemarks.first;
          
          // Create a formatted address
          String formattedAddress = _formatAddress(placemark);
          
          results.add({
            'description': formattedAddress,
            'lat': location.latitude,
            'lng': location.longitude,
            'name': placemark.name ?? query,
            'locality': placemark.locality ?? '',
            'country': placemark.country ?? '',
          });
        }
      }
      
      return results;
    } catch (e) {
      print('Error searching places: $e');
      return [];
    }
  }

  // Get place details from coordinates
  static Future<Map<String, dynamic>?> getPlaceDetails(
    double lat,
    double lng,
  ) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      
      if (placemarks.isNotEmpty) {
        var placemark = placemarks.first;
        
        return {
          'description': _formatAddress(placemark),
          'lat': lat,
          'lng': lng,
          'name': placemark.name ?? 'Unknown',
          'locality': placemark.locality ?? '',
          'country': placemark.country ?? '',
        };
      }
      
      return null;
    } catch (e) {
      print('Error getting place details: $e');
      return null;
    }
  }

  // Format address from placemark
  static String _formatAddress(Placemark placemark) {
    List<String> parts = [];
    
    if (placemark.name != null && placemark.name!.isNotEmpty) {
      parts.add(placemark.name!);
    }
    if (placemark.street != null && placemark.street!.isNotEmpty) {
      parts.add(placemark.street!);
    }
    if (placemark.locality != null && placemark.locality!.isNotEmpty) {
      parts.add(placemark.locality!);
    }
    if (placemark.administrativeArea != null && 
        placemark.administrativeArea!.isNotEmpty) {
      parts.add(placemark.administrativeArea!);
    }
    if (placemark.country != null && placemark.country!.isNotEmpty) {
      parts.add(placemark.country!);
    }
    
    return parts.join(', ');
  }

  // Convert LatLng to address
  static Future<String> getAddressFromLatLng(LatLng position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      
      if (placemarks.isNotEmpty) {
        return _formatAddress(placemarks.first);
      }
      
      return 'Unknown location';
    } catch (e) {
      print('Error getting address: $e');
      return 'Unknown location';
    }
  }
}
