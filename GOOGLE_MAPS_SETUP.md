# Google Maps Setup Guide

## Overview
Your home screen now has a real Google Map integrated! Follow the steps below to complete the setup.

## 🗺️ Get Your Google Maps API Key

### Step 1: Create a Google Cloud Project
1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project or select an existing one
3. Enable billing (required for Google Maps)

### Step 2: Enable Required APIs
Enable these APIs in your project:
- **Maps SDK for Android**
- **Maps SDK for iOS**

To enable:
1. Go to "APIs & Services" > "Library"
2. Search for each API and click "Enable"

### Step 3: Create API Credentials
1. Go to "APIs & Services" > "Credentials"
2. Click "Create Credentials" > "API Key"
3. Copy your API key
4. **Important**: Restrict your API key:
   - Click on the key to edit
   - Under "Application restrictions", select:
     - For Android: Add your app's package name and SHA-1 fingerprint
     - For iOS: Add your app's bundle identifier
   - Under "API restrictions", restrict to:
     - Maps SDK for Android
     - Maps SDK for iOS

## 🔧 Configure Your App

### For Android:
1. Open `android/app/src/main/AndroidManifest.xml`
2. Find the line: `android:value="YOUR_GOOGLE_MAPS_API_KEY_HERE"`
3. Replace `YOUR_GOOGLE_MAPS_API_KEY_HERE` with your actual API key

### For iOS:
1. Open `ios/Runner/AppDelegate.swift`
2. Find the line: `GMSServices.provideAPIKey("YOUR_GOOGLE_MAPS_API_KEY_HERE")`
3. Replace `YOUR_GOOGLE_MAPS_API_KEY_HERE` with your actual API key

## 🚀 Features Implemented

✅ **Real Google Map** - Fully interactive map with zoom, pan, and rotate
✅ **Current Location** - Shows your real-time location with blue dot
✅ **User Markers** - Displays nearby users as map markers
✅ **Location Button** - Tap to center map on your current location
✅ **Marker Interaction** - Tap markers to view user details
✅ **Location Permissions** - Automatic permission request on app start

## 🎯 How to Use

1. **Grant Location Permission**: When you first open the app, grant location access
2. **View the Map**: You'll see a real Google Map centered on your location
3. **See Nearby Users**: User markers will appear on the map
4. **Tap Markers**: Click on any marker to see user details in the bottom card
5. **My Location**: Use the floating action button to recenter on your location

## 🔒 Security Best Practices

⚠️ **Never commit your API key to version control!**

For better security, consider using environment variables:

1. Add your key to `.env` file:
   ```
   GOOGLE_MAPS_API_KEY=your_actual_api_key_here
   ```

2. Update your config files to read from environment variables

3. Add `.env` to your `.gitignore`

## 📱 Testing

### On Android:
```bash
flutter run
```

### On iOS:
```bash
cd ios
pod install
cd ..
flutter run
```

## ⚙️ Configuration Files Modified

- ✅ `lib/features/home/presentation/controller/home_controller.dart` - Added map controller and location logic
- ✅ `lib/features/home/presentation/screen/home_screen.dart` - Integrated GoogleMap widget
- ✅ `android/app/src/main/AndroidManifest.xml` - Added permissions and API key
- ✅ `ios/Runner/AppDelegate.swift` - Added Google Maps initialization
- ✅ `ios/Runner/Info.plist` - Already has location permissions

## 🆘 Troubleshooting

### Map not showing?
- Check if you've replaced `YOUR_GOOGLE_MAPS_API_KEY_HERE` with your actual key
- Verify that Maps SDK for Android/iOS are enabled in Google Cloud Console
- Check if billing is enabled on your Google Cloud project

### Location not working?
- Grant location permissions in device settings
- Check if location services are enabled on your device
- For iOS simulator, go to Features > Location > Custom Location

### Markers not showing?
- Make sure the sample users have valid latitude/longitude values
- Check if markers are within the visible map bounds

## 📝 Next Steps

You can customize:
- Marker icons (currently using default red and blue markers)
- Initial map position (currently set to Dhaka, Bangladesh)
- Map style (currently using normal map type)
- User data source (currently using sample data)

Enjoy your Google Maps integration! 🎉
