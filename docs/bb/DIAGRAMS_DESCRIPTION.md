# AyurSpace — Diagram Descriptions Reference

This document provides a structured description of all nine architectural and design diagrams produced for the AyurSpace project. Each section identifies the diagram type, explains its purpose, enumerates every component present in the source `.mmd` file, describes the relationships and data flows, and specifies the recommended placement within the blackbook.

---

## 1. System Architecture Diagram

**Source file:** `mermaid_diagrams/system_architecture.mmd`
**Diagram type:** Layered Top-Down Flowchart (`flowchart TD`)
**Blackbook chapter:** Chapter 6 — Project Design
**Placeholder asset:** `assets/placeholders/placeholder_system_arch.png`

### Purpose

The System Architecture diagram presents the complete structural decomposition of the AyurSpace application across six distinct tiers, from the user-facing presentation layer down to local and cloud storage. It illustrates how the Flutter client, Riverpod state management layer, service integrations, data repositories, external REST APIs, Firebase platform services, and local storage cooperate to deliver the application's functionality. The diagram conveys the unidirectional data flow that begins at the User and Device Camera, passes through the Presentation Layer via ConsumerWidget `watch`/`read` bindings, and terminates at either Local Storage or Firebase.

### Key Components

**User / Input**
- `User · Device Camera · ImagePicker` — the physical entry point representing the user, the device camera hardware, and the `ImagePicker` Flutter package used to capture or select images.

**Presentation Layer** (styled `client` — blue)
- `17 Screens · GoRouter · 6 Auth Guards` — the full set of application screens managed by the GoRouter navigation library, protected by six authentication guards.
- `ShellRoute — 6 Tab Bottom Navigation` — the persistent shell route providing the six-tab bottom navigation bar visible throughout the authenticated experience.
- `Localization EN · HI · MR via gen_l10n` — internationalisation support for English, Hindi, and Marathi using the Flutter `gen_l10n` toolchain.
- `Material 3 · AppTheme · AppColors · DesignTokens` — the design system based on Material 3, with the custom `AppTheme`, `AppColors` palette, and `DesignTokens` spacing and sizing constants.

**State Management — Riverpod** (styled `state` — purple)
- `11 StateNotifiers · StateNotifierProvider` — eleven reactive state containers each implemented as a `StateNotifier` and exposed via a `StateNotifierProvider`.
- Named notifiers: `Auth`, `User`, `Plants`, `Remedies`, `Scan`, `Chat`, `ChatHistory`, `DoshaQuiz`, `Wellness`, `MeditationTimer`, `Language`.

**Services Layer** (styled `svc` — orange)
- `AuthService — Email · Google · Silent Sign-In` — handles the three authentication flows.
- `FirestoreService — User CRUD · Stream · Bookmarks` — wraps all Cloud Firestore interactions including document creation, real-time streaming, and bookmark management.
- `GeminiService — Chat · Vision · Ayurvedic Info` — integrates the Google Gemini API for conversational AI, vision-based plant analysis, and Ayurvedic knowledge retrieval.
- `PlantIdService — Identify · Health Assessment` — integrates the Plant.id API v3 for plant species identification and health assessment from images.

**Data Layer** (styled `data` — green)
- `PlantsRepository · RemediesRepository` — abstract repository interfaces with local implementations (`local_*`) that are swappable with Firestore implementations.
- `Models: Plant · Remedy · UserProfile · ChatMessage · DoshaResult · Ingredient` — the core domain model classes.

**External APIs** (styled `ext` — red)
- `Google Gemini API — gemini-2.5-flash` — the generative AI endpoint using the `gemini-2.5-flash` model.
- `Plant.id API v3 — Image Recognition` — the plant identification REST API at version 3.

**Firebase Platform** (styled `ext` — red)
- `Auth · Cloud Firestore · Crashlytics` — the three Firebase services consumed via the native Firebase SDK.

**Local Storage** (styled `store` — grey, cylinder shape)
- `Seed Data — 50 Plants · 8 Remedies · 12 Quiz Q` — static bundled data shipped with the application.
- `SharedPreferences — Wellness · Chat · Language` — lightweight key-value persistence for wellness stats, chat preferences, and language selection.
- `flutter_dotenv .env — API Keys` — secure loading of API keys from a `.env` file via `flutter_dotenv`.

### Relationships and Flow

