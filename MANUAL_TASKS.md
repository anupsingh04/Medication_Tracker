# Manual Tasks

This file tracks tasks that require manual intervention or features that are not yet fully implemented in the code.

## Pending Manual Actions
- [ ] **Run `flutter pub get`**: Dependencies (`flutter_local_notifications`, `timezone`, etc.) were added.
- [ ] **Configure Android Permissions**:
    - Open `android/app/src/main/AndroidManifest.xml`.
    - Add the following permissions inside the `<manifest>` tag:
        ```xml
        <uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
        <uses-permission android:name="android.permission.VIBRATE" />
        <uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM" />
        <uses-permission android:name="android.permission.POST_NOTIFICATIONS" />
        ```
    - Add the following receiver inside the `<application>` tag (to reschedule after reboot):
        ```xml
        <receiver android:exported="false" android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationBootReceiver">
            <intent-filter>
                <action android:name="android.intent.action.BOOT_COMPLETED"/>
                <action android:name="android.intent.action.MY_PACKAGE_REPLACED"/>
                <action android:name="android.intent.action.QUICKBOOT_POWERON" />
                <action android:name="com.htc.intent.action.QUICKBOOT_POWERON"/>
            </intent-filter>
        </receiver>
        ```
- [ ] **Configure iOS Permissions**:
    - No specific `Info.plist` strings are strictly required for local notifications, but the app requests permission on launch. Ensure your provisioning profile supports Push Notifications if testing on a real device (though Local Notifications work on Simulators).
- [ ] **Verify iOS Info.plist**: Ensure `NSPhotoLibraryUsageDescription` and `NSCameraUsageDescription` are correct for your specific use case.

## Future Implementations (Out of Scope for current automation)
- **Caretaker Integration**: The "Caretaker" button on the homepage is currently a placeholder.
- **Data Synchronization**: Data is stored locally using `shared_preferences`. Syncing with a cloud backend (Firebase/Supabase) is required for multi-device support.
