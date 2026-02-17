//
//  MediationRegulationContent.swift
//  Denklem
//
//  Created by ozkan on 17.02.2026.
//

import Foundation

// MARK: - Hukuk Uyuşmazlıklarında Arabuluculuk Kanunu Yönetmeliği

extension LawDocumentContent {

    // swiftlint:disable function_body_length
    static let mediationRegulation30439 = LawDocumentContent(
        lawNumber: 30439,
        title: "HUKUK UYUŞMAZLIKLARINDA ARABULUCULUK KANUNU YÖNETMELİĞİ",
        gazetteDate: "02.06.2018",
        gazetteNumber: "30439",
        acceptanceDate: "02/06/2018",
        articles: [
            // BİRİNCİ KISIM - Genel Hükümler
            // BİRİNCİ BÖLÜM - Amaç, Kapsam, Dayanak ve Tanımlar
            LawArticle(
                number: "1",
                title: "Amaç",
                paragraphs: [
                    "Bu Yönetmeliğin amacı, hukuk uyuşmazlıklarının arabuluculuk yoluyla çözümlenmesine ilişkin her türlü arabuluculuk faaliyeti ile arabuluculuğa ilişkin usul ve esasları düzenlemektir."
                ]
            ),
            LawArticle(
                number: "2",
                title: "Kapsam",
                paragraphs: [
                    "Bu Yönetmelik; hukuk uyuşmazlıklarının arabuluculuk yoluyla çözümlenmesine ilişkin her türlü arabuluculuk faaliyeti, idarenin taraf olduğu özel hukuk uyuşmazlıklarında idarenin temsili, dava şartı olarak düzenlenen arabuluculuk sürecinin usul ve esasları ile arabulucuların eğitimi, arabuluculuk sınavının yapılması, arabulucular sicilinin düzenlenmesi, arabulucuların ve eğitim kuruluşlarının denetlenmesi ile Arabuluculuk Daire Başkanlığı ve Arabuluculuk Kurulunun çalışma usul ve esaslarını kapsar."
                ]
            ),
            LawArticle(
                number: "3",
                title: "Dayanak",
                paragraphs: [
                    "Bu Yönetmelik, 7/6/2012 tarihli ve 6325 sayılı Hukuk Uyuşmazlıklarında Arabuluculuk Kanununun 15 inci maddesinin onuncu fıkrası, 19 uncu maddesinin ikinci fıkrası, 22 nci maddesi, 31 inci maddesinin sekizinci fıkrası, 36 ncı maddesi ile 12/10/2017 tarihli ve 7036 sayılı İş Mahkemeleri Kanununun 3 üncü maddesinin yirmi ikinci fıkrasına dayanılarak hazırlanmıştır."
                ]
            ),
            LawArticle(
                number: "4",
                title: "Tanımlar",
                paragraphs: [
                    "Bu Yönetmelikte geçen;\na) Adliye arabuluculuk bürosu: Arabuluculuğa başvuranları bilgilendirmek, arabulucuları görevlendirmek ve kanunla verilen diğer görevleri yerine getirmek üzere Bakanlıkça adliyelerde kurulan birimi,\nb) Arabulucu: Arabuluculuk faaliyetini yürüten ve Bakanlıkça oluşturulan arabulucular siciline kaydedilmiş gerçek kişiyi,\nc) Arabuluculuk: Sistematik teknikler uygulayarak, görüşmek ve müzakerelerde bulunmak amacıyla tarafları bir araya getiren, onların birbirlerini anlamalarını ve bu suretle çözümlerini kendilerinin üretmesini sağlamak için aralarında iletişim sürecinin kurulmasını gerçekleştiren, tarafların çözüm üretemediklerinin ortaya çıkması hâlinde çözüm önerisi de getirebilen, uzmanlık eğitimi almış olan tarafsız ve bağımsız bir üçüncü kişinin katılımıyla ve kamu hizmeti olarak yürütülen ihtiyari bir uyuşmazlık çözüm yöntemini,\nç) Arabulucu Bilgi Sistemi: Arabuluculukla ilgili tüm iş ve işlemlerin elektronik ortamda yapılmasını sağlayan bilişim sistemini,\nd) Arabuluculuk bürosu: Arabulucunun işlerini yürüttüğü yeri,\ne) Bakanlık: Adalet Bakanlığını,\nf) Daire Başkanlığı: Adalet Bakanlığı Hukuk İşleri Genel Müdürlüğü bünyesinde kurulan Arabuluculuk Daire Başkanlığını,\ng) Eğitim kuruluşları sicili: Arabuluculuk eğitimi verme izni alan eğitim kuruluşlarının kaydedildiği sicili,\nğ) Eğitim modulü: Daire Başkanlığı tarafından hazırlanan ve eğitim kuruluşlarına arabuluculuk eğitiminde kullanılmak üzere verilen eğitim ve öğretim materyallerini,\nh) Elektronik ortam: Bilişim sistemi ve bilişim ağından oluşan toplam ortamı,\nı) Genel Müdürlük: Adalet Bakanlığı Hukuk İşleri Genel Müdürlüğünü,\ni) İdare: 5018 sayılı Kamu Malî Yönetimi ve Kontrol Kanununa ekli cetvellerde yer alan idare ve kurumlar ile mahalli idareleri,\nj) Kanun: Hukuk Uyuşmazlıklarında Arabuluculuk Kanununu,\nk) Komisyon: Arabuluculuk müzakerelerinde idareyi temsil eden komisyonu,\nl) Kurul: Arabuluculuk Kurulunu,\nm) Sicil: Arabulucular sicilini,\nn) Tarife: Arabuluculuk Asgari Ücret Tarifesini,\no) Üst yönetici: Bakanlıklarda müsteşarı, il özel idarelerinde valiyi, belediyelerde belediye başkanını, diğer kamu idarelerinde kendi mevzuatına göre tanımlanan en üst yöneticiyi veya kurulu,\nö) Yazılı sınav: Temel arabuluculuk eğitimini tamamlayanlara Bakanlıkça yapılacak yazılı sınavı,\nifade eder."
                ]
            ),
            // İKİNCİ BÖLÜM - Arabuluculuğun Temel İlkeleri
            LawArticle(
                number: "5",
                title: "İradi olma ve eşitlik",
                paragraphs: [
                    "Taraflar, arabulucuya başvurmak, süreci devam ettirmek, sonuçlandırmak veya bu süreçten vazgeçmek konusunda tamamen serbest olup, öncelikle uyuşmazlığı arabuluculuk yoluyla sonuçlandırma konusunda anlaşırlar. Taraflar, bu sürecin içine zorla dâhil edilemeyecekleri gibi her aşamada uyuşmazlığı arabuluculuk yoluyla çözmekten de vazgeçebilirler. Ancak dava şartı olarak arabuluculuğa ilişkin özel hükümler saklıdır.",
                    "Taraflar, gerek arabulucuya başvururken gerekse süreç boyunca eşit haklara sahiptirler. Taraflardan biri arabuluculuk sürecinin dışında bırakılamayacağı gibi söz hakkı da diğerine göre kısıtlanamaz."
                ]
            ),
            LawArticle(
                number: "6",
                title: "Gizlilik",
                paragraphs: [
                    "Taraflarca aksi kararlaştırılmadıkça arabulucu, arabuluculuk faaliyeti çerçevesinde kendisine sunulan veya herhangi bir şekilde elde ettiği bilgi ve belgeler ile diğer kayıtları gizli tutmakla yükümlüdür.",
                    "Aksi kararlaştırılmadıkça taraflar, kanuni temsilcileri, avukatları ve görüşmelere katılan diğer kişiler de bu konudaki gizliliğe uymak zorundadır.",
                    "Gizlilik kuralına uyma yükümlülüğü, arabulucunun yanında çalışan kişiler, denetim ve gözetimi altında ilgili mevzuat çerçevesinde staj yapanlar, Bakanlık ve Kurul görevlileri yönünden de geçerlidir.",
                    "Gizlilik kuralına aykırı hareket eden arabulucunun; hukuki ve cezai sorumluluğu saklı olup, sicilden silinmesine karar verilebilir."
                ]
            ),
            LawArticle(
                number: "7",
                title: "Beyan veya belgelerin kullanılamaması",
                paragraphs: [
                    "Taraflar, arabulucu veya arabuluculuğa katılanlar da dâhil olmak üzere üçüncü bir kişi, uyuşmazlıkla ilgili olarak hukuk davası açıldığında yahut tahkim yoluna başvurulduğunda, aşağıdaki beyan veya belgeleri delil olarak ileri süremez ve bunlar hakkında tanıklık yapamaz:\na) Taraflarca yapılan arabuluculuk daveti veya bir tarafın arabuluculuk faaliyetine katılma isteği.\nb) Uyuşmazlığın arabuluculuk yolu ile sona erdirilmesi için taraflarca ileri sürülen görüşler ve teklifler.\nc) Arabuluculuk faaliyeti esnasında, taraflarca ileri sürülen öneriler veya herhangi bir vakıa veya iddianın kabulü.\nç) Sadece arabuluculuk faaliyeti dolayısıyla hazırlanan belgeler.",
                    "Birinci fıkra hükmü, beyan veya belgenin şekline bakılmaksızın uygulanır.",
                    "Birinci fıkrada belirtilen bilgilerin açıklanması mahkeme, hakem veya herhangi bir idari makam tarafından istenemez. Bu beyan veya belgeler, birinci fıkrada öngörülenin aksine, delil olarak sunulmuş olsa dahi hükme esas alınamaz. Ancak, söz konusu bilgiler bir kanun hükmü tarafından emredildiği veya arabuluculuk süreci sonunda varılan anlaşmanın uygulanması ve icrası için gerekli olduğu ölçüde açıklanabilir.",
                    "Birinci, ikinci ve üçüncü fıkralar, arabuluculuğun konusuyla ilgili olup olmadığına bakılmaksızın, hukuk davası ve tahkimde uygulanır.",
                    "Birinci fıkrada belirtilen sınırlamalar saklı kalmak koşuluyla, hukuk davası ve tahkimde ileri sürülebilen deliller, sadece arabuluculukta sunulmaları sebebiyle kabul edilemeyecek deliller hâline gelmez."
                ]
            ),
            // ÜÇÜNCÜ BÖLÜM - Arabulucuların Hak ve Yükümlülükleri
            LawArticle(
                number: "8",
                title: "Unvanın kullanılması",
                paragraphs: [
                    "Arabulucu unvanını ve bu unvanın sağladığı yetkileri sadece sicile kayıtlı arabulucular kullanabilir. Hukuk uyuşmazlıklarında arabulucular haricinde, her ne nam altında olursa olsun taraflar arasında iletişim ve müzakere sürecini yürütmek üzere bir üçüncü kişi görevlendirilemez.",
                    "Arabulucu, arabuluculuk faaliyetine başlamadan önce bu unvanını taraflara bildirmek zorundadır.",
                    "Daire Başkanlığı, arabulucuların uzmanlık alanlarını ve uzmanlığa ilişkin usul ve esasları belirler."
                ]
            ),
            LawArticle(
                number: "9",
                title: "Ücret ve masrafların istenmesi",
                paragraphs: [
                    "Arabulucu yapmış olduğu faaliyet karşılığı ücret ve masrafları isteme hakkına sahiptir. Arabulucu, ücret ve masraflar için avans da talep edebilir.",
                    "Arabulucu, arabuluculuk süreci başlamadan önce de arabuluculuk teklifinde bulunan taraf veya taraflardan ücret ve masraflar için avans isteyebilir. Bu fıkra uyarınca alınan ücret arabuluculuk süreci sonunda alınacak arabuluculuk ücretinden mahsup edilir. Arabuluculuk sürecinin başlamaması hâlinde bu ücret iade edilmez. Masraftan kullanılmayan kısım arabuluculuk süreci sonunda iade edilir.",
                    "Aksi kararlaştırılmadıkça arabulucunun ücreti, faaliyetin sona erdiği tarihte yürürlükte bulunan Tarifeye göre belirlenir ve ücret ile masraf, taraflarca eşit olarak karşılanır.",
                    "Arabulucu, arabuluculuk sürecine ilişkin olarak belirli kişiler için aracılık yapma veya belirli kişileri tavsiye etmenin karşılığı olarak herhangi bir ücret talep edemez. Bu yasağa aykırı olarak tesis edilen işlemler batıldır."
                ]
            ),
            LawArticle(
                number: "10",
                title: "Taraflarla görüşme ve iletişim kurulması",
                paragraphs: [
                    "Arabulucu, tarafların her biri ile ayrı ayrı veya birlikte görüşebilir. Bu amaçla her türlü iletişim aracını kullanabilir.",
                    "Arabulucu, arabuluculuk faaliyetine ilişkin işlem ve eylemlerin doğru uygulandığına dair başlangıcından sona ermesine kadar sürece ilişkin önemli hususları belgelendirir. Belge, arabulucu, taraflar ile varsa tarafların kanuni temsilcileri veya avukatlarınca imzalanır. Belge, taraflar, kanuni temsilcileri veya avukatlarınca imzalanmaz ise sebebi belirtilmek sureti ile sadece arabulucu tarafından imzalanır."
                ]
            ),
            LawArticle(
                number: "11",
                title: "Görevin özenle ve tarafsız biçimde yerine getirilmesi",
                paragraphs: [
                    "Arabulucu görevini özenle ve bizzat kendisi yerine getirmek zorunda olup, bu görevini kısmen dahi olsa bir başkasına devredemez.",
                    "Arabulucu, arabuluculuk faaliyetini yürütürken tarafsız davranmak zorunda olup, tarafsızlığı hakkında şüpheye yol açacak tutum ve davranışta bulunamaz.",
                    "Arabulucu olarak görevlendirilen kimse, tarafsızlığından şüphe edilmesini gerektirecek önemli hâl ve şartların varlığı veya bu hâl ve şartların sonradan ortaya çıkması hâlinde tarafları bilgilendirmekle yükümlüdür. Bu açıklamaya rağmen taraflar, arabulucudan görevi üstlenmesini birlikte talep ederlerse, arabulucu bu görevi üstlenebilir yahut üstlenmiş olduğu görevi sürdürebilir.",
                    "Arabulucu, taraflar arasında eşitliği gözetmekle yükümlüdür.",
                    "Arabulucu, bu sıfatla görev yaptığı uyuşmazlık ile ilgili olarak açılan davada, daha sonra taraflardan birinin avukatı olarak görev üstlenemez."
                ]
            ),
            LawArticle(
                number: "12",
                title: "Reklam yasağı",
                paragraphs: [
                    "Arabulucuların iş elde etmek için reklam sayılabilecek her türlü teşebbüs ve harekette bulunmaları ve özellikle tabelalarında ve basılı kâğıtlarında arabulucu, avukat ve akademik unvan ile sicil numarası haricinde başka sıfat kullanmaları yasaktır."
                ]
            ),
            LawArticle(
                number: "13",
                title: "Tarafların aydınlatılması",
                paragraphs: [
                    "Arabulucu, arabuluculuk faaliyetinin başında, tarafları arabuluculuğun esasları, süreci ve hukuki sonuçları hakkında, şahsen ve gerektiği gibi aydınlatmakla yükümlüdür.",
                    "Arabulucu, arabuluculuk yoluyla çözümlenen hukuki uyuşmazlıklar ve arabuluculuk faaliyeti sonucunda tarafların anlaşmaya varması durumunda düzenlenecek olan anlaşma belgesi ile icra edilebilirliğin nitelik ve hukuki sonuçları hakkında tarafları bilgilendirir."
                ]
            ),
            LawArticle(
                number: "14",
                title: "Aidat ödenmesi",
                paragraphs: [
                    "Arabuluculardan sicile kayıtlarında giriş aidatı ve her yıl için yıllık aidat alınır. Aidatlar Maliye Bakanlığına ödenir.",
                    "Aidatlar, her yıl için Kurul tarafından belirlenir.",
                    "Giriş aidatı ve yıllık aidatlar genel bütçeye gelir kaydedilir.",
                    "Yıllık aidat her yılın Haziran ayı sonuna kadar ödenir."
                ]
            ),
            // İKİNCİ KISIM - Özel Hükümler
            // BİRİNCİ BÖLÜM - Arabuluculuk Faaliyeti
            LawArticle(
                number: "15",
                title: "Arabulucuya başvuru",
                paragraphs: [
                    "Taraflar dava açılmadan önce veya davanın görülmesi sırasında arabulucuya başvurma konusunda anlaşabilirler. Mahkeme de tarafları arabulucuya başvurmak konusunda; arabuluculuğun esasları, süreci ve hukuki sonuçları hakkında aydınlatıp, arabuluculuk yoluyla uyuşmazlığın çözülmesinin sosyal, ekonomik ve psikolojik açıdan faydalarının olabileceğini hatırlatarak onları teşvik edebilir. 12/1/2011 tarihli ve 6100 sayılı Hukuk Muhakemeleri Kanunundaki ön incelemeye ilişkin düzenlemeler saklıdır.",
                    "Aksi kararlaştırılmadıkça, taraflardan birinin arabulucuya başvuru teklifine otuz gün içinde olumlu cevap verilmez ise bu teklif reddedilmiş sayılır.",
                    "Arabuluculuk ücretini karşılamak için adli yardıma ihtiyaç duyan taraf, adliye arabuluculuk bürosunun bulunduğu yerdeki sulh hukuk mahkemesinin kararıyla adli yardımdan yararlanabilir. Bu konuda 6100 sayılı Kanunun 334 ilâ 340 ıncı maddeleri kıyasen uygulanır.",
                    "Üçüncü fıkra kapsamında arabuluculuk hizmeti verilmesi hâlinde arabulucunun ücreti Tarifeye göre belirlenir.",
                    "Arabuluculuk sürecinde tarafların avukatlık hizmeti bakımından adli yardımdan yararlanabilmesi hususunda 19/3/1969 tarihli ve 1136 sayılı Avukatlık Kanununun 176 ilâ 181 inci maddeleri uygulanır."
                ]
            ),
            LawArticle(
                number: "16",
                title: "Arabulucunun seçilmesi",
                paragraphs: [
                    "Başkaca bir usul kararlaştırılmadıkça arabulucu veya arabulucular taraflarca seçilir."
                ]
            ),
            LawArticle(
                number: "17",
                title: "Arabuluculuk faaliyetinin yürütülmesi",
                paragraphs: [
                    "Arabulucu, seçildikten sonra tarafları en kısa sürede ilk toplantıya davet eder.",
                    "Taraflar, emredici hukuk kurallarına aykırı olmamak kaydı ile arabuluculuk usulünü serbestçe kararlaştırabilir.",
                    "Taraflarca kararlaştırılmamışsa arabulucu; uyuşmazlığın niteliğini, tarafların isteklerini ve uyuşmazlığın hızlı bir şekilde çözümlenmesi için gereken usul ve esasları göz önüne alarak arabuluculuk faaliyetini yürütür.",
                    "Niteliği gereği yargısal bir yetkinin kullanımı olarak sadece hâkim tarafından yapılabilecek işlemler arabulucu tarafından yapılamaz.",
                    "Arabulucu, sürecin yürütülmesi sırasında, taraflara hukuki tavsiyelerde bulunamaz.",
                    "Arabulucu, arabuluculuk sürecini yürütürken tarafların temel çıkar ve gereksinimlerini ortaya koymaları ve bu doğrultuda menfaat temelli anlaşma sağlamaları için çaba gösterir. Arabulucu bu aşamada çözüm önerisinde bulunamaz. Ancak tarafların çözüm üretemediklerinin ortaya çıkması hâlinde arabulucu menfaat temelli bir çözüm önerisinde bulunabilir. Bununla beraber tarafları bir çözüm önerisi ya da öneriler dizisini kabule zorlayamaz. Ancak, taraflardan birinin uyuşmazlığın çözümü bağlamında sunmuş olduğu bir önerinin arabulucu tarafından, diğer tarafa iletilmesi ve onun bu konudaki beyanının alınması bu kapsamda değerlendirilemez.",
                    "Dava açıldıktan sonra tarafların birlikte arabulucuya başvuracaklarını beyan etmeleri hâlinde yargılama, mahkemece üç ayı geçmemek üzere ertelenir. Bu süre, tarafların birlikte başvurusu üzerine bir defaya mahsus olmak üzere üç aya kadar uzatılabilir.",
                    "Arabuluculuk müzakerelerine taraflar bizzat, kanuni temsilcileri veya avukatları aracılığı ile katılabilirler. Tarafların açık rızasıyla uyuşmazlığın çözümüne katkı sağlayabilecek uzman kişiler de müzakerelerde hazır bulundurulabilir.",
                    "Arabulucular, Arabulucu Bilgi Sistemi üzerinden faaliyetlerini yürütebilirler.",
                    "Arabulucular, yargı organları ve elektronik altyapısını tamamlamış kamu kurum ve kuruluşları ile bilgi ve belge alışverişini elektronik ortamda yapabilirler."
                ]
            ),
            LawArticle(
                number: "18",
                title: "İdarenin temsili",
                paragraphs: [
                    "Arabuluculuk müzakerelerinde idareyi, üst yönetici tarafından belirlenen iki üye ile hukuk birimi amiri veya onun belirleyeceği bir avukat ya da hukuk müşavirinden oluşan komisyon temsil eder. Hukuk biriminin veya kurum avukatının olmadığı hallerde komisyon üyelerinin tamamı üst yönetici tarafından belirlenir. Yedek komisyon üyeleri de aynı usulle seçilir. Komisyon kendisini vekil ile temsil ettiremez.",
                    "İdare, arabuluculuk davetlerinin yapılacağı adres, kayıtlı elektronik posta adresi ve telefon numarasını, bu Yönetmeliğin yürürlüğe girdiği tarihten itibaren bir ay içerisinde internet sitesinde yayınlar. Arabulucular görüşmeler kapsamında yapacakları davetlerde öncelikle bu bilgileri esas alır.",
                    "Komisyonda 2 yıl süreyle görev yapmak üzere asıl ve yedek üyeler belirlenir. İdare merkezde veya taşra teşkilatlarında komisyonlar kurabilir.",
                    "Süresi dolan üye yeniden seçilebilir. Asıl üyenin katılamadığı toplantıya yedek üye katılır. Komisyon kararlarını oy birliği ile alır.",
                    "Belirlenen komisyon üyeleri arabuluculuk sürecinde karar alma konusunda tam yetkilidir.",
                    "Komisyon, arabuluculuk müzakereleri sonunda gerekçeli bir rapor düzenler ve beş yıl boyunca saklar. Komisyonun sekretarya hizmetlerini yürüten birim tarafından gerekçeli raporların saklanmasına ilişkin gerekli tedbirler alınır.",
                    "Komisyon üyeleri, bu madde kapsamındaki görevleri uyarınca aldıkları kararlar ve yaptıkları işlemler nedeniyle görevinin gereklerine aykırı davrandıklarının mahkeme kararıyla tespit edilmesi dışında, mali ve idari yönden sorumlu tutulamazlar.",
                    "Komisyon üyelerinin arabuluculuk faaliyeti kapsamında yaptıkları işler ve aldıkları kararlar sebebiyle açılacak tazminat davaları, ancak Devlet aleyhine açılabilir. Devlet ödediği tazminattan dolayı görevinin gereklerine aykırı hareket etmek suretiyle görevini kötüye kullanan üyelere ödeme tarihinden itibaren bir yıl içinde rücu eder.",
                    "Devlet aleyhine tazminat davası açılması hâlinde mahkeme ilgili komisyon üyelerine davayı re'sen ihbar eder.",
                    "Komisyonun ve sekretaryasının çalışma usul ve esasları idareler tarafından belirlenir.",
                    "Komisyon üyeleri bu madde kapsamındaki görevleri uyarınca ilgili özel ve kamu kurum ve kuruluşları ile sekretarya aracılığıyla yazışma yetkisine sahiptir. Kurum ve kuruluşlar tarafından komisyona ivedi olarak cevap verilir.",
                    "İdarelerin taraf olduğu özel hukuk uyuşmazlıklarında, arabuluculuk sürecinde idarenin temsili, anlaşma belgesinin düzenlenmesi ve diğer hususlarda 7036 sayılı Kanun ile bu Yönetmelik hükümleri uygulanır."
                ]
            ),
            LawArticle(
                number: "19",
                title: "Arabuluculuk sürecinin başlaması ve sürelere etkisi",
                paragraphs: [
                    "Arabuluculuk süreci, dava açılmadan önce arabulucuya başvuru hâlinde, tarafların ilk toplantıya davet edilmeleri ve taraflarla arabulucu arasında sürecin devam ettirilmesi konusunda anlaşmaya varılıp bu durumun bir tutanakla belgelendirildiği tarihten itibaren işlemeye başlar. Dava açılmasından sonra arabulucuya başvuru hâlinde ise bu süreç, mahkemenin tarafları arabuluculuğa davetinin taraflarca kabul edilmesi veya tarafların arabulucuya başvurma konusunda anlaşmaya vardıklarını duruşma dışında mahkemeye yazılı olarak beyan ettikleri ya da duruşmada bu beyanlarının tutanağa geçirildiği tarihten itibaren işlemeye başlar.",
                    "Arabuluculuk sürecinin başlamasından sona ermesine kadar geçirilen süre, zamanaşımı ve hak düşürücü sürelerin hesaplanmasında dikkate alınmaz."
                ]
            ),
            LawArticle(
                number: "20",
                title: "Arabuluculuğun sona ermesi",
                paragraphs: [
                    "Aşağıda belirtilen hâllerde arabuluculuk faaliyeti sona erer:\na) Tarafların uyuşmazlık konusu üzerinde anlaşmaya varması.\nb) Taraflardan birinin karşı tarafa veya arabulucuya, arabuluculuk faaliyetinden çekildiğini bildirmesi.\nc) Tarafların anlaşarak arabuluculuk faaliyetini sona erdirmesi.\nç) Taraflara danışıldıktan sonra arabuluculuk için daha fazla çaba sarf edilmesinin gereksiz olduğunun arabulucu tarafından tespit edilmesi.\nd) Uyuşmazlığın arabuluculuğa elverişli olmadığının tespit edilmesi.",
                    "Arabuluculuk faaliyeti sonunda tarafların anlaştıkları, anlaşamadıkları veya arabuluculuk faaliyetinin nasıl sonuçlandığı son tutanak ile belgelendirilir. Arabulucu tarafından düzenlenecek bu tutanak; arabulucu, taraflar, kanuni temsilcileri veya avukatlarınca imzalanır. Tutanak; taraflar, kanuni temsilcileri veya avukatlarınca imzalanmazsa, sebebi belirtilmek sureti ile sadece arabulucu tarafından imzalanır.",
                    "Arabuluculuk faaliyeti sonunda düzenlenen son tutanağa, faaliyetin sonuçlanması dışında hangi hususların yazılacağına taraflar karar verir. Arabulucu, bu tutanak ve sonuçları konusunda taraflara gerekli açıklamaları yapar.",
                    "Arabuluculuk faaliyetinin sona ermesi hâlinde, arabulucu, bu faaliyete ilişkin kendisine yapılan bildirimi, tevdi edilen ve elinde bulunan belgeleri, ikinci fıkraya göre düzenlenen tutanağı beş yıl süre ile saklamak zorundadır. Arabulucu, arabuluculuk faaliyeti sonunda düzenlediği son tutanağın birer örneğini taraflara verir. Tutanağın bir örneğini de arabuluculuk faaliyetinin sona ermesinden itibaren bir ay içinde Arabulucu Bilgi Sistemi üzerinden Genel Müdürlüğe gönderir.",
                    "Arabulucu, arabuluculuk sürecinde hukuki ve fiili sebeplerle görevini yapamayacak hâle gelirse, tarafların üzerinde anlaştığı yeni bir arabulucu ile süreç kaldığı yerden devam ettirilebilir. Önceki yapılan işlemler geçerliliğini korur."
                ]
            ),
            LawArticle(
                number: "21",
                title: "Tarafların anlaşması",
                paragraphs: [
                    "Arabuluculuk faaliyeti sonunda varılan anlaşmanın kapsamı taraflarca belirlenir, anlaşma belgesi düzenlenmesi hâlinde, bu belge taraflar ve arabulucu tarafından imzalanır.",
                    "Taraflar, arabuluculuk faaliyeti sonunda bir anlaşmaya varırsa, bu anlaşma belgesinin icra edilebilirliğine ilişkin şerh verilmesini talep edebilirler. Bu şerhi içeren anlaşma, ilam niteliğinde belge sayılır.",
                    "Dava açılmadan önce arabuluculuğa başvurulmuşsa, anlaşmanın icra edilebilirliğine ilişkin şerh verilmesi, çekişmesiz yargıya ilişkin yetki hükümleri yanında arabulucunun görev yaptığı yer sulh hukuk mahkemesinden talep edilebilir.",
                    "Davanın görülmesi sırasında arabuluculuğa başvurulması durumunda anlaşmanın icra edilebilirliğine ilişkin şerh verilmesi, davanın görüldüğü mahkemeden talep edilebilir.",
                    "İcra edilebilirlik şerhinin verilmesi, çekişmesiz yargı işidir ve buna ilişkin inceleme dosya üzerinden yapılır. Ancak arabuluculuğa elverişli olan aile hukukuna ilişkin uyuşmazlıklarda inceleme duruşmalı olarak yapılır. Bu incelemenin kapsamı anlaşmanın içeriğinin arabuluculuğa ve cebrî icraya elverişli olup olmadığı hususları ile sınırlıdır. Anlaşma belgesine icra edilebilirlik şerhi verilmesi için mahkemeye yapılacak olan başvuru ile bunun üzerine verilecek kararlara karşı ilgili tarafından istinaf yoluna gidilmesi hâlinde, maktu harç alınır. Taraflar anlaşma belgesini icra edilebilirlik şerhi verdirmeden başka bir resmî işlemde kullanmak isterlerse, damga vergisi de maktu olarak alınır.",
                    "Taraflar ve avukatları ile arabulucunun birlikte imzaladıkları anlaşma belgesi, icra edilebilirlik şerhi aranmaksızın ilam niteliğinde belge sayılır.",
                    "Arabuluculuk faaliyeti sonunda anlaşmaya varılması hâlinde, üzerinde anlaşılan hususlar hakkında taraflarca dava açılamaz."
                ]
            ),
            // İKİNCİ BÖLÜM - Dava Şartı Olarak Arabuluculuk
            LawArticle(
                number: "22",
                title: "Dava şartı olarak arabuluculuk",
                paragraphs: [
                    "Arabulucuya başvurulmuş olmasının kanunla dava şartı olarak düzenlendiği durumlarda davacı, arabuluculuk faaliyeti sonunda anlaşmaya varılamadığına ilişkin son tutanağın aslını veya arabulucu tarafından onaylanmış bir örneğini dava dilekçesine eklemek zorundadır.",
                    "Bu zorunluluğa uyulmaması hâlinde mahkemece davacıya, son tutanağın bir haftalık kesin süre içinde mahkemeye sunulması gerektiği, aksi takdirde davanın usulden reddedileceği ihtarını içeren davetiye gönderilir. İhtarın gereği yerine getirilmez ise dava dilekçesi karşı tarafa tebliğe çıkarılmaksızın davanın usulden reddine karar verilir.",
                    "Dava dilekçesi içeriğinden açıkça arabulucuya başvurulmadan dava açıldığının anlaşılması hâlinde derhal herhangi bir usuli işlem yapılmadan ve duruşma yapılmaksızın dosya üzerinden davanın, dava şartı yokluğu sebebiyle usulden reddine karar verilir."
                ]
            ),
            LawArticle(
                number: "23",
                title: "Dava şartı olarak arabuluculuğa başvuru",
                paragraphs: [
                    "Başvuru karşı tarafın, karşı taraf birden fazla ise bunlardan birinin yerleşim yerindeki veya işin yapıldığı yerdeki adliye arabuluculuk bürosuna, adliye arabuluculuk bürosu kurulmayan yerlerde ise görevlendirilen sulh hukuk mahkemesi yazı işleri müdürlüğüne yapılır. Adliye arabuluculuk bürosu kurulmayan yerlerde, büronun görevini, görevlendirilen sulh hukuk mahkemesi yazı işleri müdürlüğü yerine getirir.",
                    "Tarafların ve uyuşmazlık konusunun aynı olduğu durumlarda birden fazla başvuru yapılmış ise, başvurunun hukuki sonuçları bakımından ilk başvuru esas alınır.",
                    "Başvuru, dilekçe ile veya bürolarda bulunan formların doldurulması suretiyle yahut elektronik ortamda yapılabilir.",
                    "Arabuluculuk başvurusu sırasında başvurandan, uyuşmazlık konusuna ilişkin hususların açıklanması istenir."
                ]
            ),
            LawArticle(
                number: "24",
                title: "Dava şartı olarak arabuluculukta arabulucunun görevlendirilmesi",
                paragraphs: [
                    "Arabulucu, adli yargı ilk derece mahkemesi adalet komisyonu başkanlıklarına bildirilen listeden adliye arabuluculuk bürosu tarafından puanlama yöntemiyle belirlenir. Ancak tarafların listede yer alan herhangi bir arabulucu üzerinde başvuru sırasında anlaşmaları hâlinde taraflar veya tarafların imzasını taşıyan bir tutanakla beraber üzerinde anlaşılan arabulucu, durumu adliye arabuluculuk bürosuna bildirdiğinde bu arabulucu görevlendirilir. Dava şartı olan arabuluculuk ile ilgili uyuşmazlıklarda liste dışında bir arabulucu görevlendirilemez.",
                    "Başvuran taraf, kendisine ve elinde bulunması hâlinde karşı tarafa ait her türlü iletişim bilgisini adliye arabuluculuk bürosuna verir. Adliye arabuluculuk bürosu, tarafların resmi kayıtlarda yer alan iletişim bilgilerini araştırmaya da yetkilidir. İlgili kurum ve kuruluşlar, uyuşmazlık konusuyla sınırlı olmak üzere adliye arabuluculuk bürosu tarafından talep edilen iletişim bilgilerini vermekle yükümlüdür.",
                    "Taraflara ait iletişim bilgileri, görevlendirilen arabulucuya adliye arabuluculuk bürosu tarafından verilir. Arabulucu bu iletişim bilgilerini esas alır, ihtiyaç duyduğunda kendiliğinden araştırma da yapabilir. Elindeki bilgiler itibarıyla her türlü iletişim vasıtasını kullanarak görevlendirme konusunda tarafları bilgilendirir ve ilk toplantıya tarafları ve varsa avukatlarını birlikte davet eder. Bilgilendirme ve davete ilişkin işlemlerini belgeye bağlar. Arabulucu taraflara ulaşamaması hâlinde, ulaşmak için hangi yolları denediğini ve hangi sebeplerle ulaşamadığını son tutanakta belirtir."
                ]
            ),
            LawArticle(
                number: "25",
                title: "Dava şartı olarak arabuluculukta arabuluculuk faaliyeti",
                paragraphs: [
                    "Arabuluculuk görüşmelerine taraflar bizzat, kanuni temsilcileri veya avukatları, idareler ise oluşturacakları komisyon aracılığıyla katılabilirler. İşverenin adi veya resmi yazılı belgeyle yetkilendirdiği çalışanı da görüşmelerde işvereni temsil edebilir ve son tutanağı imzalayabilir.",
                    "Arabulucu asilleri, arabuluculuğun esasları, süreci ve sonuçları hakkında aydınlatıp, arabuluculuk yoluyla uyuşmazlığın çözümünün ekonomik, sosyal ve psikolojik faydalarının olduğunu hatırlatarak onları bilgilendirir. Asilleri ilk oturuma varsa vekilleri ile birlikte davet eder.",
                    "Arabulucu ilk oturum davetini yaparken toplantı tarihi ve yerinin belirlenmesi konusunda taraflar ile iletişim kurar. Taraflarla yaptığı görüşme sonucunda bir mutabakat sağlanamazsa toplantı tarihini ve yerini kendisi belirler.",
                    "Arabulucu, görevlendirmeyi yapan adliye arabuluculuk bürosunun yetkili olup olmadığını kendiliğinden dikkate alamaz. Karşı taraf en geç ilk toplantıda, yerleşim yeri ve işin yapıldığı yere ilişkin belgelerini sunmak suretiyle adliye arabuluculuk bürosunun yetkisine itiraz edebilir. Bu durumda arabulucu, dosyayı derhal ilgili sulh hukuk mahkemesine gönderilmek üzere adliye arabuluculuk bürosuna teslim eder. Mahkeme, harç alınmaksızın dosya üzerinden ivedilikle yapacağı inceleme sonunda yetkili adliye arabuluculuk bürosunu belirleyip kesin olarak karara bağlar ve dosyayı adliye arabuluculuk bürosuna iade eder. Yetki itirazına ilişkin inceleme yapılırken mahkemece atamayı yapan büro değil görevlendirilen arabulucunun listesinde kayıtlı bulunduğu komisyon dikkate alınır. Mahkeme kararı adliye arabuluculuk bürosu tarafından 11/2/1959 tarihli ve 7201 sayılı Tebligat Kanunu hükümleri uyarınca taraflara masrafı suçüstü ödeneğinden karşılanmak üzere tebliğ edilir. Yetkisiz adliye arabuluculuk bürosu ayrıca kararı görevlendirdiği arabulucuya bildirir. Arabulucu görevlendirmeyi Arabulucu Bilgi Sistemi üzerinden sonlandırır. Arabulucu bundan önceki yaptığı hizmetler sebebiyle 26 ncı maddenin ikinci fıkrası uyarınca ücrete hak kazanır. Yetki itirazının reddi durumunda aynı arabulucu yeniden görevlendirilir ve 27 nci maddenin birinci fıkrasında belirtilen süreler yeni görevlendirme tarihinden başlar. Yetki itirazının kabulü durumunda ise kararın tebliğinden itibaren bir hafta içinde yetkili adliye arabuluculuk bürosuna başvurulabilir. Bu takdirde yetkisiz adliye arabuluculuk bürosuna başvurma tarihi yetkili adliye arabuluculuk bürosuna başvurma tarihi olarak kabul edilir. Yetkili adliye arabuluculuk bürosu, 24 üncü maddenin birinci fıkrası uyarınca arabulucu görevlendirir.",
                    "Arabulucu, yapılan başvuruyu görevlendirild iği tarihten itibaren üç hafta içinde sonuçlandırır. Bu süre zorunlu hallerde arabulucu tarafından en fazla bir hafta uzatılabilir. Sürenin sonucunda arabulucu anlaşamama yönünde re'sen son tutanağı düzenler.",
                    "Tarafların uyuşmazlık konusunda anlaşmaları veya kısmen anlaşmaları hâlinde süreç anlaşma son tutanağı ile sonuçlandırılır. Bunların haricindeki her durumda taraflar anlaşmamış sayılır ve anlaşmama son tutanağı düzenlenir.",
                    "Tarafların arabuluculuk sürecinde ileri sürülen taleplerden bir kısmı üzerinde anlaşmaya varmaları hâlinde, üzerinde anlaşma sağlanan ve sağlanamayan hususlar son tutanakta açıkça belirtilir ve ücret taraflardan aksi kararlaştırılmadıkça eşitçe alınır.",
                    "Arabulucu, taraflara ulaşılamaması, taraflar katılmadığı için görüşme yapılamaması, yapılan görüşmeler sonucunda veya kanunda belirtilen süre içerisinde anlaşmaya varılamaması yahut varılması hallerinde arabuluculuk faaliyetini sona erdirir ve son tutanağı düzenleyerek durumu derhal adliye arabuluculuk bürosuna bildirir.",
                    "Taraflardan birinin geçerli bir mazeret göstermeksizin ilk toplantıya katılmaması sebebiyle arabuluculuk faaliyetinin sona ermesi durumunda toplantıya katılmayan taraf, son tutanakta belirtilir ve bu taraf davada kısmen veya tamamen haklı çıksa bile yargılama giderinin tamamından sorumlu tutulur. Ayrıca bu taraf lehine vekâlet ücretine hükmedilmez. Her iki tarafın da ilk toplantıya katılmaması sebebiyle sona eren arabuluculuk faaliyeti üzerine açılacak davalarda tarafların yaptıkları yargılama giderleri kendi üzerlerinde bırakılır. Arabulucu tarafları ilk toplantıya her türlü iletişim aracıyla davet ettiğini belgelendirir. Arabulucunun düzenlediği belgeler geçerli mazeretin değerlendirilmesinde esas alınır."
                ]
            ),
            LawArticle(
                number: "26",
                title: "Dava şartı olarak arabuluculukta arabuluculuk ücreti ve giderler",
                paragraphs: [
                    "Tarafların arabuluculuk faaliyeti sonunda tamamen veya kısmen anlaşmaları hâlinde, arabuluculuk ücreti, Arabuluculuk Asgari Ücret Tarifesinin eki Arabuluculuk Ücret Tarifesinin İkinci Kısmına göre aksi kararlaştırılmadıkça taraflarca eşit şekilde karşılanır. Bu durumda ücret, Tarifenin Birinci Kısmında belirlenen iki saatlik ücret tutarından az olamaz. İşe iade talebiyle yapılan görüşmelerde tarafların anlaşmaları durumunda, arabulucuya ödenecek ücretin belirlenmesinde işçiye işe başlatılmaması hâlinde ödenecek tazminat miktarı ile çalıştırılmadığı süre için ödenecek ücret ve diğer haklarının toplamı, Tarifenin İkinci Kısmı uyarınca üzerinde anlaşılan miktar olarak kabul edilir.",
                    "Arabuluculuk faaliyeti sonunda tarafların anlaşamamaları hâlinde iki saatlik ücret tutarı Tarifenin Birinci Kısmına göre Bakanlık bütçesinden ödenir. İki saatten fazla süren görüşmeler sonunda tarafların anlaşamamaları hâlinde ise iki saati aşan kısma ilişkin ücret aksi kararlaştırılmadıkça taraflarca eşit şekilde, Tarifenin Birinci Kısmına göre karşılanır. Bakanlık bütçesinden ödenen ve taraflarca karşılanan arabuluculuk ücreti, yargılama giderlerinden sayılır. Dava açılması hâlinde mahkeme tarafından dava öncesi ödenen arabuluculuk ücretlerine ilişkin makbuz dosyaya eklenir. Yargılama giderleri olarak hükmedilen tutar 6183 sayılı Kanuna göre tahsil edilir.",
                    "Sürecin sehven kayıt, mükerrer kayıt veya arabuluculuğa elverişli olmama nedeniyle sona erdirilmesi hallerinde arabulucuya ikinci fıkra uyarınca ücret ödenmez.",
                    "Bu madde uyarınca adliye arabuluculuk bürosu tarafından yapılması gereken zaruri giderler; arabuluculuk faaliyeti sonunda anlaşmaya varılması hâlinde anlaşma uyarınca taraflarca ödenmek, anlaşmaya varılamaması hâlinde ise ileride haksız çıkacak taraftan tahsil olunmak üzere Bakanlık bütçesinden karşılanır. Dava açılması hâlinde mahkeme tarafından, yapılan zorunlu giderlere ilişkin makbuz dosyaya eklenir. Yargılama giderleri olarak hükmedilen tutar 6183 sayılı Kanuna göre tahsil edilir.",
                    "Adliye arabuluculuk bürosu tarafından, adliye arabuluculuk bürosu bulunmayan yerde sulh hukuk mahkemesi yazı işleri müdürlüğü tarafından Bakanlık tarafından ödenen arabuluculuk ücretine ilişkin liste, ödenmek üzere Cumhuriyet başsavcılığına gönderilir.",
                    "Kamu görevlileri tarafından yürütülen arabuluculuk faaliyetleri sonucunda taraflarca anlaşılan ya da Tarifeye göre tahakkuk edecek arabuluculuk ücreti, arabulucunun listesinde yer aldığı komisyona bağlı adliye arabuluculuk bürosu veya adliye arabuluculuk bürosu bulunmayan yerde sulh hukuk mahkemesi yazı işleri müdürlüğüne arabulucu tarafından bildirilir. Taraflar, arabulucu ücretini belirlenen tarihte adliye arabuluculuk bürosu veznesine yatırır. Adliye arabuluculuk bürosu yasal kesintileri yaptıktan sonra arabulucunun bildirmiş olduğu banka hesabına havale eder. Dava şartı olan arabuluculukta anlaşamama hâlinde düzenlenen sarf kararı gereğince ücret Cumhuriyet savcılığınca arabulucunun banka hesabına yatırılır."
                ]
            ),
            LawArticle(
                number: "27",
                title: "Dava şartı olarak arabuluculuğun sürelere etkisi",
                paragraphs: [
                    "Adliye arabuluculuk bürosuna başvurulmasından, son tutanağın düzenlendiği tarihe kadar geçen sürede uyuşmazlık konusu hususlarda zamanaşımı durur ve hak düşürücü süre işlemez."
                ]
            ),
            LawArticle(
                number: "28",
                title: "Dava şartı olarak arabuluculukta yetki ve atama usulü",
                paragraphs: [
                    "Arabuluculuk görüşmeleri, taraflarca aksi kararlaştırılmadıkça, arabulucuyu görevlendiren adliye arabuluculuk bürosunun bağlı bulunduğu adli yargı ilk derece mahkemesi adalet komisyonunun yetki alanı içinde yürütülür.",
                    "Seri uyuşmazlıklar, adliye arabuluculuk bürosu tarafından atanan aynı arabulucuya tevdi edilir. Seri uyuşmazlığın sayısı ve puanlama usulü Daire Başkanlığınca belirlenir.",
                    "Adliye arabuluculuk bürosunca yapılan atamalarda her dosya için arabulucuya puan verilir, puanlama ve atama usulü ile performans kriterleri Daire Başkanlığı tarafından belirlenir."
                ]
            ),
            // ÜÇÜNCÜ BÖLÜM - Arabulucular Sicili
            LawArticle(
                number: "29",
                title: "Sicilin tutulması",
                paragraphs: [
                    "Özel hukuk uyuşmazlıklarında arabuluculuk yapma yetkisini kazanmış kişilerin sicilleri, sicil numarası verilmek suretiyle, Daire Başkanlığınca tutulur.",
                    "Sicilde kişinin ad ve soyadı, uzmanlık alanı, varsa diğer mesleği, iş adresi ve akademik unvanı gibi şahsi bilgileri yer alır. Bu bilgiler, Daire Başkanlığı internet sitesinde duyurulur.",
                    "Arabulucu, sicilde yer alan kendisine ait bilgilerde meydana gelen her türlü değişikliği bir ay içinde varsa belgesi ile birlikte Genel Müdürlüğe bildirmek zorundadır. Bu değişiklikler ile ilgili olarak Daire Başkanlığı tarafından elektronik ortamda gerekli düzeltmeler yapılır.",
                    "Daire Başkanlığı, arabulucular hakkında elektronik ortamda şahsi sicil dosyası tutar. Şahsi sicil dosyasına arabulucunun kimliği, öğrenim ve meslek durumu, bildiği yabancı dil, meslekî eserleri ve yazıları, disiplin ve ceza soruşturması ve sonuçları, başka görevlerde geçen hizmet gibi hususlara ilişkin belgeler konulur."
                ]
            ),
            LawArticle(
                number: "30",
                title: "Sicile kayıt olma şartları",
                paragraphs: [
                    "Sicile kayıt, ilgilinin Daire Başkanlığına Arabulucu Bilgi Sistemi üzerinden başvurması ve şartları taşıdığının anlaşılması üzerine yapılır.",
                    "Sicile kaydedilebilmek için;\na) Türk vatandaşı olmak,\nb) Mesleğinde en az beş yıllık kıdeme sahip hukuk fakültesi mezunu olmak,\nc) Tam ehliyetli olmak,\nç) 26/9/2004 tarihli ve 5237 sayılı Türk Ceza Kanununun 53 üncü maddesinde belirtilen süreler geçmiş olsa bile; kasten işlenen bir suçtan dolayı bir yıldan fazla süreyle hapis cezasına ya da affa uğramış olsa bile Devletin güvenliğine karşı suçlar, Anayasal düzene ve bu düzenin işleyişine karşı suçlar, zimmet, irtikâp, rüşvet, hırsızlık, dolandırıcılık, sahtecilik, güveni kötüye kullanma, hileli iflas, ihaleye fesat karıştırma, edimin ifasına fesat karıştırma, suçtan kaynaklanan malvarlığı değerlerini aklama veya kaçakçılık, gerçeğe aykırı bilirkişilik yapma, yalan tanıklık ve yalan yere yemin suçlarından mahkûm olmamak,\nd) Terör örgütleriyle iltisaklı veya irtibatlı olmamak,\ne) Arabuluculuk eğitimini tamamlamak ve Bakanlıkça yapılan yazılı sınavda başarılı olmak,\ngerekir.",
                    "İlgili, başvuru sırasında 29 uncu maddenin ikinci fıkrasında belirtilen şahsi bilgilerini içeren belgeler ile bu maddenin ikinci fıkrasındaki şartları taşıdığına dair belgeleri elektronik ortamda iletir.",
                    "Başvuru tarihi itibarı ile fiilen avukatlık mesleğini veya bir kamu görevini ifa etmeyen başvuru sahiplerinin, arabuluculuk mesleğini yapmalarına ruhen ve bedenen engel bir hâllerinin bulunmadığını sağlık kuruluşlarından alacakları raporlarla belgelendirmeleri gerekir.",
                    "Sicile kayıt için başvuruda bulunan kişi, ikinci fıkranın (b) bendindeki şartı taşıdığını ve dördüncü fıkrada bahsedilen sağlık durumunu düzenlenme tarihi itibarı ile altı aydan daha eski tarihli olmayan belgelerle ispatlamak zorundadır.",
                    "İkinci fıkrada sayılan sicile kayıt şartlarını taşıdığı anlaşılan ve belgelerinde eksiklik bulunmayan başvuru sahiplerinin sicile kayıtlarının yapılacağı hususu ile şartları taşımadığı anlaşılan veya verilen bir aylık süreye rağmen eksik belgelerini sunmayan başvuru sahiplerinin sicile kayıtlarının yapılamayacağı hususunda Daire Başkanlığınca başvuru tarihinden veya eksik belgenin ikmalinden itibaren iki ay içinde karar verilir. Bu kararlar ilgilisine de tebliğ edilir. Bu kişiler belge eksikliklerini ikmal ettiklerinde yeniden sicile kayıt için başvuruda bulunabilirler.",
                    "Arabulucu, sicile kayıt tarihinden itibaren faaliyetine başlayabilir.",
                    "Arabulucu, üçüncü fıkrada sayılan şartlarla ilgili olarak kendisine ait bilgilerde meydana gelen her türlü değişikliği bir ay içinde varsa belgesi ile birlikte Genel Müdürlüğe iletir. Bu değişiklikler ile ilgili olarak Daire Başkanlığı tarafından sicilde ve elektronik ortamda gerekli düzeltmeler yapılır.",
                    "Daire Başkanlığı, sicile kayıtlı arabulucuları, görev yapmak istedikleri adli yargı ilk derece mahkemesi adalet komisyonlarına göre listeler ve listeleri ilgili komisyon başkanlıklarına bildirir. Bir arabulucu, en fazla üç komisyon listesine kaydolabilir."
                ]
            ),
            LawArticle(
                number: "31",
                title: "Sicilden silinme",
                paragraphs: [
                    "Arabuluculuk için aranan koşulları taşımadığı hâlde sicile kaydedilen veya daha sonra bu koşulları kaybeden arabulucunun kaydı Daire Başkanlığınca silinir. Arabulucunun ölümü hâlinde de aynı işlem yapılır.",
                    "Daire Başkanlığı, Kanunun öngördüğü yükümlülükleri önemli ölçüde veya sürekli yerine getirmediğini tespit ettiği arabulucuyu yazılı olarak uyarır; uyarıya uyulmaması hâlinde arabulucunun yazılı savunmasını ister. Arabulucu, istemin tebliğinden itibaren on günlük süre içinde savunmasını vermek zorundadır. Tebliğden imtina eden veya bu süre içinde savunmada bulunmayan arabulucu savunma hakkından vazgeçmiş sayılır. Bu işlemlerden sonra Daire Başkanlığı, gerekirse arabulucunun adının sicilden silinmesini Kuruldan talep eder. Kurul tarafından sicilden silinmeye yönelik bir karar verilirse Daire Başkanlığınca bu karar ilgilisine tebliğ edilir.",
                    "Arabulucu, sicilden kaydının silinmesini her zaman isteyebilir. Bu şekilde sicilden kaydı silinenler sınav şartı aranmaksızın diğer şartları haiz ise yeniden sicile kayıt yaptırabilirler."
                ]
            ),
            // ÜÇÜNCÜ KISIM - Eğitim, Sınav ve Denetim
            // BİRİNCİ BÖLÜM - Arabuluculuk Eğitimi ve Eğitim Kuruluşları
            LawArticle(
                number: "32",
                title: "Arabuluculuk eğitimi",
                paragraphs: [
                    "Arabuluculuk eğitimi, hukuk fakültesi mezunu ve beş yıllık meslekî kıdem kazanmış kişiler tarafından alınan, arabuluculuk faaliyetinin yürütülmesi ile arabuluculuğun yerine getirilmesi için gerekli olan bilgi ve becerilerin kazanılmasını amaçlayan eğitimi ifade eder.",
                    "Arabulucu olacak kişilere altmışsekiz saati teorik ve onaltı saati uygulamalı olmak üzere asgari toplam seksendört saat arabuluculuk eğitimi verilir.",
                    "Teorik ve uygulamalı eğitimin verilmesinde, eğitim modulü esas alınır.",
                    "Eğitime katılanların, belgeye dayalı ve eğitim kuruluşlarınca kabul edilen haklı bir mazeretleri olmadıkça arabuluculuk eğitimi süresince verilen ders ve çalışmalara katılımları zorunludur. Eğitim kuruluşlarınca, adayların derslere devam durumunu gösteren çizelge düzenlenir ve derslerin 1/12'sine devam etmeyenlerin eğitim programıyla ilişiği kesilir.",
                    "Daire Başkanlığı, arabulucuların uzmanlık alanlarını ve uzmanlığa ilişkin usul ve esasları belirlemeye yetkilidir.",
                    "Arabuluculara, arabuluculuk eğitim izni verilen kuruluşlarca teorik ve uygulamalı, toplam sekiz saatten az olmamak üzere üç yılda bir defa yenileme eğitimi verilir. Arabulucular yenileme eğitimine sicile kaydedildiği tarihten itibaren üçüncü yılın içinde katılmak zorundadır.",
                    "Yenileme eğitiminde; arabuluculuğa ilişkin mevzuat ve içtihat değişiklikleri ile arabuluculuk becerilerinin geliştirilmesine yönelik eğitim verilir."
                ]
            ),
            LawArticle(
                number: "33",
                title: "Arabuluculuk eğitimi katılım belgesi",
                paragraphs: [
                    "Eğitim kuruluşlarınca, eğitimlerini başarı ile tamamlayan kişilere en geç bir ay içinde arabuluculuk eğitimini tamamladıklarına dair katılım belgesi verilir."
                ]
            ),
            LawArticle(
                number: "34",
                title: "Eğitim kuruluşlarına izin verilmesi",
                paragraphs: [
                    "Arabuluculuk eğitimi üniversitelerin hukuk fakülteleri, Türkiye Barolar Birliği veya Türkiye Adalet Akademisi tarafından verilir. Bu kuruluşlar Bakanlıktan izin alarak eğitim verebilirler. İzin verilen eğitim kuruluşlarının listesi elektronik ortamda yayınlanır.",
                    "İzin için yazılı olarak başvurulur. Başvuruda eğitimin içeriğini ve süresini kapsar şekilde eğitim programı, eğiticilerin sayısı, unvanları, uzmanlıkları, yeterlikleri ve eğitim programının finansman kaynakları ile eğitim verilecek mekânlar hakkında gerekçeli ve yeterli bilgilere yer verilir.",
                    "Başvuruda sunulan belgelere dayalı olarak, eğitimin amacına ulaşacağı, eğitimin yapılacağı mekânların uygunluğu ve eğitim kuruluşlarında eğitim faaliyetinin devamlılığının sağlanacağı tespit edilirse, ilgili eğitim kuruluşuna en çok üç yıl için geçerli olmak üzere izin verilir. İzin verilen eğitim kuruluşu, eğitim kuruluşları siciline kaydedilir.",
                    "İkinci ve üçüncü fıkralarda belirtilen nitelikleri taşımadığı anlaşılan eğitim kuruluşunun başvurusu, başvuru talebinin Bakanlığa ulaştığı tarihten itibaren iki ay içinde incelenerek reddedilir ve karar ilgilisine tebliğ edilir. Bakanlıkça iki ay içinde karar verilemediği takdirde talep reddedilmiş sayılır.",
                    "İzin süresi uzatılmayan veya izni iptal edilen eğitim kuruluşu, eğitim kuruluşları sicilinden ve elektronik ortamdaki listeden silinir. Bu eğitim kuruluşuna ait belgeler dosyasında saklanır."
                ]
            ),
            LawArticle(
                number: "35",
                title: "İzin süresinin uzatılması",
                paragraphs: [
                    "Sicile kayıtlı olan bir eğitim kuruluşu kayıt süresinin bitiminden en erken bir yıl ve en geç üç ay önce, eğitim kuruluşları sicilindeki kaydının geçerlilik süresinin uzatılmasını yazılı olarak talep edebilir. Eğitim kuruluşunun 36 ncı maddeye göre sunduğu raporlardan, arabuluculuk eğitiminin başarılı şekilde devam ettiği ve 37 nci maddede belirtilen sebepler bulunmadığı takdirde, verilmiş bulunan iznin geçerlilik süresi her defasında üç yıl uzatılabilir. Eğitim kuruluşu, süresi içinde yaptığı başvuru hakkında karar verilinceye kadar listede kayıtlı kalır.",
                    "İzin süresinin uzatılmasına ilişkin talepler, talebin Bakanlığa ulaştığı tarihten itibaren iki ay içinde incelenerek karara bağlanır ve karar ilgilisine tebliğ edilir."
                ]
            ),
            LawArticle(
                number: "36",
                title: "Daire Başkanlığına bilgi verme yükümlülüğü",
                paragraphs: [
                    "Eğitim kuruluşları, her yıl ocak ayında bir önceki yıl içinde gerçekleştirdikleri eğitim faaliyetinin kapsamı, içeriği ve başarısı konusunda Daire Başkanlığına bir rapor sunar.",
                    "Rapor sunmayan eğitim kuruluşuna yazılı ihtarda bulunularak bir aylık süre verilir. İhtarda, raporun verilen süreye rağmen sunulmaması hâlinde eğitim verme izninin iptal edileceği hususu belirtilir."
                ]
            ),
            LawArticle(
                number: "37",
                title: "Eğitim kuruluşuna verilen iznin iptali",
                paragraphs: [
                    "Aşağıdaki hâllerde eğitim kuruluşuna verilmiş olan izin, Bakanlığın talebi üzerine Kurul tarafından iptal edilir:\na) İzin verilebilmesi için aranan şartlardan birinin ortadan kalkmış olduğunun veya mevcut olmadığının tespiti.\nb) Eğitimin yeterli şekilde verilemediğinin tespiti.\nc) Arabuluculuk eğitimi başarı belgesi düzenlenmesinde sahtecilik veya önemli hatalar yapılması.\nç) 36 ncı maddedeki rapor verme yükümlülüğünün yapılan ihtara rağmen yerine getirilmemesi.\nd) Eğitim faaliyetinin devamlılığının sağlanmadığının tespiti.",
                    "Eğitim kuruluşunun yazılı talebi üzerine Daire Başkanlığınca her zaman eğitim izninin iptaline karar verilebilir."
                ]
            ),
            // İKİNCİ BÖLÜM - Sınav İlke ve Kuralları
            LawArticle(
                number: "38",
                title: "Sınav",
                paragraphs: [
                    "Arabuluculuk eğitimini tamamlayanların sicile kayıt olabilmeleri için bu Yönetmeliğe uygun olarak yapılacak yazılı sınavda başarılı olmaları zorunludur.",
                    "Başarılı olanların sınav sonuçları, sicile kayıt işlemleri tamamlanıncaya kadar geçerliliğini korur."
                ]
            ),
            LawArticle(
                number: "39",
                title: "Sınavın yeri ve günü",
                paragraphs: [
                    "Sınavın yapılacağı yer, tarih ve saat Daire Başkanlığınca belirlenir.",
                    "Sınavın yeri, tarihi ve saati Genel Müdürlüğün resmî internet sayfasında yayımlanmak suretiyle duyurulur."
                ]
            ),
            LawArticle(
                number: "40",
                title: "Sınavın konusu",
                paragraphs: [
                    "Sınav, 32 nci madde uyarınca arabuluculuk eğitimi sırasında verilen konuları kapsar."
                ]
            ),
            LawArticle(
                number: "41",
                title: "Sınav işlemlerinin yürütülmesi",
                paragraphs: [
                    "Daire Başkanlığı sınavla ilgili soruların hazırlattırılması, sınavın ilanı, süresi, sınav tutanaklarının düzenlenmesi ile sınavlara ilişkin diğer işlemlerin yürütülmesini sağlar."
                ]
            ),
            LawArticle(
                number: "42",
                title: "Sınava başvuru",
                paragraphs: [
                    "Sınava girmek isteyenlerin 30 uncu maddenin ikinci fıkrasının (a), (b), (c), (ç) ve (d) bentlerinde belirtilen şartları taşıması ve arabuluculuk eğitimini tamamlaması gerekir.",
                    "Sınava başvurular, Arabulucu Bilgi Sistemi üzerinden elektronik imza ya da e-Devlet şifresi kullanmak suretiyle, T.C. kimlik numarasını gösteren belge, adli sicil beyanı veya belgesi, arabuluculuk eğitimini tamamladığını gösteren katılım belgesi, hukuk fakültesi mezunu ve mesleğinde en az beş yıllık kıdeme sahip olduğunu gösterir belgenin son başvuru günü bitimine kadar sisteme yüklenmesi suretiyle yapılır.",
                    "Başvuruya ilişkin diğer usul ve esaslar sınav ilanında belirtilir."
                ]
            ),
            LawArticle(
                number: "43",
                title: "Başvurunun incelenmesi",
                paragraphs: [
                    "Başvuru, ilgilinin sınava girebilme şartlarını taşıyıp taşımadığının tespiti açısından incelenir.",
                    "Başvuru sırasında istenen belgeleri sisteme eksik veya hatalı yüklemiş olanların ya da sınava girebilme şartlarını taşımadığı tespit edilenlerin başvuruları reddedilip, bu durum kendilerine bildirilir.",
                    "Sınava girebilme şartlarını taşıyanlara ilişkin gerekli bilgiler, sınavı yapacak kuruma iletilir."
                ]
            ),
            LawArticle(
                number: "44",
                title: "Sınavların yapılışı",
                paragraphs: [
                    "Sınav, klasik veya test usulü şeklinde yapılır.",
                    "Bu sınav, Ölçme, Seçme ve Yerleştirme Merkezi Başkanlığı, Türkiye ve Orta Doğu Amme İdaresi Enstitüsü veya yükseköğretim kurumları arasından Bakanlıkça belirlenecek bir kuruluşa yaptırılabilir."
                ]
            ),
            LawArticle(
                number: "45",
                title: "Sınavda başarı koşulu",
                paragraphs: [
                    "Sınavda yüz tam puan üzerinden en az yetmiş puan alan adaylar başarılı sayılır. Ancak Bakanlıkça, ihtiyaç durumuna göre başarılı sayılacak aday sayısı belirlenebilir. Bu durumda, arabulucu ihtiyaç sayısı sınav ilanında duyurulur.",
                    "İhtiyaç sayısının Bakanlıkça belirlenmesi halinde, sınavda yüz tam puan üzerinden en az yetmiş puan alması koşuluyla en yüksek puan alan adaydan başlamak üzere sınav ilanında belirtilen arabulucu ihtiyaç sayısı kadar aday, sınavda başarılı sayılır. Başarılı sayılan en düşük puanlı adayla aynı puanı alan adaylar da başarılı sayılır."
                ]
            ),
            LawArticle(
                number: "46",
                title: "Sınav sonuçlarının açıklanması ve itiraz",
                paragraphs: [
                    "Daire Başkanlığı, sınav sonuçlarını, sınav sonuçlarının kendisine intikal ettiği tarihten itibaren bir ay içinde ilan eder.",
                    "Sınava yapılan itirazlar, sınavı yapan kurum tarafından karara bağlanır."
                ]
            ),
            LawArticle(
                number: "47",
                title: "Sınavların geçersiz sayılması",
                paragraphs: [
                    "Sınava girenlerden;\na) İzin almadan sınav salonu veya yerini terk edenler,\nb) Sınavda kopya çekenler veya kopya çekmeye teşebbüs edenler,\nc) Sınavda kopya verenler veya kopya vermeye teşebbüs edenler,\nç) Kendi yerine başkasının sınava girmesini sağlayanlar,\nd) Sınav düzenine aykırı davranışta bulunanlar\nhakkında düzenlenen tutanak üzerine bunların sınavları geçersiz sayılır.",
                    "Sınavı kazananlardan başvuruda gerçeğe aykırı beyanda bulunduğu tespit edilenlerin sınavı da geçersiz sayılır. Bu durumda olanlar hiçbir hak talebinde bulunamazlar. Ayrıca gerçeğe aykırı beyanda bulunduğu tespit edilenler hakkında idari ve yasal işlemler yapılır."
                ]
            ),
            LawArticle(
                number: "48",
                title: "Sınavlarda başarısız kabul edilme",
                paragraphs: [
                    "Sınava başvuranlardan;\na) 45 inci maddedeki sınav başarı koşulunu sağlamayanlar,\nb) Sınavı geçersiz sayılanlar,\nc) Sınava katılmayanlar,\nbaşarısız kabul edilirler."
                ]
            ),
            LawArticle(
                number: "49",
                title: "Yeni sınav hakkı",
                paragraphs: [
                    "47 nci maddenin birinci fıkrasının (a) bendi gereğince sınavları geçersiz sayılanlar ile 48 inci maddenin birinci fıkrasının (a) ve (c) bentleri gereğince sınavlarda başarısız kabul edilenler, sınavlara yeniden girebilme hakkına sahiptirler."
                ]
            ),
            // ÜÇÜNCÜ BÖLÜM - Denetim
            LawArticle(
                number: "50",
                title: "Denetim yetkisi",
                paragraphs: [
                    "Arabulucular, arabuluculuk büroları ve arabuluculuk eğitim izni verilen kuruluşlar, Daire Başkanlığının denetimi altındadır."
                ]
            ),
            LawArticle(
                number: "51",
                title: "Denetimin kapsamı",
                paragraphs: [
                    "Eğitim kuruluşları, arabulucular ve arabuluculuk büroları, Kanun, Yönetmelik ve ilgili mevzuat uyarınca çıkarılan diğer düzenleyici işlemlere uygun hareket edip etmediği yönünden denetlenir.",
                    "Denetim sonucunda tespit edilen eksiklikler duruma göre Daire Başkanlığınca ilgili kişi ve kuruluşlara yazılı bir şekilde bildirilerek bu eksikliklerin giderilmesi için eksikliğin niteliğine göre uygun bir süre verilir. Verilen süre sonunda eksiklikler giderilmediği takdirde veya denetim sonucu, konusu suç teşkil eden uygulamalar tespit edildiğinde arabulucu veya eğitim kuruluşları hakkında Kanun, Yönetmelik ve bu mevzuat uyarınca çıkarılan diğer düzenleyici işlemler uyarınca işlem yapılır ve gerekirse adli mercilere bildirimde bulunulur."
                ]
            ),
            // DÖRDÜNCÜ KISIM - Teşkilat
            // BİRİNCİ BÖLÜM - Daire Başkanlığı
            LawArticle(
                number: "52",
                title: "Daire Başkanlığı",
                paragraphs: [
                    "Daire Başkanlığı, bir daire başkanı, yeteri kadar tetkik hâkimi ve diğer personelden oluşur.",
                    "Daire Başkanlığı nezdinde, Kanun ve bu Yönetmelikle verilen arabuluculuk faaliyetleri ile ilgili görevleri yerine getirmek üzere; Arabuluculuk Hizmetleri Bürosu, Sicil Bürosu ve Eğitim Bürosu gibi bürolar başta olmak üzere hizmetin gereklerine uygun olarak yeterli sayıda büro oluşturulur."
                ]
            ),
            LawArticle(
                number: "53",
                title: "Daire Başkanlığının görevleri",
                paragraphs: [
                    "Daire Başkanlığının görevleri genel olarak şunlardır:\na) Arabuluculuk hizmetlerinin düzenli ve verimli olarak yürütülmesini sağlamak.\nb) Arabuluculukla ilgili yayın yapmak, bu konudaki bilimsel çalışmaları teşvik etmek ve desteklemek.\nc) Kurulun çalışması ile ilgili her türlü karar ve işlemi yürütmek ve görevleri ile ilgili bakanlık, diğer kamu kurum ve kuruluşları, üniversiteler, kamu kurumu niteliğindeki meslek kuruluşları, kamu yararına çalışan vakıf ve dernekler ile uygun görülen gönüllü gerçek ve tüzel kişilerle işbirliği yapmak.\nç) Arabuluculuk kurumunun tanıtımını yapmak, bu konuda kamuoyunu bilgilendirmek, ulusal ve uluslararası kongre, sempozyum ve seminer gibi bilimsel organizasyonları düzenlemek veya desteklemek.\nd) Ülke genelinde arabuluculuk uygulamalarını izlemek, ilgili istatistikleri tutmak ve yayımlamak.\ne) Arabuluculuk eğitimi verecek kuruluşlar tarafından bu amaçla yapılan başvuru ile eğitim kuruluşları sicilindeki kaydın geçerlilik süresinin uzatılması talebinin karara bağlanmasını Bakanlığın onayına sunmak, arabuluculuk eğitimi verecek eğitim kuruluşlarını listelemek ve elektronik ortamda yayımlamak.\nf) Arabulucu sicilini tutmak, sicile kayıt taleplerini karara bağlamak, 31 inci maddenin birinci ve ikinci fıkraları kapsamında arabulucunun sicilden silinmesine karar vermek ve bu sicilde yer alan kişilere ilişkin bilgileri elektronik ortamda duyurmak.\ng) Arabulucular tarafından arabuluculuk faaliyeti sonunda düzenlenen son tutanakların kayıtlarını tutmak ve birer örneklerini saklamak.\nğ) Görev alanına giren kanun ve düzenleyici işlemler hakkında inceleme ve araştırma yaparak Genel Müdürlüğe öneride bulunmak.\nh) Yıllık faaliyet raporunu ve izleyen yıl faaliyet planını hazırlayarak Kurulun bilgisine sunmak.\nı) Yıllık Arabuluculuk Asgari Ücret Tarifesini hazırlamak."
                ]
            ),
            // İKİNCİ BÖLÜM - Arabuluculuk Kurulu ve Görevleri
            LawArticle(
                number: "54",
                title: "Kurul",
                paragraphs: [
                    "Kurul aşağıdaki üyelerden oluşur:\na) Hukuk İşleri Genel Müdürü.\nb) Arabuluculuk Daire Başkanı.\nc) Hâkimler ve Savcılar Kurulu tarafından hukuk mahkemelerinde görev yapmakta olan birinci sınıfa ayrılmış hâkimler arasından seçilecek iki hâkim.\nç) Türkiye Barolar Birliğinden üç temsilci.\nd) Türkiye Noterler Birliğinden bir temsilci.\ne) Yükseköğretim Kurulu tarafından seçilen özel hukuk alanından bir öğretim üyesi.\nf) Adalet Bakanı tarafından seçilecek üç arabulucu.\ng) Türkiye Odalar ve Borsalar Birliğinden bir temsilci.\nğ) Kendisine mensup işçi sayısı en çok olan üç işçi sendikaları konfederasyonunca seçilecek birer temsilci.\nh) En çok işveren mensubu olan işveren sendikaları konfederasyonunca seçilecek bir temsilci.\nı) Türkiye Esnaf ve Sanatkârları Konfederasyonundan bir temsilci.\ni) Türkiye Adalet Akademisi Eğitim Merkezi Başkanı.",
                    "Kurul Başkanı ihtiyaca göre Kurul toplantılarına uzman kişileri çağırabilir.",
                    "Kurul Başkanı Hukuk İşleri Genel Müdürüdür. Genel Müdürün bulunmadığı toplantılarda Başkanlık görevi Arabuluculuk Daire Başkanı tarafından yerine getirilir.",
                    "Kurul, mart ve eylül aylarında olmak üzere yılda en az iki kez toplanır. Ayrıca, Başkanın veya en az beş üyenin talebiyle Kurul her zaman toplantıya çağrılabilir.",
                    "Kurul en az on kişi ile toplanır.",
                    "Kurul üye tam sayısının salt çoğunluğu ile karar alır. Karara muhalif kalan üyelerin görüşlerini yazılı olarak sunma hakları vardır. Karara muhalif üyeler, muhalefet gerekçelerini en geç on gün içinde Kurul başkanlığına ibraz ederler.",
                    "Mazeretsiz olarak art arda iki toplantıya katılmayan üyenin üyeliği düşer. Üyeliği düşen kişinin yerine, kalan süreyi tamamlamak üzere kurum veya kuruluşunca yeni bir üye görevlendirilir. Üyenin istifası veya ölümü hâlinde de aynı hüküm geçerlidir.",
                    "Kurulun Bakanlık dışından görevlendirilen üyelerinin görev süresi üç yıldır. Görev süresi dolan üyeler yeniden görevlendirilebilir. Eski Kurulun görevi yeni Kurul oluşuncaya kadar devam eder.",
                    "Kurulun gündemi Daire Başkanlığınca belirlenip, Kurul toplantısından beş gün önce Kurul üyelerinin iletişim adreslerine elektronik posta yoluyla gönderilir. Gündem dışı konular da Kurulda görüşülebilir.",
                    "Kurulun sekretaryası Daire Başkanlığınca yürütülür.",
                    "Arabuluculuk Kuruluna başka yerden katılan Kurul üyelerinin gündelik, yol gideri, konaklama ve diğer zorunlu giderleri 10/2/1954 tarihli ve 6245 sayılı Harcırah Kanunu hükümlerine göre Bakanlıkça karşılanır."
                ]
            ),
            LawArticle(
                number: "55",
                title: "Kurulun görevleri",
                paragraphs: [
                    "Kurulun görevleri şunlardır:\na) Arabuluculuk hizmetlerine ilişkin temel ilkeler ile arabuluculuk meslek kurallarını belirlemek.\nb) Arabuluculuk eğitimine ve eğitim kuruluşlarının nitelikleri ile çalışma usul ve esaslarına yönelik ilke ve standartlar ile arabuluculuk eğitimi sonunda yapılacak olan sınava ilişkin temel ilke ve standartları tespit etmek.\nc) Arabulucuların denetimine ilişkin kuralları belirlemek.\nç) Kanuna göre çıkarılması gereken ve Genel Müdürlük tarafından hazırlanan yönetmelik taslaklarına, gerekirse değişiklik yaparak son şeklini vermek.\nd) Eğitim kuruluşlarının eğitim izinlerini iptal etmek.\ne) 31 inci maddenin üçüncü fıkrası kapsamında arabulucunun sicilden silinmesine karar vermek.\nf) Arabulucuların ödeyecekleri giriş aidatını ve yıllık aidatları tespit etmek.\ng) Arabuluculuk Asgari Ücret Tarifesini gerekiyorsa değişiklik yapmak suretiyle onaylamak.\nğ) Daire Başkanlığı tarafından yürütülecek faaliyetlerin etkinliğini artırmak üzere tavsiyelerde bulunmak.\nh) Daire Başkanlığının yıllık faaliyet raporu ve planı hakkında görüş bildirmek.\nı) Daire Başkanlığının faaliyet planında yer alan konularla ilgili kurum ve kuruluşların uygulamaya sağlayabileceği katkıları belirlemek.\ni) Arabuluculuk hizmetlerinin yürütülmesiyle ilgili olarak gerek Daire Başkanlığınca bildirilen ve gerekse re'sen öğrenilen genel ve önemli sorunları görüşüp, çözüm önerilerinde bulunmak."
                ]
            ),
            // ÜÇÜNCÜ BÖLÜM - Adliye Arabuluculuk Bürosu
            LawArticle(
                number: "56",
                title: "Adliye arabuluculuk bürosu",
                paragraphs: [
                    "Arabuluculuğa başvuranları bilgilendirmek, arabulucuları görevlendirmek ve kanunla verilen diğer görevleri yerine getirmek üzere Bakanlık tarafından uygun görülen adliyelerde, adliye arabuluculuk büroları kurulur."
                ]
            ),
            LawArticle(
                number: "57",
                title: "Adliye arabuluculuk büro personeli",
                paragraphs: [
                    "Adli yargı ilk derece mahkemesi adalet komisyonu tarafından, münhasıran bu bürolarda çalışmak üzere bir yazı işleri müdürü ile yeteri kadar personel görevlendirilir."
                ]
            ),
            LawArticle(
                number: "58",
                title: "Adliye arabuluculuk bürolarının denetimi",
                paragraphs: [
                    "Adliye arabuluculuk büroları, Hâkimler ve Savcılar Kurulu tarafından belirlenen sulh hukuk hâkiminin gözetim ve denetimi altında görev yapar. Adliye arabuluculuk bürosu kurulmayan yerlerde bu büroların görevi, adli yargı ilk derece mahkemesi adalet komisyonunca görevlendirilen sulh hukuk mahkemesi yazı işleri müdürlüğü tarafından ilgili hâkimin gözetim ve denetimi altında yerine getirilir."
                ]
            ),
            // BEŞİNCİ KISIM - Çeşitli ve Son Hükümler
            LawArticle(
                number: "59",
                title: "Yürürlükten kaldırılan yönetmelik",
                paragraphs: [
                    "26/1/2013 tarihli 28540 sayılı Resmî Gazete'de yayımlanan Hukuk Uyuşmazlıklarında Arabuluculuk Kanunu Yönetmeliği yürürlükten kaldırılmıştır."
                ]
            ),
            LawArticle(
                number: "Geçici 1",
                title: "Yenileme eğitimine esas kayıt tarihi",
                paragraphs: [
                    "1/1/2018 tarihinden önce sicile kaydolanlar bakımından bu Yönetmeliğin Resmî Gazete'de yayımlandığı tarih 32 nci maddenin altıncı fıkrası uyarınca, sicile kayıt tarihi sayılır."
                ]
            ),
            LawArticle(
                number: "60",
                title: "Yürürlük",
                paragraphs: [
                    "Bu Yönetmelik yayımı tarihinde yürürlüğe girer."
                ]
            ),
            LawArticle(
                number: "61",
                title: "Yürütme",
                paragraphs: [
                    "Bu Yönetmelik hükümlerini Adalet Bakanı yürütür."
                ]
            )
        ]
    )
    // swiftlint:enable function_body_length
}
