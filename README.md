# Medimate

Medimate is a Flutter-based mobile application designed to help users manage their medication schedules, track their adherence, and access health-related information. It was developed for the 2022 Solution Challenge.

## Table of Contents
- [Overview](#overview)
- [Tech Stack](#tech-stack)
- [Project Structure](#project-structure)
- [Features & Implementation](#features--implementation)
- [Setup Instructions](#setup-instructions)
- [Future Roadmap](#future-roadmap)

## Overview
Medimate aims to simplify medication management by providing a digital assistant that tracks prescriptions, reminds users when to take their medicine, and offers information about pills.

## Tech Stack
- **Framework:** Flutter (Dart)
- **State Management:** `setState` (Local state), `ValueNotifier`
- **Navigation:** `Navigator` (MaterialPageRoute), `BottomNavigationBar`
- **UI Components:**
    - `google_fonts`: For custom typography.
    - `font_awesome_flutter` & `cupertino_icons`: For icons.
    - `table_calendar`: For the schedule calendar view.
    - `percent_indicator`: For adherence and completion rates.
    - `expandable`: For expandable list items.
    - `smooth_page_indicator`: For onboarding or carousel indicators.
- **Data Handling:** Hardcoded data maps (currently), `json_path` (dependency included but not actively used for core data).

## Project Structure
The project follows a standard Flutter directory structure with a focus on the `lib` folder:

```
lib/
├── controller/          # Placeholder for controller logic
├── model/               # Placeholder for data models
├── view/                # UI Screens and Widgets
│   ├── home/            # Home screen and widgets (e.g., side effects survey)
│   ├── login/           # Login screen
│   ├── medication-details/ # Medication list, add/edit flows, and data
│   ├── Medication_Schedule/ # Calendar and schedule logic
│   ├── profile/         # User profile and settings
│   ├── search/          # Medication search and identification
│   └── signup/          # Sign up screens
├── main.dart            # Application entry point & Landing page
└── nav.dart             # Main navigation shell (Bottom Tab Bar)
```

**Note:** The `controller` and `model` directories are currently empty placeholders. Logic and data are primarily located within the `view` directory files (e.g., `MedicationData.dart`, `ScheduleData.dart`).

## Features & Implementation

### 1. Authentication (UI Only)
- **Login & Signup:** implemented in `view/login/login.dart` and `view/signup/signup.dart`.
- **Logic:** Currently, these screens provide a UI for user input but do not authenticate against a backend. Clicking "Login" or "Sign Up" navigates directly to the main application or profile setup screens.

### 2. Dashboard (Home)
- **File:** `view/home/homepage.dart`
- **Features:**
    - Displays user greeting.
    - **Upcoming To-do List:** Shows hardcoded upcoming medications.
    - **Journal:** Link to `SideEffectsSurveyWidget`.
    - **News/Articles:** Displays health-related articles with a tab view for "Latest" and "Bookmarks".

### 3. Medication Search
- **File:** `view/search/medication_search.dart`
- **Features:**
    - **Search by Name:** Text input field.
    - **Search by Characteristic:** Dropdowns for pill color and shape.
    - **Result Display:** "Currently Taking" and "Non-active" tabs showing lists of medications.
    - **Pill Identification:** Helper widget `HowToSwallowWidget`.

### 4. Medication List
- **File:** `view/medication-details/medication_list.dart`
- **Features:**
    - Lists active medications using `MedicationListView` and data from `MedicationService`.
    - **Actions:** Delete, History (`JournalHistoryWidget`), Edit (placeholder), and Add (`AddMedication1`).
    - **Data Source:** `lib/controller/medication_service.dart` manages the list of medications using `shared_preferences` for local storage.

### 5. Schedule
- **File:** `view/Medication_Schedule/Schedule.dart`
- **Features:**
    - **Calendar:** Interactive calendar using `table_calendar`.
    - **Daily Schedule:** Lists medications broken down by time of day (Breakfast, Lunch, Dinner, Bedtime).
    - **Data Source:** `lib/view/Medication_Schedule/ScheduleData.dart` maps dates to medication lists.

### 6. Profile
- **File:** `view/profile/Profile.dart`
- **Features:**
    - Displays user profile and settings in a tabbed view (`ProfileTab` and `SettingsTab`).
    - Edit mode toggle.

## Setup Instructions

1.  **Prerequisites:**
    - Flutter SDK (>=3.0.0)
    - Dart SDK
    - Android Studio / VS Code with Flutter extensions.

2.  **Clone the Repository:**
    ```bash
    git clone <repository_url>
    cd medimate
    ```

3.  **Install Dependencies:**
    ```bash
    flutter pub get
    ```

4.  **Run the App:**
    ```bash
    flutter run
    ```

## Future Roadmap
- **Backend Integration:** Connect to a backend service (Firebase, Supabase, or REST API) for real user authentication and data persistence.
- **State Management:** Implement a robust state management solution (Provider, Bloc, or Riverpod) to separate logic from UI.
- **Data Models:** Move data structures from `view` to `model` and implement proper JSON serialization.
- **Notifications:** Implement local notifications for medication reminders.
- **Refactoring:** Clean up the folder structure by utilizing `controller` and `model` directories effectively.
