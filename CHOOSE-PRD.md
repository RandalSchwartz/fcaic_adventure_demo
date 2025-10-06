# Product Requirements Document: "Adventure Forge" AI Storyteller

## 1. Introduction & Vision

This document outlines the product requirements for **Adventure Forge**, a "Choose Your Own Adventure" mobile application. The vision is to create a deeply engaging and endlessly replayable storytelling experience. By leveraging Google's Gemini models, the application will dynamically generate unique narratives and accompanying visual imagery based on user choices, ensuring no two adventures are ever the same.

## 2. Target Audience

The primary audience for this application includes:
-   **Creative Individuals & Readers:** Users who enjoy immersive storytelling, creative writing, and narrative-driven games.
-   **Casual Mobile Gamers:** Players looking for a unique, low-stress, and engaging experience that is easy to pick up and play in short sessions.
-   **Families & Young Adults:** A user base that appreciates imaginative and age-appropriate adventures that can be shared.

## 3. User Stories

### MVP (V1.0)

-   **As a new user,** I want to enter a theme or topic for my story, **so that** I can start a personalized adventure.
-   **As a player,** I want to read an engaging paragraph of a story and see a visually matching image, **so that** I can feel immersed in the narrative.
-   **As a player,** I want to be presented with a set of clear and distinct choices, **so that** I can control the direction of the story.
-   **As a user,** when the story is being generated, I want to see a clear loading indicator, **so that** I know the app is working and hasn't frozen.
-   **As a user,** if there is an error generating the story, I want to be notified with a clear message and be able to easily retry, **so that** a temporary network issue doesn't end my adventure.

### Future Enhancements (Post-V1)

-   **As a returning player,** I want to be able to save my adventure and resume it later, **so that** I don't lose my progress.
-   **As a registered user,** I want to have a personal account, **so that** I can keep a history of all my completed adventures.
-   **As an indecisive player,** I want to be able to go back to a previous choice and explore a different path, **so that** I can see all possible outcomes.
-   **As a proud storyteller,** I want to be able to share a link to my completed story, **so that** my friends can read my adventure.

## 4. Core Features & Prioritization

### MVP (V1.0) Requirements

-   **Themed Story Initiation:** A screen where the user can input a text-based theme to begin their adventure.
-   **Dynamic Story Generation:** The core gameplay loop, which consists of:
    -   Displaying the current story chapter (title and text).
    -   Displaying a unique, AI-generated image that represents the scene.
    -   Presenting a list of 3-5 AI-generated choices, alongside an open text field allowing the user to input their own custom action.
-   **AI Integration:** The Flutter application will communicate directly with the Gemini API to generate story text, titles, choices, and image prompts.
-   **Responsive User Experience:** The application must provide clear and immediate feedback to the user. This includes showing loading indicators during content generation and displaying user-friendly error messages with a retry option if a process fails.

### Future Enhancements (Post-V1)

-   **Story Persistence:** The ability to save and load in-progress adventures.
-   **User Authentication:** Optional user accounts (e.g., via Firebase Auth) to manage saved stories.
-   **Narrative Branching:** A system that allows users to navigate back to previous choices.
-   **Story Sharing:** A feature to generate a shareable summary or link of a completed adventure.

## 5. Application Flow

The user's journey through the application is as follows:

1.  **Starting an Adventure:** Upon opening the app, the user is presented with a screen where they can enter a theme or topic to begin their story.
2.  **Content Generation:** After the user submits their theme or chooses an action during gameplay, the application must display a clear loading indicator while it generates the next part of the story and the accompanying image.
3.  **Gameplay:** The primary gameplay screen displays the current story text, a title, a relevant image, a list of AI-generated choices, and a text field where the user can type a custom action to continue the adventure.
4.  **Error Handling:** If the application fails to fetch content from the backend, it must present a clear error message to the user and provide a simple button to retry the failed action.

## 6. Gemini API Requirements

The application will handle all communication with the Gemini API for content generation directly from the client.