| From | Edge Label | To |
|------|-----------|-----|
| User | (direct) | Presentation Layer |
| Presentation Layer | `ConsumerWidget watch · read` | State Management — Riverpod |
| State Management | (direct) | Services Layer |
| State Management | `repository pattern` | Data Layer |
| Services Layer | `HTTP REST` | External APIs |
| Services Layer | `Native SDK` | Firebase Platform |
| Data Layer | (direct) | Local Storage |
| Data Layer | `swappable impl` (dashed) | Firebase Platform |

The dashed arrow from the Data Layer to Firebase Platform indicates that the Firestore repository implementation is available as a drop-in replacement for the local implementation, emphasising the repository pattern's environment-agnostic design.

---

## 2. Data Flow Diagram — Level 0 (Context Diagram)

**Source file:** `mermaid_diagrams/dfd_level_0.mmd`
**Diagram type:** Context-Level Data Flow Diagram (`flowchart LR`)
**Blackbook chapter:** Chapter 5 — Project Analysis
**Placeholder asset:** `assets/placeholders/placeholder_dfd0.png`

### Purpose

The Level 0 DFD, also known as the Context Diagram, presents the AyurSpace system as a single atomic process interacting with its external entities. It establishes the system boundary and identifies all external actors and data stores that communicate with the system, without revealing any internal decomposition. This diagram is the starting point for structured analysis and serves as the overview from which the Level 1 DFD is derived.

### Key Components

**External Entities**
- `User` — the human actor who initiates all interactions with the system.
- `Firebase` — the external Google Firebase platform providing authentication and database services.

**Process**
- `0.1 AyurSpace System` — the entire AyurSpace application represented as a single process bubble (circle node).

**Data Store**
- `D1 | User Database` — the persistent data store holding user profile and authentication records.

### Relationships and Flow

| From | Data Flow Label | To |
|------|----------------|-----|
| User | `User Inputs` | 0.1 AyurSpace System |
| 0.1 AyurSpace System | `App Results` | User |
| 0.1 AyurSpace System | `Auth Requests` | Firebase |
| Firebase | `Auth State` | 0.1 AyurSpace System |
| 0.1 AyurSpace System | `Stored Data` | D1 \| User Database |
| D1 \| User Database | `User Profile` | 0.1 AyurSpace System |

The bidirectional communication with Firebase (Auth Requests / Auth State) represents the OAuth and token validation handshake. The bidirectional flow with D1 (Stored Data / User Profile) captures both the persistence of user data and its subsequent retrieval.

---

## 3. Data Flow Diagram — Level 1

**Source file:** `mermaid_diagrams/dfd_level_1.mmd`
**Diagram type:** Level-1 Data Flow Diagram (`flowchart LR`)
**Blackbook chapter:** Chapter 5 — Project Analysis
**Placeholder asset:** `assets/placeholders/placeholder_dfd1.png`

### Purpose

The Level 1 DFD decomposes Process 0.1 from the Context Diagram into five subordinate processes, exposing the major functional subsystems of AyurSpace and the data flows that connect them. It shows how user input is transformed through authentication, content browsing, plant scanning, AI-powered chat, and wellness management, culminating in the delivery of a user profile back to the actor.

### Key Components

**External Entities**
- `User` — the primary actor supplying credentials and receiving a user profile.
- `Firebase` — the external authentication and storage platform.

**Processes**
- `1.1 Authentication` — validates user credentials and manages auth tokens.
- `1.2 Browse Content` — retrieves plant and remedy records for display.
- `1.3 Plant Scanner` — processes captured images and returns identification results.
- `1.4 AI Chat` — manages conversational sessions with the Gemini AI.
- `1.5 Wellness & Profile` — aggregates quiz results and wellness data into the user profile.

**Data Stores**
- `D1 | User Database` — stores and provides user authentication records.
- `D2 | Plant & Remedy Data` — the local seed database of 50 plants and 8 remedies.
- `D3 | Quiz Data` — the 12 Tridosha quiz questions.
- `D4 | Preferences` — SharedPreferences storage for chat sessions, wellness stats, and language settings.

### Relationships and Flow

**Main sequential pipeline (User → Processes → User):**

| From | Data Flow Label | To |
|------|----------------|-----|
| User | `Credentials` | P1.1 Authentication |
| P1.1 Authentication | `Auth Token` | P1.2 Browse Content |
| P1.2 Browse Content | `Plant Data` | P1.3 Plant Scanner |
| P1.3 Plant Scanner | `Scan Result` | P1.4 AI Chat |
| P1.4 AI Chat | `Chat Context` | P1.5 Wellness & Profile |
| P1.5 Wellness & Profile | `User Profile` | User |

