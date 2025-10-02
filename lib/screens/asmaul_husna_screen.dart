import 'package:flutter/material.dart';

class AsmaulHusnaScreen extends StatefulWidget {
  const AsmaulHusnaScreen({super.key});

  @override
  State<AsmaulHusnaScreen> createState() => _AsmaulHusnaScreenState();
}

class _AsmaulHusnaScreenState extends State<AsmaulHusnaScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  int _selectedIndex = -1;

  final List<Map<String, String>> _asmaulHusna = [
    {
      'number': '1',
      'arabic': 'الله',
      'latin': 'Allah',
      'meaning': 'Yang Maha Esa',
      'description':
          'Nama Allah yang mencakup semua sifat kesempurnaan, Tuhan yang berhak disembah.'
    },
    {
      'number': '2',
      'arabic': 'الرَّحْمٰنُ',
      'latin': 'Ar-Rahman',
      'meaning': 'Yang Maha Pengasih',
      'description':
          'Allah Yang Maha Pengasih kepada semua makhluk di dunia tanpa memandang iman mereka.'
    },
    {
      'number': '3',
      'arabic': 'الرَّحِيْمُ',
      'latin': 'Ar-Raheem',
      'meaning': 'Yang Maha Penyayang',
      'description':
          'Allah Yang Maha Penyayang khususnya kepada orang beriman di akhirat.'
    },
    {
      'number': '4',
      'arabic': 'الْمَلِكُ',
      'latin': 'Al-Malik',
      'meaning': 'Yang Maha Merajai',
      'description': 'Allah Yang memiliki kerajaan mutlak atas segala sesuatu.'
    },
    {
      'number': '5',
      'arabic': 'الْقُدُّوْسُ',
      'latin': 'Al-Quddus',
      'meaning': 'Yang Maha Suci',
      'description': 'Allah Yang Maha Suci dari segala kekurangan dan cacat.'
    },
    {
      'number': '6',
      'arabic': 'السَّلَامُ',
      'latin': 'As-Salaam',
      'meaning': 'Yang Maha Sejahtera',
      'description': 'Allah Yang memberikan keselamatan dan bebas dari cacat.'
    },
    {
      'number': '7',
      'arabic': 'الْمُؤْمِنُ',
      'latin': 'Al-Mu\'min',
      'meaning': 'Yang Maha Mengamankan',
      'description': 'Allah Yang memberikan keamanan kepada hamba-Nya.'
    },
    {
      'number': '8',
      'arabic': 'الْمُهَيْمِنُ',
      'latin': 'Al-Muhaymin',
      'meaning': 'Yang Maha Mengawasi',
      'description': 'Allah Yang mengawasi segala sesuatu dengan sempurna.'
    },
    {
      'number': '9',
      'arabic': 'الْعَزِيْزُ',
      'latin': 'Al-Aziz',
      'meaning': 'Yang Maha Perkasa',
      'description': 'Allah Yang memiliki kekuatan mutlak dan tak terkalahkan.'
    },
    {
      'number': '10',
      'arabic': 'الْجَبَّارُ',
      'latin': 'Al-Jabbar',
      'meaning': 'Yang Maha Memaksa',
      'description':
          'Allah Yang memiliki kekuasaan mutlak melaksanakan kehendak-Nya.'
    },
    {
      'number': '11',
      'arabic': 'الْمُتَكَبِّرُ',
      'latin': 'Al-Mutakabbir',
      'meaning': 'Yang Maha Megah',
      'description': 'Allah Yang memiliki keagungan dan kemegahan mutlak.'
    },
    {
      'number': '12',
      'arabic': 'الْخَالِقُ',
      'latin': 'Al-Khaliq',
      'meaning': 'Yang Maha Pencipta',
      'description':
          'Allah Yang menciptakan segala sesuatu dari tiada menjadi ada.'
    },
    {
      'number': '13',
      'arabic': 'الْبَارِئُ',
      'latin': 'Al-Bari\'',
      'meaning': 'Yang Maha Membuat',
      'description': 'Allah Yang membuat dan membentuk makhluk dengan sempurna.'
    },
    {
      'number': '14',
      'arabic': 'الْمُصَوِّرُ',
      'latin': 'Al-Mushawwir',
      'meaning': 'Yang Maha Membentuk',
      'description': 'Allah Yang memberikan bentuk kepada makhluk-Nya.'
    },
    {
      'number': '15',
      'arabic': 'الْغَفَّارُ',
      'latin': 'Al-Ghaffar',
      'meaning': 'Yang Maha Pengampun',
      'description': 'Allah Yang mengampuni dosa hamba yang bertobat.'
    },
    {
      'number': '16',
      'arabic': 'الْقَهَّارُ',
      'latin': 'Al-Qahhar',
      'meaning': 'Yang Maha Menundukkan',
      'description':
          'Allah Yang menguasai segala sesuatu dengan kekuasaan mutlak.'
    },
    {
      'number': '17',
      'arabic': 'الْوَهَّابُ',
      'latin': 'Al-Wahhab',
      'meaning': 'Yang Maha Pemberi',
      'description': 'Allah Yang memberikan karunia tanpa mengharap balasan.'
    },
    {
      'number': '18',
      'arabic': 'الرَّزَّاقُ',
      'latin': 'Ar-Razzaq',
      'meaning': 'Yang Maha Pemberi Rezeki',
      'description': 'Allah Yang memberikan rezeki kepada semua makhluk.'
    },
    {
      'number': '19',
      'arabic': 'الْفَتَّاحُ',
      'latin': 'Al-Fattah',
      'meaning': 'Yang Maha Pembuka',
      'description': 'Allah Yang membuka pintu rahmat dan rezeki.'
    },
    {
      'number': '20',
      'arabic': 'الْعَلِيْمُ',
      'latin': 'Al-Aleem',
      'meaning': 'Yang Maha Mengetahui',
      'description':
          'Allah Yang mengetahui segala sesuatu yang tampak dan tersembunyi.'
    },
    {
      'number': '21',
      'arabic': 'الْقَابِضُ',
      'latin': 'Al-Qabidh',
      'meaning': 'Yang Maha Menyempitkan',
      'description': 'Allah Yang menyempitkan rezeki sesuai hikmah-Nya.'
    },
    {
      'number': '22',
      'arabic': 'الْبَاسِطُ',
      'latin': 'Al-Basith',
      'meaning': 'Yang Maha Melapangkan',
      'description': 'Allah Yang melapangkan rezeki sesuai kehendak-Nya.'
    },
    {
      'number': '23',
      'arabic': 'الْخَافِضُ',
      'latin': 'Al-Khafidh',
      'meaning': 'Yang Maha Merendahkan',
      'description': 'Allah Yang merendahkan orang yang sombong dan zalim.'
    },
    {
      'number': '24',
      'arabic': 'الرَّافِعُ',
      'latin': 'Ar-Rafi',
      'meaning': 'Yang Maha Meninggikan',
      'description': 'Allah Yang meninggikan derajat orang yang beriman.'
    },
    {
      'number': '25',
      'arabic': 'الْمُعِزُّ',
      'latin': 'Al-Muizz',
      'meaning': 'Yang Maha Memuliakan',
      'description':
          'Allah Yang memberikan kemuliaan kepada siapa yang dikehendaki-Nya.'
    },
    {
      'number': '26',
      'arabic': 'الْمُذِلُّ',
      'latin': 'Al-Mudzill',
      'meaning': 'Yang Maha Menghinakan',
      'description': 'Allah Yang menghinakan siapa yang dikehendaki-Nya.'
    },
    {
      'number': '27',
      'arabic': 'السَّمِيْعُ',
      'latin': 'As-Samee',
      'meaning': 'Yang Maha Mendengar',
      'description': 'Allah Yang mendengar segala suara dan bisikan.'
    },
    {
      'number': '28',
      'arabic': 'الْبَصِيْرُ',
      'latin': 'Al-Basheer',
      'meaning': 'Yang Maha Melihat',
      'description':
          'Allah Yang melihat segala sesuatu yang tampak dan tersembunyi.'
    },
    {
      'number': '29',
      'arabic': 'الْحَكَمُ',
      'latin': 'Al-Hakam',
      'meaning': 'Yang Maha Memutuskan',
      'description': 'Allah Yang memutuskan hukum dengan adil dan bijaksana.'
    },
    {
      'number': '30',
      'arabic': 'الْعَدْلُ',
      'latin': 'Al-Adl',
      'meaning': 'Yang Maha Adil',
      'description':
          'Allah Yang berlaku adil dalam segala keputusan dan tindakan.'
    },
    {
      'number': '31',
      'arabic': 'اللَّطِيْفُ',
      'latin': 'Al-Lateef',
      'meaning': 'Yang Maha Lembut',
      'description': 'Allah Yang lembut dalam memperlakukan hamba-Nya.'
    },
    {
      'number': '32',
      'arabic': 'الْخَبِيْرُ',
      'latin': 'Al-Khabeer',
      'meaning': 'Yang Maha Mengetahui',
      'description': 'Allah Yang mengetahui rahasia dan yang tersembunyi.'
    },
    {
      'number': '33',
      'arabic': 'الْحَلِيْمُ',
      'latin': 'Al-Haleem',
      'meaning': 'Yang Maha Penyantun',
      'description': 'Allah Yang penyabar dan tidak tergesa-gesa menghukum.'
    },
    {
      'number': '34',
      'arabic': 'الْعَظِيْمُ',
      'latin': 'Al-Adheem',
      'meaning': 'Yang Maha Agung',
      'description': 'Allah Yang memiliki keagungan yang tak terbatas.'
    },
    {
      'number': '35',
      'arabic': 'الْغَفُوْرُ',
      'latin': 'Al-Ghafoor',
      'meaning': 'Yang Maha Pengampun',
      'description': 'Allah Yang sering mengampuni dosa hamba-Nya.'
    },
    {
      'number': '36',
      'arabic': 'الشَّكُوْرُ',
      'latin': 'As-Shakoor',
      'meaning': 'Yang Maha Pembalas Budi',
      'description': 'Allah Yang membalas kebaikan hamba dengan berlipat ganda.'
    },
    {
      'number': '37',
      'arabic': 'الْعَلِيُّ',
      'latin': 'Al-Aliyy',
      'meaning': 'Yang Maha Tinggi',
      'description': 'Allah Yang tinggi martabat-Nya dari segala sesuatu.'
    },
    {
      'number': '38',
      'arabic': 'الْكَبِيْرُ',
      'latin': 'Al-Kabeer',
      'meaning': 'Yang Maha Besar',
      'description': 'Allah Yang besar zat, sifat, dan perbuatan-Nya.'
    },
    {
      'number': '39',
      'arabic': 'الْحَفِيْظُ',
      'latin': 'Al-Hafeedh',
      'meaning': 'Yang Maha Memelihara',
      'description': 'Allah Yang memelihara dan menjaga segala sesuatu.'
    },
    {
      'number': '40',
      'arabic': 'الْمُقِيْتُ',
      'latin': 'Al-Muqeet',
      'meaning': 'Yang Maha Memberi Kecukupan',
      'description': 'Allah Yang memberikan kecukupan kepada makhluk-Nya.'
    },
    {
      'number': '41',
      'arabic': 'الْحَسِيْبُ',
      'latin': 'Al-Haseeb',
      'meaning': 'Yang Maha Menghitung',
      'description': 'Allah Yang menghitung dan membalas segala amal perbuatan.'
    },
    {
      'number': '42',
      'arabic': 'الْجَلِيْلُ',
      'latin': 'Al-Jaleel',
      'meaning': 'Yang Maha Mulia',
      'description':
          'Allah Yang memiliki kemuliaan dan keagungan yang sempurna.'
    },
    {
      'number': '43',
      'arabic': 'الْكَرِيْمُ',
      'latin': 'Al-Kareem',
      'meaning': 'Yang Maha Mulia',
      'description': 'Allah Yang mulia dan dermawan kepada hamba-Nya.'
    },
    {
      'number': '44',
      'arabic': 'الرَّقِيْبُ',
      'latin': 'Ar-Raqeeb',
      'meaning': 'Yang Maha Mengawasi',
      'description': 'Allah Yang mengawasi segala tingkah laku makhluk-Nya.'
    },
    {
      'number': '45',
      'arabic': 'الْمُجِيْبُ',
      'latin': 'Al-Mujeeb',
      'meaning': 'Yang Maha Mengabulkan',
      'description': 'Allah Yang mengabulkan doa dan permohonan hamba-Nya.'
    },
    {
      'number': '46',
      'arabic': 'الْوَاسِعُ',
      'latin': 'Al-Wasi',
      'meaning': 'Yang Maha Luas',
      'description': 'Allah Yang luas rahmat, ilmu, dan kekuasaan-Nya.'
    },
    {
      'number': '47',
      'arabic': 'الْحَكِيْمُ',
      'latin': 'Al-Hakeem',
      'meaning': 'Yang Maha Bijaksana',
      'description': 'Allah Yang bijaksana dalam segala keputusan dan tindakan.'
    },
    {
      'number': '48',
      'arabic': 'الْوَدُوْدُ',
      'latin': 'Al-Wadood',
      'meaning': 'Yang Maha Pengasih',
      'description':
          'Allah Yang mengasihi hamba-Nya dengan kasih sayang yang dalam.'
    },
    {
      'number': '49',
      'arabic': 'الْمَجِيْدُ',
      'latin': 'Al-Majeed',
      'meaning': 'Yang Maha Mulia',
      'description':
          'Allah Yang memiliki kemuliaan dan kemegahan yang sempurna.'
    },
    {
      'number': '50',
      'arabic': 'الْبَاعِثُ',
      'latin': 'Al-Ba\'its',
      'meaning': 'Yang Maha Membangkitkan',
      'description':
          'Allah Yang membangkitkan makhluk dari kematian di hari kiamat.'
    },
    {
      'number': '51',
      'arabic': 'الشَّهِيْدُ',
      'latin': 'As-Shaheed',
      'meaning': 'Yang Maha Menyaksikan',
      'description': 'Allah Yang menyaksikan segala perbuatan makhluk-Nya.'
    },
    {
      'number': '52',
      'arabic': 'الْحَقُّ',
      'latin': 'Al-Haqq',
      'meaning': 'Yang Maha Benar',
      'description': 'Allah Yang benar zat, sifat, perkataan, dan janji-Nya.'
    },
    {
      'number': '53',
      'arabic': 'الْوَكِيْلُ',
      'latin': 'Al-Wakeel',
      'meaning': 'Yang Maha Memelihara',
      'description':
          'Allah Yang dipercaya untuk mengurus segala urusan makhluk.'
    },
    {
      'number': '54',
      'arabic': 'الْقَوِيُّ',
      'latin': 'Al-Qawiyy',
      'meaning': 'Yang Maha Kuat',
      'description': 'Allah Yang memiliki kekuatan sempurna tanpa kelemahan.'
    },
    {
      'number': '55',
      'arabic': 'الْمَتِيْنُ',
      'latin': 'Al-Mateen',
      'meaning': 'Yang Maha Kokoh',
      'description': 'Allah Yang kokoh kekuatan-Nya tanpa ada yang melemahkan.'
    },
    {
      'number': '56',
      'arabic': 'الْوَلِيُّ',
      'latin': 'Al-Waliyy',
      'meaning': 'Yang Maha Melindungi',
      'description':
          'Allah Yang melindungi dan menolong hamba-Nya yang beriman.'
    },
    {
      'number': '57',
      'arabic': 'الْحَمِيْدُ',
      'latin': 'Al-Hameed',
      'meaning': 'Yang Maha Terpuji',
      'description':
          'Allah Yang terpuji dalam segala zat, sifat, dan perbuatan-Nya.'
    },
    {
      'number': '58',
      'arabic': 'الْمُحْصِي',
      'latin': 'Al-Muhshiy',
      'meaning': 'Yang Maha Menghitung',
      'description':
          'Allah Yang menghitung segala sesuatu dengan teliti dan sempurna.'
    },
    {
      'number': '59',
      'arabic': 'الْمُبْدِئُ',
      'latin': 'Al-Mubdi\'',
      'meaning': 'Yang Maha Memulai',
      'description': 'Allah Yang memulai penciptaan segala sesuatu.'
    },
    {
      'number': '60',
      'arabic': 'الْمُعِيْدُ',
      'latin': 'Al-Mu\'eed',
      'meaning': 'Yang Maha Mengembalikan',
      'description': 'Allah Yang mengembalikan makhluk setelah kematian.'
    },
    {
      'number': '61',
      'arabic': 'الْمُحْيِي',
      'latin': 'Al-Muhyiy',
      'meaning': 'Yang Maha Menghidupkan',
      'description': 'Allah Yang menghidupkan makhluk dari keadaan mati.'
    },
    {
      'number': '62',
      'arabic': 'الْمُمِيْتُ',
      'latin': 'Al-Mumeet',
      'meaning': 'Yang Maha Mematikan',
      'description': 'Allah Yang mematikan makhluk sesuai dengan ketentuan-Nya.'
    },
    {
      'number': '63',
      'arabic': 'الْحَيُّ',
      'latin': 'Al-Hayy',
      'meaning': 'Yang Maha Hidup',
      'description':
          'Allah Yang hidup dengan kehidupan yang sempurna dan kekal.'
    },
    {
      'number': '64',
      'arabic': 'الْقَيُّوْمُ',
      'latin': 'Al-Qayyoom',
      'meaning': 'Yang Maha Berdiri Sendiri',
      'description': 'Allah Yang berdiri sendiri dan mengurus segala sesuatu.'
    },
    {
      'number': '65',
      'arabic': 'الْوَاجِدُ',
      'latin': 'Al-Wajid',
      'meaning': 'Yang Maha Kaya',
      'description': 'Allah Yang kaya dan tidak memerlukan siapa pun.'
    },
    {
      'number': '66',
      'arabic': 'الْمَاجِدُ',
      'latin': 'Al-Majid',
      'meaning': 'Yang Maha Mulia',
      'description': 'Allah Yang mulia dan agung dalam segala hal.'
    },
    {
      'number': '67',
      'arabic': 'الْوَاحِدُ',
      'latin': 'Al-Wahid',
      'meaning': 'Yang Maha Esa',
      'description': 'Allah Yang Esa dalam zat, sifat, dan perbuatan-Nya.'
    },
    {
      'number': '68',
      'arabic': 'الصَّمَدُ',
      'latin': 'As-Shamad',
      'meaning': 'Yang Maha Dibutuhkan',
      'description':
          'Allah Yang dibutuhkan oleh semua makhluk tetapi tidak membutuhkan siapa pun.'
    },
    {
      'number': '69',
      'arabic': 'الْقَادِرُ',
      'latin': 'Al-Qadir',
      'meaning': 'Yang Maha Kuasa',
      'description': 'Allah Yang berkuasa atas segala sesuatu.'
    },
    {
      'number': '70',
      'arabic': 'الْمُقْتَدِرُ',
      'latin': 'Al-Muqtadir',
      'meaning': 'Yang Maha Menentukan',
      'description':
          'Allah Yang menentukan takdir segala sesuatu dengan sempurna.'
    },
    {
      'number': '71',
      'arabic': 'الْمُقَدِّمُ',
      'latin': 'Al-Muqaddim',
      'meaning': 'Yang Maha Mendahulukan',
      'description': 'Allah Yang mendahulukan apa yang dikehendaki-Nya.'
    },
    {
      'number': '72',
      'arabic': 'الْمُؤَخِّرُ',
      'latin': 'Al-Mu\'akhkhir',
      'meaning': 'Yang Maha Mengakhirkan',
      'description': 'Allah Yang mengakhirkan apa yang dikehendaki-Nya.'
    },
    {
      'number': '73',
      'arabic': 'الأَوَّلُ',
      'latin': 'Al-Awwal',
      'meaning': 'Yang Maha Awal',
      'description': 'Allah Yang ada sejak awal, tidak ada yang mendahului-Nya.'
    },
    {
      'number': '74',
      'arabic': 'الآخِرُ',
      'latin': 'Al-Aakhir',
      'meaning': 'Yang Maha Akhir',
      'description': 'Allah Yang kekal abadi, tidak ada yang setelah-Nya.'
    },
    {
      'number': '75',
      'arabic': 'الظَّاهِرُ',
      'latin': 'Az-Zhahir',
      'meaning': 'Yang Maha Nyata',
      'description': 'Allah Yang nyata keberadaan-Nya melalui tanda-tanda-Nya.'
    },
    {
      'number': '76',
      'arabic': 'الْبَاطِنُ',
      'latin': 'Al-Bathin',
      'meaning': 'Yang Maha Tersembunyi',
      'description': 'Allah Yang tersembunyi zat-Nya dari penglihatan makhluk.'
    },
    {
      'number': '77',
      'arabic': 'الْوَالِي',
      'latin': 'Al-Waali',
      'meaning': 'Yang Maha Memerintah',
      'description': 'Allah Yang memerintah dan menguasai segala sesuatu.'
    },
    {
      'number': '78',
      'arabic': 'الْمُتَعَالِي',
      'latin': 'Al-Muta\'aali',
      'meaning': 'Yang Maha Tinggi',
      'description': 'Allah Yang tinggi dari segala sifat makhluk.'
    },
    {
      'number': '79',
      'arabic': 'الْبَرُّ',
      'latin': 'Al-Barr',
      'meaning': 'Yang Maha Berbuat Baik',
      'description': 'Allah Yang berbuat baik dan dermawan kepada hamba-Nya.'
    },
    {
      'number': '80',
      'arabic': 'التَّوَّابُ',
      'latin': 'At-Tawwab',
      'meaning': 'Yang Maha Penerima Tobat',
      'description': 'Allah Yang menerima tobat hamba dan mengampuni dosanya.'
    },
    {
      'number': '81',
      'arabic': 'الْمُنْتَقِمُ',
      'latin': 'Al-Muntaqim',
      'meaning': 'Yang Maha Pembalas',
      'description': 'Allah Yang membalas kejahatan orang-orang yang durhaka.'
    },
    {
      'number': '82',
      'arabic': 'العَفُوُّ',
      'latin': 'Al-Afuww',
      'meaning': 'Yang Maha Pemaaf',
      'description': 'Allah Yang memaafkan dosa hamba tanpa menghukumnya.'
    },
    {
      'number': '83',
      'arabic': 'الرَّؤُوْفُ',
      'latin': 'Ar-Ra\'oof',
      'meaning': 'Yang Maha Pengasih',
      'description':
          'Allah Yang sangat penyayang dan lemah lembut kepada hamba-Nya.'
    },
    {
      'number': '84',
      'arabic': 'مَالِكُ الْمُلْكِ',
      'latin': 'Malik Al-Mulk',
      'meaning': 'Penguasa Kerajaan',
      'description':
          'Allah Yang memiliki dan menguasai seluruh kerajaan alam semesta.'
    },
    {
      'number': '85',
      'arabic': 'ذُوالْجَلاَلِ وَالإِكْرَامِ',
      'latin': 'Dzul Jalali Wal Ikram',
      'meaning': 'Yang Memiliki Keagungan dan Kemuliaan',
      'description':
          'Allah Yang memiliki keagungan dan kemuliaan yang sempurna.'
    },
    {
      'number': '86',
      'arabic': 'الْمُقْسِطُ',
      'latin': 'Al-Muqsith',
      'meaning': 'Yang Maha Adil',
      'description':
          'Allah Yang berlaku adil dalam memberikan hukuman dan ganjaran.'
    },
    {
      'number': '87',
      'arabic': 'الْجَامِعُ',
      'latin': 'Al-Jami',
      'meaning': 'Yang Maha Mengumpulkan',
      'description':
          'Allah Yang mengumpulkan makhluk di hari kiamat untuk dihisab.'
    },
    {
      'number': '88',
      'arabic': 'الْغَنِيُّ',
      'latin': 'Al-Ghaniyy',
      'meaning': 'Yang Maha Kaya',
      'description': 'Allah Yang kaya dan tidak membutuhkan siapa pun.'
    },
    {
      'number': '89',
      'arabic': 'الْمُغْنِي',
      'latin': 'Al-Mughni',
      'meaning': 'Yang Maha Memberi Kekayaan',
      'description':
          'Allah Yang memberikan kekayaan dan kecukupan kepada hamba-Nya.'
    },
    {
      'number': '90',
      'arabic': 'الْمَانِعُ',
      'latin': 'Al-Mani',
      'meaning': 'Yang Maha Mencegah',
      'description': 'Allah Yang mencegah apa yang tidak baik bagi hamba-Nya.'
    },
    {
      'number': '91',
      'arabic': 'الضَّارُ',
      'latin': 'Ad-Dharr',
      'meaning': 'Yang Maha Pemberi Mudarat',
      'description': 'Allah Yang memberikan cobaan sesuai dengan hikmah-Nya.'
    },
    {
      'number': '92',
      'arabic': 'النَّافِعُ',
      'latin': 'An-Nafi',
      'meaning': 'Yang Maha Pemberi Manfaat',
      'description': 'Allah Yang memberikan manfaat kepada makhluk-Nya.'
    },
    {
      'number': '93',
      'arabic': 'النُّوْرُ',
      'latin': 'An-Nur',
      'meaning': 'Yang Maha Bercahaya',
      'description':
          'Allah Yang menjadi cahaya langit dan bumi serta memberi petunjuk.'
    },
    {
      'number': '94',
      'arabic': 'الْهَادِي',
      'latin': 'Al-Hadi',
      'meaning': 'Yang Maha Pemberi Petunjuk',
      'description':
          'Allah Yang memberikan petunjuk kepada makhluk-Nya ke jalan yang benar.'
    },
    {
      'number': '95',
      'arabic': 'الْبَدِيْعُ',
      'latin': 'Al-Badee',
      'meaning': 'Yang Maha Pencipta',
      'description':
          'Allah Yang menciptakan segala sesuatu dengan cara yang menakjubkan.'
    },
    {
      'number': '96',
      'arabic': 'الْبَاقِي',
      'latin': 'Al-Baqi',
      'meaning': 'Yang Maha Kekal',
      'description': 'Allah Yang kekal abadi dan tidak akan binasa.'
    },
    {
      'number': '97',
      'arabic': 'الْوَارِثُ',
      'latin': 'Al-Warits',
      'meaning': 'Yang Maha Pewaris',
      'description':
          'Allah Yang mewarisi segala sesuatu setelah makhluk-Nya binasa.'
    },
    {
      'number': '98',
      'arabic': 'الرَّشِيْدُ',
      'latin': 'Ar-Rasheed',
      'meaning': 'Yang Maha Pandai',
      'description':
          'Allah Yang pandai dalam mengatur segala urusan dengan sempurna.'
    },
    {
      'number': '99',
      'arabic': 'الصَّبُوْرُ',
      'latin': 'As-Shabur',
      'meaning': 'Yang Maha Sabar',
      'description':
          'Allah Yang sabar dalam menghadapi kemaksiatan hamba-Nya dan tidak tergesa-gesa menghukum.'
    },
  ];

  List<Map<String, String>> get filteredAsma {
    if (_searchQuery.isEmpty) {
      return _asmaulHusna;
    }
    return _asmaulHusna.where((asma) {
      return asma['latin']!
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          asma['meaning']!.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          asma['arabic']!.contains(_searchQuery);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = filteredAsma;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Asmaul Husna'),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                  _selectedIndex = -1;
                });
              },
              decoration: InputDecoration(
                hintText: 'Cari nama Allah...',
                prefixIcon: const Icon(Icons.search, color: Color(0xFF2E7D32)),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),

          // Counter
          if (_searchQuery.isEmpty)
            Container(
              color: Colors.white,
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF2E7D32), Color(0xFF4CAF50)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.favorite, color: Colors.white),
                    const SizedBox(width: 8),
                    Text(
                      '${_asmaulHusna.length} Nama Allah Yang Indah',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final asma = filtered[index];
                final isSelected = index == _selectedIndex;
                return _buildAsmaCard(asma, index, isSelected);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAsmaCard(Map<String, String> asma, int index, bool isSelected) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: isSelected ? 8 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: isSelected
              ? const LinearGradient(
                  colors: [Color(0xFF2E7D32), Color(0xFF4CAF50)],
                )
              : LinearGradient(
                  colors: [Colors.white, Colors.green[50]!],
                ),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            setState(() {
              _selectedIndex = _selectedIndex == index ? -1 : index;
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Number
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color:
                            isSelected ? Colors.white : const Color(0xFF2E7D32),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          asma['number']!,
                          style: TextStyle(
                            color: isSelected
                                ? const Color(0xFF2E7D32)
                                : Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 16),

                    // Arabic and Latin
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            asma['arabic']!,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: isSelected
                                  ? Colors.white
                                  : const Color(0xFF2E7D32),
                            ),
                            textDirection: TextDirection.rtl,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            asma['latin']!,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: isSelected
                                  ? Colors.white70
                                  : Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Expand Icon
                    Icon(
                      isSelected ? Icons.expand_less : Icons.expand_more,
                      color: isSelected ? Colors.white : Colors.grey,
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // Meaning
                Text(
                  asma['meaning']!,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : const Color(0xFF2E7D32),
                  ),
                ),

                // Expanded Description
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: isSelected ? null : 0,
                  child: isSelected
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 16),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Penjelasan:',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    asma['description']!,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      height: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 16),

                            // Action Buttons
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton.icon(
                                    onPressed: () => _copyAsma(asma),
                                    icon: const Icon(Icons.copy,
                                        size: 18, color: Colors.white),
                                    label: const Text('Salin',
                                        style: TextStyle(color: Colors.white)),
                                    style: OutlinedButton.styleFrom(
                                      side:
                                          const BorderSide(color: Colors.white),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () => _shareAsma(asma),
                                    icon: const Icon(Icons.share, size: 18),
                                    label: const Text('Bagikan'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      foregroundColor: const Color(0xFF2E7D32),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _copyAsma(Map<String, String> asma) {
    // In a real app, you would use Clipboard.setData
    // final asmaText = '''
    // ${asma['number']}. ${asma['arabic']} (${asma['latin']})
    //
    // Artinya: ${asma['meaning']}
    //
    // ${asma['description']}
    // ''';
    // Clipboard.setData(ClipboardData(text: asmaText));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${asma['latin']} berhasil disalin'),
        backgroundColor: const Color(0xFF2E7D32),
      ),
    );
  }

  void _shareAsma(Map<String, String> asma) {
    // In a real app, you would use Share.share
    // final asmaText = '''
    // ${asma['number']}. ${asma['arabic']} (${asma['latin']})
    //
    // Artinya: ${asma['meaning']}
    //
    // ${asma['description']}
    //
    // Dibagikan dari Al-Qur'an Digital
    // ''';
    // Share.share(asmaText);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Berbagi ${asma['latin']}'),
        backgroundColor: const Color(0xFF2E7D32),
      ),
    );
  }
}
