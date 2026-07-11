# Required Firebase setup for the updated Flutter app

1. In Firebase Console, open **Authentication > Sign-in method**.
2. Enable **Email/Password** authentication. The app keeps the phone-number login UI and internally converts a phone such as `0123456789` to `0123456789@medcare.local`.
3. Existing Firestore users created by the old build do not have Firebase Authentication accounts. Register them again in the updated app, or create matching Authentication accounts manually.
4. Keep the existing `users`, `doctors`, and `appointments` collections.
5. The updated app automatically creates `appointmentSlots` documents for doctor bookings.
6. Each doctor document should preferably contain `active: true`. Missing `active` is also treated as active.
7. The admin portal should use the Firestore doctor document ID as the doctor ID. Do not create duplicate doctor records with the same person.

## Doctor fields expected by Flutter

- `nameEng`
- `nameChinese`
- `specialty` (must match a specialty in `assets/data/specialties.json`)
- `title`
- `qualification`
- `location`
- `contact`
- `languages` (array)
- `imagePath` (existing local asset filename)
- `weeklySchedule` (optional array)
- `holidayClosures` (optional array)
- `isBookable` (boolean)
- `isPrimary` (boolean)
- `remarks` (string)
- `active` (boolean)

## Important

Deploy Firestore Security Rules before production. Patients should only read their own appointments, while only authenticated admins should create, update, or delete doctor documents.