**Data store interactions:**

| From | Data Flow Label | To |
|------|----------------|-----|
| P1.1 Authentication | `Auth Data` | D1 \| User Database |
| Firebase | `Auth Access` | D1 \| User Database |
| D2 \| Plant & Remedy Data | `Records` | P1.2 Browse Content |
| D2 \| Plant & Remedy Data | `Local Match` | P1.3 Plant Scanner |
| P1.4 AI Chat | `Session Data` | D4 \| Preferences |
| D4 \| Preferences | `Saved Stats` | P1.5 Wellness & Profile |
| D3 \| Quiz Data | `Questions` | P1.5 Wellness & Profile |
| P1.5 Wellness & Profile | `Wellness Data` | D4 \| Preferences |

---

## 4. UML Class Diagram

**Source file:** `mermaid_diagrams/class_diagram.mmd`
**Diagram type:** UML Class Diagram (`classDiagram`)
**Blackbook chapter:** Chapter 6 — Project Design
**Placeholder asset:** `assets/placeholders/placeholder_class_diagram.png`

### Purpose

The UML Class Diagram models the static structure of the AyurSpace domain, identifying the principal classes, their attributes, their methods, and the associations between them. It covers the domain entity classes (`User`, `Plant`), the value/result classes (`PlantIdResult`, `GeminiResponse`), the service classes (`PlantIdService`, `GeminiService`), and the state container class (`ChatState`), showing how the application's core data and behaviour are distributed across objects.

### Key Components

**Class: `User`**
- Attributes: `+String uid`, `+String name`, `+String email`, `+DoshaResult dosha`
- Methods: `+authenticate()`

**Class: `Plant`**
- Attributes: `+String scientificName`, `+String hindiName`, `+List~String~ uses`, `+String rasa`, `+String virya`

**Class: `PlantIdService`**
- Attributes: `+String apiKey`
- Methods: `+identifyFromBytes(Uint8List imageBytes) PlantIdResult`

**Class: `GeminiService`**
- Attributes: `+String apiKey`
- Methods: `+getAyurvedicInfo(String plantName) GeminiResponse`, `+sendChat(String message, List~ChatTurn~ history) GeminiResponse`

**Class: `PlantIdResult`**
- Attributes: `+String scientificName`, `+String commonName`, `+double probability`, `+bool isHealthy`, `+String description`

**Class: `GeminiResponse`**
- Attributes: `+String text`, `+bool isError`

**Class: `ChatState`**
- Attributes: `+List~ChatMessage~ messages`, `+bool isTyping`, `+String error`
- Methods: `+copyWith()`

### Relationships

| From | Relationship | To | Label |
|------|-------------|-----|-------|
| `User` | Association (`-->`) | `Plant` | `scans and saves` |
| `PlantIdService` | Dependency (`..>`) | `PlantIdResult` | `returns` |
| `GeminiService` | Dependency (`..>`) | `Plant` | `hydrates data` |
| `GeminiService` | Dependency (`..>`) | `GeminiResponse` | `returns` |
| `ChatState` | Association (`-->`) | `GeminiService` | `uses` |

The dependency arrows (`..>`) indicate that `PlantIdService` and `GeminiService` create and return instances of their respective result classes without owning them. The association from `User` to `Plant` reflects that a user initiates scans and persists identified plants to their profile.

---

## 5. Activity Diagram — Plant Scan Workflow

**Source file:** `mermaid_diagrams/activity_diagram.mmd`
**Diagram type:** UML State/Activity Diagram (`stateDiagram-v2`)
**Blackbook chapter:** Chapter 6 — Project Design
**Placeholder asset:** `assets/placeholders/placeholder_activity.png`

### Purpose

The Activity Diagram traces the end-to-end lifecycle of a plant scanning session, from the user's initial tap on the Scan feature through image capture, compression, API submission, confidence evaluation, Gemini AI enrichment, and final persistence to Cloud Firestore. It makes explicit the conditional branching at the `PlantIdResponse` composite state, where the confidence threshold of 0.2 (probability) acts as the gate between a successful identification and an error-retry loop.

### Key Components

