const admin = require("firebase-admin");
const serviceAccount = require("./serviceAccountKey.json");
const fs = require("fs");

// Load doctors.json
const raw = fs.readFileSync("./assets/data/doctors.json", "utf8");
const data = JSON.parse(raw);
const doctors = data.doctors;

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

const db = admin.firestore();

async function upload() {
  console.log(`Uploading ${doctors.length} doctors to Firestore...\n`);

  for (let i = 0; i < doctors.length; i++) {
    const doctor = doctors[i];

    // Generate a clean document ID from the doctor's name
    // e.g. "Dr. Tan Hau Tong" -> "dr_tan_hau_tong"
    const docId = doctor.nameEng
      .toLowerCase()
      .replace(/dr\.\s*/i, "dr_")
      .replace(/\s+/g, "_")
      .replace(/[^a-z0-9_]/g, "");

    // Add the generated ID into the document itself
    const doctorWithId = {
      id: docId,
      ...doctor,
    };

    await db.collection("doctors").doc(docId).set(doctorWithId);
    console.log(`✅ (${i + 1}/30) Uploaded: ${doctor.nameEng} → ID: ${docId}`);
  }

  console.log("\n🎉 All 30 doctors uploaded successfully!");
  process.exit(0);
}

upload().catch((err) => {
  console.error("❌ Error:", err.message);
  process.exit(1);
});