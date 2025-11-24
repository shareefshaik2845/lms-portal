# Deployment Checklist

## Pre-Deployment Verification

### Code Quality
- [x] No compilation errors
- [x] All features implemented
- [x] Error handling in place
- [x] Loading states implemented
- [x] Null safety enabled
- [x] Code follows Flutter best practices

### Testing
- [ ] Test admin login
- [ ] Test user login
- [ ] Test all CRUD operations
- [ ] Test video playback
- [ ] Test checkpoints
- [ ] Test error scenarios
- [ ] Test on multiple devices
- [ ] Test on different screen sizes
- [ ] Test network error handling
- [ ] Test session expiration

### Documentation
- [x] README.md complete
- [x] USER_GUIDE.md complete
- [x] API_GUIDE.md complete
- [x] QUICKSTART.md complete
- [x] IMPLEMENTATION_SUMMARY.md complete

### Configuration
- [ ] API URL configured correctly
- [ ] App name set
- [ ] App icon added
- [ ] Splash screen configured
- [ ] Package name set (Android)
- [ ] Bundle ID set (iOS)

---

## Android Deployment

### 1. Update Build Configuration
Edit `android/app/build.gradle`:
```gradle
defaultConfig {
    applicationId "com.yourcompany.lms_portal"
    minSdkVersion 21
    targetSdkVersion 33
    versionCode 1
    versionName "1.0.0"
}
```

### 2. Add App Icon
- Place icon files in `android/app/src/main/res/mipmap-*`
- Use Android Asset Studio or manual placement

### 3. Create Keystore
```bash
keytool -genkey -v -keystore ~/lms-release-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias lms
```

### 4. Configure Signing
Create `android/key.properties`:
```properties
storePassword=<password>
keyPassword=<password>
keyAlias=lms
storeFile=<path-to-keystore>
```

Add to `android/app/build.gradle`:
```gradle
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

signingConfigs {
    release {
        keyAlias keystoreProperties['keyAlias']
        keyPassword keystoreProperties['keyPassword']
        storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
        storePassword keystoreProperties['storePassword']
    }
}

buildTypes {
    release {
        signingConfig signingConfigs.release
    }
}
```

### 5. Build Release APK
```bash
flutter build apk --release
```

Output: `build/app/outputs/flutter-apk/app-release.apk`

### 6. Build App Bundle (for Play Store)
```bash
flutter build appbundle --release
```

Output: `build/app/outputs/bundle/release/app-release.aab`

### 7. Test Release Build
```bash
flutter install --release
```

---

## iOS Deployment

### 1. Update Configuration
Edit `ios/Runner/Info.plist`:
```xml
<key>CFBundleDisplayName</key>
<string>LMS Portal</string>
<key>CFBundleIdentifier</key>
<string>com.yourcompany.lmsPortal</string>
```

### 2. Add App Icon
- Use Xcode to add app icons
- Open `ios/Runner.xcworkspace` in Xcode
- Navigate to Assets.xcassets > AppIcon

### 3. Configure Signing
- Open project in Xcode
- Select Runner target
- Go to Signing & Capabilities
- Select your team
- Enable automatic signing

### 4. Build Release
```bash
flutter build ios --release
```

### 5. Archive in Xcode
- Open `ios/Runner.xcworkspace` in Xcode
- Product > Archive
- Upload to App Store Connect

---

## Web Deployment

### 1. Build Web App
```bash
flutter build web --release
```

Output: `build/web/`

### 2. Deploy to Hosting

#### Firebase Hosting
```bash
firebase init hosting
firebase deploy
```

#### Netlify
- Drag `build/web` folder to Netlify

#### GitHub Pages
- Copy `build/web` contents to docs folder
- Enable GitHub Pages in repository settings

---

## Backend Configuration

### 1. Ensure Backend is Running
- Verify API server is accessible
- Check all endpoints are working
- Test with Postman or curl

### 2. Update API URL
In `lib/core/constants/api_constants.dart`:
```dart
static const String baseUrl = 'https://your-production-api.com';
```

### 3. Configure CORS (Backend)
Ensure backend allows requests from mobile app.

---

## Security Checklist

- [ ] API endpoints use HTTPS in production
- [ ] JWT tokens have expiration
- [ ] Sensitive data not logged
- [ ] API keys not hardcoded
- [ ] Backend validates all requests
- [ ] Rate limiting enabled
- [ ] SQL injection protection
- [ ] XSS protection