**States**
- `[*]` — initial pseudostate (entry point)
- `Dashboard` — the application's home screen; also the terminal state after scan completion
- `CameraInterface` — the live camera view through which the user frames the subject plant
- `ImageCaptured` — the state immediately after the user takes a photograph
- `Compressing` — the image pre-processing state where the captured image is downsampled and JPEG compressed
- `APIUpload` — the state during which the compressed Base64-encoded bytes are transmitted via HTTP POST to Plant.id
- `PlantIdResponse` — a composite state encapsulating the API response evaluation:
  - `[*] → CheckConfidence` — entry into the composite state
  - `CheckConfidence → ValidTaxonomy` — transition when probability ≥ 0.2
  - `CheckConfidence → Invalid` — transition when probability < 0.2
- `Invalid` — the error state that redirects the user back to `CameraInterface` for retry
- `ValidTaxonomy` — the accepted identification state carrying the plant's taxonomic name
- `QueryGemini` — the state during which a prompt is constructed from the taxonomy and dispatched to the Gemini API
- `DisplayResult` — the state in which the Gemini-generated Ayurvedic response is presented to the user
- `CloudFirestore` — the persistence state where the scan record is written to the user's history in Cloud Firestore

### Transitions

| From | Transition Trigger | To |
|------|------------------|----|
| Dashboard | `Tap Scan` | CameraInterface |
| CameraInterface | `User takes photo` | ImageCaptured |
| ImageCaptured | `Downsample and JPEG compress` | Compressing |
| Compressing | `Compressed Bytes in Base64` | APIUpload |
| APIUpload | `POST to Plant.id` | PlantIdResponse |
| CheckConfidence | `Probability above 0.2` | ValidTaxonomy |
| CheckConfidence | `Probability below 0.2` | Invalid |
| Invalid | `Show Error or Retry` | CameraInterface |
| ValidTaxonomy | `Prompt creation with Taxonomy` | QueryGemini |
| QueryGemini | `Gemini generates Ayurvedic response` | DisplayResult |
| DisplayResult | `Save to History` | CloudFirestore |
| CloudFirestore | `Finish` | Dashboard |

---

## 6. Sequence Diagram — Plant Identification Workflow

**Source file:** `mermaid_diagrams/sequence_diagram.mmd`
**Diagram type:** UML Sequence Diagram (`sequenceDiagram`)
**Blackbook chapter:** Chapter 6 — Project Design
**Placeholder asset:** `assets/placeholders/placeholder_sequence.png`

### Purpose

The Sequence Diagram illustrates the chronological message exchange between the five participating objects during a plant identification session. It captures the exact request–response pairs, the activation lifelines of each participant, and the temporal ordering of asynchronous HTTP calls. Where the Activity Diagram focuses on states and transitions within the system, the Sequence Diagram focuses on inter-object communication and timing, making it particularly useful for understanding integration contracts between the Flutter client and the three external services.

### Participants

| Alias in diagram | Full name |
|-----------------|-----------|
| `User` | User |
| `Flutter Client` | Flutter Client (the AyurSpace mobile application) |
| `Plant.id API` | Plant.id API (external classification service) |
| `Gemini API` | Gemini API (Google generative AI service) |
| `Cloud Firestore` | Cloud Firestore (Firebase NoSQL database) |

### Message Sequence

1. `User` → `Flutter Client` : `Tap Camera and Capture Image`
   - Flutter Client activation begins.
2. `Flutter Client` → `Flutter Client` (self-call) : `Downsample and Compress to Base64`
3. `Flutter Client` → `Plant.id API` : `POST base64_image`
   - Plant.id API activation begins.
4. `Plant.id API` → `Flutter Client` (return, dashed) : `Return plant classification JSON`
   - Plant.id API activation ends.
5. `Flutter Client` → `Flutter Client` (self-call) : `Extract top probability`
6. `Flutter Client` → `Gemini API` : `POST Prompt with PlantName`
   - Gemini API activation begins.
7. `Gemini API` → `Flutter Client` (return, dashed) : `Return AI text with Dosha and Uses`
   - Gemini API activation ends.
8. `Flutter Client` → `Cloud Firestore` : `Save scan history object`
   - Cloud Firestore activation begins.
9. `Cloud Firestore` → `Flutter Client` (return, dashed) : `Confirmation`
   - Cloud Firestore activation ends.
10. `Flutter Client` → `User` (return, dashed) : `Render Plant Details interface`
    - Flutter Client activation ends.

---

## 7. Gantt Chart — Project Timeline

