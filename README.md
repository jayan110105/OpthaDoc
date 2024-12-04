# OpthaDoc - Ophthalmology EMR App  

**OpthaDoc** is a feature-rich **Flutter** application designed to serve as an Electronic Medical Record (EMR) system for ophthalmologists. Its dual-mode functionality ensures seamless operation in both offline and online environments, making it ideal for medical camps and hospitals.  

---

## Features  

### Modes of Operation  
1. **Camp Mode**  
   - Operates **offline**, suitable for remote medical camps with limited internet connectivity.  
   - **Key Features:**  
     - Patient registration.  
     - Eye checkup documentation.  
     - Viewing and editing records.  
   - **No Login Required:** Quick and straightforward access.  

2. **Hospital Mode**  
   - Requires admin-created accounts with a mandatory password change upon first login.  
   - **Advanced Functionalities:**  
     - Scheduling algorithm to distribute patient load efficiently.  
     - Syncs offline data from Camp Mode to the hospital's cloud database.  
   - Secure and hierarchical access for hospital workflows.  

---

## Technology Stack  

- **Frontend:** Built with **Flutter** for a cross-platform, responsive UI.  
- **Backend:**  
  - **Firebase** for real-time data management, authentication, and cloud storage.  
- **OCR Integration:**  
  - **Google ML Kit** for extracting patient data from Aadhaar cards during registration.  

---

## Getting Started  

### Prerequisites  
1. Install [Flutter](https://flutter.dev/docs/get-started/install) and ensure your development environment is set up.  
2. Configure a Firebase project and enable relevant services (Firestore, Authentication).  

### Installation  
1. Clone the repository:
   
   ```bash  
   git clone https://github.com/your-repo/OpthaDoc.git  
   cd OpthaDoc
   ```
2. Install dependencies:

  ```bash
  flutter pub get
  ```
3. Configure Firebase:

Add your Firebase configuration file (google-services.json for Android and GoogleService-Info.plist for iOS) to the project.

4. Run the application:

  ```bash
  flutter run  
