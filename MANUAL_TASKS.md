# Manual Tasks

This file tracks tasks that require manual intervention or features that are not yet fully implemented in the code.

## Pending Manual Actions
- [ ] **Run `flutter pub get`**: The dependency `image_picker` was added to `pubspec.yaml` but package installation cannot be performed automatically in this environment.
- [ ] **Configure Android Permissions**: If using the camera or gallery on older Android versions, verify `AndroidManifest.xml` permissions.
- [ ] **Verify iOS Info.plist**: Ensure `NSPhotoLibraryUsageDescription` and `NSCameraUsageDescription` are correct for your specific use case.

## Future Implementations (Out of Scope for current automation)
- **Real-time Scheduling**: The current "Now" and "Upcoming" sections on the Homepage are simulations based on the list order. Implementing a robust scheduling engine (using local notifications or a background service) to trigger at specific times is needed.
- **Caretaker Integration**: The "Caretaker" button on the homepage is currently a placeholder.
- **Adherence Tracking**: The "Taken/Snooze/Skip" buttons on the Homepage update the UI state temporarily but do not yet persist to a database or calculate long-term adherence statistics.
