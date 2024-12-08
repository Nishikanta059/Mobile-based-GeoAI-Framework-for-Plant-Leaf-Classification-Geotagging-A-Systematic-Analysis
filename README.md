# Mobile based GeoAI Framework for Plant Leaf Classification & Geotagging: A Systematic Analysis

**Authors:** N. Parida, D. K. Dalei, and N. Panigrahi  
**Conference:** 2023 14th International Conference on Computing Communication and Networking Technologies (ICCCNT)  
**Location:** Delhi, India  
**Year:** 2023  
**Pages:** 1-6  
**DOI:** [10.1109/ICCCNT56998.2023.10306809](https://doi.org/10.1109/ICCCNT56998.2023.10306809)  
**URL:** [IEEE Xplore Link](https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=10306809&isnumber=10306339)

---

## Demo
![TreeMap](https://github.com/user-attachments/assets/5fafc2c5-7803-437e-8aef-715e004161c6)

https://github.com/user-attachments/assets/f15be7a0-1d78-428a-9bb3-fb779a56cfd1



## Abstract

Plants are critical for sustaining life on Earth by providing food and oxygen necessary for living beings. With an abundance of plant species, biologists, researchers, and nature lovers continuously study and analyze these species. Plants have been sources of food and medicine throughout human history, with the medicinal values of plants being a key area of research for discovering new drugs. Moreover, the use of edible leaves for food in critical situations such as military operations and civilian activities like trekking has significant potential.

The leaf is one of the most crucial parts of a plant that carries essential information for plant identification and characterization. While other parts such as flowers and fruits are also studied, they are not as extensively researched. Leaf classification plays a vital role in creating comprehensive plant databases, aiding in identification and management. Modern approaches to plant identification now leverage machine learning and deep learning techniques to accelerate data collection and analysis.

This paper explores the design of a mobile-based GeoAI system, where users can capture images of leaves using their mobile devices, and instantly analyze the characteristics of the leaves on the device. The study focuses on the design and implementation of the system, from the Android application to the backend server module. A comprehensive analysis of various CNN models for leaf classification is also presented. A prototype system has been developed to demonstrate the complete workflow of this GeoAI system.

---

## System Architecture

### Prototype System Design

The system is designed with a client-server model. The **client module** operates on an Android-based platform, while the **server module** handles the storage and processing of the leaf dataset. The architecture is divided into the following components:

- **Mobile Client**: Captures leaf images using the device camera and sends them to the backend server.
- **AppServer**: Stores leaf images and their associated location information. It also handles communication between the mobile client and the GeoAI server.
- **GeoAI Server**: Processes leaf images using deep learning models (CNNs) for classification and returns results to the AppServer.

### Workflow

1. **Mobile Client**: The user captures an image of a leaf using the mobile camera. The image is sent to the **AppServer**.
2. **AppServer**: The image is stored in Firebase Firestore (a NoSQL database), and a cloud function triggers the transfer of the image data to the **GeoAI Server**.
3. **GeoAI Server**: The server processes the image through two deep learning models:
   - **U2Net**: For image masking.
   - **ResNet50**: For leaf classification.
4. **Results**: The classification results, including the class name and confidence factor, are sent back to Firebase and displayed to the user.

### Key Components

#### 1. **AppServer** (Firebase)
- **Firebase Firestore**: Stores metadata (location, classification results) for each leaf image.
- **Firebase Storage**: Stores images received from both the client and the GeoAI server.
- **Firebase Cloud Function**: Triggers the image data transfer to the GeoAI server for classification.

#### 2. **GeoAI Server**
- **Flask (Python)**: A micro web framework used to host the server.
- **Deep Learning Models**:
  - **U2Net**: For image masking.
  - **ResNet50**: For leaf classification, trained on multiple datasets.
- **Ngrok**: Allows the local machine to be accessed over the internet, enabling remote processing.

#### 3. **Mobile Client**
- **Flutter Framework**: A cross-platform mobile app that works on Android, iOS, and web browsers.
- **Key Libraries**:
  - **Firebase**: For cloud-based storage and communication.
  - **Image Picker**: For capturing images from the camera or gallery.
  - **GPS Location**: To capture the geographic location of the leaf.
  - **Google Maps**: To display location information on a map.

---

## Leaf Classification Using CNN Models

The core task of plant identification revolves around leaf classification, which involves extracting key features such as leaf shape, texture, and color. While traditional machine learning methods require manual feature extraction, deep learning approaches—specifically **Convolutional Neural Networks (CNNs)**—automate this process, resulting in faster and more accurate classifications.

### Models Used

1. **ResNet50**: A deep learning model with high accuracy for image classification tasks, used to classify leaf types.
2. **U2Net**: A deep learning model designed for image segmentation, specifically used for image masking before classification.

---
