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

  /// Evening routine (Ratricharya) items
  static const List<Map<String, String>> eveningRoutine = [
    {'en': 'Eat light dinner before sunset', 'hi': 'सूर्यास्त से पहले हल्का रात्रि भोजन'},
    {'en': 'Take a short walk after dinner', 'hi': 'रात्रि भोजन के बाद थोड़ी देर टहलें'},
    {'en': 'Avoid screens 1 hour before bed', 'hi': 'सोने से 1 घंटे पहले स्क्रीन से बचें'},
    {'en': 'Practice gentle stretching or yoga', 'hi': 'हल्की स्ट्रेचिंग या योग करें'},
    {'en': 'Massage feet with warm oil', 'hi': 'गर्म तेल से पैरों की मालिश करें'},
    {'en': 'Drink warm milk with turmeric', 'hi': 'हल्दी वाला गर्म दूध पिएं'},
    {'en': 'Sleep by 10 PM', 'hi': 'रात 10 बजे तक सो जाएं'},
  ];

  /// Meditation types with durations
  static const List<Map<String, dynamic>> meditationTypes = [
    {'name': 'Breathing Focus', 'icon': 'air', 'duration': 5, 'description': 'Simple breath awareness'},
    {'name': 'Body Scan', 'icon': 'accessibility_new', 'duration': 10, 'description': 'Progressive relaxation'},
    {'name': 'Mantra Meditation', 'icon': 'record_voice_over', 'duration': 15, 'description': 'Om chanting'},
    {'name': 'Loving Kindness', 'icon': 'favorite', 'duration': 10, 'description': 'Metta meditation'},
    {'name': 'Visualization', 'icon': 'landscape', 'duration': 15, 'description': 'Peaceful imagery'},
  ];

  /// Sleep sounds for relaxation
  static const List<Map<String, String>> sleepSounds = [
    {'name': 'Rain', 'icon': 'water_drop', 'color': '0xFF4FC3F7'},
    {'name': 'Ocean', 'icon': 'waves', 'color': '0xFF0288D1'},
    {'name': 'Forest', 'icon': 'forest', 'color': '0xFF4CAF50'},
    {'name': 'Thunder', 'icon': 'thunderstorm', 'color': '0xFF7E57C2'},
    {'name': 'Fire', 'icon': 'local_fire_department', 'color': '0xFFFF7043'},
    {'name': 'Om Chant', 'icon': 'self_improvement', 'color': '0xFFFFB74D'},
  ];

  /// Daily affirmations
  static const List<Map<String, String>> affirmations = [
    {'en': 'I am in harmony with nature and my body.', 'hi': 'मैं प्रकृति और अपने शरीर के साथ सामंजस्य में हूं।'},
    {'en': 'My mind is calm, my body is healthy.', 'hi': 'मेरा मन शांत है, मेरा शरीर स्वस्थ है।'},
    {'en': 'I nourish myself with wholesome foods.', 'hi': 'मैं पौष्टिक भोजन से खुद को पोषित करता हूं।'},
    {'en': 'Balance flows through every cell of my being.', 'hi': 'संतुलन मेरे हर कोशिका में बहता है।'},
    {'en': 'I honor my body\'s natural rhythms.', 'hi': 'मैं अपने शरीर की प्राकृतिक लय का सम्मान करता हूं।'},
  ];

  /// Mood emoji mapping
  static const List<Map<String, dynamic>> moodOptions = [
    {'value': 1, 'emoji': '😴', 'label': 'Tired'},
    {'value': 2, 'emoji': '😐', 'label': 'Okay'},
    {'value': 3, 'emoji': '😊', 'label': 'Good'},
    {'value': 4, 'emoji': '😄', 'label': 'Great'},
    {'value': 5, 'emoji': '🤩', 'label': 'Amazing'},
  ];
}
