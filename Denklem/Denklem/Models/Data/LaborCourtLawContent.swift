//
//  LaborCourtLawContent.swift
//  Denklem
//
//  Created by ozkan on 17.02.2026.
//

import Foundation

// MARK: - Law Document Content Models

/// Represents a single article (madde) in a law document
struct LawArticle {
    let number: String          // e.g., "1", "GEÇİCİ 1"
    let title: String
    let paragraphs: [String]
}

/// Complete law document content
struct LawDocumentContent {
    let lawNumber: Int
    let title: String
    let gazetteDate: String
    let gazetteNumber: String
    let acceptanceDate: String
    let articles: [LawArticle]
}

// MARK: - Factory

extension LawDocumentContent {

    /// Returns law/regulation document content for the given content identifier
    static func content(for contentId: Int) -> LawDocumentContent? {
        switch contentId {
        case 6325: return Self.mediationLaw6325
        case 7036: return Self.laborCourtLaw7036
        case 30439: return Self.mediationRegulation30439
        default: return nil
        }
    }

    /// Converts the entire law content to a plain text string for sharing
    func toPlainText() -> String {
        var text = ""

        text += "\(title)\n\n"
        text += "Kanun Numarası: \(lawNumber)\n"
        text += "Kabul Tarihi: \(acceptanceDate)\n"
        text += "Resmî Gazete Tarihi: \(gazetteDate)\n"
        text += "Resmî Gazete Sayısı: \(gazetteNumber)\n\n"

        for article in articles {
            text += "MADDE \(article.number) – \(article.title)\n\n"
            for (index, paragraph) in article.paragraphs.enumerated() {
                text += "(\(index + 1)) \(paragraph)\n\n"
            }
        }

        return text
    }
}

// MARK: - 7036 Sayılı İş Mahkemeleri Kanunu

extension LawDocumentContent {