---

## Performance Optimization

### 1. Enable Obfuscation
```bash
flutter build apk --release --obfuscate --split-debug-info=/<project-name>/<directory>
```

### 2. Reduce App Size
```bash
flutter build apk --release --split-per-abi
```

### 3. Optimize Images
- Compress images
- Use appropriate image formats
- Implement lazy loading

### 4. Cache API Responses
- Implement caching strategy
- Use local database for offline support

---

## Store Listing Preparation

### App Store (iOS)
- [ ] App name
- [ ] App description (4000 chars)
- [ ] Keywords
- [ ] Screenshots (6.5", 5.5")
- [ ] App icon (1024x1024)
- [ ] Privacy policy URL
- [ ] Support URL
- [ ] App category
- [ ] Age rating

### Google Play (Android)
- [ ] App name
- [ ] Short description (80 chars)
- [ ] Full description (4000 chars)
- [ ] Screenshots (phone, tablet)
- [ ] Feature graphic (1024x500)
- [ ] App icon (512x512)
- [ ] Privacy policy URL
- [ ] Content rating
- [ ] App category

---

## Post-Deployment

### Monitoring
- [ ] Set up crash reporting (Firebase Crashlytics)
- [ ] Set up analytics (Firebase Analytics)
- [ ] Monitor API usage
- [ ] Monitor app performance
- [ ] Set up error tracking

### Maintenance
- [ ] Plan for updates
- [ ] Monitor user feedback
- [ ] Fix bugs promptly
- [ ] Add new features based on feedback
- [ ] Keep dependencies updated

### User Support
- [ ] Create support email/contact
- [ ] Prepare FAQ document
- [ ] Set up feedback channel
- [ ] Plan for user onboarding

---

## Version Management

### Current Version
- Version: 1.0.0
- Build: 1

### Update pubspec.yaml
```yaml
version: 1.0.0+1
```

### Version Bump Strategy
- Major (1.0.0): Breaking changes
- Minor (0.1.0): New features
- Patch (0.0.1): Bug fixes
- Build (+1): Build number

---

## Rollback Plan

### If Issues Occur
1. Identify the issue
2. Fix in development
3. Test thoroughly
4. Deploy hotfix
5. Monitor closely

### Keep Previous Versions
- Archive previous APK/IPA
- Tag releases in Git
- Document changes

---

## Launch Checklist

### Day Before Launch
- [ ] Final testing complete
- [ ] Documentation updated
- [ ] Support channels ready
- [ ] Backend scaled for load
- [ ] Monitoring tools active

### Launch Day
- [ ] Deploy backend updates
- [ ] Submit app to stores
- [ ] Test production environment
- [ ] Monitor for issues
- [ ] Be ready to respond

### Day After Launch
- [ ] Check analytics
- [ ] Monitor crash reports
- [ ] Respond to reviews
- [ ] Fix critical bugs
- [ ] Plan next update

---

## Success Metrics

### Track These KPIs
- [ ] Number of downloads
- [ ] Daily active users (DAU)
- [ ] User retention rate
- [ ] Course completion rate
- [ ] Average session duration
- [ ] Crash-free sessions
- [ ] User ratings
- [ ] Video engagement

---

## Environment Variables

### Development
```dart
static const String baseUrl = 'http://localhost:8000';
static const bool isProduction = false;
```

### Production
```dart
static const String baseUrl = 'https://api.production.com';
static const bool isProduction = true;
```

---

## Final Pre-Launch Checks

- [ ] All tests passing
- [ ] No memory leaks
- [ ] No console errors
- [ ] Loading times acceptable
- [ ] Offline behavior handled
- [ ] Deep linking works
- [ ] Push notifications configured (if applicable)
- [ ] In-app purchases configured (if applicable)
- [ ] Terms of service accepted
- [ ] Privacy policy reviewed
- [ ] Compliance requirements met

---

## Contact Information

**Developer:** [Your Name]
**Email:** [your.email@example.com]
**Support:** [support@example.com]
**Website:** [https://your-website.com]

---

## Notes

- Keep this checklist updated with each release
- Document all deployment steps
- Maintain deployment logs
- Share knowledge with team

---

*Good luck with your deployment!* 🚀

---

*Last Updated: November 6, 2025*
