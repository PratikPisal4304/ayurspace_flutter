/// Wellness content data for the Wellness Hub screen
class WellnessData {
  WellnessData._();

  // ============ AYURVEDIC TIME ZONES ============

  /// Ayurvedic time period based on current hour
  /// Kapha: 6am-10am & 6pm-10pm
  /// Pitta: 10am-2pm & 10pm-2am
  /// Vata:  2pm-6pm  & 2am-6am
  static String getAyurvedicTimePeriod(int hour) {
    if ((hour >= 6 && hour < 10) || (hour >= 18 && hour < 22)) return 'Kapha';
    if ((hour >= 10 && hour < 14) || (hour >= 22 || hour < 2)) return 'Pitta';
    return 'Vata';
  }

  /// Get a contextual greeting based on the Ayurvedic time
  static Map<String, String> getTimeGreeting(int hour) {
    if (hour >= 4 && hour < 6) {
      return {
        'en': '🌅 Brahma Muhurta — The Sacred Hour',
        'hi': '🌅 ब्रह्म मुहूर्त — पवित्र समय',
      };
    } else if (hour >= 6 && hour < 10) {
      return {
        'en': '☀️ Good Morning — Kapha Time',
        'hi': '☀️ सुप्रभात — कफ काल',
      };
    } else if (hour >= 10 && hour < 14) {
      return {
        'en': '🔥 Midday — Pitta Time (strongest digestion)',
        'hi': '🔥 दोपहर — पित्त काल (सबसे मजबूत पाचन)',
      };
    } else if (hour >= 14 && hour < 18) {
      return {
        'en': '🌬️ Afternoon — Vata Time (light & creative)',
        'hi': '🌬️ दोपहर बाद — वात काल (हल्का और रचनात्मक)',
      };
    } else if (hour >= 18 && hour < 22) {
      return {
        'en': '🌙 Evening — Kapha Time (wind down)',
        'hi': '🌙 शाम — कफ काल (विश्राम का समय)',
      };
    } else {
      return {
        'en': '🌌 Night — Pitta Time (body repairs)',
        'hi': '🌌 रात — पित्त काल (शरीर मरम्मत)',
      };
    }
  }

  /// Get smart suggestion based on time
  static Map<String, String> getTimeSuggestion(int hour) {
    if (hour >= 4 && hour < 6) {
      return {
        'en': 'This is the ideal time for meditation and spiritual practice.',
        'hi': 'यह ध्यान और आध्यात्मिक अभ्यास के लिए आदर्श समय है।',
      };
    } else if (hour >= 6 && hour < 10) {
      return {
        'en': 'Perfect time for exercise, yoga, and a nourishing breakfast.',
        'hi': 'व्यायाम, योग और पौष्टिक नाश्ते के लिए सही समय।',
      };
    } else if (hour >= 10 && hour < 14) {
      return {
        'en':
            'Your digestive fire (Agni) is at its peak. Eat your largest meal now!',
        'hi': 'आपकी पाचन अग्नि चरम पर है। अभी सबसे भारी भोजन करें!',
      };
    } else if (hour >= 14 && hour < 18) {
      return {
        'en': 'Ideal for creative work, light snacking, and herbal tea.',
        'hi': 'रचनात्मक कार्य, हल्के नाश्ते और हर्बल चाय के लिए आदर्श।',
      };
    } else if (hour >= 18 && hour < 22) {
      return {
        'en': 'Wind down with a light dinner, gentle walk, and relaxation.',
        'hi': 'हल्का रात्रि भोजन, टहलना और विश्राम करें।',
      };
    } else {
      return {
        'en': 'Your body is healing. Aim for deep, restorative sleep.',
        'hi': 'आपका शरीर ठीक हो रहा है। गहरी नींद का लक्ष्य रखें।',
      };
    }
  }

  // ============ SEASONAL WISDOM (RITUCHARYA) ============

