const {initializeApp, cert} = require("firebase-admin/app");
const {getFirestore} = require("firebase-admin/firestore");
const serviceAccount = require("./serviceAccountKey.json");

initializeApp({ credential: cert(serviceAccount) });
const db = getFirestore();

const vaccines = [
  { id: "vac_chicken_pox", name: "Chicken Pox",
    details: "Protects against varicella virus. Recommended for children and adults without prior infection.",
    location: "Vaccination Centre, Ground Floor", contact: "04-123 4567" },
  { id: "vac_dengue", name: "Dengue",
    details: "Live attenuated vaccine for dengue virus. Recommended in endemic areas, especially for children.",
    location: "Vaccination Centre, Ground Floor", contact: "04-123 4567" },
  { id: "vac_hep_a", name: "Hepatitis A - Adult (19 years and above)",
    details: "Prevents liver infection caused by hepatitis A virus. Two doses 6 months apart for adults.",
    location: "Vaccination Centre, Ground Floor", contact: "04-123 4567" },
  { id: "vac_hep_b", name: "Hepatitis B - Adult (20 years and above)",
    details: "Protects against hepatitis B virus. Three doses over 6 months. Essential for healthcare workers.",
    location: "Vaccination Centre, Ground Floor", contact: "04-123 4567" },
  { id: "vac_hpv", name: "Human Papilloma Virus",
    details: "Guards against HPV-related cancers. Most effective before sexual activity. Recommended for ages 9-45.",
    location: "Vaccination Centre, Ground Floor", contact: "04-123 4567" },
  { id: "vac_influenza", name: "Influenza",
    details: "Seasonal flu vaccine. Updated yearly. Recommended for everyone over 6 months of age.",
    location: "Vaccination Centre, Ground Floor", contact: "04-123 4567" },
  { id: "vac_japanese_enc", name: "Japanese Encephalitis",
    details: "Prevents mosquito-borne brain infection. Two doses, 28 days apart. Important for travelers to Asia.",
    location: "Vaccination Centre, Ground Floor", contact: "04-123 4567" },
  { id: "vac_mmr", name: "Measles, Mumps, Rubella",
    details: "MMR vaccine offers lifelong protection. Two doses recommended in childhood. Prevents viral outbreaks.",
    location: "Vaccination Centre, Ground Floor", contact: "04-123 4567" },
];

async function upload() {
  console.log(`Uploading ${vaccines.length} vaccines...\n`);
  for (const vac of vaccines) {
    await db.collection("vaccines").doc(vac.id).set(vac);
    console.log(`✅ Uploaded: ${vac.name}`);
  }
  console.log("\n🎉 All vaccines uploaded!");
  process.exit(0);
}

upload().catch(err => { console.error("❌ Error:", err.message); process.exit(1); });