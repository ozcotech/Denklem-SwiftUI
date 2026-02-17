//
//  AttorneyFeeTariffContent.swift
//  Denklem
//
//  Created by ozkan on 17.02.2026.
//

import Foundation

// MARK: - Attorney Fee Tariff Content Models

/// A single fee row in a tariff table (e.g., "İlk 600.000,00 TL için → %16")
struct AttorneyFeeItem {
    let number: String      // "1", "2a", "5b", "" (for continuation rows)
    let description: String
    let amount: String      // e.g., "4.000,00 TL" or "Üçüncü kısma göre belirlenir"
}

/// A section/chapter in the attorney fee tariff appendix
struct AttorneyFeeTableSection {
    let partTitle: String       // e.g., "BİRİNCİ KISIM – BİRİNCİ BÖLÜM"
    let subtitle: String        // e.g., "Dava ve Takiplerin Dışındaki..."
    let items: [AttorneyFeeItem]
    let footnote: String?
}

/// A bracket row in the third part percentage table
struct AttorneyFeeBracket {
    let number: Int
    let description: String     // e.g., "İlk 600.000,00 TL için"
    let rate: String            // e.g., "%16"
}

/// Complete attorney fee minimum tariff content
struct AttorneyFeeTariffContent {
    let year: Int
    let gazetteInfo: String
    let effectiveDate: String
    let articles: [LawArticle]
    let tableSections: [AttorneyFeeTableSection]
    let part3Title: String
    let part3Subtitle: String
    let part3Brackets: [AttorneyFeeBracket]
}

// MARK: - Factory

extension AttorneyFeeTariffContent {

    /// Returns attorney fee tariff content for the given year
    static func content(for year: Int) -> AttorneyFeeTariffContent? {
        switch year {
        case 2026: return Self.content2026
        default: return nil
        }
    }

    /// Converts the entire tariff content to a plain text string for sharing
    func toPlainText() -> String {
        var text = ""

        text += "\(year) Yılı Avukatlık Asgari Ücret Tarifesi\n"
        text += "\(gazetteInfo)\n"
        text += "Yürürlük Tarihi: \(effectiveDate)\n\n"

        for article in articles {
            text += "MADDE \(article.number) – \(article.title)\n\n"
            for (index, paragraph) in article.paragraphs.enumerated() {
                text += "(\(index + 1)) \(paragraph)\n\n"
            }
        }

        for section in tableSections {
            text += "\(section.partTitle)\n"
            text += "\(section.subtitle)\n\n"
            for item in section.items {
                let num = item.number.isEmpty ? "   " : "\(item.number)."
                text += "\(num) \(item.description): \(item.amount)\n"
            }
            if let footnote = section.footnote {
                text += "\n* \(footnote)\n"
            }
            text += "\n"
        }

        text += "\(part3Title)\n\(part3Subtitle)\n\n"
        for bracket in part3Brackets {
            text += "\(bracket.number). \(bracket.description): \(bracket.rate)\n"
        }

        return text
    }
}

// MARK: - 2026 Content

extension AttorneyFeeTariffContent {

