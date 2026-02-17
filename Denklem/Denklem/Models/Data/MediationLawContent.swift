//
//  MediationLawContent.swift
//  Denklem
//
//  Created by ozkan on 17.02.2026.
//

import Foundation

// MARK: - 6325 Sayılı Hukuk Uyuşmazlıklarında Arabuluculuk Kanunu

extension LawDocumentContent {

    // swiftlint:disable function_body_length
    static let mediationLaw6325 = LawDocumentContent(
        lawNumber: 6325,
        title: "HUKUK UYUŞMAZLIKLARINDA ARABULUCULUK KANUNU",
        gazetteDate: "22.06.2012",
        gazetteNumber: "28331",
        acceptanceDate: "7/6/2012",
        articles: [
            // BİRİNCİ BÖLÜM - Amaç, Kapsam ve Tanımlar
            LawArticle(
                number: "1",
                title: "Amaç ve kapsam",
                paragraphs: [
                    "Bu Kanunun amacı, hukuk uyuşmazlıklarının arabuluculuk yoluyla çözümlenmesinde uygulanacak usul ve esasları düzenlemektir.",
                    "Bu Kanun, yabancılık unsuru taşıyanlar da dâhil olmak üzere, ancak tarafların üzerinde serbestçe tasarruf edebilecekleri iş veya işlemlerden doğan özel hukuk uyuşmazlıklarının çözümlenmesinde uygulanır. Şu kadar ki, aile içi şiddet iddiasını içeren uyuşmazlıklar arabuluculuğa elverişli değildir."
                ]
            ),
            LawArticle(
                number: "2",
                title: "Tanımlar",
                paragraphs: [
                    "Bu Kanunun uygulanmasında;\na) Arabulucu: Arabuluculuk faaliyetini yürüten ve Bakanlıkça düzenlenen arabulucular siciline kaydedilmiş bulunan gerçek kişiyi,\nb) Arabuluculuk: Sistematik teknikler uygulayarak, görüşmek ve müzakerelerde bulunmak amacıyla tarafları bir araya getiren, onların birbirlerini anlamalarını ve bu suretle çözümlerini kendilerinin üretmesini sağlamak için aralarında iletişim sürecinin kurulmasını gerçekleştiren, tarafların çözüm üretemediklerinin ortaya çıkması hâlinde çözüm önerisi de getirebilen, uzmanlık eğitimi almış olan tarafsız ve bağımsız bir üçüncü kişinin katılımıyla ve ihtiyarî olarak yürütülen uyuşmazlık çözüm yöntemini,\nc) Bakanlık: Adalet Bakanlığını,\nç) Daire Başkanlığı: Hukuk İşleri Genel Müdürlüğü bünyesinde oluşturulacak Arabuluculuk Daire Başkanlığını,\nd) Genel Müdürlük: Hukuk İşleri Genel Müdürlüğünü,\ne) (Ek: 12/10/2017-7036/17 md.) İdare: 10/12/2003 tarihli ve 5018 sayılı Kamu Malî Yönetimi ve Kontrol Kanununa ekli (I), (II), (III) ve (IV) sayılı cetvellerde yer alan idare ve kurumlar ile 5018 sayılı Kanunda tanımlanan mahalli idareler ve bu idareler tarafından kurulan işletmeleri, özel kanunla kurulmuş diğer kamu kurum, kurul, üst kurul ve kuruluşları, kamu iktisadi teşebbüsleri ile bunların bağlı ortaklıkları, müessese ve işletmelerini, sermayesinin yüzde ellisinden fazlası kamuya ait diğer ortaklıkları,\nf) Kurul: Arabuluculuk Kurulunu,\ng) Sicil: Arabulucular sicilini,\nifade eder."
                ]
            ),
            // İKİNCİ BÖLÜM - Arabuluculuğa İlişkin Temel İlkeler
            LawArticle(
                number: "3",
                title: "İradi olma ve eşitlik",
                paragraphs: [
                    "Taraflar, arabulucuya başvurmak, süreci devam ettirmek, sonuçlandırmak veya bu süreçten vazgeçmek konusunda serbesttirler. Şu kadar ki dava şartı olarak arabuluculuğa ilişkin 18/A maddesi hükmü saklıdır.",
                    "Taraflar, gerek arabulucuya başvururken gerekse tüm süreç boyunca eşit haklara sahiptirler."
                ]
            ),
            LawArticle(
                number: "4",
                title: "Gizlilik",
                paragraphs: [
                    "Taraflarca aksi kararlaştırılmadıkça arabulucu, arabuluculuk faaliyeti çerçevesinde kendisine sunulan veya diğer bir şekilde elde ettiği bilgi ve belgeler ile diğer kayıtları gizli tutmakla yükümlüdür.",
                    "Aksi kararlaştırılmadıkça taraflar ve görüşmelere katılan diğer kişiler de bu konudaki gizliliğe uymak zorundadırlar."
                ]
            ),
            LawArticle(
                number: "5",
                title: "Beyan veya belgelerin kullanılamaması",
                paragraphs: [
                    "Taraflar, arabulucu veya arabuluculuğa katılanlar da dâhil üçüncü bir kişi, uyuşmazlıkla ilgili olarak hukuk davası açıldığında yahut tahkim yoluna başvurulduğunda, aşağıdaki beyan veya belgeleri delil olarak ileri süremez ve bunlar hakkında tanıklık yapamaz:\na) Taraflarca yapılan arabuluculuk daveti veya bir tarafın arabuluculuk faaliyetine katılma isteği.\nb) Uyuşmazlığın arabuluculuk yolu ile sona erdirilmesi için taraflarca ileri sürülen görüşler ve teklifler.\nc) Arabuluculuk faaliyeti esnasında, taraflarca ileri sürülen öneriler veya herhangi bir vakıa veya iddianın kabulü.\nç) Sadece arabuluculuk faaliyeti dolayısıyla hazırlanan belgeler.",
                    "Birinci fıkra hükmü, beyan veya belgenin şekline bakılmaksızın uygulanır.",
                    "Birinci fıkrada belirtilen bilgilerin açıklanması mahkeme, hakem veya herhangi bir idari makam tarafından istenemez. Bu beyan veya belgeler, birinci fıkrada öngörülenin aksine, delil olarak sunulmuş olsa dahi hükme esas alınamaz. Ancak, söz konusu bilgiler bir kanun hükmü tarafından emredildiği veya arabuluculuk süreci sonunda varılan anlaşmanın uygulanması ve icrası için gerekli olduğu ölçüde açıklanabilir.",
                    "Yukarıdaki fıkralar, arabuluculuğun konusuyla ilgili olup olmadığına bakılmaksızın, hukuk davası ve tahkimde uygulanır.",
                    "Birinci fıkrada belirtilen sınırlamalar saklı kalmak koşuluyla, hukuk davası ve tahkimde ileri sürülebilen deliller, sadece arabuluculukta sunulmaları sebebiyle kabul edilemeyecek deliller haline gelmez."
                ]
            ),
            // ÜÇÜNCÜ BÖLÜM - Arabulucuların Hak ve Yükümlülükleri
            LawArticle(
                number: "6",
                title: "Unvanın kullanılması",
                paragraphs: [
                    "Sicile kayıtlı olan arabulucular, arabulucu unvanını ve bu unvanın sağladığı yetkileri kullanma hakkına sahiptirler.",
                    "Arabulucu, arabuluculuk faaliyeti sırasında bu unvanını belirtmek zorundadır.",
                    "(Ek: 12/10/2017-7036/19 md.) Daire Başkanlığı, arabulucuların uzmanlık alanlarını ve uzmanlığa ilişkin usul ve esasları belirlemeye yetkilidir."
                ]
            ),
            LawArticle(
                number: "7",
                title: "Ücret ve masrafların istenmesi",
                paragraphs: [
                    "Arabulucu yapmış olduğu faaliyet karşılığı ücret ve masrafları isteme hakkına sahiptir. Arabulucu, ücret ve masraflar için avans da talep edebilir.",
                    "Aksi kararlaştırılmadıkça arabulucunun ücreti, faaliyetin sona erdiği tarihte yürürlükte bulunan Arabulucu Asgari Ücret Tarifesine göre belirlenir ve ücret ile masraf taraflarca eşit olarak karşılanır.",
                    "Arabulucu, arabuluculuk sürecine ilişkin olarak belirli kişiler için aracılık yapma veya belirli kişileri tavsiye etmenin karşılığı olarak ücret alamaz. Bu yasağa aykırı işlemler batıldır."
                ]
            ),
            LawArticle(
                number: "8",
                title: "Taraflarla görüşme ve iletişim kurulması",
                paragraphs: [
                    "Arabulucu, tarafların her biri ile ayrı ayrı veya birlikte görüşebilir ve iletişim kurabilir."
                ]
            ),
            LawArticle(
                number: "9",
                title: "Görevin özenle ve tarafsız biçimde yerine getirilmesi",
                paragraphs: [
                    "Arabulucu görevini özenle, tarafsız bir biçimde ve şahsen yerine getirir.",
                    "Arabulucu olarak görevlendirilen kimse, tarafsızlığından şüphe edilmesini gerektirecek önemli hâl ve şartların varlığı hâlinde, bu hususta tarafları bilgilendirmekle yükümlüdür. Bu açıklamaya rağmen taraflar, arabulucudan birlikte talep ederlerse, arabulucu bu görevi üstlenebilir yahut üstlenmiş olduğu görevi sürdürebilir.",
                    "Arabulucu, taraflar arasında eşitliği gözetmekle yükümlüdür.",
                    "Arabulucu, bu sıfatla görev yaptığı uyuşmazlıkla ilgili olarak açılan davada, daha sonra taraflardan birinin avukatı olarak görev üstlenemez."
                ]
            ),
            LawArticle(
                number: "10",
                title: "Reklam yasağı",
                paragraphs: [
                    "Arabulucuların iş elde etmek için reklam sayılabilecek her türlü teşebbüs ve harekette bulunmaları ve özellikle tabelalarında ve basılı kâğıtlarında arabulucu, avukat ve akademik unvanlarından başka sıfat kullanmaları yasaktır."
                ]
            ),
            LawArticle(
                number: "11",
                title: "Tarafların aydınlatılması",
                paragraphs: [
                    "Arabulucu, arabuluculuk faaliyetinin başında, tarafları arabuluculuğun esasları, süreci ve sonuçları hakkında gerektiği gibi aydınlatmakla yükümlüdür."
                ]
            ),
            LawArticle(
                number: "12",
                title: "Aidat ödenmesi",
                paragraphs: [
                    "Arabuluculardan sicile kayıtlarında giriş aidatı ve her yıl için yıllık aidat alınır.",
                    "Giriş aidatı ve yıllık aidatlar genel bütçeye gelir kaydedilir."
                ]
            ),
            // DÖRDÜNCÜ BÖLÜM - Arabuluculuk Faaliyeti
            LawArticle(
                number: "13",
                title: "Arabulucuya başvuru",
                paragraphs: [
                    "Taraflar dava açılmadan önce veya davanın görülmesi sırasında arabulucuya başvurma konusunda anlaşabilirler. Mahkeme de tarafları arabulucuya başvurmak konusunda aydınlatıp, teşvik edebilir.",
                    "Aksi kararlaştırılmadıkça taraflardan birinin arabulucuya başvuru teklifine otuz gün içinde olumlu cevap verilmez ise bu teklif reddedilmiş sayılır.",
                    "(Ek: 12/10/2017-7036/21 md.) Arabuluculuk ücretini karşılamak için adli yardıma ihtiyaç duyan taraf, arabuluculuk bürosunun bulunduğu yerdeki sulh hukuk mahkemesinin kararıyla adli yardımdan yararlanabilir. Bu konuda 12/1/2011 tarihli ve 6100 sayılı Hukuk Muhakemeleri Kanununun 334 ila 340 ıncı maddeleri kıyasen uygulanır."
                ]
            ),
            LawArticle(
                number: "14",
                title: "Arabulucunun seçilmesi",
                paragraphs: [
                    "Başkaca bir usul kararlaştırılmadıkça arabulucu veya arabulucular taraflarca seçilir."
                ]
            ),
            LawArticle(
                number: "15",
                title: "Arabuluculuk faaliyetinin yürütülmesi",
                paragraphs: [
                    "Arabulucu, seçildikten sonra tarafları en kısa sürede ilk toplantıya davet eder.",
                    "Taraflar, emredici hukuk kurallarına aykırı olmamak kaydıyla arabuluculuk usulünü serbestçe kararlaştırabilirler.",
                    "Taraflarca kararlaştırılmamışsa arabulucu; uyuşmazlığın niteliğini, tarafların isteklerini ve uyuşmazlığın hızlı bir şekilde çözümlenmesi için gereken usul ve esasları göz önüne alarak arabuluculuk faaliyetini yürütür.",
                    "Niteliği gereği yargısal bir yetkinin kullanımı olarak sadece hâkim tarafından yapılabilecek işlemler arabulucu tarafından yapılamaz.",
                    "Dava açıldıktan sonra tarafların birlikte arabulucuya başvuracaklarını beyan etmeleri hâlinde yargılama, mahkemece üç ayı geçmemek üzere ertelenir. Bu süre, tarafların birlikte başvurusu üzerine üç aya kadar uzatılabilir.",
                    "(Değişik: 12/10/2017-7036/22 md.) Arabuluculuk müzakerelerine taraflar bizzat, kanuni temsilcileri veya avukatları aracılığıyla katılabilirler. Uyuşmazlığın çözümüne katkı sağlayabilecek uzman kişiler de müzakerelerde hazır bulundurulabilir.",
                    "(Ek: 12/10/2017-7036/22 md.) Tarafların çözüm üretemediklerinin ortaya çıkması hâlinde arabulucu bir çözüm önerisinde bulunabilir.",
                    "(Ek: 12/10/2017-7036/22 md.) Arabuluculuk müzakerelerinde idareyi, üst yönetici tarafından belirlenen iki üye ile hukuk birimi amiri veya onun belirleyeceği bir avukat ya da hukuk müşavirinden oluşan komisyon temsil eder. Komisyon, arabuluculuk müzakereleri sonunda gerekçeli bir rapor düzenler ve beş yıl boyunca saklar.",
                    "(Ek: 12/10/2017-7036/22 md.) Komisyon üyelerinin arabuluculuk faaliyeti kapsamında yaptıkları işler ve aldıkları kararlar sebebiyle açılacak tazminat davaları, ancak Devlet aleyhine açılabilir. Devlet ödediği tazminattan dolayı görevinin gereklerine aykırı hareket etmek suretiyle görevini kötüye kullanan üyelere ödeme tarihinden itibaren bir yıl içinde rücu eder.",
                    "(Ek: 12/10/2017-7036/22 md.) Bu maddenin uygulanmasına ilişkin usul ve esaslar Bakanlıkça yürürlüğe konulan yönetmelikle düzenlenir."
                ]
            ),
            LawArticle(
                number: "16",
                title: "Arabuluculuk sürecinin başlaması ve sürelere etkisi",
                paragraphs: [
                    "Arabuluculuk süreci, dava açılmadan önce arabulucuya başvuru hâlinde, tarafların ilk toplantıya davet edilmeleri ve taraflarla arabulucu arasında sürecin devam ettirilmesi konusunda anlaşmaya varılıp bu durumun bir tutanakla belgelendirildiği tarihten itibaren işlemeye başlar. Dava açılmasından sonra arabulucuya başvuru hâlinde ise bu süreç, mahkemenin tarafları arabuluculuğa davetinin taraflarca kabul edilmesi veya tarafların arabulucuya başvurma konusunda anlaşmaya vardıklarını duruşma dışında mahkemeye yazılı olarak beyan ettikleri ya da duruşmada bu beyanlarının tutanağa geçirildiği tarihten itibaren işlemeye başlar.",
                    "Arabuluculuk sürecinin başlamasından sona ermesine kadar geçirilen süre, zamanaşımı ve hak düşürücü sürelerin hesaplanmasında dikkate alınmaz."
                ]
            ),
            LawArticle(
                number: "17",
                title: "Arabuluculuğun sona ermesi",
                paragraphs: [
                    "Aşağıda belirtilen hâllerde arabuluculuk faaliyeti sona erer:\na) Tarafların anlaşmaya varması.\nb) Taraflara danışıldıktan sonra arabuluculuk için daha fazla çaba sarf edilmesinin gereksiz olduğunun arabulucu tarafından tespit edilmesi.\nc) Taraflardan birinin karşı tarafa veya arabulucuya, arabuluculuk faaliyetinden çekildiğini bildirmesi.\nç) Tarafların anlaşarak arabuluculuk faaliyetini sona erdirmesi.\nd) (Değişik: 12/10/2017-7036/23 md.) Uyuşmazlığın arabuluculuğa elverişli olmadığının tespit edilmesi.",
                    "Arabuluculuk faaliyeti sonunda tarafların anlaştıkları, anlaşamadıkları veya arabuluculuk faaliyetinin nasıl sonuçlandığı bir tutanak ile belgelendirilir. Arabulucu tarafından düzenlenecek bu belge, arabulucu, taraflar, kanuni temsilcileri veya avukatlarınca imzalanır. Belge taraflar, kanuni temsilcileri veya avukatlarınca imzalanmazsa, sebebi belirtilmek suretiyle sadece arabulucu tarafından imzalanır.",
                    "Arabuluculuk faaliyeti sonunda düzenlenen tutanağa, faaliyetin sonuçlanması dışında hangi hususların yazılacağına taraflar karar verir. Arabulucu, bu tutanak ve sonuçları konusunda taraflara gerekli açıklamaları yapar ve taraflar hazır değilse her türlü iletişim vasıtasını kullanarak hazır bulunmayan tarafları bilgilendirir.",
                    "Arabuluculuk faaliyetinin sona ermesi hâlinde, arabulucu, bu faaliyete ilişkin kendisine yapılan bildirimi, tevdi edilen ve elinde bulunan belgeleri, ikinci fıkraya göre düzenlenen tutanağı beş yıl süre ile saklamak zorundadır. Arabulucu, arabuluculuk faaliyeti sonunda düzenlediği son tutanağın bir örneğini arabuluculuk faaliyetinin sona ermesinden itibaren bir ay içinde Genel Müdürlüğe gönderir."
                ]
            ),
            LawArticle(
                number: "17/A",
                title: "Milletlerarası sulh anlaşma belgelerinin icrası",
                paragraphs: [
                    "(Ek:28/3/2023-7445/33 md.) 25/2/2021 tarihli ve 7282 sayılı Arabuluculuk Sonucunda Yapılan Milletlerarası Sulh Anlaşmaları Hakkında Birleşmiş Milletler Konvansiyonunun Onaylanmasının Uygun Bulunduğuna Dair Kanunla kabul edilen Sözleşme kapsamında arabuluculuk sonucu düzenlenen sulh anlaşma belgelerinin yerine getirilmesi için icra edilebilirlik şerhinin asliye ticaret mahkemesinden alınması zorunludur.",
                    "İcra edilebilirlik şerhi, tarafların kararlaştırdıkları yer mahkemesinden, kararlaştırdıkları yer yoksa sırasıyla karşı tarafın Türkiye'deki yerleşim yeri mahkemesinden, sakin olduğu yer mahkemesinden, Türkiye'de yerleşim yeri veya sakin olduğu bir yer mevcut değilse Ankara, İstanbul veya İzmir mahkemelerinden birinden istenebilir.",
                    "İcra edilebilirlik şerhinin verilmesine ilişkin inceleme dosya üzerinden, Sözleşme hükümleri ile 18 inci madde hükmüne göre yapılır. Mahkeme, gerektiğinde gerekçesini de göstererek duruşma açabilir."
                ]
            ),
            LawArticle(
                number: "17/B",
                title: "Taşınmazın devrine veya taşınmaz üzerinde sınırlı ayni hak kurulmasına ilişkin uyuşmazlıklarda arabuluculuk",
                paragraphs: [
                    "(Ek:28/3/2023-7445/34 md.) Taşınmazın devrine veya taşınmaz üzerinde sınırlı ayni hak kurulmasına ilişkin uyuşmazlıklar arabuluculuğa elverişlidir.",
                    "Birinci fıkra kapsamındaki uyuşmazlıklarda, tarafların yazılı olarak kararlaştırması ve arabulucunun bu kararı tutanak altına alması halinde arabulucunun talebiyle, arabuluculuk süreciyle sınırlı olmak ve konulduğu tarihten itibaren üç ayı geçmemek üzere tasarruf yetkisinin kısıtlandığına dair tapu siciline şerh verilir. Bu şerh, tarafların anlaşamaması veya tarafların şerhin kaldırılması konusunda anlaşması halinde arabulucunun talebiyle, üç aylık sürenin sonunda ise kendiliğinden kalkar.",
                    "Arabuluculuk süreci sonunda tarafların anlaşması halinde anlaşma belgesi, taşınmazın devri veya taşınmaz üzerinde sınırlı ayni hak kurulmasıyla ilgili olarak kanunlarda yer alan sınırlamalar ile usul ve esaslar gözetilmek suretiyle düzenlenir.",
                    "Anlaşma belgesinin icra edilebilirliğine ilişkin şerhin alınması zorunlu olup bu şerh taşınmazın bulunduğu yer sulh hukuk mahkemesinden alınır. Mahkeme yapacağı incelemede anlaşma içeriğini, arabuluculuğa ve cebri icraya elverişli olup olmadığı ve taşınmazın devri veya taşınmaz üzerinde sınırlı ayni hak kurulmasıyla ilgili olarak kanunlarda yer alan sınırlamalar ile usul ve esaslara uyulup uyulmadığı yönünden denetler; bu kapsamda kurum veya kuruluşlardan bilgi veya belge talep edebilir ve gerektiğinde duruşma açabilir.",
                    "Anlaşma belgesinin icra edilebilirliğine ilişkin şerhin verilmesiyle ilgili diğer hususlar hakkında 18 inci madde hükmü uygulanır.",
                    "(Ek:7/11/2024-7531/24 md.) Anlaşma belgesinin taraflarından biri, icra edilebilirlik şerhi verilmesinden sonra tapu müdürlüğünden tescil talebinde bulunabilir. Tapu müdürlüğünce taşınmaza ilişkin mevzuatta öngörülen gerekli inceleme ve değerlendirme yapıldıktan sonra resmi senet düzenlenmeksizin tescil talebi yerine getirilir."
                ]
            ),
            LawArticle(
                number: "18",
                title: "Tarafların anlaşması",
                paragraphs: [
                    "Arabuluculuk faaliyeti sonunda varılan anlaşmanın kapsamı taraflarca belirlenir; anlaşma belgesi düzenlenmesi hâlinde bu belge taraflar ve arabulucu tarafından imzalanır.",
                    "Taraflar arabuluculuk faaliyeti sonunda bir anlaşmaya varırlarsa, bu anlaşma belgesinin icra edilebilirliğine ilişkin şerh verilmesini talep edebilirler. Dava açılmadan önce arabuluculuğa başvurulmuşsa, anlaşmanın icra edilebilirliğine ilişkin şerh verilmesi, arabulucunun görev yaptığı yer sulh hukuk mahkemesinden talep edilebilir. Davanın görülmesi sırasında arabuluculuğa başvurulması durumunda ise anlaşmanın icra edilebilirliğine ilişkin şerh verilmesi, davanın görüldüğü mahkemeden talep edilebilir. Bu şerhi içeren anlaşma, ilam niteliğinde belge sayılır.",
                    "İcra edilebilirlik şerhinin verilmesi, çekişmesiz yargı işidir ve buna ilişkin inceleme dosya üzerinden yapılır. Ancak arabuluculuğa elverişli olan aile hukukuna ilişkin uyuşmazlıklarda inceleme duruşmalı olarak yapılır. Bu incelemenin kapsamı anlaşmanın içeriğinin arabuluculuğa ve cebri icraya elverişli olup olmadığı hususlarıyla sınırlıdır. Anlaşma belgesine icra edilebilirlik şerhi verilmesi için mahkemeye yapılacak olan başvuru ile bunun üzerine verilecek kararlara karşı ilgili tarafından istinaf yoluna gidilmesi hâlinde, maktu harç alınır. Taraflar anlaşma belgesini icra edilebilirlik şerhi verdirmeden başka bir resmî işlemde kullanmak isterlerse, damga vergisi de maktu olarak alınır.",
                    "(Ek: 12/10/2017-7036/35 md.) Kanunlarda icra edilebilirlik şerhi alınmasının zorunlu kılındığı haller hariç, taraflar ve avukatları ile arabulucunun, ticari uyuşmazlıklar bakımından ise avukatlar ile arabulucunun birlikte imzaladıkları anlaşma belgesi, icra edilebilirlik şerhi aranmaksızın ilam niteliğinde belge sayılır.",
                    "(Ek: 12/10/2017-7036/24 md.) Arabuluculuk faaliyeti sonunda anlaşmaya varılması hâlinde, üzerinde anlaşılan hususlar hakkında taraflarca dava açılamaz."
                ]
            ),
            // BEŞİNCİ BÖLÜM - Dava Şartı Olarak Arabuluculuk
            LawArticle(
                number: "18/A",
                title: "Dava şartı olarak arabuluculuk",
                paragraphs: [
                    "(Ek:6/12/2018-7155/23 md.) İlgili kanunlarda arabulucuya başvurulmuş olması dava şartı olarak kabul edilmiş ise arabuluculuk sürecine aşağıdaki hükümler uygulanır.",
                    "Davacı, arabuluculuk faaliyeti sonunda anlaşmaya varılamadığına ilişkin son tutanağın aslını veya arabulucu tarafından onaylanmış bir örneğini dava dilekçesine eklemek zorundadır. Bu zorunluluğa uyulmaması hâlinde mahkemece davacıya, son tutanağın bir haftalık kesin süre içinde mahkemeye sunulması gerektiği, aksi takdirde davanın usulden reddedileceği ihtarını içeren davetiye gönderilir. İhtarın gereği yerine getirilmez ise dava dilekçesi karşı tarafa tebliğe çıkarılmaksızın davanın usulden reddine karar verilir. Arabulucuya başvurulmadan dava açıldığının anlaşılması hâlinde herhangi bir işlem yapılmaksızın davanın, dava şartı yokluğu sebebiyle usulden reddine karar verilir.",
                    "Daire Başkanlığı, sicile kayıtlı arabuluculardan bu madde uyarınca arabuluculuk yapmak isteyenleri, varsa uzmanlık alanlarını da belirterek, görev yapmak istedikleri adli yargı ilk derece mahkemesi adalet komisyonlarına göre listeler ve listeleri ilgili komisyon başkanlıklarına bildirir. Komisyon başkanlıkları, bu listeleri kendi yargı çevrelerindeki arabuluculuk bürolarına, arabuluculuk bürosu kurulmayan yerlerde ise görevlendirecekleri sulh hukuk mahkemesi yazı işleri müdürlüğüne gönderir.",
                    "Başvuru, uyuşmazlığın konusuna göre yetkili mahkemenin bulunduğu yer arabuluculuk bürosuna, arabuluculuk bürosu kurulmayan yerlerde ise görevlendirilen yazı işleri müdürlüğüne yapılır.",
                    "Arabulucu, komisyon başkanlıklarına bildirilen listeden büro tarafından belirlenir. Ancak tarafların listede yer alan herhangi bir arabulucu üzerinde anlaşmaları hâlinde bu arabulucu görevlendirilir.",
                    "Başvuran taraf, kendisine ve elinde bulunması hâlinde karşı tarafa ait her türlü iletişim bilgisini arabuluculuk bürosuna verir. Büro, tarafların resmî kayıtlarda yer alan iletişim bilgilerini araştırmaya da yetkilidir. İlgili kurum ve kuruluşlar, büro tarafından talep edilen bilgi ve belgeleri vermekle yükümlüdür.",
                    "Taraflara ait iletişim bilgileri, görevlendirilen arabulucuya büro tarafından verilir. Arabulucu bu iletişim bilgilerini esas alır, ihtiyaç duyduğunda kendiliğinden araştırma da yapabilir. Elindeki bilgiler itibarıyla her türlü iletişim vasıtasını kullanarak görevlendirme konusunda tarafları bilgilendirir ve ilk toplantıya davet eder. Avukatı bulunsa bile asıl tarafı da bilgilendirir. Bilgilendirme ve davete ilişkin işlemlerini belgeye bağlar.",
                    "Arabulucu, görevlendirmeyi yapan büronun yetkili olup olmadığını kendiliğinden dikkate alamaz. Karşı taraf en geç ilk toplantıda, yetkiye ilişkin belgeleri sunmak suretiyle arabuluculuk bürosunun yetkisine itiraz edebilir. Bu durumda arabulucu, dosyayı derhâl ilgili sulh hukuk mahkemesine gönderilmek üzere büroya teslim eder. Mahkeme, harç alınmaksızın dosya üzerinden yapacağı inceleme sonunda en geç bir hafta içinde yetkili büroyu kesin olarak karara bağlar ve dosyayı büroya iade eder.",
                    "Arabulucu, yapılan başvuruyu görevlendirildiği tarihten itibaren üç hafta içinde sonuçlandırır. Bu süre zorunlu hâllerde arabulucu tarafından en fazla bir hafta uzatılabilir.",
                    "Arabulucu; taraflara ulaşılamaması veya taraflar katılmadığı için görüşme yapılamaması ya da tarafların anlaşması yahut tarafların anlaşamaması hâllerinde arabuluculuk faaliyetini sona erdirir ve son tutanağı düzenleyerek durumu derhâl arabuluculuk bürosuna bildirir.",
                    "Taraflardan birinin geçerli bir mazeret göstermeksizin ilk toplantıya katılmaması sebebiyle arabuluculuk faaliyetinin sona ermesi durumunda toplantıya katılmayan taraf, son tutanakta belirtilir ve bu taraf davada kısmen veya tamamen haklı çıksa bile karşı tarafın ödemekle yükümlü olduğu yargılama giderlerinin yarısından sorumlu tutulur. Ayrıca bu taraf lehine Avukatlık Asgari Ücret Tarifesine göre belirlenen vekâlet ücretinin yarısına hükmedilir. Her iki tarafın da ilk toplantıya katılmaması sebebiyle sona eren arabuluculuk faaliyeti üzerine açılacak davalarda tarafların yaptıkları yargılama giderleri kendi üzerlerinde bırakılır.",
                    "Tarafların arabuluculuk faaliyeti sonunda anlaşmaları hâlinde, arabuluculuk ücreti, Arabuluculuk Asgari Ücret Tarifesinin eki Arabuluculuk Ücret Tarifesinin İkinci Kısmına göre aksi kararlaştırılmadıkça taraflarca eşit şekilde karşılanır. Bu durumda ücret, Tarifenin Birinci Kısmında belirlenen iki saatlik ücret tutarından az olamaz.",
                    "Arabuluculuk faaliyeti sonunda taraflara ulaşılamaması, taraflar katılmadığı için görüşme yapılamaması veya iki saatten az süren görüşmeler sonunda tarafların anlaşamamaları hâllerinde, iki saatlik ücret tutarı Tarifenin Birinci Kısmına göre Adalet Bakanlığı bütçesinden ödenir. İki saatten fazla süren görüşmeler sonunda tarafların anlaşamamaları hâlinde ise iki saati aşan kısma ilişkin ücret aksi kararlaştırılmadıkça taraflarca eşit şekilde uyuşmazlığın konusu dikkate alınarak Tarifenin Birinci Kısmına göre karşılanır. Adalet Bakanlığı bütçesinden ödenen ve taraflarca karşılanan arabuluculuk ücreti, yargılama giderlerinden sayılır.",
                    "Bu madde uyarınca arabuluculuk bürosu tarafından yapılması gereken zaruri giderler; arabuluculuk faaliyeti sonunda anlaşmaya varılması hâlinde anlaşma uyarınca taraflarca ödenmek, anlaşmaya varılamaması hâlinde ise ileride haksız çıkacak taraftan tahsil olunmak üzere Adalet Bakanlığı bütçesinden karşılanır.",
                    "Arabuluculuk bürosuna başvurulmasından son tutanağın düzenlendiği tarihe kadar geçen sürede zamanaşımı durur ve hak düşürücü süre işlemez.",
                    "Dava açılmadan önce ihtiyati tedbir kararı verilmesi hâlinde 6100 sayılı Kanunun 397 nci maddesinin birinci fıkrasında, ihtiyati haciz kararı verilmesi hâlinde ise 9/6/1932 tarihli ve 2004 sayılı İcra ve İflas Kanununun 264 üncü maddesinin birinci fıkrasında düzenlenen dava açma süresi, arabuluculuk bürosuna başvurulmasından son tutanağın düzenlendiği tarihe kadar işlemez.",
                    "Arabuluculuk görüşmeleri, taraflarca aksi kararlaştırılmadıkça, arabulucuyu görevlendiren büronun bağlı bulunduğu adli yargı ilk derece mahkemesi adalet komisyonunun yetki alanı içinde yürütülür.",
                    "Özel kanunlarda tahkim veya başka bir alternatif uyuşmazlık çözüm yoluna başvurma zorunluluğunun olduğu veya tahkim sözleşmesinin bulunduğu hâllerde, dava şartı olarak arabuluculuğa ilişkin hükümler uygulanmaz.",
                    "İlgili kanunlarda dava şartı olarak arabuluculuğa ilişkin kabul edilen özel hükümler saklıdır.",
                    "Bu bölümde hüküm bulunmayan hâllerde niteliğine uygun düştüğü ölçüde bu Kanunun diğer hükümleri uygulanır."
                ]
            ),
            LawArticle(
                number: "18/B",
                title: "Bazı uyuşmazlıklarda dava şartı olarak arabuluculuk",
                paragraphs: [
                    "(Ek:28/3/2023-7445/37 md.) Aşağıdaki uyuşmazlıklarda, dava açılmadan önce arabulucuya başvurulmuş olması dava şartıdır:\na) Kiralanan taşınmazların 2004 sayılı Kanuna göre ilamsız icra yoluyla tahliyesine ilişkin hükümler hariç olmak üzere, kira ilişkisinden kaynaklanan uyuşmazlıklar.\nb) Taşınır ve taşınmazların paylaştırılmasına ve ortaklığın giderilmesine ilişkin uyuşmazlıklar.\nc) 23/6/1965 tarihli ve 634 sayılı Kat Mülkiyeti Kanunundan kaynaklanan uyuşmazlıklar.\nç) Komşu hakkından kaynaklanan uyuşmazlıklar.",
                    "Arabuluculuk süreci sonunda tarafların anlaşması halinde anlaşma belgesi, taşınmazla ilgili olarak kanunlarda yer alan sınırlamalar ile usul ve esaslar gözetilmek suretiyle düzenlenir.",
                    "Bu madde kapsamında düzenlenen anlaşma belgesinin icra edilebilirliğine ilişkin şerhin alınması zorunlu olup bu şerh taşınmazla ilgili anlaşma belgeleri bakımından taşınmazın bulunduğu yer, diğer anlaşma belgeleri bakımından ise arabulucunun görev yaptığı yer sulh hukuk mahkemesinden alınır.",
                    "Anlaşma belgesinin icra edilebilirliğine ilişkin şerhin verilmesiyle ilgili diğer hususlar hakkında 18 inci madde hükmü uygulanır.",
                    "(Ek:7/11/2024-7531/26 md.) Taşınmazın devrine veya taşınmaz üzerinde sınırlı ayni hak kurulmasına ilişkin anlaşma belgesinin taraflarından biri, icra edilebilirlik şerhi verilmesinden sonra tapu müdürlüğünden tescil talebinde bulunabilir."
                ]
            ),
            // ALTINCI BÖLÜM - Arabulucular Sicili
            LawArticle(
                number: "19",
                title: "Arabulucular sicilinin tutulması",
                paragraphs: [
                    "Daire Başkanlığı, özel hukuk uyuşmazlıklarında arabuluculuk yapma yetkisini kazanmış kişilerin sicilini tutar. Bu sicilde yer alan kişilere ilişkin bilgiler, Daire Başkanlığı tarafından elektronik ortamda da duyurulur.",
                    "Arabulucular sicilinin tutulmasına ilişkin usul ve esaslar Bakanlıkça hazırlanacak yönetmelikle düzenlenir."
                ]
            ),
            LawArticle(
                number: "20",
                title: "Arabulucular siciline kayıt şartları",
                paragraphs: [
                    "Sicile kayıt, ilgilinin Daire Başkanlığına yazılı olarak başvurması üzerine yapılır.",
                    "Arabulucular siciline kaydedilebilmek için;\na) Türk vatandaşı olmak,\nb) Mesleğinde en az beş yıllık kıdeme sahip hukuk fakültesi mezunu olmak,\nc) Tam ehliyetli olmak,\nç) (Değişik: 12/10/2017-7036/25 md.) 5237 sayılı Türk Ceza Kanununun 53 üncü maddesinde belirtilen süreler geçmiş olsa bile; kasten işlenen bir suçtan dolayı bir yıldan fazla süreyle hapis cezasına ya da affa uğramış olsa bile belirli suçlardan mahkûm olmamak,\nd) (Ek: 5/6/2017-KHK-691/9 md.) Terör örgütleriyle iltisaklı veya irtibatlı olmamak,\ne) Arabuluculuk eğitimini tamamlamak ve mesleğinde yirmi yıl kıdeme sahip olanlar hariç Bakanlıkça yapılan yazılı sınavda başarılı olmak,\ngerekir.",
                    "Arabulucu, sicile kayıt tarihinden itibaren faaliyetine başlayabilir.",
                    "(Ek: 12/10/2017-7036/25 md.) Daire Başkanlığı, sicile kayıtlı arabulucuları, görev yapmak istedikleri adli yargı ilk derece mahkemesi adalet komisyonlarına göre listeler ve listeleri ilgili komisyon başkanlıklarına gönderir. Bir arabulucu, en fazla üç komisyon listesine kaydolabilir."
                ]
            ),
            LawArticle(
                number: "21",
                title: "Arabulucular sicilinden silinme",
                paragraphs: [
                    "Daire Başkanlığı, arabuluculuk için aranan koşulları taşımadığı hâlde sicile kaydedilen veya daha sonra bu koşulları kaybeden arabulucunun kaydını siler.",
                    "Daire Başkanlığı, bu Kanunun öngördüğü yükümlülükleri yerine getirmediğini tespit ettiği arabulucuyu yazılı olarak uyarır; bu uyarıya uyulmaması hâlinde arabulucunun savunmasını aldıktan sonra, gerekirse adının sicilden silinmesini Kuruldan talep eder.",
                    "Arabulucu, arabulucular sicilinden kaydının silinmesini her zaman isteyebilir."
                ]
            ),
            // YEDİNCİ BÖLÜM - Arabuluculuk Eğitimi ve Eğitim Kuruluşları
            LawArticle(
                number: "22-27",
                title: "Arabuluculuk Eğitimi ve Eğitim Kuruluşları",
                paragraphs: [
                    "Arabuluculuk eğitimi, hukuk fakültesinin tamamlanmasından sonra alınan, arabuluculuk faaliyetinin yürütülmesiyle ilgili temel bilgileri, iletişim teknikleri, müzakere ve uyuşmazlık çözüm yöntemleri ve davranış psikolojisi ile yönetmelikte gösterilecek olan diğer teorik ve pratik bilgileri içeren eğitimi ifade eder.",
                    "Arabuluculuk eğitimi, bünyesinde hukuk fakültesi bulunan üniversitelerin hukuk fakülteleri, Türkiye Barolar Birliği ve Türkiye Adalet Akademisi tarafından verilir. Bu kuruluşlar Bakanlıktan izin alarak eğitim verebilirler.",
                    "Eğitim kuruluşları, eğitimlerini başarıyla tamamlayan kişilere arabuluculuk eğitimini tamamladıklarına dair bir belge verir.",
                    "Eğitim kuruluşuna verilmiş olan izin, Kanunda belirtilen hallerde Bakanlığın talebi üzerine Kurul tarafından iptal edilir."
                ]
            ),
            // SEKİZİNCİ BÖLÜM - Kuruluş ve Görevler
            LawArticle(
                number: "28-32",
                title: "Kuruluş ve Görevler",
                paragraphs: [
                    "Bu Kanunda belirtilen görevleri yerine getirmek üzere, Genel Müdürlük bünyesinde Daire Başkanlığı kurulur. Arabuluculuk hizmetlerine ilişkin olarak bu Kanunda belirtilen görevleri yerine getirmek üzere, Bakanlık bünyesinde Arabuluculuk Kurulu oluşturulur.",
                    "Arabuluculuğa başvuranları bilgilendirmek, arabulucuları görevlendirmek ve kanunla verilen diğer görevleri yerine getirmek üzere Bakanlık tarafından uygun görülen adliyelerde arabuluculuk büroları kurulur.",
                    "Daire Başkanlığının görevleri arasında arabuluculuk hizmetlerinin düzenli ve verimli olarak yürütülmesini sağlamak, arabuluculukla ilgili yayın yapmak, arabulucu sicilini tutmak ve Yıllık Arabuluculuk Asgari Ücret Tarifesini hazırlamak yer alır.",
                    "Kurulun görevleri arasında arabuluculuk hizmetlerine ilişkin temel ilkeler ile arabuluculuk meslek kurallarını belirlemek, eğitime ilişkin standartları tespit etmek ve Arabuluculuk Asgari Ücret Tarifesini onaylamak yer alır."
                ]
            ),
            // DOKUZUNCU BÖLÜM - Ceza Hükümleri
            LawArticle(
                number: "33",
                title: "Gizliliğin ihlali",
                paragraphs: [
                    "Bu Kanunun 4 üncü maddesindeki yükümlülüğe aykırı hareket ederek bir kişinin hukuken korunan menfaatinin zarar görmesine neden olan kişi altı aya kadar hapis cezası ile cezalandırılır.",
                    "Bu suçların soruşturulması ve kovuşturulması şikâyete bağlıdır."
                ]
            ),
            // ONUNCU BÖLÜM - Son ve Geçici Hükümler
            LawArticle(
                number: "34-36",
                title: "Kadrolar, Değiştirilen hükümler ve Yönetmelikler",
                paragraphs: [
                    "Ekli listelerde yer alan kadrolar ihdas edilerek 190 sayılı Genel Kadro ve Usulü Hakkında Kanun Hükmünde Kararnameye ekli cetvellerin Adalet Bakanlığına ait bölümlerine eklenmiştir.",
                    "1136 sayılı Avukatlık Kanununun 12 nci maddesinin birinci fıkrasının (d) bendine \"Hakemlik\" ibaresinden sonra gelmek üzere \"arabuluculuk,\" ibaresi eklenmiştir.",
                    "Arabuluculuk eğitimi verecek kuruluşların denetlenmesi ile eğitimin süresi, içeriği ve standartları, yapılacak olan yazılı sınavın ilke ve kurallarının belirlenmesi, arabulucular sicilinin düzenlenmesi ve arabulucularda aranacak koşullar, arabulucuların denetlenmesi ve izlenmesi ile bu Kanunun uygulanmasını gösteren diğer hususlar, Bakanlıkça çıkarılacak yönetmeliklerle düzenlenir."
                ]
            ),
            LawArticle(
                number: "Geçici 1",
                title: "Geçiş hükümleri",
                paragraphs: [
                    "Bu Kanunun yayımı tarihinden itibaren iki ay içinde kuruluş ve teşkilatlanma tamamlanır.",
                    "Bu Kanunun 31 inci maddesinde öngörülen kurum ve kuruluşlar, Kurulda görev yapacak temsilcileri Kanunun yayımı tarihinden itibaren iki ay içinde Genel Müdürlüğe bildirirler.",
                    "Arabulucu yerine ilgili kurumlardan bildirilen temsilcilerin Kuruldaki görev süresi bir yıldır.",
                    "Birinci fıkrada belirtilen kuruluş ve teşkilatlanmanın tamamlanmasından itibaren üç ay içinde Kurul toplanır."
                ]
            ),
            LawArticle(
                number: "Geçici 2",
                title: "Yönetmelikler",
                paragraphs: [
                    "Bu Kanunda öngörülen yönetmelikler, Kurulun ilk toplantısından itibaren üç ay içinde çıkarılır."
                ]
            ),
            LawArticle(
                number: "Geçici 3",
                title: "Dava şartı geçiş hükmü",
                paragraphs: [
                    "(Ek:28/3/2023-7445/38 md.) Bu maddeyi ihdas eden Kanunla, bu Kanuna eklenen 18/B maddesinin dava şartı olarak arabuluculuğa ilişkin hükümleri, bu maddenin yürürlüğe girdiği tarih itibarıyla ilk derece mahkemeleri ve bölge adliye mahkemeleri ile Yargıtayda görülmekte olan davalar hakkında uygulanmaz."
                ]
            ),
            LawArticle(
                number: "37",
                title: "Yürürlük",
                paragraphs: [
                    "Bu Kanunun;\na) 28 ilâ 32 nci maddeleri ile geçici maddeleri yayımı tarihinde,\nb) Diğer hükümleri ise yayımı tarihinden bir yıl sonra,\nyürürlüğe girer."
                ]
            ),
            LawArticle(
                number: "38",
                title: "Yürütme",
                paragraphs: [
                    "Bu Kanun hükümlerini Bakanlar Kurulu yürütür."
                ]
            )
        ]
    )
    // swiftlint:enable function_body_length
}