### 6.1. Story Step Generation
-   **Models:** `gemini-1.5-pro` (recommended for highest quality), `gemini-1.5-flash` (for a balance of speed and quality), or `gemini-nano-banana` (for on-device generation).
-   **Requirement:** The application must take the full story history (all previous steps) and the user's latest choice as input to send to the API. This is critical for maintaining narrative context and consistency. The model must be prompted to return a structured JSON object.

#### **Required JSON Schema:**
The model must be constrained to return a JSON object matching this structure.
```json
{
  "type": "OBJECT",
  "properties": {
    "title": { "type": "STRING", "description": "A short, catchy title for this part of the story." },
    "story": { "type": "STRING", "description": "An engaging paragraph of the story." },
    "imagePrompt": { "type": "STRING", "description": "A detailed, artistic prompt for an image generation model." },
    "choices": { "type": "ARRAY", "description": "An array of 3 to 5 distinct actions for the user.", "items": { "type": "STRING" } }
  },
  "required": ["title", "story", "imagePrompt", "choices"]
}
```

### 6.2. Image Generation
This function generates the visual content for each step.
-   **Models:** `gemini-1.5-pro` or `gemini-1.5-flash`.
-   **Requirement:** The application must take the `imagePrompt` from the story step generation and, for subsequent images, the previously generated image to maintain stylistic consistency. The generated image should have a 16:9 aspect ratio.

## 7. High-Level Technical Stack

-   **Mobile Framework:** Flutter (for cross-platform support on iOS and Android).
-   **AI Models:** Google Gemini (for story and image generation, accessed via a client-side API key).
-   **State Management:** A reactive state management solution is required. Signals is recommended.
-   **Backend Services:** For future enhancements requiring data persistence (like saving stories), Firebase (FlutterFire) is the recommended solution. The core AI functionality for the MVP will not use a backend.

## 8. Technical Guidelines

Based on initial exploration, the following architectural patterns are recommended to ensure a high-quality, testable, and maintainable codebase:

-   **State Management:** The `signals` package should be used for all reactive state management.
-   **Dependency Injection:** A simple `ServiceLocator` pattern should be used to provide services (like the `AdventureService`) to the rest of the application. This avoids tight coupling and makes testing easier.
-   **Service Abstraction:** An `AIProvider` interface should be used to abstract the connection to the AI service. This decouples the application logic from the specific `google_generative_ai` package and facilitates easier testing and future migration.
-   **Testing:** The `mocktail` package should be used for creating mocks in unit and widget tests. All features should be accompanied by a robust suite of tests.
-   **Code Quality:** The codebase must pass `flutter analyze` with zero warnings or errors before any feature is considered complete.

## 9. Success Metrics

The success of the MVP will be measured by:
-   **User Engagement:** Average session duration of 5+ minutes.
-   **User Retention:** Day 1 retention rate of 20% or higher.
-   **Core Loop Completion:** 80% of users who start an adventure complete at least 5 steps.
-   **Qualitative Feedback:** Positive reviews on app stores focusing on creativity and engagement.

## 9. Risks and Open Questions

-   **API Key Exposure:** The use of a client-side `GEMINI_API_KEY` is suitable for development and controlled demos. However, this approach is insecure for a publicly released application, especially on the web, as the key can be easily extracted. A production release would require migrating to a secure backend proxy (like a Cloud Function) to protect the key.
-   **API Costs:** The cost of frequent calls to Gemini models needs to be monitored closely to ensure the business model is sustainable.
-   **Content Moderation:** A strategy must be in place to handle inappropriate user-generated themes and to ensure the AI-generated content remains safe and appropriate for the target audience.
-   **Image Consistency:** Maintaining a consistent visual style across a long and branching narrative is technically challenging and may require prompt engineering and iteration.
-   **Repetitive Narratives:** The system prompts may need to be refined to prevent the LLM from falling into repetitive loops or generating generic, uninspired story content.