    // swiftlint:disable function_body_length
    static let content2026 = AttorneyFeeTariffContent(
        year: 2026,
        gazetteInfo: "Resmî Gazete: 4 Kasım 2025, Sayı: 33067",
        effectiveDate: "4 Kasım 2025",
        articles: [
            LawArticle(
                number: "1",
                title: "Amaç ve kapsam",
                paragraphs: [
                    "Mahkemelerde, tüm hukuki yardımlarda, taraflar arasındaki uyuşmazlığı sonlandıran her türlü merci kararlarında ve ayrıca kanun gereği mahkemelerce karşı tarafa yükletilmesi gereken avukatlık ücretinin tayin ve takdirinde, 19/3/1969 tarihli ve 1136 sayılı Avukatlık Kanunu ve bu Tarife hükümleri uygulanır.",
                    "Taraflar arasında akdi avukatlık ücreti kararlaştırılmaması veya kararlaştırılan akdi avukatlık ücretinin geçersiz sayılması halinde; mahkemelerce, dava konusu edilen tutar üzerinden bu Tarife gereğince hesaplanacak avukatlık ücretinin altında bir ücrete hükmedilemez. Bu Tarife 1136 sayılı Kanunun 164 üncü maddesinin dördüncü fıkrası doğrultusunda gerçekleştirilecek olan akdi avukatlık ücreti belirlenmesinde sadece asgari değerin hesaplanmasında dikkate alınır. Diğer hususlar 1136 sayılı Kanundaki hükümlere tabidir.",
                    "Avukatlık asgari ücret tarifesi altında vekalet ücreti kararlaştırılamaz. Bu Tarife hükümleri altında kararlaştırılan akdi avukatlık ücretleri, bu Tarife hükümleri uyarınca kararlaştırılmış olarak kabul edilir."
                ]
            ),
            LawArticle(
                number: "2",
                title: "Avukatlık ücretinin kapsadığı işler",
                paragraphs: [
                    "Bu Tarifede yazılı avukatlık ücreti, dava dışındaki işler için hukuki yardım tamamlanıncaya, davada ise kesin hüküm elde edilinceye kadar olan bütün iş ve işlemler karşılığıdır. Avukat tarafından takip edilen dava veya işle ilgili olarak düzenlenen dilekçe ve yapılan diğer işlemler ayrı ücreti gerektirmez. Hükümlerin tavzihine ilişkin istemlerin ret veya kabulü halinde de avukatlık ücretine hükmedilemez.",
                    "Buna karşılık, icra takipleriyle, Yargıtay, Danıştay ve Sayıştayda temyizen ve bölge idare ve bölge adliye mahkemelerinde istinaf başvurusu üzerine görülen işlerin duruşmaları ayrı ücreti gerektirir.",
                    "Hangi sebeple olursa olsun, temyiz veya istinaf başvurusu üzerine verilen bozma veya kaldırma kararı sonrasında hükmolunan yargı kararlarında, hükmün verildiği tarihte yürürlükte olan Tarife esas alınır.",
                    "Temyiz başvurusu üzerine verilen bozma kararı sonrasında istinafta görülen duruşmalı işlerde, duruşma sayısına göre, bu Tarifenin ikinci kısmının ikinci bölümünün 18 inci sırasının (b) veya (c) bentlerine göre avukatlık ücretine hükmolunur."
                ]
            ),
            LawArticle(
                number: "3",
                title: "Avukatlık ücretinin aidiyeti, sınırları ve ortak veya değişik sebeple davanın reddinde davalıların avukatlık ücreti",
                paragraphs: [
                    "Yargı yerlerince avukata ait olmak üzere karşı tarafa yükletilecek avukatlık ücreti, bu Tarifede yazılı miktardan az ve üç katından çok olamaz. Bu ücretin belirlenmesinde, avukatın emeği, çabası, işin önemi, niteliği ve davanın süresi göz önünde tutulur.",
                    "Müteselsil sorumluluk da dahil olmak üzere, birden fazla davalı aleyhine açılan davanın reddinde, ret sebebi ortak olan davalılar vekili lehine tek, ret sebebi ayrı olan davalılar vekili lehine ise her ret sebebi için ayrı ayrı avukatlık ücretine hükmolunur."
                ]
            ),
            LawArticle(
                number: "4",
                title: "Birden çok avukat ile temsil",
                paragraphs: [
                    "Aynı hukuki yardımın birden çok avukat tarafından yapılması durumunda, karşı tarafa bir avukatlık ücretinden fazlası yükletilemez."
                ]
            ),
            LawArticle(
                number: "5",
                title: "Ücretin tümünü hak etme",
                paragraphs: [
                    "Hangi aşamada olursa olsun, dava ve icra takibini kabul eden avukat, bu Tarife hükümleri ile belirlenen ücretin tamamına hak kazanır.",
                    "Gerek kısmi dava gerekse belirsiz alacak ve tespit davasında mahkemece dava değerinin belirlenmesinden sonra davacı davasını belirlenmiş değere göre takip etmese dahi, yasal avukatlık ücreti, belirlenmiş dava değerine göre hesaplanır."
                ]
            ),
            LawArticle(
                number: "6",
                title: "Davanın konusuz kalması, feragat, kabul ve sulhte ücret",
                paragraphs: [
                    "Anlaşmazlık, davanın konusuz kalması, feragat, kabul, sulh veya herhangi bir nedenle; ön inceleme tutanağı imzalanıncaya kadar giderilirse, bu Tarife hükümleriyle belirlenen ücretlerin yarısına, ön inceleme tutanağı imzalandıktan sonra giderilirse tamamına hükmolunur. Bu madde yargı mercileri tarafından hesaplanan akdi avukatlık ücreti sözleşmelerinde uygulanmaz."
                ]
            ),
            LawArticle(
                number: "7",
                title: "Görevsizlik, yetkisizlik, dava ön şartlarının yokluğu veya husumet nedeniyle davanın reddinde, davanın nakli ve açılmamış sayılmasında ücret",
                paragraphs: [
                    "Ön inceleme tutanağı imzalanıncaya kadar; davanın nakli, davanın açılmamış sayılması yahut görevsizlik veya yetkisizlik kararı verildikten sonra başka bir mahkemede yargılamaya devam edilmemesi durumunda bu Tarifede yazılı ücretin yarısına, ön inceleme tutanağı imzalandıktan sonra karar verilmesi durumunda tamamına hükmolunur. Şu kadar ki, davanın görüldüğü mahkemeye göre hükmolunacak avukatlık ücreti, bu Tarifenin ikinci kısmının ikinci bölümünde yazılı miktarları geçemez.",
                    "Davanın dinlenebilmesi için kanunlarda öngörülen ön şartın yerine getirilmemiş olması ve husumet nedeniyle davanın reddine karar verilmesinde, davanın görüldüğü mahkemeye göre bu Tarifenin ikinci kısmının ikinci bölümünde yazılı miktarları geçmemek üzere üçüncü kısımda yazılı avukatlık ücretine hükmolunur.",
                    "Kanunlar gereği gönderme, yeni mahkemeler kurulması, iş bölümü itirazı nedeniyle verilen tüm gönderme kararları nedeniyle görevsizlik, gönderme veya yetkisizlik kararı verilmesi durumunda avukatlık ücretine hükmedilmez."
                ]
            ),
            LawArticle(
                number: "8",
                title: "Karşılık davada, davaların birleştirilmesinde, ayrılmasında ve tarafta iradi değişiklik halinde ücret",
                paragraphs: [
                    "Bir davanın takibi sırasında karşılık dava açılması, başka bir davanın bu davayla birleştirilmesi veya davaların ayrılması durumunda, her dava için ayrı ücrete hükmolunur.",
                    "Tarafta iradi değişiklik halinde, davanın tarafı olmaktan çıkarılan ve aleyhine dava açılmasına sebebiyet vermeyen kişi vekille temsil edilmişse, lehine maktu avukatlık ücretine hükmolunur."
                ]
            ),
            LawArticle(
                number: "9",
                title: "Nafaka, kira tespiti ve tahliye davalarında ücret",
                paragraphs: [
                    "Tahliye davalarında bir yıllık kira bedeli tutarı, kira tespiti ve nafaka davalarında tespit olunan kira bedeli farkının veya hükmolunan nafakanın bir yıllık tutarı üzerinden bu Tarifenin üçüncü kısmı gereğince hesaplanacak miktarın tamamı, avukatlık ücreti olarak hükmolunur. Bu miktarlar, bu Tarifenin ikinci kısmının ikinci bölümünde davanın görüldüğü mahkemeye göre belirlenmiş bulunan ücretten az olamaz.",
                    "Nafaka davalarında reddedilen kısım için avukatlık ücretine hükmedilemez."
                ]
            ),
            LawArticle(
                number: "10",
                title: "Manevi tazminat davalarında ücret",
                paragraphs: [
                    "Manevi tazminat davalarında avukatlık ücreti, hüküm altına alınan miktar üzerinden bu Tarifenin üçüncü kısmına göre belirlenir.",
                    "Davanın kısmen reddi durumunda, karşı taraf vekili yararına bu Tarifenin üçüncü kısmına göre hükmedilecek ücret, davacı vekili lehine belirlenen ücreti geçemez.",
                    "Bu davaların tamamının reddi durumunda avukatlık ücreti, bu Tarifenin ikinci kısmının ikinci bölümüne göre hükmolunur.",
                    "Manevi tazminat davasının, maddi tazminat veya parayla değerlendirilmesi mümkün diğer taleplerle birlikte açılması durumunda; manevi tazminat açısından avukatlık ücreti ayrı bir kalem olarak hükmedilir."
                ]
            ),
            LawArticle(
                number: "11",
                title: "İcra ve iflas müdürlükleri ile icra mahkemelerinde ücret",
                paragraphs: [
                    "İcra ve İflas Müdürlüklerindeki hukuki yardımlara ilişkin avukatlık ücreti, takip sonuçlanıncaya kadar yapılan bütün işlemlerin karşılığıdır. Konusu para veya para ile değerlendirilebiliyor ise avukatlık ücreti, bu Tarifenin üçüncü kısmına göre belirlenir. Şu kadar ki takip miktarı 56.250,00 TL'ye kadar olan icra takiplerinde avukatlık ücreti, bu Tarifenin ikinci kısmının ikinci bölümünde, icra dairelerindeki takipler için öngörülen maktu ücrettir. Ancak, bu ücret asıl alacağı geçemez.",
                    "Aciz belgesi alınması, takibi sonuçlandıran işlemlerden sayılır. Bu durumda avukata tam ücret ödenir.",
                    "İcra mahkemelerinde duruşma yapılırsa bu Tarife gereğince ayrıca avukatlık ücretine hükmedilir. Şu kadar ki bu ücret, bu Tarifenin ikinci kısmının ikinci bölümünün iki ve üç sıra numaralarında gösterilen iş ve davalarla ilgili hukuki yardımlara ilişkin olup, bu Tarifenin üçüncü kısmına göre belirlenecek avukatlık ücreti bu sıra numaralarında yazılı miktarları geçemez. Ancak icra mahkemelerinde açılan istihkak davalarında, üçüncü kısım gereğince hesaplanacak avukatlık ücretine hükmolunur.",
                    "Borçlu ödeme süresi içerisinde borcunu öderse bu Tarifeye göre belirlenecek ücretin dörtte üçü takdir edilir. Maktu ücreti gerektiren işlerde de bu hüküm uygulanır.",
                    "Tahliyeye ilişkin icra takiplerinde bu Tarifenin ikinci kısmının ikinci bölümünde belirtilen maktu ücrete hükmedilir. Borçlu ödeme süresi içerisinde borcunu öderse bu Tarifeye göre belirlenecek ücretin dörtte üçü takdir edilir.",
                    "İcra dairelerinde borçlu vekili olarak takip edilen işlerde taraflar arasında akdi avukatlık ücreti kararlaştırılmamış veya kararlaştırılan akdi avukatlık ücretinin geçersiz sayıldığı hallerde; çıkabilecek uyuşmazlıkların 1136 sayılı Kanunun 164 üncü maddesinin dördüncü fıkrası uyarınca çözülmesinde avukatlık ücreti, bu Tarifenin ikinci kısım ikinci bölümünde icra dairelerinde yapılan takipler için belirlenen maktu ücrettir. Ancak belirlenen ücret asıl alacağı geçemez."
                ]
            ),
            LawArticle(
                number: "12",
                title: "Tüketici mahkemeleri ve tüketici hakem heyetlerinde ücret",
                paragraphs: [
                    "Tüketici hakem heyetlerinin tüketici lehine verdiği kararlara karşı açılan itiraz davalarında, kararın iptali durumunda tüketici aleyhine, bu Tarifenin üçüncü kısmına göre vekâlet ücretine hükmedilir.",
                    "Ancak, hükmedilen ücret kabul veya reddedilen miktarı geçemez.",
                    "Ancak, mevcut olduğu halde tüketici hakem heyetine sunulmayan bir bilgi veya belgenin tüketici mahkemesine sunulması nedeniyle kararın iptali halinde tüketici aleyhine vekalet ücretine hükmedilemez.",
                    "Tüketici hakem heyetlerinde avukat aracılığı ile takip edilen işlerde, avukat ile müvekkili arasında çıkabilecek uyuşmazlıklarda bu Tarifenin birinci kısım ikinci bölümünün tüketici hakem heyetlerine ilişkin kuralı uygulanır."
                ]
            ),
            LawArticle(
                number: "13",
                title: "Tarifelerin üçüncü kısmına göre ücret",
                paragraphs: [
                    "Bu Tarifenin ikinci kısmının ikinci bölümünde gösterilen hukuki yardımların konusu para veya para ile değerlendirilebiliyor ise avukatlık ücreti, davanın görüldüğü mahkeme için bu Tarifenin ikinci kısmında belirtilen maktu ücretlerin altında kalmamak kaydıyla (7 nci maddenin ikinci fıkrası, 10 uncu maddenin üçüncü fıkrası ile 12 nci maddenin birinci fıkrası, 16 ncı maddenin ikinci fıkrası hükümleri saklı kalmak kaydıyla) bu Tarifenin üçüncü kısmına göre belirlenir.",
                    "Ancak, hükmedilen ücret kabul veya reddedilen miktarı geçemez.",
                    "Maddi tazminat istemli davanın kısmen reddi durumunda, karşı taraf vekili yararına bu Tarifenin üçüncü kısmına göre hükmedilecek ücret, davacı vekili lehine belirlenen ücreti geçemez.",
                    "Maddi tazminat istemli davaların tamamının reddi durumunda avukatlık ücreti, bu Tarifenin ikinci kısmının ikinci bölümüne göre hükmolunur."
                ]
            ),
            LawArticle(
                number: "14",
                title: "Ceza davalarında ücret",
                paragraphs: [
                    "Kamu davasına katılma üzerine, mahkumiyete ya da hükmün açıklanmasının geri bırakılmasına karar verilmiş ise vekil ile temsil edilen katılan lehine bu Tarifenin ikinci kısmının ikinci bölümünde belirlenen avukatlık ücreti sanığa yükletilir. Bu hüküm, katılanın 4/12/2004 tarihli ve 5271 sayılı Ceza Muhakemesi Kanunu gereğince görevlendirilen vekili bulunması durumunda kovuşturma için ödenen ücret mahsup edilerek uygulanır.",
                    "Ceza hükmü taşıyan özel kanun, tüzük ve kararnamelere göre yalnız para cezasına hükmolunan davalarda bu Tarifeye göre belirlenecek avukatlık ücreti hükmolunan para cezası tutarını geçemez.",
                    "4/12/2004 tarihli ve 5271 sayılı Ceza Muhakemesi Kanununun 141 ve devamı maddelerine göre tazminat için Ağır Ceza Mahkemelerine yapılan başvurularda, bu Tarifenin üçüncü kısmı gereğince avukatlık ücretine hükmedilir. Şu kadar ki, hükmedilecek bu ücret bu Tarifenin ikinci kısmının ikinci bölümünün dokuzuncu sırasındaki ücretten az, on üçüncü sırasındaki ücretten fazla olamaz.",
                    "Beraat eden ve vekil veya müdafi ile temsil edilen sanık yararına Hazine aleyhine maktu avukatlık ücretine hükmedilir. Bu hüküm, sanığın 4/12/2004 tarihli ve 5271 sayılı Ceza Muhakemesi Kanunu gereğince görevlendirilen müdafii bulunması durumunda kovuşturma için Hazineden alınan ücretin mahsubu suretiyle uygulanır.",
                    "Sulh ceza hâkimliklerinde görülen tekzip, internet yayın içeriğinden çıkarma, idari para cezalarına itiraz gibi başvuruların reddi, kabulü veya hâkimlik kararına yapılan itiraz üzerine, kararın kaldırılması halinde işin duruşmasız veya duruşmalı oluşuna göre ikinci kısım birinci bölüm 1. sıradaki iş için öngörüldüğü şekilde avukatlık ücretine hükmedilir. Ancak başvuruya konu idari para cezasının miktarı bu Tarifenin ikinci kısım birinci bölüm 1. sıradaki iş için öngörülen maktu ücretin altında ise idari para cezası kadar avukatlık ücretine hükmedilir."
                ]
            ),
            LawArticle(
                number: "15",
                title: "Danıştayda, bölge idare, idare ve vergi mahkemelerinde görülen dava ve işlerde ücret",
                paragraphs: [
                    "Danıştayda ilk derecede veya duruşmalı olarak temyiz yoluyla görülen dava ve işlerde, idari ve vergi dava daireleri kurulları ile dava dairelerinde, bölge idare, idare ve vergi mahkemelerinde birinci savunma dilekçesi süresinin bitimine kadar anlaşmazlığın feragat, kabul, davanın konusuz kalması ya da herhangi bir nedenle ortadan kalkması veya bu nedenlerle davanın reddine karar verilmesi durumunda bu Tarifede yazılı ücretin yarısına, diğer durumlarda tamamına hükmedilir.",
                    "Şu kadar ki, dilekçelerin görevli mercie gönderilmesine veya dilekçenin reddine karar verilmesi durumunda avukatlık ücretine hükmolunmaz."
                ]
            ),
            LawArticle(
                number: "16",
                title: "Arabuluculuk, uzlaşma ve her türlü sulh anlaşmasında ücret",
                paragraphs: [
                    "1136 sayılı Kanunun 35/A maddesinde uzlaşma sağlama, arabuluculuk, uzlaştırma ve her türlü sulh anlaşmalarından doğacak avukatlık ücreti uyuşmazlıklarında bu Tarifede yer alan hükümler uyarınca hesaplanacak miktarlar, akdi avukatlık ücretinin asgari değerlerini oluşturur. 1136 sayılı Kanunun 35/A maddesi kapsamında uzlaşma sağlanması halinde, bu Tarifenin ikinci kısmının ikinci bölümünde davanın görüldüğü mahkemeye göre öngörülen maktu ücretin dörtte bir fazlası olarak belirlenir.",
                    "Ancak, arabuluculuğun dava şartı olması halinde, arabuluculuk aşamasında avukat aracılığı ile takip edilen işlerde aşağıdaki hükümler uygulanır:\na) Konusu para olan veya para ile değerlendirilebilen işlerde avukatlık ücreti; arabuluculuk sonucunda arabuluculuk anlaşma belgesinin imzalanması halinde, bu Tarifenin üçüncü kısmına göre hesaplanan ücretin dörtte bir fazlası olarak belirlenir. Şu kadar ki miktarı 50.000,00 TL'ye kadar olan arabuluculuk faaliyetlerinde avukatlık ücreti, bu maddenin (c) bendinde yer alan maktu ücretin dörtte bir fazlası olarak belirlenir. Ancak, bu ücret asıl alacağı geçemez.\nb) Konusu para olmayan veya para ile değerlendirilemeyen işlerde avukatlık ücreti; arabuluculuk sonucunda arabuluculuk anlaşma belgesinin imzalanması halinde, bu Tarifenin ikinci kısmının ikinci bölümünde davanın görüldüğü mahkemeye göre öngörülen maktu ücretin dörtte bir fazlası olarak belirlenir.\nc) Arabuluculuk faaliyetinin anlaşmazlık ile sonuçlanması halinde, avukat, bu Tarifenin birinci kısım birinci bölüm altıncı sırasında belirlenen ücrete hak kazanır. Ancak, bu ücret asıl alacağı geçemez.\nç) Arabuluculuk faaliyetinin anlaşmazlık ile sonuçlanması halinde, tarafın aynı vekille dava yoluna gitmesi durumunda müvekkilin avukatına ödeyeceği asgari ücret, (c) bendine göre ödediği maktu ücret mahsup edilerek, bu Tarifeye göre belirlenir."
                ]
            ),
            LawArticle(
                number: "17",
                title: "Tahkimde ve Sigorta Tahkim Komisyonunda ücret",
                paragraphs: [
                    "Hakem önünde yapılan her türlü hukuki yardımlarda bu Tarife hükümleri uygulanır.",
                    "Sigorta Tahkim Komisyonları, vekalet ücretine hükmederken, bu Tarifenin ikinci kısmının ikinci bölümünde asliye mahkemeleri için öngörülen ücretin altında kalmamak kaydıyla bu Tarifenin üçüncü kısmına göre avukatlık ücretine hükmeder. Ancak talebi kısmen ya da tamamen reddedilenler aleyhine bu Tarifeye göre hesaplanan ücretin beşte birine hükmedilir. Konusu para ile ölçülemeyen işlerde, bu Tarifenin ikinci kısmının ikinci bölümünde asliye mahkemeleri için öngörülen maktu ücrete hükmedilir. Ancak talebi kısmen ya da tamamen reddedilenler aleyhine öngörülen maktu ücretin beşte birine hükmedilir. Sigorta Tahkim Komisyonlarınca hükmedilen vekalet ücreti, kabul veya reddedilen miktarı geçemez.",
                    "28/1/2012 tarihli ve 28187 sayılı Resmî Gazete'de yayımlanan Spor Genel Müdürlüğü Tahkim Kurulu Yönetmeliğinin 14 üncü maddesinin üçüncü fıkrası uyarınca, Tahkim Kurulu, bu Tarifenin ikinci kısmının ikinci bölümünde idare ve vergi mahkemelerinde görülen davalar için öngörülen avukatlık ücretine hükmeder."
                ]
            ),
            LawArticle(
                number: "18",
                title: "İş takibinde ücret",
                paragraphs: [
                    "Bu Tarifeye göre iş takibi; yargı yetkisinin kullanılması ile ilgisi bulunmayan iş ve işlemlerin yapılabilmesi için, iş sahibi veya temsilci tarafından yerine getirilmesi kanunlara göre zorunlu olan iş ve işlemlerdir.",
                    "Bu Tarifede yazılı iş takibi ücreti bir veya birden çok resmi daire, kurum veya kuruluşça yapılan çeşitli işlemleri içine alsa bile, o işin sonuçlanmasına kadar yapılan bütün hukuki yardımların karşılığıdır."
                ]
            ),
            LawArticle(
                number: "19",
                title: "Dava vekili ve dava takipçileri eliyle takip olunan işlerde ücret",
                paragraphs: [
                    "Dava vekilleri tarafından takip olunan dava ve işlerde de bu Tarife uygulanır.",
                    "Dava takipçileri tarafından takip olunan dava ve işlerde bu Tarifede belirtilen ücretin 1/4'ü uygulanır."
                ]
            ),
            LawArticle(
                number: "20",
                title: "Tarifede yazılı olmayan işlerde ücret",
                paragraphs: [
                    "Bu Tarifede yazılı olmayan hukuki yardımlar için, işin niteliği göz önünde tutularak, bu Tarifedeki benzer işlere göre ücret belirlenir."
                ]
            ),
            LawArticle(
                number: "21",
                title: "Uygulanacak tarife",
                paragraphs: [
                    "Avukatlık ücretinin takdirinde, hukuki yardımın tamamlandığı veya dava sonunda hüküm verildiği tarihte yürürlükte olan Tarife esas alınır."
                ]
            ),
            LawArticle(
                number: "22",
                title: "Seri davalarda ücret",
                paragraphs: [
                    "İhtiyari dava arkadaşlığının bir türü olan seri davalar ister ayrı dava konusu yapılsın ister bir davada birleştirilsin toplamda on dosyaya kadar açılan seri davalarda her bir dosya için ayrı ayrı tam avukatlık ücretine, toplamda elli dosyaya kadar açılan seri davalarda ilk on dosyadan sonra gelen her bir dosya için ayrı ayrı tam ücretin %50'si oranında avukatlık ücretine, toplamda yüz dosyaya kadar açılan seri davalarda ilk elli dosyadan sonra gelen her bir dosya için ayrı ayrı tam ücretin %40'ı oranında avukatlık ücretine, toplamda yüzden fazla açılan seri davalarda ilk yüz dosyadan sonra gelen her bir dosya için ayrı ayrı tam ücretin %25'i oranında avukatlık ücretine hükmedilir. Duruşmalı işlerde bu şekilde avukatlık ücretine hükmedilmesi için dosyaya ilişkin tüm duruşmaların aynı gün aynı mahkemede yapılması gerekir."
                ]
            ),
            LawArticle(
                number: "23",
                title: "Kötü niyetli veya haksız dava açılmasında ücret",
                paragraphs: [
                    "Kötü niyetli davalı veya hiçbir hakkı olmadığı hâlde dava açan taraf, yargılama giderlerinden başka, diğer tarafın vekiliyle aralarında kararlaştırılan vekâlet ücretinin tamamı veya bir kısmını ödemeye mahkûm edilebilir. Vekâlet ücretinin miktarı hakkında uyuşmazlık çıkması veya mahkemece miktarının fahiş bulunması hâlinde, bu miktar doğrudan mahkemece 1136 sayılı Kanun ve bu Tarife esas alınarak takdir olunur."
                ]
            ),
            LawArticle(
                number: "24",
                title: "Yürürlük",
                paragraphs: [
                    "Bu Tarife yayımı tarihinde yürürlüğe girer."
                ]
            )
        ],
        tableSections: [
            // BİRİNCİ KISIM – BİRİNCİ BÖLÜM
            AttorneyFeeTableSection(
                partTitle: "BİRİNCİ KISIM – BİRİNCİ BÖLÜM",
                subtitle: "Dava ve Takiplerin Dışındaki Hukuki Yardımlarda Ödenecek Ücret",
                items: [
                    AttorneyFeeItem(number: "1", description: "Büroda sözlü danışma (ilk bir saate kadar)", amount: "4.000,00 TL"),
                    AttorneyFeeItem(number: "", description: "Takip eden her saat için", amount: "1.800,00 TL"),
                    AttorneyFeeItem(number: "2", description: "Çağrı üzerine gidilen yerde sözlü danışma (ilk bir saate kadar)", amount: "7.000,00 TL"),
                    AttorneyFeeItem(number: "", description: "Takip eden her saat için", amount: "3.500,00 TL"),
                    AttorneyFeeItem(number: "3", description: "Yazılı danışma için (ilk bir saate kadar)", amount: "7.000,00 TL"),
                    AttorneyFeeItem(number: "", description: "Takip eden her saat için", amount: "3.500,00 TL"),
                    AttorneyFeeItem(number: "4", description: "Her türlü dilekçe yazılması, ihbarname, ihtarname, protesto düzenlenmesinde", amount: "6.000,00 TL"),
                    AttorneyFeeItem(number: "5a", description: "Sözleşmeler – Kira sözleşmesi ve benzeri", amount: "8.000,00 TL"),
                    AttorneyFeeItem(number: "5b", description: "Sözleşmeler – Tüzük, yönetmelik, miras sözleşmesi, vasiyetname, vakıf senedi ve benzeri belgelerin hazırlanması", amount: "32.000,00 TL"),
                    AttorneyFeeItem(number: "5c", description: "Sözleşmeler – Şirket ana sözleşmesi, şirketlerin devir ve birleşmesi vb. ticari işlerle ilgili sözleşmeler", amount: "21.000,00 TL"),
                    AttorneyFeeItem(number: "6", description: "Arabuluculuk faaliyetinin anlaşmazlık ile sonuçlanması halinde, taraf vekilleri için", amount: "8.000,00 TL")
                ],
                footnote: nil
            ),
            // BİRİNCİ KISIM – İKİNCİ BÖLÜM
            AttorneyFeeTableSection(
                partTitle: "BİRİNCİ KISIM – İKİNCİ BÖLÜM",
                subtitle: "İş Takibi Konusundaki Hukuki Yardımlarda Ödenecek Ücret",
                items: [
                    AttorneyFeeItem(number: "1", description: "Bir durumun belgelendirilmesi, ödeme aşamasındaki paranın tahsili veya bir belgenin örneğinin çıkarılması gibi işlerin takibi için", amount: "6.000,00 TL"),
                    AttorneyFeeItem(number: "2a", description: "Bir hakkın doğumu, tespiti, tescili, nakli, değiştirilmesi, sona erdirilmesi veya korunması gibi amaçlarla yapılan işler için", amount: "12.000,00 TL"),
                    AttorneyFeeItem(number: "2b", description: "İpotek tesisi ve fekki gibi işlemler de dahil olmak üzere bir hakkın doğumu ve sona erdirilmesi olarak nitelenen işlemler nedeni ile sürekli sözleşme ile çalışılan bankalar, finans kuruluşları ve benzerlerine verilen her bir hukuki yardım için", amount: "3.000,00 TL"),
                    AttorneyFeeItem(number: "3", description: "Tüzel kişi tacirlerin şirket kuruluş sözleşmelerinin imzalanması, bu tacirlerin çalışma konuları ile ilgili ruhsat ve imtiyazların alınması, devri ve Türk vatandaşlığına kabul edilme gibi işlerin takibi için", amount: "60.000,00 TL"),
                    AttorneyFeeItem(number: "4", description: "Vergi komisyonlarında takip edilen işler için", amount: "24.000,00 TL"),
                    AttorneyFeeItem(number: "5a", description: "Uluslararası yargı yerlerinde takip edilen işlerde – Duruşmasız ise", amount: "110.000,00 TL"),
                    AttorneyFeeItem(number: "5b", description: "Uluslararası yargı yerlerinde takip edilen işlerde – Duruşmalı ise", amount: "200.000,00 TL"),
                    AttorneyFeeItem(number: "5c", description: "Uluslararası yargı yerlerinde – Konusu para olan işlerde", amount: "Tarifenin üçüncü kısmına göre belirlenir"),
                    AttorneyFeeItem(number: "6", description: "6502 sayılı Kanunun 70. maddesi kapsamında tüketici hakem heyetleri, hal hakem heyetleri nezdindeki hukuki yardımlar (3. kısım esas; hesaplanan ücret maktu ücretin altında ise)", amount: "7.000,00 TL")
                ],
                footnote: nil
            ),
            // BİRİNCİ KISIM – ÜÇÜNCÜ BÖLÜM
            AttorneyFeeTableSection(
                partTitle: "BİRİNCİ KISIM – ÜÇÜNCÜ BÖLÜM",
                subtitle: "1136 Sayılı Kanunun 35 inci Maddesi Gereğince Bulundurulması Zorunlu Sözleşmeli Avukatlara Aylık Ödenecek Ücret",
                items: [
                    AttorneyFeeItem(number: "1", description: "Yapı kooperatiflerinde", amount: "27.000,00 TL"),
                    AttorneyFeeItem(number: "2", description: "Anonim şirketlerde", amount: "45.000,00 TL")
                ],
                footnote: "Takip edilen dava, takip ve işlerde tarifeye göre hesaplanacak avukatlık ücreti yıllık avukatlık ücretinin üzerinde olduğu takdirde aradaki eksik miktar avukata ayrıca ödenir."
            ),
            // BİRİNCİ KISIM – DÖRDÜNCÜ BÖLÜM
            AttorneyFeeTableSection(
                partTitle: "BİRİNCİ KISIM – DÖRDÜNCÜ BÖLÜM",
                subtitle: "Sözleşmeli Avukatlara Ödeyecekleri Aylık Avukatlık Ücreti",
                items: [
                    AttorneyFeeItem(number: "1", description: "Özel Kişi ve Tüzel Kişilerin Sözleşmeli Avukatlarına Ödeyecekleri Aylık Avukatlık Ücreti", amount: "33.000,00 TL"),
                    AttorneyFeeItem(number: "2", description: "Kamu Kurum ve Kuruluşlarının Sözleşmeli Avukatlarına Ödeyecekleri Aylık Avukatlık Ücreti", amount: "33.000,00 TL")
                ],
                footnote: "Takip edilen dava, takip ve işlerde tarifeye göre hesaplanacak avukatlık ücreti yıllık avukatlık ücretinin üzerinde olduğu takdirde aradaki eksik miktar avukata ayrıca ödenir."
            ),
            // İKİNCİ KISIM – BİRİNCİ BÖLÜM
            AttorneyFeeTableSection(
                partTitle: "İKİNCİ KISIM – BİRİNCİ BÖLÜM",
                subtitle: "Yargı Yerlerinde, İcra ve İflas Dairelerinde Yapılan ve Konusu Para Olsa veya Para ile Değerlendirilebilse Bile Maktu Ücrete Bağlı Hukuki Yardımlara Ödenecek Ücret",
                items: [
                    AttorneyFeeItem(number: "1a", description: "İhtiyati haciz, ihtiyati tedbir, delillerin tespiti, icranın geri bırakılması, ödeme ve tevdi yeri belirlenmesi işleri – Duruşmasız ise", amount: "10.000,00 TL"),
                    AttorneyFeeItem(number: "1b", description: "İhtiyati haciz, ihtiyati tedbir, delillerin tespiti, icranın geri bırakılması, ödeme ve tevdi yeri belirlenmesi işleri – Duruşmalı ise", amount: "12.500,00 TL"),
                    AttorneyFeeItem(number: "2", description: "Ortaklığın giderilmesi için satış memurluğunda yapılacak işlerin takibi için", amount: "18.000,00 TL"),
                    AttorneyFeeItem(number: "3", description: "Ortaklığın giderilmesi ve taksim davaları için", amount: "40.000,00 TL"),
                    AttorneyFeeItem(number: "4a", description: "Vergi Mahkemelerinde takip edilen dava ve işler – Duruşmasız ise", amount: "30.000,00 TL"),
                    AttorneyFeeItem(number: "4b", description: "Vergi Mahkemelerinde takip edilen dava ve işler – Duruşmalı ise", amount: "40.000,00 TL"),
                    AttorneyFeeItem(number: "5", description: "Tüketici Mahkemelerinde görülen kredi taksitlerinin veya faizinin uyarlanması davaları için", amount: "20.000,00 TL")
                ],
                footnote: nil
            ),
            // İKİNCİ KISIM – İKİNCİ BÖLÜM
            AttorneyFeeTableSection(
                partTitle: "İKİNCİ KISIM – İKİNCİ BÖLÜM",
                subtitle: "Yargı Yerleri ile İcra ve İflas Dairelerinde Yapılan ve Konusu Para Olmayan veya Para ile Değerlendirilemeyen Hukuki Yardımlara Ödenecek Ücret",
                items: [
                    AttorneyFeeItem(number: "1", description: "İcra Dairelerinde yapılan takipler için", amount: "9.000,00 TL"),
                    AttorneyFeeItem(number: "2", description: "İcra Mahkemelerinde takip edilen işler için", amount: "11.000,00 TL"),
                    AttorneyFeeItem(number: "3", description: "İcra Mahkemelerinde takip edilen dava ve duruşmalı işler için", amount: "18.000,00 TL"),
                    AttorneyFeeItem(number: "4", description: "Tahliyeye ilişkin icra takipleri için", amount: "20.000,00 TL"),
                    AttorneyFeeItem(number: "5", description: "İcra Mahkemelerinde takip edilen ceza işleri için", amount: "15.000,00 TL"),
                    AttorneyFeeItem(number: "6", description: "Çocuk teslimi ve çocukla kişisel ilişki kurulmasına dair ilam ve tedbir kararlarının yerine getirilmesine muhalefetten kaynaklanan işler", amount: "16.000,00 TL"),
                    AttorneyFeeItem(number: "7", description: "Ceza soruşturma evresinde takip edilen işler için", amount: "11.000,00 TL"),
                    AttorneyFeeItem(number: "8", description: "Sulh Hukuk Mahkemelerinde takip edilen davalar için", amount: "30.000,00 TL"),
                    AttorneyFeeItem(number: "9", description: "Sulh Ceza Hâkimlikleri ve İnfaz Hâkimliklerinde takip edilen davalar için", amount: "18.000,00 TL"),
                    AttorneyFeeItem(number: "10", description: "Asliye Mahkemelerinde takip edilen davalar için", amount: "45.000,00 TL"),
                    AttorneyFeeItem(number: "11", description: "Tüketici Mahkemelerinde takip edilen davalar için", amount: "22.500,00 TL"),
                    AttorneyFeeItem(number: "12", description: "Fikri ve Sınai Haklar Mahkemelerinde takip edilen davalar için", amount: "55.000,00 TL"),
                    AttorneyFeeItem(number: "13", description: "Ağır Ceza Mahkemelerinde takip edilen davalar için", amount: "65.000,00 TL"),
                    AttorneyFeeItem(number: "14", description: "Çocuk Mahkemelerinde takip edilen davalar için", amount: "45.000,00 TL"),
                    AttorneyFeeItem(number: "15", description: "Çocuk Ağır Ceza Mahkemelerinde takip edilen davalar için", amount: "65.000,00 TL"),
                    AttorneyFeeItem(number: "16", description: "Askerlik Kanunu uyarınca Disiplin Kurullarında takip edilen davalar için", amount: "27.000,00 TL"),
                    AttorneyFeeItem(number: "17a", description: "İdare ve Vergi Mahkemelerinde takip edilen davalar – Duruşmasız ise", amount: "30.000,00 TL"),
                    AttorneyFeeItem(number: "17b", description: "İdare ve Vergi Mahkemelerinde takip edilen davalar – Duruşmalı ise", amount: "40.000,00 TL"),
                    AttorneyFeeItem(number: "18a", description: "Bölge Adliye / İdare Mahkemeleri – İlk derecede görülen davalar için", amount: "35.000,00 TL"),
                    AttorneyFeeItem(number: "18b", description: "Bölge Adliye / İdare Mahkemeleri – İstinaf yolu ile görülen bir duruşması olan işler için", amount: "22.000,00 TL"),
                    AttorneyFeeItem(number: "18c", description: "Bölge Adliye / İdare Mahkemeleri – İstinaf yolu ile görülen birden fazla duruşması veya keşif gerektiren işler için", amount: "42.000,00 TL"),
                    AttorneyFeeItem(number: "19a", description: "Sayıştay'da görülen hesap yargılamaları – Duruşmasız ise", amount: "34.000,00 TL"),
                    AttorneyFeeItem(number: "19b", description: "Sayıştay'da görülen hesap yargılamaları – Duruşmalı ise", amount: "65.000,00 TL"),
                    AttorneyFeeItem(number: "20", description: "Yargıtay'da ilk derecede görülen davalar için", amount: "65.000,00 TL"),
                    AttorneyFeeItem(number: "21a", description: "Danıştay'da ilk derecede görülen davalar – Duruşmasız ise", amount: "40.000,00 TL"),
                    AttorneyFeeItem(number: "21b", description: "Danıştay'da ilk derecede görülen davalar – Duruşmalı ise", amount: "65.000,00 TL"),
                    AttorneyFeeItem(number: "22", description: "Yargıtay, Danıştay ve Sayıştay'da temyiz yolu ile görülen işlerin duruşması için", amount: "40.000,00 TL"),
                    AttorneyFeeItem(number: "23", description: "Uyuşmazlık Mahkemesindeki davalar için", amount: "40.000,00 TL"),
                    AttorneyFeeItem(number: "24a", description: "Anayasa Mahkemesi – Yüce Divan sıfatı ile bakılan davalar", amount: "120.000,00 TL"),
                    AttorneyFeeItem(number: "24b1", description: "Anayasa Mahkemesi – Bireysel başvuru, duruşmasız işlerde", amount: "40.000,00 TL"),
                    AttorneyFeeItem(number: "24b2", description: "Anayasa Mahkemesi – Bireysel başvuru, duruşmalı işlerde", amount: "80.000,00 TL"),
                    AttorneyFeeItem(number: "24c", description: "Anayasa Mahkemesi – Diğer dava ve işler", amount: "90.000,00 TL")
                ],
                footnote: nil
            )
        ],
        part3Title: "ÜÇÜNCÜ KISIM",
        part3Subtitle: "Yargı Yerleri ile İcra ve İflas Dairelerinde Yapılan ve Konusu Para Olan veya Para ile Değerlendirilebilen Hukuki Yardımlara Ödenecek Ücret",
        part3Brackets: [
            AttorneyFeeBracket(number: 1, description: "İlk 600.000,00 TL için", rate: "%16"),
            AttorneyFeeBracket(number: 2, description: "Sonra gelen 600.000,00 TL için", rate: "%15"),
            AttorneyFeeBracket(number: 3, description: "Sonra gelen 1.200.000,00 TL için", rate: "%14"),
            AttorneyFeeBracket(number: 4, description: "Sonra gelen 1.200.000,00 TL için", rate: "%13"),
            AttorneyFeeBracket(number: 5, description: "Sonra gelen 1.800.000,00 TL için", rate: "%11"),
            AttorneyFeeBracket(number: 6, description: "Sonra gelen 2.400.000,00 TL için", rate: "%8"),
            AttorneyFeeBracket(number: 7, description: "Sonra gelen 3.000.000,00 TL için", rate: "%5"),
            AttorneyFeeBracket(number: 8, description: "Sonra gelen 3.600.000,00 TL için", rate: "%3"),
            AttorneyFeeBracket(number: 9, description: "Sonra gelen 4.200.000,00 TL için", rate: "%2"),
            AttorneyFeeBracket(number: 10, description: "18.600.000,00 TL'dan yukarısı için", rate: "%1")
        ]
    )
    // swiftlint:enable function_body_length
}
