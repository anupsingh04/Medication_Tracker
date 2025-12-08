# Manual Tasks

This file tracks tasks that require manual intervention or features that are not yet fully implemented in the code.

## Pending Manual Actions
- [ ] **Run `flutter pub get`**: Dependencies (`shared_preferences`, `image_picker`, `intl`, `percent_indicator`) were added.
- [ ] **Configure Android Permissions**: If using the camera or gallery on older Android versions, verify `AndroidManifest.xml` permissions.
- [ ] **Verify iOS Info.plist**: Ensure `NSPhotoLibraryUsageDescription` and `NSCameraUsageDescription` are correct for your specific use case.

## Future Implementations (Out of Scope for current automation)
- **Local Notifications**: The app currently calculates "Due" medications when the app is open. To receive alerts when the app is closed, you must implement `flutter_local_notifications` or a similar background service. The logic for calculating due times is already in `MedicationService.getDueMedications()`.
- **Caretaker Integration**: The "Caretaker" button on the homepage is currently a placeholder.
- **Data Synchronization**: Data is stored locally using `shared_preferences`. Syncing with a cloud backend (Firebase/Supabase) is required for multi-device support.
