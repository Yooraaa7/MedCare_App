const {initializeApp, cert} = require("firebase-admin/app");
const {getFirestore} = require("firebase-admin/firestore");
const serviceAccount = require("./serviceAccountKey.json");

initializeApp({ credential: cert(serviceAccount) });
const db = getFirestore();

// ── Our Packages ──────────────────────────────────────────────────────────────
const ourPackages = [
  { id: "pkg_dna_decode", name: "DNA Decode Genetic Screening", imagePath: "package1.png",
    category: "healthScreening", group: "our",
    subCategories: ["DNA Decode Fit", "DNA Decode Heritage", "DNA Decode Prevent"] },
  { id: "pkg_health_screening", name: "Health Screening Package", imagePath: "package2.png",
    category: "healthScreening", group: "our", subCategories: [] },
  { id: "pkg_cancer_markers", name: "Cancer Markers for Women and Men", imagePath: "package3.png",
    category: "healthScreening", group: "our", subCategories: [] },
  { id: "pkg_diabetes", name: "Diabetes Screening Package", imagePath: "package4.png",
    category: "healthScreening", group: "our", subCategories: [] },
  { id: "pkg_osteoporosis", name: "Osteoporosis Screening Package", imagePath: "package5.png",
    category: "healthScreening", group: "our", subCategories: [] },
  { id: "pkg_premarital", name: "Pre-marital Screening Package", imagePath: "package6.png",
    category: "healthScreening", group: "our", subCategories: [] },
  { id: "pkg_apolipo", name: "Apolipoprotein / Lipoprotein Studies", imagePath: "package7.png",
    category: "healthScreening", group: "our", subCategories: [] },
];

// ── Children Packages ─────────────────────────────────────────────────────────
const childrenPackages = [
  { id: "pkg_children_screening", name: "Children's Screening Package", imagePath: "package8.png",
    category: "healthScreening", group: "children", subCategories: [] },
  { id: "pkg_weight_mgmt", name: "Weight Management Wellness Screening", imagePath: "package9.png",
    category: "healthScreening", group: "children", subCategories: [] },
];

// ── Wellness Packages ─────────────────────────────────────────────────────────
const wellnessPackages = [
  { id: "pkg_proactive", name: "Proactive Lifestyle Screening", imagePath: "package10.png",
    category: "healthScreening", group: "wellness", subCategories: [] },
  { id: "pkg_cognitive", name: "Cognitive Screening Test", imagePath: "package11.png",
    category: "healthScreening", group: "wellness", subCategories: [] },
];

const allPackages = [...ourPackages, ...childrenPackages, ...wellnessPackages];

async function upload() {
  console.log(`Uploading ${allPackages.length} packages...\n`);
  for (const pkg of allPackages) {
    await db.collection("packages").doc(pkg.id).set(pkg);
    console.log(`✅ Uploaded: ${pkg.name} [${pkg.group}]`);
  }
  console.log("\n🎉 All packages uploaded!");
  process.exit(0);
}

upload().catch(err => { console.error("❌ Error:", err.message); process.exit(1); });