/// Wellness content data for the Wellness Hub screen
class WellnessData {
  WellnessData._();

  /// Daily routine (Dinacharya) items
  static const List<Map<String, String>> dailyRoutine = [
    {'en': 'Wake up before sunrise (Brahma Muhurta)', 'hi': 'सूर्योदय से पहले जागें (ब्रह्म मुहूर्त)'},
    {'en': 'Drink warm water on empty stomach', 'hi': 'खाली पेट गुनगुना पानी पिएं'},
    {'en': 'Tongue scraping and oil pulling', 'hi': 'जीभ साफ करना और तेल गरारा'},
    {'en': 'Self-massage with warm oil (Abhyanga)', 'hi': 'गर्म तेल से स्व-मालिश (अभ्यंग)'},
    {'en': 'Light exercise or yoga', 'hi': 'हल्का व्यायाम या योग'},
    {'en': 'Meditation for 10-15 minutes', 'hi': '10-15 मिनट ध्यान'},
    {'en': 'Eat breakfast by 8 AM', 'hi': 'सुबह 8 बजे तक नाश्ता करें'},
  ];

  /// Dosha balancing tips
  static const Map<String, List<Map<String, String>>> doshaBalanceTips = {
    'Vata': [
      {'en': 'Stay warm and avoid cold', 'hi': 'गर्म रहें और ठंड से बचें'},
      {'en': 'Follow a regular routine', 'hi': 'नियमित दिनचर्या अपनाएं'},
      {'en': 'Eat warm, grounding foods', 'hi': 'गर्म, पोषक भोजन खाएं'},
      {'en': 'Get enough rest and sleep', 'hi': 'पर्याप्त आराम और नींद लें'},
      {'en': 'Practice calming activities', 'hi': 'शांत गतिविधियां करें'},
    ],
    'Pitta': [
      {'en': 'Stay cool and avoid heat', 'hi': 'ठंडा रहें और गर्मी से बचें'},
      {'en': 'Avoid spicy and sour foods', 'hi': 'तीखे और खट्टे भोजन से बचें'},
      {'en': 'Practice moderation in all things', 'hi': 'हर चीज में संयम रखें'},
      {'en': 'Spend time in nature', 'hi': 'प्रकृति में समय बिताएं'},
      {'en': 'Avoid excessive competition', 'hi': 'अत्यधिक प्रतिस्पर्धा से बचें'},
    ],
    'Kapha': [
      {'en': 'Stay active and exercise daily', 'hi': 'सक्रिय रहें और रोज व्यायाम करें'},
      {'en': 'Eat light, warm, spicy foods', 'hi': 'हल्का, गर्म, मसालेदार भोजन खाएं'},
      {'en': 'Seek new experiences', 'hi': 'नए अनुभव लें'},
      {'en': 'Wake up early before sunrise', 'hi': 'सूर्योदय से पहले जागें'},
      {'en': 'Avoid daytime naps', 'hi': 'दिन में सोने से बचें'},
    ],
  };

  /// Yoga and meditation practices
  static const List<Map<String, String>> yogaPractices = [
    {'en': 'Surya Namaskar (Sun Salutation)', 'hi': 'सूर्य नमस्कार'},
    {'en': 'Pranayama breathing exercises', 'hi': 'प्राणायाम श्वास व्यायाम'},
    {'en': 'Nadi Shodhana (Alternate nostril breathing)', 'hi': 'नाड़ी शोधन (अनुलोम विलोम)'},
    {'en': 'Shavasana for relaxation', 'hi': 'शवासन विश्राम के लिए'},
    {'en': 'Mindfulness meditation', 'hi': 'माइंडफुलनेस ध्यान'},
    {'en': 'Trataka (candle gazing)', 'hi': 'त्राटक (दीपक ध्यान)'},
  ];

  /// Seasonal wisdom (Ritucharya)
  static const List<Map<String, String>> seasonalWisdom = [
    {'en': 'Winter: Warm, nourishing foods. Increase oil intake.', 'hi': 'सर्दी: गर्म, पौष्टिक भोजन। तेल बढ़ाएं।'},
    {'en': 'Spring: Light diet, detoxification. Reduce sweet and oily.', 'hi': 'वसंत: हल्का आहार, डिटॉक्स। मीठा-तैलीय कम करें।'},
    {'en': 'Summer: Cooling foods, stay hydrated. Avoid excess exercise.', 'hi': 'गर्मी: ठंडा भोजन, पानी पिएं। ज्यादा व्यायाम से बचें।'},
    {'en': 'Monsoon: Digestive care, warm drinks. Avoid raw foods.', 'hi': 'मानसून: पाचन की देखभाल, गर्म पेय। कच्चे भोजन से बचें।'},
    {'en': 'Autumn: Balance Vata dosha. Eat grounding foods.', 'hi': 'शरद: वात दोष संतुलन। पोषक भोजन खाएं।'},
  ];

  /// Quick wellness tips
  static const List<Map<String, String>> quickTips = [
    {'en': 'Eat your largest meal at lunch when digestion is strongest', 'hi': 'दोपहर में सबसे भारी भोजन करें जब पाचन शक्ति सबसे तेज हो'},
    {'en': 'Go to bed by 10 PM for optimal rest', 'hi': 'अच्छे आराम के लिए रात 10 बजे तक सो जाएं'},
    {'en': 'Practice gratitude daily', 'hi': 'रोज़ कृतज्ञता का अभ्यास करें'},
    {'en': 'Spend time in nature regularly', 'hi': 'नियमित रूप से प्रकृति में समय बिताएं'},
    {'en': 'Drink water stored in copper vessel', 'hi': 'तांबे के बर्तन में रखा पानी पिएं'},
    {'en': 'Avoid eating when stressed or upset', 'hi': 'तनाव या परेशान होने पर भोजन न करें'},
    {'en': 'Chew food 32 times before swallowing', 'hi': 'निगलने से पहले 32 बार चबाएं'},
  ];
}