  /// Returns the current Ayurvedic season (Ritu) for the Indian subcontinent
  static String getCurrentSeason(int month) {
    if (month == 1 || month == 2) return 'Shishira'; // Late Winter
    if (month == 3 || month == 4) return 'Vasanta'; // Spring
    if (month == 5 || month == 6) return 'Grishma'; // Summer
    if (month == 7 || month == 8) return 'Varsha'; // Monsoon
    if (month == 9 || month == 10) return 'Sharad'; // Autumn
    return 'Hemanta'; // Early Winter
  }

  static const Map<String, Map<String, dynamic>> seasonalDetails = {
    'Shishira': {
      'en': 'Late Winter (Shishira Ritu)',
      'hi': 'शीत ऋतु (शिशिर)',
      'emoji': '❄️',
      'dosha': 'Kapha',
      'tips': [
        {
          'en': 'Eat warm, sweet, sour, and salty foods',
          'hi': 'गर्म, मीठा, खट्टा, और नमकीन खाएं'
        },
        {
          'en': 'Use sesame oil for Abhyanga (self-massage)',
          'hi': 'अभ्यंग के लिए तिल तेल का प्रयोग करें'
        },
        {
          'en': 'Drink warm water with ginger',
          'hi': 'अदरक वाला गर्म पानी पिएं'
        },
        {
          'en': 'Strengthen immunity with Chyawanprash',
          'hi': 'च्यवनप्राश से प्रतिरक्षा बढ़ाएं'
        },
      ],
    },
    'Vasanta': {
      'en': 'Spring (Vasanta Ritu)',
      'hi': 'वसंत ऋतु',
      'emoji': '🌸',
      'dosha': 'Kapha',
      'tips': [
        {
          'en': 'Eat light, dry, warm, and easily digestible food',
          'hi': 'हल्का, सूखा, गर्म और सुपाच्य भोजन करें'
        },
        {
          'en': 'Avoid heavy, oily, and cold foods',
          'hi': 'भारी, तैलीय और ठंडे खाने से बचें'
        },
        {
          'en': 'Practice Nasya (nasal cleansing) with warm oil',
          'hi': 'गर्म तेल से नस्य करें'
        },
        {
          'en': 'Increase physical activity and cardio exercise',
          'hi': 'शारीरिक गतिविधि और कार्डियो बढ़ाएं'
        },
      ],
    },
    'Grishma': {
      'en': 'Summer (Grishma Ritu)',
      'hi': 'ग्रीष्म ऋतु',
      'emoji': '☀️',
      'dosha': 'Vata',
      'tips': [
        {
          'en': 'Drink cool water infused with mint or rose petals',
          'hi': 'पुदीना या गुलाब जल वाला ठंडा पानी पिएं'
        },
        {
          'en': 'Eat sweet, light, liquid, and cooling foods',
          'hi': 'मीठा, हल्का, तरल और ठंडा भोजन करें'
        },
        {
          'en': 'Avoid excessive exercise and sun exposure',
          'hi': 'ज्यादा व्यायाम और धूप से बचें'
        },
        {
          'en': 'Apply sandalwood paste for cooling',
          'hi': 'ठंडक के लिए चंदन का लेप लगाएं'
        },
      ],
    },
    'Varsha': {
      'en': 'Monsoon (Varsha Ritu)',
      'hi': 'वर्षा ऋतु',
      'emoji': '🌧️',
      'dosha': 'Vata',
      'tips': [
        {
          'en': 'Eat freshly cooked warm food with spices',
          'hi': 'मसालेदार ताज़ा गर्म खाना खाएं'
        },
        {
          'en': 'Avoid raw salads and stale food',
          'hi': 'कच्चे सलाद और बासी भोजन से बचें'
        },
        {
          'en': 'Use Triphala for digestive support',
          'hi': 'पाचन के लिए त्रिफला का प्रयोग करें'
        },
        {
          'en': 'Keep surroundings dry and practice fumigation with herbs',
          'hi': 'सूखा वातावरण रखें और जड़ी-बूटी धूप करें'
        },
      ],
    },
    'Sharad': {
      'en': 'Autumn (Sharad Ritu)',
      'hi': 'शरद ऋतु',
      'emoji': '🍂',
      'dosha': 'Pitta',
      'tips': [
        {
          'en': 'Eat sweet, bitter, and astringent foods',
          'hi': 'मधुर, तिक्त और कषाय रस का भोजन करें'
        },
        {
          'en': 'Consume cooling herbs like Shatavari and Amla',
          'hi': 'शतावरी और आंवला जैसी शीतल जड़ी-बूटियां लें'
        },
        {
          'en': 'Practice moonlight exposure (Chandrika Snana)',
          'hi': 'चांदनी स्नान (चन्द्रिका स्नान) करें'
        },
        {
          'en': 'Perform Virechana (purgation therapy) for Pitta balance',
          'hi': 'पित्त संतुलन के लिए विरेचन करें'
        },
      ],
    },
    'Hemanta': {
      'en': 'Early Winter (Hemanta Ritu)',
      'hi': 'हेमंत ऋतु',
      'emoji': '🧣',
      'dosha': 'Vata',
      'tips': [
        {
          'en': 'Eat nourishing, heavy, warm, sweet, and oily foods',
          'hi': 'पौष्टिक, भारी, गर्म, मीठा और तैलीय भोजन करें'
        },
        {
          'en': 'Perform Abhyanga with warm sesame or mustard oil',
          'hi': 'गर्म तिल या सरसों तेल से अभ्यंग करें'
        },
        {
          'en': 'Exercise vigorously as digestive fire is strong',
          'hi': 'जोरदार व्यायाम करें क्योंकि अग्नि प्रबल है'
        },
        {
          'en': 'Drink warm milk with turmeric and nutmeg at night',
          'hi': 'रात में हल्दी-जायफल वाला गर्म दूध पिएं'
        },
      ],
    },
  };