**Source file:** `mermaid_diagrams/gantt_chart.mmd`
**Diagram type:** Gantt Chart (`gantt`)
**Blackbook chapter:** Chapter 4 — Plan of Project
**Placeholder asset:** `assets/placeholders/placeholder_gantt.png`

### Purpose

The Gantt Chart provides a visual schedule of the AyurSpace project from inception to final presentation, covering five development phases distributed across fourteen tasks. It communicates the planned duration of each task, the sequential and parallel dependencies between them, and the completion status of each phase at the time of documentation. The chart is titled **AyurSpace Project Timeline** and uses date format `YYYY-MM-DD` with axis labels formatted as `%b %d`.

### Key Components

**Section: Planning and Design** (all tasks marked `done`)

| Task ID | Task Name | Start Date | Duration |
|---------|-----------|-----------|---------|
| `des1` | Requirement Analysis | 2025-08-01 | 14 days |
| `des2` | UI/UX Design | 2025-08-15 | 21 days |
| `des3` | System Architecture | 2025-09-05 | 14 days |

**Section: Frontend Development** (Flutter Setup marked `active`; remaining pending)

| Task ID | Task Name | Start Date | Duration |
|---------|-----------|-----------|---------|
| `dev1` | Flutter Setup | 2025-09-20 | 7 days |
| `dev2` | Home and Scan UI | 2025-09-27 | 21 days |
| `dev3` | Chatbot Interface | 2025-10-18 | 14 days |
| `dev4` | Profile and Settings | 2025-11-01 | 10 days |

**Section: Backend and Integration** (all tasks pending)

| Task ID | Task Name | Start Date | Duration |
|---------|-----------|-----------|---------|
| `back1` | Firebase Auth and Database | 2025-11-15 | 14 days |
| `back2` | Plant.id API Integration | 2025-11-29 | 14 days |
| `back3` | Gemini API Integration | 2025-12-13 | 14 days |

**Section: Testing and Refinement** (all tasks pending)

| Task ID | Task Name | Start Date | Duration |
|---------|-----------|-----------|---------|
| `test1` | Unit and Integration Testing | 2025-12-27 | 21 days |
| `test2` | User Acceptance Testing | 2026-01-17 | 14 days |
| `test3` | Bug Fixing and Polish | 2026-01-31 | 14 days |

**Section: Deployment** (all tasks pending)

| Task ID | Task Name | Start Date | Duration |
|---------|-----------|-----------|---------|
| `deploy1` | App Store Submission | 2026-02-15 | 7 days |
| `deploy2` | Final Presentation | 2026-02-22 | 5 days |

The overall project spans from **2025-08-01** to **2026-02-27**, a duration of approximately seven months.

---

## 8. Application Flowchart

**Source file:** `mermaid_diagrams/flowchart.mmd`
**Diagram type:** Top-Down Flowchart (`graph TD`)
**Blackbook chapter:** Chapter 5 — Project Analysis
**Placeholder asset:** `assets/placeholders/placeholder_flowchart.png`

### Purpose

The Application Flowchart models the primary navigational and logical flow of the AyurSpace application from launch through the three core user journeys: Plant Scanning, AI Chat, and Tridosha Quiz. Unlike the sequence or activity diagrams, which focus on a single workflow in depth, the flowchart presents a breadth-first view of the entire user experience, making it suitable for communicating system behaviour to non-technical stakeholders. Decision nodes mark the two authentication checks and the three feature selection branches.

### Key Components

**Start/End nodes** (styled `startend` — orange-red)
- `App Start` — the terminal/initial node representing application launch.

**Decision nodes** (styled `decision` — yellow)
- `Is User Logged In?` — authentication guard evaluated at application start.
- `Select Action` — the branching node at the Home Dashboard for selecting a feature.
- `Confidence above 0.2?` — the confidence threshold check after plant photo processing.
- `Has Chat History?` — checks whether existing chat messages exist in Firestore.

**Process nodes** (styled `process` — purple)
- `Render Login Options` — presents authentication methods (email, Google).
- `Home Dashboard` — the central hub screen.
- `Launch Camera` — activates the device camera for plant scanning.
- `Show Error and Retry` — displays an error message and loops back to camera.
- `Fetch Gemini Data` — calls the Gemini API with the identified plant name.
- `Show Ayurvedic Properties` — renders the plant detail screen with Ayurvedic attributes.
- `Welcome Message` — shows the initial greeting for a new chat session.
- `Load Firestore stream` — resumes an existing chat session from Firestore.
- `Generate Response` — invokes the Gemini chat API and streams the reply.
- `Execute Dosha Assessment` — presents the 12-question Tridosha quiz.
- `Compute Predominant Score` — calculates which dosha (Vata, Pitta, or Kapha) is dominant.
- `Sync to Profile` — persists the computed dosha result to the user profile.

