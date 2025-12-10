import '../models/dosha.dart';

/// Complete dosha quiz questions with bilingual support
const List<DoshaQuizQuestion> doshaQuizData = [
  DoshaQuizQuestion(
    id: '1',
    category: 'Physical',
    question: 'How is your body frame?',
    questionHindi: 'आपके शरीर की बनावट कैसी है?',
    options: [
      DoshaQuizOption(
          text: 'Thin, light, hard to gain weight',
          textHindi: 'पतला, हल्का, वजन बढ़ाना मुश्किल',
          dosha: DoshaType.vata),
      DoshaQuizOption(
          text: 'Medium, muscular, athletic',
          textHindi: 'मध्यम, मांसल, एथलेटिक',
          dosha: DoshaType.pitta),
      DoshaQuizOption(
          text: 'Large, solid, easy to gain weight',
          textHindi: 'बड़ा, ठोस, वजन आसानी से बढ़ता है',
          dosha: DoshaType.kapha),
    ],
  ),
  DoshaQuizQuestion(
    id: '2',
    category: 'Physical',
    question: 'How is your skin?',
    questionHindi: 'आपकी त्वचा कैसी है?',
    options: [
      DoshaQuizOption(
          text: 'Dry, rough, thin, cool',
          textHindi: 'सूखी, खुरदरी, पतली, ठंडी',
          dosha: DoshaType.vata),
      DoshaQuizOption(
          text: 'Warm, oily, prone to redness',
          textHindi: 'गर्म, तैलीय, लालिमा होती है',
          dosha: DoshaType.pitta),
      DoshaQuizOption(
          text: 'Thick, smooth, cool, moist',
          textHindi: 'मोटी, मुलायम, ठंडी, नम',
          dosha: DoshaType.kapha),
    ],
  ),
  DoshaQuizQuestion(
    id: '3',
    category: 'Mental',
    question: 'How do you handle stress?',
    questionHindi: 'आप तनाव कैसे संभालते हैं?',
    options: [
      DoshaQuizOption(
          text: 'Become anxious, worry, fearful',
          textHindi: 'चिंतित, डरा हुआ हो जाता हूं',
          dosha: DoshaType.vata),
      DoshaQuizOption(
          text: 'Get angry, irritated, frustrated',
          textHindi: 'गुस्सा, चिड़चिड़ा हो जाता हूं',
          dosha: DoshaType.pitta),
      DoshaQuizOption(
          text: 'Become withdrawn, sad, lethargic',
          textHindi: 'उदास, सुस्त हो जाता हूं',
          dosha: DoshaType.kapha),
    ],
  ),
  DoshaQuizQuestion(
    id: '4',
    category: 'Digestion',
    question: 'How is your appetite?',
    questionHindi: 'आपकी भूख कैसी है?',
    options: [
      DoshaQuizOption(
          text: 'Variable, skipping meals is easy',
          textHindi: 'अनियमित, खाना छोड़ना आसान',
          dosha: DoshaType.vata),
      DoshaQuizOption(
          text: 'Strong, get irritable if hungry',
          textHindi: 'तेज, भूखे रहने पर चिड़चिड़ापन',
          dosha: DoshaType.pitta),
      DoshaQuizOption(
          text: 'Steady, can skip meals without issue',
          textHindi: 'स्थिर, खाना छोड़ना कोई समस्या नहीं',
          dosha: DoshaType.kapha),
    ],
  ),
  DoshaQuizQuestion(
    id: '5',
    category: 'Lifestyle',
    question: 'How is your sleep?',
    questionHindi: 'आपकी नींद कैसी है?',
    options: [
      DoshaQuizOption(
          text: 'Light, interrupted, hard to fall asleep',
          textHindi: 'हल्की, टूटी हुई, सोना मुश्किल',
          dosha: DoshaType.vata),
      DoshaQuizOption(
          text: 'Moderate, wake refreshed',
          textHindi: 'मध्यम, तरोताजा उठता हूं',
          dosha: DoshaType.pitta),
      DoshaQuizOption(
          text: 'Deep, heavy, hard to wake up',
          textHindi: 'गहरी, भारी, उठना मुश्किल',
          dosha: DoshaType.kapha),
    ],
  ),
  DoshaQuizQuestion(
    id: '6',
    category: 'Physical',
    question: 'How is your hair?',
    questionHindi: 'आपके बाल कैसे हैं?',
    options: [
      DoshaQuizOption(
          text: 'Dry, thin, frizzy, prone to dandruff',
          textHindi: 'सूखे, पतले, रूखे, रूसी वाले',
          dosha: DoshaType.vata),
      DoshaQuizOption(
          text: 'Fine, oily, early graying',
          textHindi: 'बारीक, तैलीय, जल्दी सफेद होने वाले',
          dosha: DoshaType.pitta),
      DoshaQuizOption(
          text: 'Thick, lustrous, wavy',
          textHindi: 'घने, चमकदार, लहरदार',
          dosha: DoshaType.kapha),
    ],
  ),
  DoshaQuizQuestion(
    id: '7',
    category: 'Physical',
    question: 'What is your body temperature?',
    questionHindi: 'आपके शरीर का तापमान कैसा रहता है?',
    options: [
      DoshaQuizOption(
          text: 'Cold hands and feet',
          textHindi: 'ठंडे हाथ और पैर',
          dosha: DoshaType.vata),
      DoshaQuizOption(
          text: 'Warm, hate hot weather',
          textHindi: 'गर्म, गर्मी पसंद नहीं',
          dosha: DoshaType.pitta),
      DoshaQuizOption(
          text: 'Cool but tolerate warmth well',
          textHindi: 'ठंडा लेकिन गर्मी सह लेता हूं',
          dosha: DoshaType.kapha),
    ],
  ),
  DoshaQuizQuestion(
    id: '8',
    category: 'Mental',
    question: 'How do you make decisions?',
    questionHindi: 'आप निर्णय कैसे लेते हैं?',
    options: [
      DoshaQuizOption(
          text: 'Quick but often change mind',
          textHindi: 'जल्दी लेकिन मन बदलता रहता है',
          dosha: DoshaType.vata),
      DoshaQuizOption(
          text: 'Decisive and confident',
          textHindi: 'निर्णायक और आत्मविश्वासी',
          dosha: DoshaType.pitta),
      DoshaQuizOption(
          text: 'Slow and deliberate',
          textHindi: 'धीमा और सोच-समझकर',
          dosha: DoshaType.kapha),
    ],
  ),
  DoshaQuizQuestion(
    id: '9',
    category: 'Mental',
    question: 'How is your memory?',
    questionHindi: 'आपकी याददाश्त कैसी है?',
    options: [
      DoshaQuizOption(
          text: 'Quick to learn, quick to forget',
          textHindi: 'जल्दी सीखता हूं, जल्दी भूलता हूं',
          dosha: DoshaType.vata),
      DoshaQuizOption(
          text: 'Sharp and clear',
          textHindi: 'तेज और स्पष्ट',
          dosha: DoshaType.pitta),
      DoshaQuizOption(
          text: 'Slow to learn, never forget',
          textHindi: 'धीरे सीखता हूं, कभी नहीं भूलता',
          dosha: DoshaType.kapha),
    ],
  ),
  DoshaQuizQuestion(
    id: '10',
    category: 'Digestion',
    question: 'How is your digestion?',
    questionHindi: 'आपका पाचन कैसा है?',
    options: [
      DoshaQuizOption(
          text: 'Irregular, gas and bloating',
          textHindi: 'अनियमित, गैस और पेट फूलना',
          dosha: DoshaType.vata),
      DoshaQuizOption(
          text: 'Strong, acidic, heartburn',
          textHindi: 'तेज, अम्लीय, जलन',
          dosha: DoshaType.pitta),
      DoshaQuizOption(
          text: 'Slow but steady',
          textHindi: 'धीमा लेकिन स्थिर',
          dosha: DoshaType.kapha),
    ],
  ),
];
