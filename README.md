# PresenSee App

PresenSee is a Flutter-based digital attendance application integrated with Firebase, Hive for local storage, Bloc for state management, and Cloudinary for image uploads. The app allows users to clock in only when they are physically located at the office premises.

---

## Getting Started

Follow these steps to run the app locally:

1. **Clone the repository:**

```bash
git clone https://github.com/fanes-setiawan/presen_see.git
cd presensee
```

2. **Install dependencies:**

```bash
flutter pub get
```

3. **Setup environment variables:**

```bash
CLOUDINARY_CLOUD_NAME=******
CLOUDINARY_UPLOAD_PRESET=******
```

4. **Run the app:**

```bash
flutter run
```