### Flow Logic

**Authentication path:**
- `App Start → Is User Logged In? — No → Render Login Options — Success → Home Dashboard`
- `App Start → Is User Logged In? — Yes → Home Dashboard`

**Scan path:**
- `Home Dashboard → Select Action — Tap Scan → Launch Camera → Confidence above 0.2? — Yes → Fetch Gemini Data → Show Ayurvedic Properties → Home Dashboard`
- `Confidence above 0.2? — No → Show Error and Retry → Launch Camera` (retry loop)

**Chat path:**
- `Home Dashboard → Select Action — Tap Chat → Has Chat History? — No → Welcome Message → Generate Response → Home Dashboard`
- `Has Chat History? — Yes → Load Firestore stream → Generate Response → Home Dashboard`

**Quiz path:**
- `Home Dashboard → Select Action — Tap Quiz → Execute Dosha Assessment → Compute Predominant Score → Sync to Profile → Home Dashboard`

---

## 9. UML Use Case Diagram

**Source file:** `mermaid_diagrams/use_case.mmd`
**Diagram type:** Use Case Diagram (`graph LR`)
**Blackbook chapter:** Chapter 5 — Project Analysis
**Placeholder asset:** `assets/placeholders/placeholder_use_case.png`

### Purpose

The Use Case Diagram identifies all actors that interact with the AyurSpace system and specifies the ten functional use cases available within the system boundary. It documents the include and extend relationships that govern how use cases delegate to or extend one another, and it maps each use case to the external API or service it depends upon. This diagram serves as the foundation for functional requirements elicitation and communicates the system's scope at the use-case level.

### Key Components

**Actors** (external to the system boundary)
- `Mobile User` — the primary human actor who initiates all user-facing interactions.
- `Plant.id API` — the external plant identification service.
- `Gemini API` — the external Google generative AI service.
- `Firebase Service` — the external authentication and database platform.

**System boundary:** `AyurSpace Application`

**Use Cases (UC1–UC10)**

| ID | Use Case Name |
|----|--------------|
| UC1 | Authenticate User |
| UC2 | Scan Plant Image |
| UC3 | Pre-process Image |
| UC4 | Identify Plant Taxonomy |
| UC5 | Fetch Ayurvedic Info |
| UC6 | Chat with AyurBot |
| UC7 | Take Tridosha Quiz |
| UC8 | View Scan History |
| UC9 | Update Profile |
| UC10 | Login |

### Relationships

**Mobile User initiates:**
- UC1 Authenticate User
- UC2 Scan Plant Image
- UC6 Chat with AyurBot
- UC7 Take Tridosha Quiz
- UC8 View Scan History
- UC9 Update Profile

**Include relationships** (the base use case always calls the included use case):

| Base Use Case | `include` | Included Use Case |
|--------------|----------|------------------|
| UC1 Authenticate User | → | UC10 Login |
| UC2 Scan Plant Image | → | UC3 Pre-process Image |
| UC2 Scan Plant Image | → | UC4 Identify Plant Taxonomy |
| UC6 Chat with AyurBot | → | UC10 Login |
| UC7 Take Tridosha Quiz | → | UC10 Login |
| UC8 View Scan History | → | UC10 Login |
| UC9 Update Profile | → | UC10 Login |

**Extend relationship** (the extending use case optionally augments the base):

| Base Use Case | `extend` | Extending Use Case |
|--------------|---------|------------------|
| UC4 Identify Plant Taxonomy | → | UC5 Fetch Ayurvedic Info |

**External system connections:**

| Use Case | External Actor |
|----------|---------------|
| UC4 Identify Plant Taxonomy | Plant.id API |
| UC5 Fetch Ayurvedic Info | Gemini API |
| UC6 Chat with AyurBot | Gemini API |
| UC1 Authenticate User | Firebase Service |
| UC8 View Scan History | Firebase Service |

The `include` relationship with UC10 (Login) across five use cases reflects the application-wide authentication guard — no feature is accessible without a valid session. The `extend` relationship from UC4 to UC5 captures the optional enrichment step: once a plant taxonomy is identified, Ayurvedic information is fetched from Gemini only when a valid taxonomy is returned.
