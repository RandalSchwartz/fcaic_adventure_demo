# Implementation Plan: Adventure Forge V1.0

This plan outlines the necessary steps to build the Minimum Viable Product (MVP) of the "Adventure Forge" application, as specified in the PRD.

## High-Level Checklist

-   [ ] **1. Project Setup & Foundation:** Configure the Flutter project, add dependencies, and establish the core architecture.
-   [ ] **2. AI Service Abstraction:** Create the `AIProvider` interface and a concrete implementation for the Gemini API.
-   [ ] **3. Dependency Injection:** Implement the `ServiceLocator` to provide services throughout the app.
-   [ ] **4. Themed Story Initiation UI:** Build the initial screen for users to input their story theme.
-   [ ] **5. Core Models:** Define the Dart classes for the story data structures.
-   [ ] **6. State Management Setup:** Implement the core `AdventureService` using `signals` to manage application state.
-   [ ] **7. Gameplay UI:** Develop the main screen that displays the story, image, and choices.
-   [ ] **8. Loading & Error UI:** Implement UI components for loading indicators and error messages with a retry mechanism.
-   [ ] **9. Final Integration & Code Quality:** Connect all components and ensure the codebase meets quality standards.

---

## Detailed Implementation Steps

### 1. Project Setup & Foundation

This step involves preparing the Flutter project and establishing the foundational patterns that will be used throughout development.

-   **Tasks:**
    1.  Initialize a new Flutter project if one doesn't already exist.
    2.  Add required dependencies to `pubspec.yaml`:
        -   `google_generative_ai`: For Gemini API communication.
        -   `signals`: For reactive state management.
        -   `mocktail`: For testing mocks.
    3.  Create a basic folder structure for the application (`lib/src`, `lib/src/services`, `lib/src/models`, `lib/src/ui`, etc.).
    4.  Set up the `GEMINI_API_KEY`. For development, this can be done by adding it to a file that is included in `.gitignore` (e.g., `lib/api_key.dart`). Add a prominent comment warning that this method is insecure for production.

-   **Testable Component:**
    -   **Automated:** Run `flutter pub get` to ensure all dependencies are resolved without version conflicts.
    -   **Manual:** Verify that the project builds and runs successfully on an emulator or device. Confirm that the API key file is listed in `.gitignore` and is not committed to version control.

### 2. AI Service Abstraction

Decouple the application from the `google_generative_ai` package to facilitate testing and future changes.

-   **Tasks:**
    1.  Create an abstract class `AIProvider` in `lib/src/services/ai_provider.dart`.
    2.  Define methods in the interface that match the app's needs, such as `Future<StoryStep> generateStoryStep(List<StoryStep> history, String choice)` and `Future<Uint8List> generateImage(String prompt)`.
    3.  Create a concrete implementation, `GeminiAIProvider`, that uses the `google_generative_ai` package to fulfill the interface contract. It will handle the API calls and JSON parsing/validation.

-   **Testable Component:**
    -   **Automated:** Write unit tests for `GeminiAIProvider`. Use `mocktail` to mock the `GenerativeModel` class from the `google_generative_ai` package. Verify that the correct parameters are passed to the model and that the JSON response is correctly parsed into the application's models.

### 3. Dependency Injection

Implement a simple Service Locator to manage and provide access to services like the `AIProvider`.

-   **Tasks:**
    1.  Create a `ServiceLocator` class (`lib/src/service_locator.dart`).
    2.  Add methods to register and retrieve services (e.g., `register<T>(T service)`, `get<T>()`).
    3.  In `main.dart`, initialize the `ServiceLocator` and register the `GeminiAIProvider`.

-   **Testable Component:**
    -   **Automated:** Write a unit test to verify that a service can be registered and then retrieved from the locator.

### 4. Themed Story Initiation UI

Build the first screen the user interacts with.

-   **Tasks:**
    1.  Create a new widget for the "start screen" (`lib/src/ui/start_screen.dart`).
    2.  Add a `TextField` for the user to enter their story theme.
    3.  Add a `Button` (e.g., `ElevatedButton`) to start the adventure.
    4.  When the button is tapped, it should call a method in the state management service (to be created in Step 6) and navigate to the gameplay screen.

-   **Testable Component:**
    -   **Automated:** Write a widget test for the `StartScreen`. Verify that the `TextField` and `ElevatedButton` are present. Simulate entering text and tapping the button, and verify that the correct navigation or service call is made.
    -   **Manual:** Run the app. Enter a theme into the text field and tap the start button. Verify that the app transitions to the (currently empty) gameplay screen.

### 5. Core Models

Define the Dart data structures that will hold the story information, matching the JSON schema from the PRD.