  // ============ DOSHA-SPECIFIC CONTENT ============

  /// Dosha-specific meditation recommendations
  static const Map<String, List<Map<String, dynamic>>> doshaMeditations = {
    'Vata': [
      {
        'name': 'Grounding Body Scan',
        'icon': 'accessibility_new',
        'duration': 10,
        'description': 'Feel connected to the earth'
      },
      {
        'name': 'Guided Nidra',
        'icon': 'bedtime',
        'duration': 20,
        'description': 'Deep yogic sleep for Vata calm'
      },
      {
        'name': 'Om Chanting',
        'icon': 'record_voice_over',
        'duration': 15,
        'description': 'Stabilizing vibration'
      },
    ],
    'Pitta': [
      {
        'name': 'Cooling Breath',
        'icon': 'air',
        'duration': 10,
        'description': 'Sheetali Pranayama'
      },
      {
        'name': 'Moonlight Visualization',
        'icon': 'nightlight_round',
        'duration': 15,
        'description': 'Cool, peaceful imagery'
      },
      {
        'name': 'Loving Kindness',
        'icon': 'favorite',
        'duration': 10,
        'description': 'Metta meditation for compassion'
      },
    ],
    'Kapha': [
      {
        'name': 'Energizing Breath',
        'icon': 'local_fire_department',
        'duration': 10,
        'description': 'Kapalabhati Pranayama'
      },
      {
        'name': 'Active Visualization',
        'icon': 'landscape',
        'duration': 10,
        'description': 'Visualize radiant sun energy'
      },
      {
        'name': 'Mantra Meditation',
        'icon': 'record_voice_over',
        'duration': 15,
        'description': 'Stimulating sacred chanting'
      },
    ],
  };

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
      {
        'en': 'Avoid excessive competition',
        'hi': 'अत्यधिक प्रतिस्पर्धा से बचें'
      },
    ],
    'Kapha': [
      {
        'en': 'Stay active and exercise daily',
        'hi': 'सक्रिय रहें और रोज व्यायाम करें'
      },
      {
        'en': 'Eat light, warm, spicy foods',
        'hi': 'हल्का, गर्म, मसालेदार भोजन खाएं'
      },
      {'en': 'Seek new experiences', 'hi': 'नए अनुभव लें'},
      {'en': 'Wake up early before sunrise', 'hi': 'सूर्योदय से पहले जागें'},
      {'en': 'Avoid daytime naps', 'hi': 'दिन में सोने से बचें'},
    ],
  };

  // ============ AHARA (DIETARY TIPS) ============

  /// Dosha-specific food recommendations
  static const Map<String, Map<String, dynamic>> aharaTips = {
    'Vata': {
      'favor': [
        {
          'en': 'Warm soups, stews, and cooked grains',
          'hi': 'गर्म सूप, स्टू, और पके अनाज'
        },
        {
          'en': 'Ghee, sesame oil, and warm milk',
          'hi': 'घी, तिल तेल, और गर्म दूध'
        },
        {
          'en': 'Sweet fruits like bananas, mangoes',
          'hi': 'मीठे फल जैसे केला, आम'
        },
        {
          'en': 'Nuts and seeds (almonds, walnuts)',
          'hi': 'मेवे (बादाम, अखरोट)'
        },
      ],
      'avoid': [
        {
          'en': 'Raw salads, cold drinks, and dry foods',
          'hi': 'कच्चे सलाद, ठंडे पेय, सूखा भोजन'
        },
        {
          'en': 'Excessive caffeine and carbonated drinks',
          'hi': 'अत्यधिक कैफीन और कार्बोनेटेड पेय'
        },
      ],
      'spice': {'en': 'Ginger, Cinnamon, Cumin', 'hi': 'अदरक, दालचीनी, जीरा'},
    },
    'Pitta': {
      'favor': [
        {
          'en': 'Cool salads, sweet fruits, and coconut',
          'hi': 'ठंडे सलाद, मीठे फल, और नारियल'
        },
        {
          'en': 'Ghee, coconut oil, and cooling herbs',
          'hi': 'घी, नारियल तेल, शीतल जड़ी-बूटियां'
        },
        {
          'en': 'Milk, rice, and green leafy vegetables',
          'hi': 'दूध, चावल, और हरी पत्तेदार सब्जियां'
        },
        {
          'en': 'Cucumber, melon, and pomegranate',
          'hi': 'खीरा, तरबूज, और अनार'
        },
      ],
      'avoid': [
        {
          'en': 'Hot spices, fermented food, and alcohol',
          'hi': 'तीखे मसाले, खमीर भोजन, और शराब'
        },
        {
          'en': 'Sour and salty foods in excess',
          'hi': 'ज्यादा खट्टा और नमकीन भोजन'
        },
      ],
      'spice': {
        'en': 'Coriander, Fennel, Cardamom',
        'hi': 'धनिया, सौंफ, इलायची'
      },
    },
    'Kapha': {
      'favor': [
        {
          'en': 'Light, warm, and spicy foods',
          'hi': 'हल्का, गर्म, और मसालेदार भोजन'
        },
        {
          'en': 'Honey, barley, millet, and corn',
          'hi': 'शहद, जौ, बाजरा, और मक्का'
        },
        {
          'en': 'Leafy greens and bitter vegetables',
          'hi': 'हरी पत्तेदार और कड़वी सब्जियां'
        },
        {'en': 'Apples, pears, and berries', 'hi': 'सेब, नाशपाती, और बेरी'},
      ],
      'avoid': [
        {
          'en': 'Heavy, oily, and sweet foods',
          'hi': 'भारी, तैलीय, और मीठे भोजन से बचें'
        },
        {
          'en': 'Dairy (except buttermilk), fried food',
          'hi': 'डेयरी (छाछ छोड़कर), तला हुआ'
        },
      ],
      'spice': {
        'en': 'Turmeric, Black Pepper, Ginger',
        'hi': 'हल्दी, काली मिर्च, अदरक'
      },
    },
  };

  // ============ DAILY ROUTINES ============

  /// Daily routine (Dinacharya) items
  static const List<Map<String, String>> dailyRoutine = [
    {
      'en': 'Wake up before sunrise (Brahma Muhurta)',
      'hi': 'सूर्योदय से पहले जागें (ब्रह्म मुहूर्त)'
    },
    {
      'en': 'Drink warm water on empty stomach',
      'hi': 'खाली पेट गुनगुना पानी पिएं'
    },
    {
      'en': 'Tongue scraping and oil pulling',
      'hi': 'जीभ साफ करना और तेल गरारा'
    },
    {
      'en': 'Self-massage with warm oil (Abhyanga)',
      'hi': 'गर्म तेल से स्व-मालिश (अभ्यंग)'
    },
    {'en': 'Light exercise or yoga', 'hi': 'हल्का व्यायाम या योग'},
    {'en': 'Meditation for 10-15 minutes', 'hi': '10-15 मिनट ध्यान'},
    {'en': 'Eat breakfast by 8 AM', 'hi': 'सुबह 8 बजे तक नाश्ता करें'},
  ];

  /// Evening routine (Ratricharya) items
  static const List<Map<String, String>> eveningRoutine = [
    {
      'en': 'Eat light dinner before sunset',
      'hi': 'सूर्यास्त से पहले हल्का रात्रि भोजन'
    },
    {
      'en': 'Take a short walk after dinner',
      'hi': 'रात्रि भोजन के बाद थोड़ी देर टहलें'
    },
    {
      'en': 'Avoid screens 1 hour before bed',
      'hi': 'सोने से 1 घंटे पहले स्क्रीन से बचें'
    },
    {
      'en': 'Practice gentle stretching or yoga',
      'hi': 'हल्की स्ट्रेचिंग या योग करें'
    },
    {
      'en': 'Massage feet with warm oil',
      'hi': 'गर्म तेल से पैरों की मालिश करें'
    },
    {'en': 'Drink warm milk with turmeric', 'hi': 'हल्दी वाला गर्म दूध पिएं'},
    {'en': 'Sleep by 10 PM', 'hi': 'रात 10 बजे तक सो जाएं'},
  ];

  // ============ YOGA & PRACTICES ============

  /// Yoga and meditation practices
  static const List<Map<String, String>> yogaPractices = [
    {'en': 'Surya Namaskar (Sun Salutation)', 'hi': 'सूर्य नमस्कार'},
    {'en': 'Pranayama breathing exercises', 'hi': 'प्राणायाम श्वास व्यायाम'},
    {
      'en': 'Nadi Shodhana (Alternate nostril breathing)',
      'hi': 'नाड़ी शोधन (अनुलोम विलोम)'
    },
    {'en': 'Shavasana for relaxation', 'hi': 'शवासन विश्राम के लिए'},
    {'en': 'Mindfulness meditation', 'hi': 'माइंडफुलनेस ध्यान'},
    {'en': 'Trataka (candle gazing)', 'hi': 'त्राटक (दीपक ध्यान)'},
  ];

  // ============ DEFAULT MEDITATION ============

  /// Meditation types with durations (generic / fallback)
  static const List<Map<String, dynamic>> meditationTypes = [
    {
      'name': 'Breathing Focus',
      'icon': 'air',
      'duration': 5,
      'description': 'Simple breath awareness'
    },
    {
      'name': 'Body Scan',
      'icon': 'accessibility_new',
      'duration': 10,
      'description': 'Progressive relaxation'
    },
    {
      'name': 'Mantra Meditation',
      'icon': 'record_voice_over',
      'duration': 15,
      'description': 'Om chanting'
    },
    {
      'name': 'Loving Kindness',
      'icon': 'favorite',
      'duration': 10,
      'description': 'Metta meditation'
    },
    {
      'name': 'Visualization',
      'icon': 'landscape',
      'duration': 15,
      'description': 'Peaceful imagery'
    },
  ];

  // ============ SLEEP SOUNDS ============

  /// Sleep sounds for relaxation
  static const List<Map<String, String>> sleepSounds = [
    {'name': 'Rain', 'icon': 'water_drop', 'color': '0xFF4FC3F7'},
    {'name': 'Ocean', 'icon': 'waves', 'color': '0xFF0288D1'},
    {'name': 'Forest', 'icon': 'forest', 'color': '0xFF4CAF50'},
    {'name': 'Thunder', 'icon': 'thunderstorm', 'color': '0xFF7E57C2'},
    {'name': 'Fire', 'icon': 'local_fire_department', 'color': '0xFFFF7043'},
    {'name': 'Om Chant', 'icon': 'self_improvement', 'color': '0xFFFFB74D'},
  ];

  // ============ QUICK TIPS ============

  /// Quick wellness tips
  static const List<Map<String, String>> quickTips = [
    {
      'en': 'Eat your largest meal at lunch when digestion is strongest',
      'hi': 'दोपहर में सबसे भारी भोजन करें जब पाचन शक्ति सबसे तेज हो'
    },
    {
      'en': 'Go to bed by 10 PM for optimal rest',
      'hi': 'अच्छे आराम के लिए रात 10 बजे तक सो जाएं'
    },
    {'en': 'Practice gratitude daily', 'hi': 'रोज़ कृतज्ञता का अभ्यास करें'},
    {
      'en': 'Spend time in nature regularly',
      'hi': 'नियमित रूप से प्रकृति में समय बिताएं'
    },
    {
      'en': 'Drink water stored in copper vessel',
      'hi': 'तांबे के बर्तन में रखा पानी पिएं'
    },
    {
      'en': 'Avoid eating when stressed or upset',
      'hi': 'तनाव या परेशान होने पर भोजन न करें'
    },
    {
      'en': 'Chew food 32 times before swallowing',
      'hi': 'निगलने से पहले 32 बार चबाएं'
    },
  ];

  // ============ AFFIRMATIONS ============

  /// Daily affirmations
  static const List<Map<String, String>> affirmations = [
    {
      'en': 'I am in harmony with nature and my body.',
      'hi': 'मैं प्रकृति और अपने शरीर के साथ सामंजस्य में हूं।'
    },
    {
      'en': 'My mind is calm, my body is healthy.',
      'hi': 'मेरा मन शांत है, मेरा शरीर स्वस्थ है।'
    },
    {
      'en': 'I nourish myself with wholesome foods.',
      'hi': 'मैं पौष्टिक भोजन से खुद को पोषित करता हूं।'
    },
    {
      'en': 'Balance flows through every cell of my being.',
      'hi': 'संतुलन मेरे हर कोशिका में बहता है।'
    },
    {
      'en': 'I honor my body\'s natural rhythms.',
      'hi': 'मैं अपने शरीर की प्राकृतिक लय का सम्मान करता हूं।'
    },
  ];

  // ============ MOOD ============

  /// Mood emoji mapping
  static const List<Map<String, dynamic>> moodOptions = [
    {'value': 1, 'emoji': '😴', 'label': 'Tired'},
    {'value': 2, 'emoji': '😐', 'label': 'Okay'},
    {'value': 3, 'emoji': '😊', 'label': 'Good'},
    {'value': 4, 'emoji': '😄', 'label': 'Great'},
    {'value': 5, 'emoji': '🤩', 'label': 'Amazing'},
  ];
}
