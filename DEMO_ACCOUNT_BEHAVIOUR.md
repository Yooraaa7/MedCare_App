# Demo account behaviour

The Firebase Authentication account `0188888888@medcare.local` is treated as the permanent demo patient.

It receives the original local sample appointments, sample notifications, primary doctor, and healthcare history dashboard. Firestore appointments created using this account are appended to those samples.

All other newly registered patients start with no appointments and no primary doctor. They see only appointments they create and that are stored with their own `patientUid`.