    // swiftlint:disable function_body_length
    static let laborCourtLaw7036 = LawDocumentContent(
        lawNumber: 7036,
        title: "İŞ MAHKEMELERİ KANUNU",
        gazetteDate: "25.10.2017",
        gazetteNumber: "30221",
        acceptanceDate: "12/10/2017",
        articles: [
            LawArticle(
                number: "1",
                title: "Amaç",
                paragraphs: [
                    "Bu Kanunun amacı; iş mahkemelerinin kuruluş, görev, yetki ve yargılama usulünü düzenlemektir."
                ]
            ),
            LawArticle(
                number: "2",
                title: "İş mahkemelerinin kuruluşu",
                paragraphs: [
                    "İş mahkemeleri, Hâkimler ve Savcılar Kurulunun olumlu görüşü alınarak, tek hâkimli ve asliye mahkemesi derecesinde Adalet Bakanlığınca lüzum görülen yerlerde kurulur. Bu mahkemelerin yargı çevresi, 26/9/2004 tarihli ve 5235 sayılı Adlî Yargı İlk Derece Mahkemeleri ile Bölge Adliye Mahkemelerinin Kuruluş, Görev ve Yetkileri Hakkında Kanun hükümlerine göre belirlenir.",
                    "İş durumunun gerekli kıldığı yerlerde iş mahkemelerinin birden fazla dairesi oluşturulabilir. Bu daireler numaralandırılır. İhtisaslaşmanın sağlanması amacıyla, gelen işlerin yoğunluğu ve niteliği dikkate alınarak, daireler arasındaki iş dağılımı Hâkimler ve Savcılar Kurulu tarafından belirlenebilir. Bu kararlar Resmî Gazete'de yayımlanır. Daireler, tevzi edilen davalara bakmak zorundadır.",
                    "İş mahkemesi kurulmamış olan yerlerde bu mahkemenin görev alanına giren dava ve işlere, o yerdeki asliye hukuk mahkemesince, bu Kanundaki usul ve esaslara göre bakılır."
                ]
            ),
            LawArticle(
                number: "3",
                title: "Dava şartı olarak arabuluculuk",
                paragraphs: [
                    "Kanuna, bireysel veya toplu iş sözleşmesine dayanan işçi veya işveren alacağı ve tazminatı ile işe iade talebiyle açılan davalarda, arabulucuya başvurulmuş olması dava şartıdır. Bu alacak ve tazminatla ilgili itirazın iptali, menfi tespit ve istirdat davaları hakkında birinci cümle hükmü uygulanır.",
                    "Davacı, arabuluculuk faaliyeti sonunda anlaşmaya varılamadığına ilişkin son tutanağın aslını veya arabulucu tarafından onaylanmış bir örneğini dava dilekçesine eklemek zorundadır. Bu zorunluluğa uyulmaması hâlinde mahkemece davacıya, son tutanağın bir haftalık kesin süre içinde mahkemeye sunulması gerektiği, aksi takdirde davanın usulden reddedileceği ihtarını içeren davetiye gönderilir. İhtarın gereği yerine getirilmez ise dava dilekçesi karşı tarafa tebliğe çıkarılmaksızın davanın usulden reddine karar verilir. Arabulucuya başvurulmadan dava açıldığının anlaşılması hâlinde herhangi bir işlem yapılmaksızın davanın, dava şartı yokluğu sebebiyle usulden reddine karar verilir.",
                    "İş kazası veya meslek hastalığından kaynaklanan maddi ve manevi tazminat ile bunlarla ilgili tespit, itiraz ve rücu davaları hakkında birinci fıkra hükmü uygulanmaz.",
                    "Arabuluculuk Daire Başkanlığı, sicile kayıtlı arabuluculardan bu madde uyarınca arabuluculuk yapmak isteyenleri, varsa uzmanlık alanlarını da belirterek, görev yapmak istedikleri adli yargı ilk derece mahkemesi adalet komisyonlarına göre listeler ve listeleri ilgili komisyon başkanlıklarına bildirir. Komisyon başkanlıkları, bu listeleri kendi yargı çevrelerindeki arabuluculuk bürolarına, arabuluculuk bürosu kurulmayan yerlerde ise görevlendirecekleri sulh hukuk mahkemesi yazı işleri müdürlüğüne gönderir.",
                    "Başvuru karşı tarafın, karşı taraf birden fazla ise bunlardan birinin yerleşim yerindeki veya işin yapıldığı yerdeki arabuluculuk bürosuna, arabuluculuk bürosu kurulmayan yerlerde ise görevlendirilen yazı işleri müdürlüğüne yapılır.",
                    "Arabulucu, komisyon başkanlıklarına bildirilen listeden büro tarafından belirlenir. Ancak tarafların listede yer alan herhangi bir arabulucu üzerinde anlaşmaları hâlinde bu arabulucu görevlendirilir.",
                    "Başvuran taraf, kendisine ve elinde bulunması hâlinde karşı tarafa ait her türlü iletişim bilgisini arabuluculuk bürosuna verir. Büro, tarafların resmi kayıtlarda yer alan iletişim bilgilerini araştırmaya da yetkilidir. İlgili kurum ve kuruluşlar, büro tarafından talep edilen bilgi ve belgeleri vermekle yükümlüdür.",
                    "Taraflara ait iletişim bilgileri, görevlendirilen arabulucuya büro tarafından verilir. Arabulucu bu iletişim bilgilerini esas alır, ihtiyaç duyduğunda kendiliğinden araştırma da yapabilir. Elindeki bilgiler itibarıyla her türlü iletişim vasıtasını kullanarak görevlendirme konusunda tarafları bilgilendirir ve ilk toplantıya davet eder. Bilgilendirme ve davete ilişkin işlemlerini belgeye bağlar.",
                    "Arabulucu, görevlendirmeyi yapan büronun yetkili olup olmadığını kendiliğinden dikkate alamaz. Karşı taraf en geç ilk toplantıda, yerleşim yeri ve işin yapıldığı yere ilişkin belgelerini sunmak suretiyle arabuluculuk bürosunun yetkisine itiraz edebilir. Bu durumda arabulucu, dosyayı derhâl ilgili sulh hukuk mahkemesine gönderilmek üzere büroya teslim eder. Mahkeme, harç alınmaksızın dosya üzerinden yapacağı inceleme sonunda yetkili büroyu kesin olarak karara bağlar ve dosyayı büroya iade eder. Mahkeme kararı büro tarafından 11/2/1959 tarihli ve 7201 sayılı Tebligat Kanunu hükümleri uyarınca taraflara tebliğ edilir. Yetki itirazının reddi durumunda aynı arabulucu yeniden görevlendirilir ve onuncu fıkrada belirtilen süreler yeni görevlendirme tarihinden başlar. Yetki itirazının kabulü durumunda ise kararın tebliğinden itibaren bir hafta içinde yetkili büroya başvurulabilir. Bu takdirde yetkisiz büroya başvurma tarihi yetkili büroya başvurma tarihi olarak kabul edilir. Yetkili büro, altıncı fıkra uyarınca arabulucu görevlendirir.",
                    "Arabulucu, yapılan başvuruyu görevlendirildiği tarihten itibaren üç hafta içinde sonuçlandırır. Bu süre zorunlu hâllerde arabulucu tarafından en fazla bir hafta uzatılabilir.",
                    "Arabulucu, taraflara ulaşılamaması, taraflar katılmadığı için görüşme yapılamaması yahut yapılan görüşmeler sonucunda anlaşmaya varılması veya varılamaması hâllerinde arabuluculuk faaliyetini sona erdirir ve son tutanağı düzenleyerek durumu derhâl arabuluculuk bürosuna bildirir.",
                    "Taraflardan birinin geçerli bir mazeret göstermeksizin ilk toplantıya katılmaması sebebiyle arabuluculuk faaliyetinin sona ermesi durumunda toplantıya katılmayan taraf, son tutanakta belirtilir ve bu taraf davada kısmen veya tamamen haklı çıksa bile karşı tarafın ödemekle yükümlü olduğu yargılama giderlerinin yarısından sorumlu tutulur. Ayrıca bu taraf lehine Avukatlık Asgari Ücret Tarifesine göre belirlenen vekâlet ücretinin yarısına hükmedilir. Her iki tarafın da ilk toplantıya katılmaması sebebiyle sona eren arabuluculuk faaliyeti üzerine açılacak davalarda tarafların yaptıkları yargılama giderleri kendi üzerlerinde bırakılır.",
                    "Tarafların arabuluculuk faaliyeti sonunda anlaşmaları hâlinde, arabuluculuk ücreti, Arabuluculuk Asgari Ücret Tarifesinin eki Arabuluculuk Ücret Tarifesinin İkinci Kısmına göre aksi kararlaştırılmadıkça taraflarca eşit şekilde karşılanır. Bu durumda ücret, Tarifenin Birinci Kısmında belirlenen iki saatlik ücret tutarından az olamaz. İşe iade talebiyle yapılan görüşmelerde tarafların anlaşmaları durumunda, arabulucuya ödenecek ücretin belirlenmesinde işçiye işe başlatılmaması hâlinde ödenecek tazminat miktarı ile çalıştırılmadığı süre için ödenecek ücret ve diğer haklarının toplamı, Tarifenin İkinci Kısmı uyarınca üzerinde anlaşılan miktar olarak kabul edilir.",
                    "Arabuluculuk faaliyeti sonunda taraflara ulaşılamaması, taraflar katılmadığı için görüşme yapılamaması veya iki saatten az süren görüşmeler sonunda tarafların anlaşamamaları hâllerinde, iki saatlik ücret tutarı Tarifenin Birinci Kısmına göre Adalet Bakanlığı bütçesinden ödenir. İki saatten fazla süren görüşmeler sonunda tarafların anlaşamamaları hâlinde ise iki saati aşan kısma ilişkin ücret aksi kararlaştırılmadıkça taraflarca eşit şekilde Tarifenin Birinci Kısmına göre karşılanır. Adalet Bakanlığı bütçesinden ödenen ve taraflarca karşılanan arabuluculuk ücreti, yargılama giderlerinden sayılır.",
                    "(İptal: Anayasa Mahkemesinin 3/6/2025 tarihli ve E.:2024/157; K.:2025/121 sayılı Kararı ile.)",
                    "Bu madde uyarınca arabuluculuk bürosu tarafından yapılması gereken zaruri giderler; arabuluculuk faaliyeti sonunda anlaşmaya varılması hâlinde anlaşma uyarınca taraflarca ödenmek, anlaşmaya varılamaması hâlinde ise ileride haksız çıkacak taraftan tahsil olunmak üzere Adalet Bakanlığı bütçesinden karşılanır.",
                    "Arabuluculuk bürosuna başvurulmasından son tutanağın düzenlendiği tarihe kadar geçen sürede zamanaşımı durur ve hak düşürücü süre işlemez.",
                    "Arabuluculuk görüşmelerine taraflar bizzat, kanuni temsilcileri veya avukatları aracılığıyla katılabilirler. İşverenin yazılı belgeyle yetkilendirdiği çalışanı da görüşmelerde işvereni temsil edebilir ve son tutanağı imzalayabilir.",
                    "Arabuluculuk görüşmeleri, taraflarca aksi kararlaştırılmadıkça, arabulucuyu görevlendiren büronun bağlı bulunduğu adli yargı ilk derece mahkemesi adalet komisyonunun yetki alanı içinde yürütülür.",
                    "13/6/1952 tarihli ve 5953 sayılı Basın Mesleğinde Çalışanlarla Çalıştıranlar Arasındaki Münasebetlerin Tanzimi Hakkında Kanunda düzenlenen gazeteci ile 20/4/1967 tarihli ve 854 sayılı Deniz İş Kanununda düzenlenen gemiadamı, bu madde kapsamında işçi sayılır.",
                    "Bu maddede hüküm bulunmayan hâllerde niteliğine uygun düştüğü ölçüde 7/6/2012 tarihli ve 6325 sayılı Hukuk Uyuşmazlıklarında Arabuluculuk Kanunu hükümleri uygulanır.",
                    "Arabuluculuğa başvuru usulü, arabulucunun görevlendirilmesi ve arabuluculuk görüşmelerine ilişkin diğer hususlar Adalet Bakanlığınca yürürlüğe konulan yönetmelikle belirlenir."
                ]
            ),
            LawArticle(
                number: "4",
                title: "Sosyal Güvenlik Kurumuna başvuru zorunluluğu",
                paragraphs: [
                    "31/5/2006 tarihli ve 5510 sayılı Sosyal Sigortalar ve Genel Sağlık Sigortası Kanunu ile diğer sosyal güvenlik mevzuatından kaynaklanan uyuşmazlıklarda, hizmet akdine tabi çalışmaları nedeniyle zorunlu sigortalılık sürelerinin tespiti talepleri hariç olmak üzere, dava açılmadan önce Sosyal Güvenlik Kurumuna başvurulması zorunludur. Diğer kanunlarda öngörülen süreler saklı kalmak kaydıyla yapılan başvuruya altmış gün içinde Kurumca cevap verilmezse talep reddedilmiş sayılır. Kuruma karşı dava açılabilmesi için taleplerin reddedilmesi veya reddedilmiş sayılması şarttır. Kuruma başvuruda geçirilecek süre zamanaşımı ve hak düşürücü sürelerin hesaplanmasında dikkate alınmaz.",
                    "Hizmet akdine tabi çalışmaları nedeniyle zorunlu sigortalılık sürelerinin tespiti talebi ile işveren aleyhine açılan davalarda, dava Kuruma resen ihbar edilir. İhbar üzerine davaya davalı yanında ferî müdahil olarak katılan Kurum, yanında katıldığı taraf başvurmasa dahi kanun yoluna başvurabilir. Kurum, yargılama sonucu verilecek kararı kesinleştikten sonra uygulamakla yükümlüdür."
                ]
            ),
            LawArticle(
                number: "5",
                title: "Görev",
                paragraphs: [
                    "İş mahkemeleri;\na) 5953 sayılı Kanuna tabi gazeteciler, 854 sayılı Kanuna tabi gemiadamları, 22/5/2003 tarihli ve 4857 sayılı İş Kanununa veya 11/1/2011 tarihli ve 6098 sayılı Türk Borçlar Kanununun İkinci Kısmının Altıncı Bölümünde düzenlenen hizmet sözleşmelerine tabi işçiler ile işveren veya işveren vekilleri arasında, iş ilişkisi nedeniyle sözleşmeden veya kanundan doğan her türlü hukuk uyuşmazlıklarına,\nb) İdari para cezalarına itirazlar ile 5510 sayılı Kanunun geçici 4 üncü maddesi kapsamındaki uyuşmazlıklar hariç olmak üzere Sosyal Güvenlik Kurumu veya Türkiye İş Kurumunun taraf olduğu iş ve sosyal güvenlik mevzuatından kaynaklanan uyuşmazlıklara,\nc) Diğer kanunlarda iş mahkemelerinin görevli olduğu belirtilen uyuşmazlıklara,\nilişkin dava ve işlere bakar."
                ]
            ),
            LawArticle(
                number: "6",
                title: "Yetki",
                paragraphs: [
                    "İş mahkemelerinde açılacak davalarda yetkili mahkeme, davalı gerçek veya tüzel kişinin davanın açıldığı tarihteki yerleşim yeri mahkemesi ile işin veya işlemin yapıldığı yer mahkemesidir.",
                    "Davalı birden fazla ise bunlardan birinin yerleşim yeri mahkemesi de yetkilidir.",
                    "İş kazasından doğan tazminat davalarında, iş kazasının veya zararın meydana geldiği yer ile zarar gören işçinin yerleşim yeri mahkemesi de yetkilidir.",
                    "İş mahkemelerinin yetkilerine ilişkin olarak diğer kanunlarda yer alan hükümler saklıdır.",
                    "Bu madde hükümlerine aykırı yetki sözleşmeleri geçersizdir."
                ]
            ),
            LawArticle(
                number: "7",
                title: "Yargılama usulü ve kanun yolları",
                paragraphs: [
                    "İş mahkemelerinde basit yargılama usulü uygulanır.",
                    "Davaların yığılması hâlinde, her bir talebe ilişkin vakıalar bakımından ispat yükü ve deliller ayrı ayrı değerlendirilir.",
                    "12/1/2011 tarihli ve 6100 sayılı Hukuk Muhakemeleri Kanununun kanun yollarına ilişkin hükümleri, iş mahkemelerince verilen kararlar hakkında da uygulanır.",
                    "Kanun yoluna başvuru süresi, ilamın taraflara tebliğinden itibaren işlemeye başlar.",
                    "Kanun yoluna başvurulan kararlar, bölge adliye mahkemesi ve Yargıtayca ivedilikle karara bağlanır."
                ]
            ),
            LawArticle(
                number: "8",
                title: "Temyiz edilemeyen kararlar",
                paragraphs: [
                    "Diğer kanunlardaki hükümler saklı kalmak kaydıyla, aşağıda belirtilen dava ve işlerde verilen kararlar hakkında temyiz yoluna başvurulamaz:\na) 4857 sayılı Kanunun 20 nci maddesi uyarınca açılan fesih bildirimine itiraz davalarında verilen kararlar.\nb) İşveren tarafından toplu iş sözleşmesi veya işyeri düzenlemeleri uyarınca işçiye verilen disiplin cezalarının iptali için açılan davalarda verilen kararlar.\nc) 18/10/2012 tarihli ve 6356 sayılı Sendikalar ve Toplu İş Sözleşmesi Kanununun;\n  1) 24 üncü maddesinin birinci ve beşinci fıkraları,\n  2) 34 üncü maddesinin dördüncü fıkrası,\n  3) 53 üncü maddesinin birinci fıkrası,\n  4) 71 inci maddesinin birinci fıkrası,\n  kapsamında açılan davalarda verilen kararlar.\nç) 25/6/2001 tarihli ve 4688 sayılı Kamu Görevlileri Sendikaları ve Toplu Sözleşme Kanununun;\n  1) 10 uncu maddesinin sekizinci fıkrası,\n  2) 14 üncü maddesinin dördüncü fıkrası,\n  kapsamında açılan davalarda verilen kararlar."
                ]
            ),
            LawArticle(
                number: "9",
                title: "Hüküm bulunmayan hâller",
                paragraphs: [
                    "Bu Kanunda hüküm bulunmayan hâllerde 6100 sayılı Kanun hükümleri uygulanır."
                ]
            ),
            LawArticle(
                number: "10",
                title: "Yürürlükten kaldırılan hükümler",
                paragraphs: [
                    "30/1/1950 tarihli ve 5521 sayılı İş Mahkemeleri Kanunu yürürlükten kaldırılmıştır.",
                    "Mevzuatta, yürürlükten kaldırılan 5521 sayılı Kanuna yapılan atıflar, bu Kanuna yapılmış sayılır."
                ]
            ),
            LawArticle(
                number: "11-16",
                title: "İş Kanunu ile ilgili düzenlemeler",
                paragraphs: [
                    "22/5/2003 tarihli ve 4857 sayılı İş Kanunu ile ilgili olup yerine işlenmiştir."
                ]
            ),
            LawArticle(
                number: "17-28",
                title: "Arabuluculuk Kanunu ile ilgili düzenlemeler",
                paragraphs: [
                    "7/6/2012 tarihli ve 6325 sayılı Hukuk Uyuşmazlıklarında Arabuluculuk Kanunu ile ilgili olup yerine işlenmiştir."
                ]
            ),
            LawArticle(
                number: "29-36",
                title: "Sendikalar ve Toplu İş Sözleşmesi Kanunu ile ilgili düzenlemeler",
                paragraphs: [
                    "18/10/2012 tarihli ve 6356 sayılı Sendikalar ve Toplu İş Sözleşmesi Kanunu ile ilgili olup yerine işlenmiştir."
                ]
            ),
            LawArticle(
                number: "37",
                title: "KİT Personel Rejimi ile ilgili düzenleme",
                paragraphs: [
                    "22/1/1990 tarihli ve 399 sayılı Kamu İktisadi Teşebbüsleri Personel Rejiminin Düzenlenmesi ve 233 Sayılı Kanun Hükmünde Kararnamenin Bazı Maddelerinin Yürürlükten Kaldırılmasına Dair Kanun Hükmünde Kararname ile ilgili olup yerine işlenmiştir."
                ]
            ),
            LawArticle(
                number: "Geçici 1",
                title: "Geçiş hükümleri",
                paragraphs: [
                    "Mülga 5521 sayılı Kanun gereğince kurulan iş mahkemeleri, bu Kanun uyarınca kurulmuş iş mahkemeleri olarak kabul edilir. Bu maddenin yürürlüğe girdiği tarihten önce açılmış olan davalar, açıldıkları mahkemelerde görülmeye devam olunur.",
                    "Bu Kanunun dava şartı olarak arabuluculuğa ilişkin hükümleri, bu hükümlerin yürürlüğe girdiği tarih itibarıyla ilk derece mahkemeleri ve bölge adliye mahkemeleri ile Yargıtayda görülmekte olan davalar hakkında uygulanmaz.",
                    "Başka mahkemelerin görev alanına girerken bu Kanunla iş mahkemelerinin görev alanına dâhil edilen dava ve işler, iş mahkemelerine devredilmez; kesinleşinceye kadar ilgili mahkemeler tarafından görülmeye devam olunur.",
                    "İlk derece mahkemeleri tarafından bu Kanunun yürürlüğe girdiği tarihten önce verilen kararlar, karar tarihindeki kanun yoluna ilişkin hükümlere tabidir."
                ]
            ),
            LawArticle(
                number: "38",
                title: "Yürürlük",
                paragraphs: [
                    "Bu Kanunun;\na) 3 üncü, 11 inci ve 12 nci maddeleri 1/1/2018 tarihinde,\nb) Diğer hükümleri yayımı tarihinde,\nyürürlüğe girer."
                ]
            ),
            LawArticle(
                number: "39",
                title: "Yürütme",
                paragraphs: [
                    "Bu Kanun hükümlerini Bakanlar Kurulu yürütür."
                ]
            )
        ]
    )
    // swiftlint:enable function_body_length
}
