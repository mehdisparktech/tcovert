# Google Maps সাদা Background সমস্যা সমাধান

## 🔴 সমস্যা
Map এর background সাদা দেখাচ্ছে কিন্তু markers দেখা যাচ্ছে। এর মানে **Google Maps tiles load হচ্ছে না।**

## ✅ সমাধান (ধাপে ধাপে)

### ধাপ ১: Google Cloud Console এ যান
1. যান: https://console.cloud.google.com/
2. আপনার project select করুন (যেখানে API key তৈরি করেছেন)
3. উপরে menu থেকে নিশ্চিত করুন সঠিক project select করা আছে

### ধাপ ২: APIs Enable করুন ✅

**এটা সবচেয়ে গুরুত্বপূর্ণ!**

1. Left sidebar থেকে যান: **APIs & Services** > **Library**
2. নিচের APIs search করে **ENABLE** করুন:

   #### Android এর জন্য (Required):
   - ✅ **Maps SDK for Android** 
   - ✅ **Places API** (optional)
   
   #### iOS এর জন্য (Required):
   - ✅ **Maps SDK for iOS**
   
   #### অতিরিক্ত (Recommended):
   - ✅ **Geocoding API**
   - ✅ **Geolocation API**

**নোট:** প্রতিটি API এর পাশে "ENABLED" লেখা থাকতে হবে।

### ধাপ ৩: Billing Enable করুন 💳

Google Maps ব্যবহার করতে billing enable করা **আবশ্যক**।

1. Left sidebar থেকে যান: **Billing**
2. যদি billing link না থাকে:
   - "Link a billing account" click করুন
   - নতুন billing account তৈরি করুন
   - Credit/Debit card add করুন
   
3. **চিন্তা করবেন না!** Google দেয়:
   - প্রথম **$300** free credit (90 দিনের জন্য)
   - প্রতি মাসে **$200** free Maps usage
   - সাধারণত testing এর জন্য কোনো টাকা লাগে না

### ধাপ ৪: API Key Configuration Check করুন 🔑

1. যান: **APIs & Services** > **Credentials**
2. আপনার API key click করুন (যেটা আপনি app এ use করছেন)

#### Option A: Testing এর জন্য (সহজ)
- **Application restrictions:** "None" select করুন
- **API restrictions:** "Don't restrict key" select করুন
- **Save** করুন

#### Option B: Production এর জন্য (নিরাপদ)
- **Application restrictions:** 
  - "Android apps" select করুন
  - Package name add করুন: `com.example.tcovert` (অথবা আপনার app এর package)
  - SHA-1 certificate fingerprint add করুন
  
- **API restrictions:** 
  - "Restrict key" select করুন
  - নিচের APIs select করুন:
    - Maps SDK for Android
    - Maps SDK for iOS
    - Geocoding API
    - Geolocation API

- **Save** করুন

### ধাপ ৫: Package Name যাচাই করুন

Android Manifest এ package name check করুন:

```bash
# File দেখুন:
cat android/app/build.gradle
```

`applicationId` যা আছে সেটা Cloud Console এ add করেছেন কিনা নিশ্চিত করুন।

### ধাপ ৬: SHA-1 Certificate পান (Production এর জন্য)

#### Debug SHA-1:
```bash
cd android
./gradlew signingReport
```

অথবা:

```bash
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
```

SHA-1 fingerprint copy করে Cloud Console এ add করুন।

### ধাপ ৭: Changes Apply হওয়ার জন্য অপেক্ষা করুন ⏰

API configuration changes apply হতে **2-5 minutes** লাগতে পারে।

এই সময়ে:
```bash
# Clean করুন
flutter clean
flutter pub get
```

### ধাপ ৮: App নতুন করে Install করুন

```bash
# Uninstall করুন (device/emulator থেকে)
# তারপর নতুন করে run করুন:
flutter run
```

## 🧪 যাচাই করুন

App run করার পর terminal/logcat এ check করুন:

### সফল হলে দেখবেন:
```
✅ Google Map Created Successfully
```

### Error থাকলে দেখবেন:
```
Authorization failure. Please see https://developers.google.com/maps/documentation/android-sdk/error-codes
```

## 🔍 Common Errors এবং সমাধান

### Error 1: "Authorization failure"
**কারণ:** API key সঠিক না বা APIs enable করা নেই
**সমাধান:** 
- Maps SDK for Android enable করুন
- API key সঠিক আছে কিনা check করুন
- Billing enable করুন

### Error 2: Map সাদা কিন্তু markers আছে
**কারণ:** Maps SDK enable না বা billing নেই
**সমাধান:** 
- ধাপ ২ এবং ধাপ ৩ সঠিকভাবে করুন
- 5 minutes অপেক্ষা করুন
- App নতুন করে install করুন

### Error 3: "API key not valid"
**কারণ:** Package name/SHA-1 match করছে না
**সমাধান:**
- API restrictions "None" করে test করুন
- কাজ করলে, সঠিক package name এবং SHA-1 add করুন

## 📱 Quick Test Checklist

এই সব check করুন:

- [ ] Maps SDK for Android **ENABLED**
- [ ] Billing account **LINKED**
- [ ] API key সঠিক জায়গায় আছে (AndroidManifest.xml)
- [ ] API restrictions: "None" (testing এর জন্য)
- [ ] Internet permission আছে (AndroidManifest.xml)
- [ ] App fresh install করেছেন
- [ ] 5 minutes অপেক্ষা করেছেন changes এর পর

## 🎯 এখনই এই কাজগুলো করুন:

1. ✅ Google Cloud Console এ যান
2. ✅ Maps SDK for Android **Enable** করুন
3. ✅ Billing **Enable** করুন  
4. ✅ API restrictions **"None"** করুন (testing এর জন্য)
5. ✅ **Save** করুন এবং **5 minutes** অপেক্ষা করুন
6. ✅ App **uninstall** করুন
7. ✅ `flutter clean && flutter run` করুন

## 📞 সাহায্য দরকার?

যদি এখনও কাজ না করে:
1. Terminal/Logcat এর error message দেখুন
2. Google Cloud Console এ **APIs & Services** > **Dashboard** চেক করুন
3. সেখানে API requests show করবে - error থাকলে দেখাবে

---

**মনে রাখুন:** Billing enable করা আবশ্যক কিন্তু testing এ সাধারণত কোনো টাকা লাগে না! 💰
