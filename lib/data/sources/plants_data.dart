import '../models/plant.dart';

/// Static plant data - 30 Ayurvedic medicinal plants
/// Ported from React Native plants.json
final List<Plant> plantsData = [
  const Plant(
    id: '1',
    name: 'Tulsi',
    hindi: 'तुलसी',
    scientificName: 'Ocimum sanctum',
    image:
        'https://commons.wikimedia.org/wiki/Special:FilePath/Ocimum_tenuiflorum.jpg',
    doshas: ['Vata', 'Kapha'],
    benefits: ['Immunity', 'Respiratory', 'Stress Relief'],
    rating: 4.8,
    category: 'Herbs',
    difficulty: 'Easy',
    season: ['Summer', 'Monsoon'],
    description:
        "Holy Basil, known as the 'Queen of Herbs', is one of the most sacred plants in India. It has powerful adaptogenic, antimicrobial, and immunomodulatory properties.",
    uses: [
      'Common cold and cough',
      'Fever reduction',
      'Stress and anxiety relief',
      'Digestive disorders',
      'Skin problems'
    ],
    dosage: '5-10 fresh leaves daily or 300-600mg extract twice daily',
    precautions: 'Avoid during pregnancy. May lower blood sugar levels.',
    growingTips:
        'Grows well in warm climate with well-drained soil. Requires 6-8 hours of sunlight daily.',
    harvestTime: '90-120 days after planting',
  ),
  const Plant(
    id: '2',
    name: 'Ashwagandha',
    hindi: 'अश्वगंधा',
    scientificName: 'Withania somnifera',
    image:
        'https://commons.wikimedia.org/wiki/Special:FilePath/Withania_somnifera.jpg',
    doshas: ['Vata', 'Kapha'],
    benefits: ['Energy', 'Stress', 'Sleep'],
    rating: 4.9,
    category: 'Roots',
    difficulty: 'Medium',
    season: ['Winter', 'Spring'],
    description:
        "Known as 'Indian Ginseng', Ashwagandha is a powerful adaptogen that helps the body manage stress, boost energy, and improve concentration.",
    uses: [
      'Chronic stress and fatigue',
      'Anxiety and depression',
      'Insomnia',
      'Memory enhancement',
      'Muscle strength'
    ],
    dosage: '300-500mg of root extract twice daily with meals',
    precautions:
        'Avoid during pregnancy and hyperthyroidism. May interact with sedatives.',
    growingTips:
        'Prefers dry regions with well-drained sandy loam soil. Drought tolerant once established.',
    harvestTime: '150-180 days for root harvest',
  ),
  const Plant(
    id: '3',
    name: 'Neem',
    hindi: 'नीम',
    scientificName: 'Azadirachta indica',
    image:
        'https://commons.wikimedia.org/wiki/Special:FilePath/Azadirachta_indica_NP.JPG',
    doshas: ['Pitta', 'Kapha'],
    benefits: ['Skin', 'Blood Purifier', 'Antibacterial'],
    rating: 4.7,
    category: 'Bark',
    difficulty: 'Easy',
    season: ['All Seasons'],
    description:
        "Neem is called 'Nature's Pharmacy' for its extensive medicinal properties. Every part of the neem tree has therapeutic value, particularly for skin and blood purification.",
    uses: [
      'Skin infections and acne',
      'Dental health',
      'Blood purification',
      'Diabetes management',
      'Wound healing'
    ],
    dosage: '2-4 leaves daily or 500mg extract twice daily',
    precautions:
        'Avoid during pregnancy and in children. May affect fertility.',
    growingTips:
        'Hardy tree that grows in tropical and subtropical climates. Tolerates poor soil and drought.',
    harvestTime: 'Leaves can be harvested year-round',
  ),
  const Plant(
    id: '4',
    name: 'Turmeric',
    hindi: 'हल्दी',
    scientificName: 'Curcuma longa',
    image:
        'https://commons.wikimedia.org/wiki/Special:FilePath/Curcuma_longa_roots.jpg',
    doshas: ['Kapha', 'Vata'],
    benefits: ['Anti-inflammatory', 'Digestion', 'Immunity'],
    rating: 4.9,
    category: 'Roots',
    difficulty: 'Medium',
    season: ['All Seasons'],
    description:
        'Golden Spice of India, turmeric contains curcumin, a powerful anti-inflammatory and antioxidant compound used for thousands of years in Ayurvedic medicine.',
    uses: [
      'Arthritis and joint pain',
      'Digestive issues',
      'Liver support',
      'Wound healing',
      'Immune enhancement'
    ],
    dosage:
        '500-1000mg of curcumin extract daily with black pepper for absorption',
    precautions:
        'May interact with blood thinners. High doses can cause digestive upset.',
    growingTips:
        'Requires warm, humid climate with well-drained, fertile soil. Grows from rhizomes.',
    harvestTime: '7-10 months after planting',
  ),
  const Plant(
    id: '5',
    name: 'Brahmi',
    hindi: 'ब्राह्मी',
    scientificName: 'Bacopa monnieri',
    image:
        'https://commons.wikimedia.org/wiki/Special:FilePath/Bacopa_monnieri_leaf1_(8405968839).jpg',
    doshas: ['Pitta', 'Kapha'],
    benefits: ['Memory', 'Focus', 'Brain Health'],
    rating: 4.6,
    category: 'Herbs',
    difficulty: 'Easy',
    season: ['Summer', 'Monsoon'],
    description:
        "Brahmi is a renowned brain tonic in Ayurveda, known for enhancing memory, learning, and cognitive function. It's also called 'herb of grace'.",
    uses: [
      'Memory enhancement',
      'ADHD and learning difficulties',
      'Anxiety and stress',
      'Epilepsy support',
      'Hair growth'
    ],
    dosage: '300-450mg extract daily or 5-10 fresh leaves',
    precautions:
        'May cause digestive upset initially. Avoid with thyroid medications.',
    growingTips:
        'Aquatic plant that grows in wetlands. Requires constant moisture and partial shade.',
    harvestTime: '60-90 days, can be harvested multiple times',
  ),
  const Plant(
    id: '6',
    name: 'Amla',
    hindi: 'आंवला',
    scientificName: 'Phyllanthus emblica',
    image:
        'https://commons.wikimedia.org/wiki/Special:FilePath/Phyllanthus_emblica_fruit_01.jpg',
    doshas: ['Pitta', 'Kapha'],
    benefits: ['Vitamin C', 'Hair', 'Digestion'],
    rating: 4.8,
    category: 'Fruits',
    difficulty: 'Medium',
    season: ['Winter'],
    description:
        "Indian Gooseberry, richest natural source of Vitamin C. Known as 'Amrit Phal' (fruit of immortality), it's a powerful rejuvenator and antioxidant.",
    uses: [
      'Hair growth and graying prevention',
      'Immunity boost',
      'Digestive health',
      'Eye health',
      'Skin rejuvenation'
    ],
    dosage: '1-2 fresh fruits daily or 500-1000mg powder with water',
    precautions:
        'May lower blood sugar. Excessive consumption can cause constipation.',
    growingTips:
        'Grows in tropical and subtropical regions. Requires well-drained soil and full sunlight.',
    harvestTime: 'Fruits ripen in winter, 3-4 years after planting',
  ),
  const Plant(
    id: '7',
    name: 'Giloy',
    hindi: 'गिलोय',
    scientificName: 'Tinospora cordifolia',
    image:
        'https://commons.wikimedia.org/wiki/Special:FilePath/Tinospora_cordifolia.jpg',
    doshas: ['Vata', 'Pitta', 'Kapha'],
    benefits: ['Fever', 'Immunity', 'Detox'],
    rating: 4.7,
    category: 'Herbs',
    difficulty: 'Easy',
    season: ['All Seasons'],
    description:
        "Divine nectar or 'Amrita', Giloy is a powerful immunomodulator and antipyretic. It's tridoshic, meaning it balances all three doshas.",
    uses: [
      'Chronic fever and dengue',
      'Immunity enhancement',
      'Diabetes management',
      'Arthritis and gout',
      'Liver detoxification'
    ],
    dosage: '2-3 teaspoons of fresh stem juice or 500mg powder twice daily',
    precautions: 'May lower blood sugar levels. Avoid with immunosuppressants.',
    growingTips:
        'Climbing shrub that grows well in tropical climate. Can grow on other trees.',
    harvestTime: 'Stems can be harvested year-round',
  ),
  const Plant(
    id: '8',
    name: 'Shatavari',
    hindi: 'शतावरी',
    scientificName: 'Asparagus racemosus',
    image:
        'https://commons.wikimedia.org/wiki/Special:FilePath/Asparagus_racemosus_plant.JPG',
    doshas: ['Vata', 'Pitta'],
    benefits: ["Women's Health", 'Digestive', 'Immunity'],
    rating: 4.6,
    category: 'Roots',
    difficulty: 'Medium',
    season: ['Winter', 'Spring'],
    description:
        "Queen of herbs for women, Shatavari means 'she who possesses 100 husbands'. It's a supreme female reproductive tonic and adaptogen.",
    uses: [
      'Female reproductive health',
      'Lactation support',
      'Menopausal symptoms',
      'Digestive ulcers',
      'Immune system'
    ],
    dosage: '500-1000mg powder twice daily with milk or water',
    precautions: 'Avoid if allergic to asparagus. May affect hormone levels.',
    growingTips:
        'Grows in rocky, gravelly soils in tropical and subtropical regions. Drought resistant.',
    harvestTime: '18-24 months for root harvest',
  ),
  const Plant(
    id: '9',
    name: 'Triphala',
    hindi: 'त्रिफला',
    scientificName: 'Terminalia chebula mix',
    image:
        'https://commons.wikimedia.org/wiki/Special:FilePath/Terminalia_chebula.jpg',
    doshas: ['Vata', 'Pitta', 'Kapha'],
    benefits: ['Digestion', 'Detox', 'Eye Health'],
    rating: 4.8,
    category: 'Fruits',
    difficulty: 'Easy',
    season: ['All Seasons'],
    description:
        "Triphala is a combination of three fruits (Haritaki, Bibhitaki, Amalaki). It's one of the most important formulations in Ayurveda for gentle detoxification.",
    uses: [
      'Constipation and digestive issues',
      'Colon cleansing',
      'Eye health',
      'Weight management',
      'Antioxidant support'
    ],
    dosage:
        '1-2 teaspoons powder at night with warm water or 500-1000mg tablets',
    precautions:
        'Avoid during pregnancy and diarrhea. May cause loose stools initially.',
    growingTips:
        'Combination of three fruits from different trees requiring tropical climate.',
    harvestTime: 'Individual fruits harvested at different seasons',
  ),
  const Plant(
    id: '10',
    name: 'Ginger',
    hindi: 'अदरक',
    scientificName: 'Zingiber officinale',
    image:
        'https://commons.wikimedia.org/wiki/Special:FilePath/Zingiber_officinale.JPG',
    doshas: ['Vata', 'Kapha'],
    benefits: ['Digestion', 'Nausea', 'Anti-inflammatory'],
    rating: 4.9,
    category: 'Roots',
    difficulty: 'Easy',
    season: ['All Seasons'],
    description:
        'Universal medicine in Ayurveda, ginger is a powerful digestive stimulant and anti-inflammatory agent. Fresh and dry forms have different properties.',
    uses: [
      'Nausea and morning sickness',
      'Digestive disorders',
      'Cold and flu',
      'Arthritis pain',
      'Motion sickness'
    ],
    dosage: '1-3 grams fresh or 250-500mg dried powder 2-3 times daily',
    precautions:
        'May interact with blood thinners. High doses can cause heartburn.',
    growingTips:
        'Grows in warm, humid climates with rich, well-drained soil. Partial shade preferred.',
    harvestTime: '8-10 months after planting',
  ),
  const Plant(
    id: '11',
    name: 'Aloe Vera',
    hindi: 'घृतकुमारी',
    scientificName: 'Aloe barbadensis',
    image: 'https://commons.wikimedia.org/wiki/Special:FilePath/Aloe_vera.jpg',
    doshas: ['Pitta', 'Kapha'],
    benefits: ['Skin', 'Digestion', 'Cooling'],
    rating: 4.6,
    category: 'Herbs',
    difficulty: 'Easy',
    season: ['Summer'],
    description:
        "Nature's cooling gel, Aloe Vera is excellent for skin care and digestive health. It contains over 75 active compounds including vitamins and enzymes.",
    uses: [
      'Skin burns and wounds',
      'Digestive issues',
      'Diabetes management',
      'Dental health',
      'Hair conditioning'
    ],
    dosage: '2-3 tablespoons fresh gel or 50-200mg aloin daily',
    precautions: 'Latex can cause cramping. Avoid oral use during pregnancy.',
    growingTips:
        'Succulent plant requiring minimal water and well-drained soil. Full to partial sun.',
    harvestTime: 'Outer leaves can be harvested after 3-4 years',
  ),
  const Plant(
    id: '12',
    name: 'Moringa',
    hindi: 'सहजन',
    scientificName: 'Moringa oleifera',
    image:
        'https://commons.wikimedia.org/wiki/Special:FilePath/Moringa_Oleifera.jpg',
    doshas: ['Vata', 'Kapha'],
    benefits: ['Nutrition', 'Energy', 'Immunity'],
    rating: 4.7,
    category: 'Herbs',
    difficulty: 'Easy',
    season: ['All Seasons'],
    description:
        'Miracle tree packed with vitamins, minerals, and amino acids. Moringa leaves contain more vitamin C than oranges and more calcium than milk.',
    uses: [
      'Nutritional deficiency',
      'Energy boost',
      'Blood sugar regulation',
      'Lactation support',
      'Inflammation'
    ],
    dosage: '1-2 teaspoons leaf powder daily or 400mg capsules twice daily',
    precautions: 'Generally safe. High doses may cause digestive upset.',
    growingTips:
        'Fast-growing tree thriving in tropical and subtropical climates. Drought tolerant.',
    harvestTime: 'Leaves can be harvested year-round after 8 months',
  ),
  const Plant(
    id: '13',
    name: 'Licorice',
    hindi: 'मुलेठी',
    scientificName: 'Glycyrrhiza glabra',
    image:
        'https://commons.wikimedia.org/wiki/Special:FilePath/Glycyrrhiza_glabra_Y01.jpg',
    doshas: ['Vata', 'Pitta'],
    benefits: ['Respiratory', 'Throat', 'Stress Relief'],
    rating: 4.5,
    category: 'Roots',
    difficulty: 'Medium',
    season: ['Winter', 'Spring'],
    description:
        "Sweet root with powerful soothing properties for respiratory and digestive systems. It's also an excellent adaptogen and demulcent.",
    uses: [
      'Cough and sore throat',
      'Peptic ulcers',
      'Adrenal fatigue',
      'Skin inflammation',
      'Menopausal symptoms'
    ],
    dosage: '1-2 grams root powder or 250-500mg extract twice daily',
    precautions:
        'Long-term use may raise blood pressure. Avoid with heart disease and during pregnancy.',
    growingTips:
        'Perennial plant requiring deep, fertile soil. Prefers temperate climate.',
    harvestTime: '3-4 years for root harvest',
  ),
  const Plant(
    id: '14',
    name: 'Fenugreek',
    hindi: 'मेथी',
    scientificName: 'Trigonella foenum-graecum',
    image:
        'https://commons.wikimedia.org/wiki/Special:FilePath/Trigonella_foenum-graecum.jpg',
    doshas: ['Kapha', 'Vata'],
    benefits: ['Digestion', 'Lactation', 'Blood Sugar'],
    rating: 4.4,
    category: 'Seeds',
    difficulty: 'Easy',
    season: ['Winter'],
    description:
        "Fenugreek seeds are packed with fiber and nutrients. They're particularly valued for supporting milk production in nursing mothers and blood sugar control.",
    uses: [
      'Diabetes management',
      'Lactation enhancement',
      'Digestive health',
      'Testosterone support',
      'Hair growth'
    ],
    dosage: '2-5 grams seeds soaked overnight or 500-600mg extract twice daily',
    precautions:
        'May cause maple syrup odor in urine. Avoid during pregnancy (can induce contractions).',
    growingTips:
        'Annual plant growing in cool season. Requires well-drained soil and full sun.',
    harvestTime: '90-120 days for seed harvest',
  ),
  const Plant(
    id: '15',
    name: 'Arjuna',
    hindi: 'अर्जुन',
    scientificName: 'Terminalia arjuna',
    image:
        'https://commons.wikimedia.org/wiki/Special:FilePath/Terminalia_arjuna.jpg',
    doshas: ['Pitta', 'Kapha'],
    benefits: ['Heart Health', 'Blood Pressure', 'Cholesterol'],
    rating: 4.7,
    category: 'Bark',
    difficulty: 'Medium',
    season: ['All Seasons'],
    description:
        'Heart tonic par excellence, Arjuna bark strengthens the heart muscle, regulates blood pressure, and supports cardiovascular health.',
    uses: [
      'Heart disease',
      'High blood pressure',
      'High cholesterol',
      'Angina',
      'Heart failure support'
    ],
    dosage: '500-1000mg bark powder twice daily or as heart tonic tea',
    precautions:
        'May interact with heart medications. Consult doctor before use.',
    growingTips:
        'Large evergreen tree growing near rivers and streams. Requires moist soil.',
    harvestTime: 'Bark collected from mature trees',
  ),
  const Plant(
    id: '16',
    name: 'Guggul',
    hindi: 'गुग्गुल',
    scientificName: 'Commiphora wightii',
    image:
        'https://commons.wikimedia.org/wiki/Special:FilePath/Commiphora_wightii.jpg',
    doshas: ['Kapha', 'Vata'],
    benefits: ['Cholesterol', 'Weight Loss', 'Joint Health'],
    rating: 4.5,
    category: 'Herbs',
    difficulty: 'Medium',
    season: ['Winter'],
    description:
        'Guggul resin has been used for centuries for its cholesterol-lowering and anti-inflammatory properties.',
    uses: [
      'High cholesterol',
      'Weight loss',
      'Arthritis',
      'Hypothyroidism',
      'Acne'
    ],
    dosage: '500-1000mg extract twice daily',
    precautions:
        'May interact with thyroid medications. Avoid during pregnancy.',
    growingTips:
        'Grows in arid regions with rocky soils. Drought-resistant thorny shrub.',
    harvestTime: 'Resin collected by tapping the bark',
  ),
  const Plant(
    id: '17',
    name: 'Haritaki',
    hindi: 'हरड़',
    scientificName: 'Terminalia chebula',
    image:
        'https://commons.wikimedia.org/wiki/Special:FilePath/Terminalia_chebula.jpg',
    doshas: ['Vata', 'Pitta', 'Kapha'],
    benefits: ['Digestion', 'Detox', 'Brain Health'],
    rating: 4.7,
    category: 'Fruits',
    difficulty: 'Medium',
    season: ['All Seasons'],
    description:
        'King of medicines in Ayurveda, Haritaki is one-third of Triphala. Revered for rejuvenating properties.',
    uses: [
      'Constipation',
      'Digestive disorders',
      'Cognitive enhancement',
      'Wound healing',
      'Detox'
    ],
    dosage: '3-6 grams powder or 500-1000mg extract daily',
    precautions: 'May cause loose stools. Avoid during pregnancy.',
    growingTips: 'Large deciduous tree growing in tropical regions.',
    harvestTime: 'Fruits ripen in winter months',
  ),
  const Plant(
    id: '18',
    name: 'Bibhitaki',
    hindi: 'बहेड़ा',
    scientificName: 'Terminalia bellirica',
    image:
        'https://commons.wikimedia.org/wiki/Special:FilePath/Terminalia_bellirica.jpg',
    doshas: ['Kapha', 'Pitta'],
    benefits: ['Respiratory', 'Detox', 'Hair'],
    rating: 4.5,
    category: 'Fruits',
    difficulty: 'Medium',
    season: ['All Seasons'],
    description:
        'One of three fruits in Triphala, excellent for respiratory health and removing excess mucus.',
    uses: [
      'Respiratory congestion',
      'Hair growth',
      'Eye health',
      'Diarrhea',
      'Throat infections'
    ],
    dosage: '3-6 grams powder or 500mg extract twice daily',
    precautions: 'Generally safe. May cause dry mouth.',
    growingTips: 'Large tree preferring tropical climate.',
    harvestTime: 'Fruits mature in late winter',
  ),
  const Plant(
    id: '19',
    name: 'Shankhpushpi',
    hindi: 'शंखपुष्पी',
    scientificName: 'Convolvulus pluricaulis',
    image:
        'https://commons.wikimedia.org/wiki/Special:FilePath/Evolvulus_prostratus_(Convolvulaceae)_III.jpg',
    doshas: ['Pitta', 'Kapha'],
    benefits: ['Memory', 'Brain Health', 'Sleep'],
    rating: 4.6,
    category: 'Flowers',
    difficulty: 'Medium',
    season: ['Summer', 'Monsoon'],
    description:
        'Brain tonic and memory enhancer that calms the mind and reduces anxiety.',
    uses: [
      'Memory enhancement',
      'Anxiety and stress',
      'Insomnia',
      'Hypertension',
      'Mental fatigue'
    ],
    dosage: '3-6 grams powder or 300-500mg extract twice daily',
    precautions: 'May enhance effects of sedatives.',
    growingTips: 'Perennial herb growing in sandy loam soil.',
    harvestTime: 'Whole plant harvested during flowering',
  ),
  const Plant(
    id: '20',
    name: 'Manjistha',
    hindi: 'मंजिष्ठा',
    scientificName: 'Rubia cordifolia',
    image:
        'https://commons.wikimedia.org/wiki/Special:FilePath/Rubia_cordifolia.jpg',
    doshas: ['Pitta', 'Kapha'],
    benefits: ['Blood Purifier', 'Skin', 'Lymphatic'],
    rating: 4.5,
    category: 'Roots',
    difficulty: 'Hard',
    season: ['Monsoon'],
    description:
        'Supreme blood purifier and lymphatic tonic with powerful detoxifying properties.',
    uses: [
      'Skin disorders',
      'Blood purification',
      'Lymphatic drainage',
      'Wound healing'
    ],
    dosage: '1-3 grams powder twice daily',
    precautions: 'May cause red urine (harmless). Avoid during pregnancy.',
    growingTips: 'Climbing plant growing in hilly regions.',
    harvestTime: 'Roots harvested after 2-3 years',
  ),
  const Plant(
    id: '21',
    name: 'Punarnava',
    hindi: 'पुनर्नवा',
    scientificName: 'Boerhavia diffusa',
    image:
        'https://commons.wikimedia.org/wiki/Special:FilePath/Boerhavia_diffusa.jpg',
    doshas: ['Kapha', 'Pitta'],
    benefits: ['Kidney', 'Urinary', 'Anti-inflammatory'],
    rating: 4.4,
    category: 'Herbs',
    difficulty: 'Medium',
    season: ['Monsoon'],
    description:
        "Rejuvenator meaning 'makes the body new again'. Excellent for kidney health.",
    uses: [
      'Kidney disorders',
      'UTI',
      'Edema',
      'Joint inflammation',
      'Liver support'
    ],
    dosage: '3-6 grams powder or 500mg extract twice daily',
    precautions: 'Monitor if on diuretics.',
    growingTips: 'Hardy weed growing in tropical regions.',
    harvestTime: 'Whole plant harvested during monsoon',
  ),
  const Plant(
    id: '22',
    name: 'Gokshura',
    hindi: 'गोखरू',
    scientificName: 'Tribulus terrestris',
    image:
        'https://commons.wikimedia.org/wiki/Special:FilePath/Tribulus_terrestris_fruit.jpg',
    doshas: ['Vata', 'Pitta'],
    benefits: ['Urinary', 'Reproductive', 'Kidney'],
    rating: 4.5,
    category: 'Herbs',
    difficulty: 'Medium',
    season: ['Summer'],
    description:
        'Aphrodisiac and kidney tonic for urinary tract health and reproductive function.',
    uses: [
      'Urinary tract health',
      'Kidney stones',
      'Reproductive vitality',
      'Muscle building'
    ],
    dosage: '500-1000mg extract or 3-6 grams powder twice daily',
    precautions: 'May affect hormone levels.',
    growingTips: 'Annual herb growing in dry, sandy areas.',
    harvestTime: 'Fruits harvested when mature',
  ),
  const Plant(
    id: '23',
    name: 'Pippali',
    hindi: 'पिप्पली',
    scientificName: 'Piper longum',
    image:
        'https://commons.wikimedia.org/wiki/Special:FilePath/Piper_longum.jpg',
    doshas: ['Vata', 'Kapha'],
    benefits: ['Respiratory', 'Digestion', 'Immunity'],
    rating: 4.6,
    category: 'Herbs',
    difficulty: 'Medium',
    season: ['Winter'],
    description:
        'Long pepper with powerful bioavailability-enhancing properties.',
    uses: [
      'Chronic cough',
      'Digestive fire',
      'Weight loss',
      'Joint pain',
      'Immunity'
    ],
    dosage: '250-500mg powder with honey',
    precautions: 'Heating herb, avoid in high Pitta.',
    growingTips: 'Climbing vine in tropical regions.',
    harvestTime: 'Spikes harvested when green',
  ),
  const Plant(
    id: '24',
    name: 'Jatamansi',
    hindi: 'जटामांसी',
    scientificName: 'Nardostachys jatamansi',
    image:
        'https://commons.wikimedia.org/wiki/Special:FilePath/Nardostachys_grandiflora.jpg',
    doshas: ['Vata', 'Pitta'],
    benefits: ['Sleep', 'Stress', 'Memory'],
    rating: 4.5,
    category: 'Roots',
    difficulty: 'Hard',
    season: ['Winter'],
    description:
        'Powerful nervine and brain tonic that calms the mind and promotes restful sleep.',
    uses: [
      'Insomnia',
      'Anxiety',
      'Memory enhancement',
      'Epilepsy support',
      'Hair growth'
    ],
    dosage: '1-3 grams powder or 250-500mg extract before bed',
    precautions: 'May enhance sedative effects.',
    growingTips: 'High-altitude plant in Himalayas.',
    harvestTime: 'Rhizomes harvested after 3-5 years',
  ),
  const Plant(
    id: '25',
    name: 'Bala',
    hindi: 'बला',
    scientificName: 'Sida cordifolia',
    image:
        'https://commons.wikimedia.org/wiki/Special:FilePath/Sida_cordifolia.jpg',
    doshas: ['Vata', 'Pitta'],
    benefits: ['Strength', 'Energy', 'Muscle Health'],
    rating: 4.4,
    category: 'Herbs',
    difficulty: 'Medium',
    season: ['Summer'],
    description:
        "Country mallow renowned for building strength (Bala means 'strength').",
    uses: [
      'Muscle weakness',
      'Nervous system support',
      'Heart tonic',
      'Chronic fatigue'
    ],
    dosage: '3-6 grams powder or 500mg extract twice daily with milk',
    precautions: 'Avoid with heart conditions and high BP.',
    growingTips: 'Perennial shrub in tropical regions.',
    harvestTime: 'Roots and leaves from mature plants',
  ),
  const Plant(
    id: '26',
    name: 'Kutki',
    hindi: 'कुटकी',
    scientificName: 'Picrorhiza kurroa',
    image:
        'https://commons.wikimedia.org/wiki/Special:FilePath/Picrorhiza_kurroa.jpg',
    doshas: ['Pitta', 'Kapha'],
    benefits: ['Liver', 'Digestion', 'Fever'],
    rating: 4.6,
    category: 'Roots',
    difficulty: 'Hard',
    season: ['Winter'],
    description:
        'Powerful liver protectant and bitter tonic for digestive health.',
    uses: [
      'Liver disorders',
      'Fever',
      'Jaundice',
      'Digestive issues',
      'Skin conditions'
    ],
    dosage: '1-3 grams powder or 250-500mg extract',
    precautions: 'Very bitter. Avoid during pregnancy.',
    growingTips: 'Alpine plant growing in Himalayas.',
    harvestTime: 'Rhizomes harvested in autumn',
  ),
  const Plant(
    id: '27',
    name: 'Vacha',
    hindi: 'वचा',
    scientificName: 'Acorus calamus',
    image:
        'https://commons.wikimedia.org/wiki/Special:FilePath/Acorus-calamus1.jpg',
    doshas: ['Kapha', 'Vata'],
    benefits: ['Brain Health', 'Speech', 'Memory'],
    rating: 4.5,
    category: 'Roots',
    difficulty: 'Hard',
    season: ['Monsoon'],
    description: 'Calamus root is a powerful brain tonic and speech enhancer.',
    uses: [
      'Speech disorders',
      'Memory enhancement',
      'Mental fog',
      'Digestive disorders'
    ],
    dosage: '250-500mg powder or small piece chewed',
    precautions: 'Use Indian variety only. Avoid during pregnancy.',
    growingTips: 'Semi-aquatic plant growing in marshy areas.',
    harvestTime: 'Rhizomes harvested in autumn',
  ),
  const Plant(
    id: '28',
    name: 'Bakuchi',
    hindi: 'बाकुची',
    scientificName: 'Psoralea corylifolia',
    image:
        'https://commons.wikimedia.org/wiki/Special:FilePath/Psoralea_corylifolia_-_Agri-Horticultural_Society_of_India_-_Alipore_-_Kolkata_2013-01-05_2280.JPG',
    doshas: ['Kapha', 'Vata'],
    benefits: ['Skin', 'Vitiligo', 'Psoriasis'],
    rating: 4.3,
    category: 'Seeds',
    difficulty: 'Medium',
    season: ['Winter'],
    description:
        'Powerful herb for skin conditions especially vitiligo and psoriasis.',
    uses: ['Vitiligo', 'Psoriasis', 'Skin disorders', 'Bone health'],
    dosage: '3-6 grams powder or oil application',
    precautions: 'Causes photosensitivity. Avoid sun exposure after use.',
    growingTips: 'Annual herb requiring warm climate.',
    harvestTime: 'Seeds collected when mature',
  ),
  const Plant(
    id: '29',
    name: 'Chitrak',
    hindi: 'चित्रक',
    scientificName: 'Plumbago zeylanica',
    image:
        'https://commons.wikimedia.org/wiki/Special:FilePath/Plumbago_zeylanica.jpg',
    doshas: ['Kapha', 'Vata'],
    benefits: ['Digestion', 'Metabolism', 'Weight Loss'],
    rating: 4.4,
    category: 'Roots',
    difficulty: 'Medium',
    season: ['All Seasons'],
    description:
        'Powerful digestive stimulant that kindles digestive fire and boosts metabolism.',
    uses: [
      'Digestive weakness',
      'Weight loss',
      'Metabolism boost',
      'Constipation'
    ],
    dosage: '250-500mg powder with honey',
    precautions: 'Very hot herb. Avoid in high Pitta and pregnancy.',
    growingTips: 'Perennial shrub in tropical regions.',
    harvestTime: 'Roots harvested from mature plants',
  ),
  const Plant(
    id: '30',
    name: 'Vidari',
    hindi: 'विदारी',
    scientificName: 'Pueraria tuberosa',
    image:
        'https://commons.wikimedia.org/wiki/Special:FilePath/Pueraria_tuberosa_(Roxb._ex_Willd.)_DC._(51960230859).jpg',
    doshas: ['Vata', 'Pitta'],
    benefits: ['Strength', 'Rejuvenation', 'Immunity'],
    rating: 4.5,
    category: 'Roots',
    difficulty: 'Medium',
    season: ['Winter', 'Spring'],
    description:
        'Powerful rejuvenative tonic for building strength and vitality.',
    uses: [
      'Building strength',
      'Weight gain',
      'Immunity',
      'Reproductive health',
      'Anti-aging'
    ],
    dosage: '3-6 grams powder with milk twice daily',
    precautions: 'May increase Kapha. Avoid in obesity.',
    growingTips: 'Climbing vine with tuberous roots.',
    harvestTime: 'Tubers harvested after 2-3 years',
  ),
];

/// Get all plant categories
List<String> getPlantCategories() {
  return plantsData.map((p) => p.category).toSet().toList()..sort();
}

/// Get all dosha types from plants
List<String> getAllDoshas() {
  return ['Vata', 'Pitta', 'Kapha'];
}

/// Get all difficulty levels
List<String> getDifficultyLevels() {
  return ['Easy', 'Medium', 'Hard'];
}

/// Get all seasons
List<String> getSeasons() {
  return ['All Seasons', 'Summer', 'Monsoon', 'Winter', 'Spring'];
}