-   **Tasks:**
    1.  Create a `StoryStep` class in `lib/src/models/story_step.dart`.
    2.  Add final properties for `title`, `story`, `imagePrompt`, and `choices` (as a `List<String>`).
    3.  Add a factory constructor `StoryStep.fromJson(Map<String, dynamic> json)` to parse the data from the Gemini API.

-   **Testable Component:**
    -   **Automated:** Write a unit test for the `StoryStep` model. Create a sample JSON map that matches the expected API output and verify that the `fromJson` factory constructor correctly parses it into a `StoryStep` object.

### 6. State Management Setup

Create the central service that manages the application's state and business logic.

-   **Tasks:**
    1.  Create an `AdventureService` class in `lib/src/services/adventure_service.dart`.
    2.  Use `signals` to manage the application state:
        -   `final storyHistory = signal<List<StoryStep>>([]);`
        -   `final currentImage = signal<Uint8List?>(null);`
        -   `final isLoading = signal<bool>(false);`
        -   `final errorMessage = signal<String?>(null);`
    3.  Implement the core logic method, `void startAdventure(String theme)`. This method will:
        -   Set `isLoading.value = true` and `errorMessage.value = null`.
        -   Call the `AIProvider` to generate the first story step.
        -   Call the `AIProvider` to generate the first image.
        -   On success, update `storyHistory` and `currentImage`.
        -   On failure, update `errorMessage`.
        -   Finally, set `isLoading.value = false`.
    4.  Implement `void makeChoice(String choice)` to handle subsequent steps.

-   **Testable Component:**
    -   **Automated:** Write unit tests for `AdventureService`. Use `mocktail` to provide a mock `AIProvider`. Test the `startAdventure` and `makeChoice` methods. Verify that the signals (`isLoading`, `errorMessage`, etc.) are updated correctly in both success and failure scenarios.

### 7. Gameplay UI

Develop the main screen where the user reads the story and makes choices.

-   **Tasks:**
    1.  Create a `GameplayScreen` widget (`lib/src/ui/gameplay_screen.dart`).
    2.  Use `Watch` widgets (from the `signals` package) to reactively build the UI based on the state in `AdventureService`.
    3.  Display the `title` and `story` from the latest `StoryStep`.
    4.  Display the `currentImage`.
    5.  Render the `choices` as a list of `Button` widgets.
    6.  Include a `TextField` for the user to enter a custom action.
    7.  When a choice is made (either by tapping a button or submitting text), call the `makeChoice` method in `AdventureService`.

-   **Testable Component:**
    -   **Automated:** Write widget tests for the `GameplayScreen`. Provide a mock `AdventureService` to control the state. Verify that the UI correctly displays the story, image, and choices based on the mock data. Simulate tapping a choice button and verify the correct service method is called.
    -   **Manual:** Run the app and start an adventure. Verify that the story text, a generated image, and a list of choices appear. Make a choice and confirm that the story updates with new content.

### 8. Loading & Error UI

Provide clear feedback to the user during network calls and when errors occur.

-   **Tasks:**
    1.  In the `GameplayScreen` and `StartScreen`, use the `isLoading` signal to conditionally display a `CircularProgressIndicator`. This should overlay the screen or replace the main content area.
    2.  In the `GameplayScreen`, use the `errorMessage` signal to conditionally display an error message (e.g., in a `Snackbar` or a dialog).
    3.  The error UI must include a "Retry" button that calls the last failed action again (e.g., `startAdventure` or `makeChoice`).

-   **Testable Component:**
    -   **Automated:** Write widget tests. Set the mock `AdventureService`'s `isLoading` signal to `true` and verify the loading indicator is visible. Set the `errorMessage` signal and verify the error message and retry button are displayed.
    -   **Manual:** Manually test the loading state by adding a `Future.delayed` in the `AIProvider`. To test the error state, temporarily disable the network connection on the test device/emulator or throw an exception from the mock `AIProvider`. Verify the loading and error UIs appear correctly and that the retry button works.

### 9. Final Integration & Code Quality

Ensure all parts of the application work together seamlessly and meet the required quality standards.

-   **Tasks:**
    1.  Perform a full end-to-end review of the application flow.
    2.  Run `flutter analyze .` and fix all reported issues, warnings, and lints.
    3.  Ensure all automated tests are passing.
    4.  Review the code for clarity, maintainability, and adherence to the architectural patterns defined in the PRD.

-   **Testable Component:**
    -   **Automated:** The `flutter analyze` command must return `No issues found!`. The test suite must complete with all tests passing.
    -   **Manual:** Play through several adventures from start to finish. Try different themes and choices. Intentionally trigger error conditions to ensure they are handled gracefully. The application should feel responsive and stable.