//
//  TariffDocumentContent.swift
//  Denklem
//
//  Created by ozkan on 17.02.2026.
//

import Foundation

// MARK: - Tariff Document Content Models

/// Represents a single article (madde) in the tariff document
struct TariffArticle {
    let number: Int
    let title: String
    let paragraphs: [String]
}

/// Represents a party count tier row in the first part table
struct TariffPartyTier {
    let label: String       // e.g., "2 kişi taraf başına"
    let amount: String      // e.g., "785,00 TL"
}

/// Represents a dispute category in the first part table
struct TariffFirstPartCategory {
    let number: Int
    let title: String
    let tiers: [TariffPartyTier]
}

/// Represents a bracket row in the second part table
struct TariffSecondPartBracket {
    let number: Int
    let description: String    // e.g., "İlk 300.000,00 TL'si için"
    let singleRate: String     // e.g., "% 6"
    let multipleRate: String   // e.g., "% 9"
}

/// Complete tariff document content for a specific year
struct TariffDocumentContent {
    let year: Int
    let gazetteInfo: String
    let effectiveDate: String
    let articles: [TariffArticle]
    let firstPartTitle: String
    let firstPartCategories: [TariffFirstPartCategory]
    let secondPartTitle: String
    let secondPartBrackets: [TariffSecondPartBracket]
}

// MARK: - Factory

extension TariffDocumentContent {

    /// Returns tariff document content for the given year
    static func content(for year: Int) -> TariffDocumentContent? {
        switch year {
        case 2025: return Self.content2025
        case 2026: return Self.content2026
        default: return nil
        }
    }

    /// Converts the entire tariff content to a plain text string for sharing
    func toPlainText() -> String {
        var text = ""

        // Title
        text += "\(year) Yılı Arabuluculuk Asgari Ücret Tarifesi\n"
        text += "\(gazetteInfo)\n"
        text += "Yürürlük Tarihi: \(effectiveDate)\n"
        text += "\n"

        // Articles
        for article in articles {
            text += "MADDE \(article.number) – \(article.title)\n\n"
            for (index, paragraph) in article.paragraphs.enumerated() {
                text += "(\(index + 1)) \(paragraph)\n\n"
            }
        }

        // First Part
        text += "EK: Arabuluculuk Ücret Tarifesi\n\n"
        text += "\(firstPartTitle)\n\n"

        for category in firstPartCategories {
            text += "\(category.number). \(category.title)\n"
            for tier in category.tiers {
                text += "  • \(tier.label): \(tier.amount)\n"
            }
            text += "\n"
        }

        // Second Part
        text += "\(secondPartTitle)\n\n"

        for bracket in secondPartBrackets {
            text += "\(bracket.number). \(bracket.description)\n"
            text += "   Bir arabulucu: \(bracket.singleRate) | Birden fazla: \(bracket.multipleRate)\n"
        }

        return text
    }
}

// MARK: - Shared Party Tier Labels

private enum PartyTierLabels {
    static let twoPerson = "Bir saati; 2 kişinin taraf olması durumunda, taraf başına"
    static let threeToFive = "Bir saati; 3-5 kişinin taraf olması durumunda, taraf sayısı gözetmeksizin"
    static let sixToTen = "Bir saati; 6-10 kişinin taraf olması durumunda, taraf sayısı gözetmeksizin"
    static let elevenPlus = "Bir saati; 11 ve daha fazla kişinin taraf olması durumunda, taraf sayısı gözetmeksizin"
}

// MARK: - 2025 Content

extension TariffDocumentContent {

    // swiftlint:disable function_body_length
    static let content2025 = TariffDocumentContent(
        year: 2025,
        gazetteInfo: "Resmî Gazete: 25 Aralık 2024, Sayı: 32763",
        effectiveDate: "1 Ocak 2025",
        articles: [
            TariffArticle(
                number: 1,
                title: "Amaç, Konu ve Kapsam",
                paragraphs: [
                    "Özel hukuk uyuşmazlıklarının arabuluculuk yoluyla çözümlenmesinde, arabulucu ile uyuşmazlığın tarafları arasında geçerli bir ücret sözleşmesi yapılmamış olan veya ücret miktarı konusunda arabulucu ile taraflar arasında ihtilaf bulunan durumlarda, 7/6/2012 tarihli ve 6325 sayılı Hukuk Uyuşmazlıklarında Arabuluculuk Kanunu, 2/6/2018 tarihli ve 30439 sayılı Resmî Gazete'de yayımlanan Hukuk Uyuşmazlıklarında Arabuluculuk Kanunu Yönetmeliği ve bu Tarife hükümleri uygulanır.",
                    "Bu Tarifede belirlenen ücretlerin altında arabuluculuk ücreti kararlaştırılamaz. Aksine yapılan sözleşmelerin ücrete ilişkin hükümleri geçersiz olup, ücrete ilişkin olarak bu Tarife hükümleri uygulanır."
                ]
            ),
            TariffArticle(
                number: 2,
                title: "Arabuluculuk Ücretinin Kapsadığı İşler",
                paragraphs: [
                    "Bu Tarifede yazılı arabuluculuk ücreti, uyuşmazlığın arabuluculuk yoluyla çözüme kavuşturulmasını sağlamak amacıyla, arabuluculuk faaliyetini yürüten arabulucular siciline kayıtlı kişiye, sarf ettiği emek ve mesainin karşılığında, uyuşmazlığın taraflarınca yapılan parasal ödemenin karşılığıdır.",
                    "Arabuluculuk faaliyeti süresince arabulucu tarafından düzenlenen evrak ve yapılan diğer işlemler ayrı ücreti gerektirmez.",
                    "Arabulucu, ihtiyari arabuluculuk süreci başlamadan önce arabuluculuk teklifinde bulunan taraf veya taraflardan ücret ve masraf isteyebilir. Bu fıkra uyarınca alınan ücret arabuluculuk süreci sonunda arabuluculuk ücretinden mahsup edilir. Arabuluculuk sürecinin başlamaması hâlinde bu ücret iade edilmez. Masraftan kullanılmayan kısım arabuluculuk süreci sonunda iade edilir.",
                    "Arabulucu, dava şartı arabuluculuk sürecinde taraflardan masraf isteyemez.",
                    "Arabulucu, arabuluculuk sürecine ilişkin olarak belirli kişiler için aracılık yapma veya belirli kişileri tavsiye etmenin karşılığı olarak herhangi bir ücret talep edemez. Bu yasağa aykırı olarak tesis edilen işlemler hükümsüzdür."
                ]
            ),
            TariffArticle(
                number: 3,
                title: "Arabuluculuk Ücretinin Sınırları",
                paragraphs: [
                    "Aksi kararlaştırılmadıkça arabuluculuk ücreti taraflarca eşit ödenir.",
                    "Aynı uyuşmazlığın çözümüne ilişkin bu Tarifenin eki Arabuluculuk Ücret Tarifesinin birinci kısmında belirtilen hallerde arabuluculuk faaliyetinin birden çok arabulucu tarafından yürütülmesi durumunda, her bir arabulucuya bu Tarifede belirtilen ücret ayrı ayrı ödenir.",
                    "Aynı uyuşmazlığın çözümüne ilişkin bu Tarifenin eki Arabuluculuk Ücret Tarifesinin ikinci kısmında belirtilen hallerde arabuluculuk faaliyetinin birden çok arabulucu tarafından yürütülmesi durumunda, bu Tarifede birden fazla arabulucu için belirtilen orandaki ücret her bir arabulucuya eşit bölünerek ödenir."
                ]
            ),
            TariffArticle(
                number: 4,
                title: "Ücretin Tümünü Hak Etme",
                paragraphs: [
                    "Arabuluculuk faaliyetinin, gerek tarafların uyuşmazlık konusu üzerinde anlaşmaya varmış olması, gerek taraflara danışıldıktan sonra arabuluculuk için daha fazla çaba sarf edilmesinin gereksiz olduğunun arabulucu tarafından tespit edilmesi, gerekse taraflardan birinin karşı tarafa veya arabulucuya, arabuluculuk faaliyetinden çekildiğini bildirmesi veya taraflardan birinin ölümü ya da iflası halinde veya tarafların anlaşarak arabuluculuk faaliyetini sona erdirmesi sebepleriyle sona ermesi hallerinde, arabuluculuk faaliyetini yürütme görevini kabul eden arabulucu, bu Tarife hükümleri ile belirlenen ücretin tamamına hak kazanır.",
                    "Arabuluculuk faaliyetine başlandıktan sonra, uyuşmazlığın arabuluculuğa elverişli olmadığı hususu ortaya çıkar ve bu sebeple arabuluculuk faaliyeti sona erdirilir ise, sonradan ortaya çıkan bu durumla ilgili olarak eğer arabulucunun herhangi bir kusuru yoksa arabuluculuk faaliyetini yürütme görevini kabul eden arabulucu, bu Tarife hükümleri ile belirlenen ücretin tamamına hak kazanır."
                ]
            ),
            TariffArticle(
                number: 5,
                title: "Arabuluculuk Faaliyetinin Konusuz Kalması, Feragat, Kabul ve Sulhte Ücret",
                paragraphs: [
                    "İhtiyari arabuluculuk sürecinde uyuşmazlık, arabuluculuk faaliyeti devam ederken, arabuluculuk faaliyetinin konusuz kalması, feragat, kabul veya sulh gibi arabuluculuk yolu dışındaki yöntem ve nedenlerle giderilirse ücretin tamamına hak kazanılır.",
                    "Dava şartı arabuluculuk sürecinde; sehven kayıt, mükerrer kayıt veya arabuluculuğa elverişli olmama nedeniyle sona erdirilmesi hallerinde arabulucuya ücret ödenmez."
                ]
            ),
            TariffArticle(
                number: 6,
                title: "Yeni Bir Uyuşmazlık Konusunun Ortaya Çıkmasında Ücret",
                paragraphs: [
                    "Somut bir uyuşmazlıkla ilgili arabuluculuk faaliyetinin yürütülmesi sırasında, yeni uyuşmazlık konularının ortaya çıkması halinde, her bir uyuşmazlık için ayrı ücrete hak kazanılır. Ancak dava şartı kapsamında yapılan arabuluculuk başvurularında anlaşmama durumunda bu hüküm uygulanmaz."
                ]
            ),
            TariffArticle(
                number: 7,
                title: "Arabuluculuk Ücret Tarifesine Göre Ücret",
                paragraphs: [
                    "Konusu para olmayan veya para ile değerlendirilemeyen hukuki uyuşmazlıklarda; arabuluculuk ücreti bu Tarifenin eki Arabuluculuk Ücret Tarifesinin birinci kısmına göre belirlenir.",
                    "Konusu para olan veya para ile değerlendirilebilen hukuki uyuşmazlıklarda; arabuluculuk ücreti bu Tarifenin eki Arabuluculuk Ücret Tarifesinin ikinci kısmına göre belirlenir.",
                    "Arabuluculuk sürecinin sonunda anlaşma sağlanamaması halinde, arabuluculuğun konusu para olan veya para ile değerlendirilebilen hukuki uyuşmazlık olsa bile arabulucu, arabuluculuk ücretini bu Tarifenin eki Arabuluculuk Ücret Tarifesinin birinci kısmına göre isteyebilir.",
                    "Arabuluculuk sürecinin sonunda seri uyuşmazlıklarda anlaşma sağlanması halinde, arabuluculuğun konusu para olan veya para ile değerlendirilebilen hukuki uyuşmazlık olsa bile arabulucu, her bir uyuşmazlık bakımından, ticari uyuşmazlıklarda 5.000,00 TL diğer uyuşmazlıklarda ise 4.000,00 TL ücret isteyebilir. Taraflardan birinin aynı olduğu ve bir ay içinde başvurulan en az on uyuşmazlık seri uyuşmazlık olarak kabul edilir.",
                    "Arabuluculuk sürecinin sonunda anlaşma sağlanması halinde, kira tespiti ve tahliye talepli uyuşmazlıklarda ücret; tahliye talepli uyuşmazlıklarda bir yıllık kira bedeli tutarının yarısı, kira tespiti uyuşmazlıklarında tespit olunan kira bedeli farkının bir yıllık tutarı üzerinden bu Tarifenin ikinci kısmına göre belirlenir.",
                    "Ortaklığın giderilmesine ilişkin uyuşmazlıklar ile ticari uyuşmazlıklarda, arabuluculuk sürecinin sonunda anlaşma sağlanması halinde, arabuluculuk ücreti bu Tarifenin ikinci kısmına göre belirlenir. Ancak bu ücret 9.000,00 TL'den az olamaz.",
                    "Arabuluculuk sürecinin sonunda anlaşma sağlanması halinde, anlaşma bedeline bakılmaksızın arabuluculuk ücreti 6.000,00 TL'den az olamaz."
                ]
            ),
            TariffArticle(
                number: 8,
                title: "Arabuluculuk Ücret Tarifesinde Yazılı Olmayan Hallerde Ücret",
                paragraphs: [
                    "Arabuluculuk Ücret Tarifesinde yazılı olmayan haller için, söz konusu Tarifenin birinci kısmındaki diğer tür uyuşmazlıklar için belirlenen ücret ödenir."
                ]
            ),
            TariffArticle(
                number: 9,
                title: "Uyuşmazlığın Arabuluculuk-Tahkim Yoluyla Çözülmesinin Önerilmesinde Ücret",
                paragraphs: [
                    "Arabuluculuk sürecinin sonunda anlaşma sağlanamaması halinde, anlaşamama son tutanağının düzenlenmesinden sonra, Arabulucu, tarafları arabuluculuk-tahkim yoluna devam etmeleri konusunda; arabuluculuk-tahkimin esasları, süreci ve hukuki sonuçları hakkında aydınlatıp, arabuluculuk-tahkim yoluyla uyuşmazlığın çözülmesinin sosyal, ekonomik ve psikolojik açıdan faydalarının olabileceğini hatırlatarak teşvik edebilir. Bu teşvik üzerine tarafların, arabuluculuk-tahkim yoluna devam etmeyi ve bir tahkim merkezinin arabuluculuk-tahkim kurallarını veya tahkim kurallarını uygulamayı kabul etmeleri halinde, ilgili tahkim merkezi tarafından arabulucuya, bilgilendirme ücreti ödenir."
                ]
            ),
            TariffArticle(
                number: 10,
                title: "Uygulanacak Tarife",
                paragraphs: [
                    "Arabuluculuk ücretinin takdirinde, arabuluculuk faaliyetinin sona erdiği tarihte yürürlükte olan tarife esas alınır."
                ]
            ),
            TariffArticle(
                number: 11,
                title: "Yürürlük",
                paragraphs: [
                    "Bu Tarife 1/1/2025 tarihinde yürürlüğe girer."
                ]
            )
        ],
        firstPartTitle: "Birinci Kısım – Konusu Para Olmayan veya Para ile Değerlendirilemeyen Hukuki Uyuşmazlıklar",
        firstPartCategories: [
            TariffFirstPartCategory(
                number: 1,
                title: "Aile Hukuku ile ilgili uyuşmazlıklar",
                tiers: [
                    TariffPartyTier(label: PartyTierLabels.twoPerson, amount: "785,00 TL"),
                    TariffPartyTier(label: PartyTierLabels.threeToFive, amount: "1.650,00 TL"),
                    TariffPartyTier(label: PartyTierLabels.sixToTen, amount: "1.750,00 TL"),
                    TariffPartyTier(label: PartyTierLabels.elevenPlus, amount: "1.850,00 TL")
                ]
            ),
            TariffFirstPartCategory(
                number: 2,
                title: "Ticari uyuşmazlıklar",
                tiers: [
                    TariffPartyTier(label: PartyTierLabels.twoPerson, amount: "1.150,00 TL"),
                    TariffPartyTier(label: PartyTierLabels.threeToFive, amount: "2.350,00 TL"),
                    TariffPartyTier(label: PartyTierLabels.sixToTen, amount: "2.450,00 TL"),
                    TariffPartyTier(label: PartyTierLabels.elevenPlus, amount: "2.550,00 TL")
                ]
            ),
            TariffFirstPartCategory(
                number: 3,
                title: "İşçi - İşveren uyuşmazlıkları",
                tiers: [
                    TariffPartyTier(label: PartyTierLabels.twoPerson, amount: "785,00 TL"),
                    TariffPartyTier(label: PartyTierLabels.threeToFive, amount: "1.650,00 TL"),
                    TariffPartyTier(label: PartyTierLabels.sixToTen, amount: "1.750,00 TL"),
                    TariffPartyTier(label: PartyTierLabels.elevenPlus, amount: "1.850,00 TL")
                ]
            ),
            TariffFirstPartCategory(
                number: 4,
                title: "Tüketici uyuşmazlıkları",
                tiers: [
                    TariffPartyTier(label: PartyTierLabels.twoPerson, amount: "785,00 TL"),
                    TariffPartyTier(label: PartyTierLabels.threeToFive, amount: "1.650,00 TL"),
                    TariffPartyTier(label: PartyTierLabels.sixToTen, amount: "1.750,00 TL"),
                    TariffPartyTier(label: PartyTierLabels.elevenPlus, amount: "1.850,00 TL")
                ]
            ),
            TariffFirstPartCategory(
                number: 5,
                title: "Kira, Komşu Hakkı ve Kat Mülkiyeti uyuşmazlıkları",
                tiers: [
                    TariffPartyTier(label: PartyTierLabels.twoPerson, amount: "835,00 TL"),
                    TariffPartyTier(label: PartyTierLabels.threeToFive, amount: "1.750,00 TL"),
                    TariffPartyTier(label: PartyTierLabels.sixToTen, amount: "1.850,00 TL"),
                    TariffPartyTier(label: PartyTierLabels.elevenPlus, amount: "1.950,00 TL")
                ]
            ),
            TariffFirstPartCategory(
                number: 6,
                title: "Ortaklığın Giderilmesi uyuşmazlıkları",
                tiers: [
                    TariffPartyTier(label: PartyTierLabels.twoPerson, amount: "900,00 TL"),
                    TariffPartyTier(label: PartyTierLabels.threeToFive, amount: "2.000,00 TL"),
                    TariffPartyTier(label: PartyTierLabels.sixToTen, amount: "2.100,00 TL"),
                    TariffPartyTier(label: PartyTierLabels.elevenPlus, amount: "2.200,00 TL")
                ]
            ),
            TariffFirstPartCategory(
                number: 7,
                title: "Diğer tür uyuşmazlıklar",
                tiers: [
                    TariffPartyTier(label: PartyTierLabels.twoPerson, amount: "785,00 TL"),
                    TariffPartyTier(label: PartyTierLabels.threeToFive, amount: "1.650,00 TL"),
                    TariffPartyTier(label: PartyTierLabels.sixToTen, amount: "1.750,00 TL"),
                    TariffPartyTier(label: PartyTierLabels.elevenPlus, amount: "1.850,00 TL")
                ]
            )
        ],
        secondPartTitle: "İkinci Kısım – Konusu Para Olan veya Para ile Değerlendirilebilen Hukuki Uyuşmazlıklar",
        secondPartBrackets: [
            TariffSecondPartBracket(number: 1, description: "İlk 300.000,00 TL'si için", singleRate: "% 6", multipleRate: "% 9"),
            TariffSecondPartBracket(number: 2, description: "Sonra gelen 480.000,00 TL'si için", singleRate: "% 5", multipleRate: "% 7,5"),
            TariffSecondPartBracket(number: 3, description: "Sonra gelen 780.000,00 TL'si için", singleRate: "% 4", multipleRate: "% 6"),
            TariffSecondPartBracket(number: 4, description: "Sonra gelen 1.560.000,00 TL'si için", singleRate: "% 3", multipleRate: "% 4,5"),
            TariffSecondPartBracket(number: 5, description: "Sonra gelen 4.680.000,00 TL'si için", singleRate: "% 2", multipleRate: "% 3"),
            TariffSecondPartBracket(number: 6, description: "Sonra gelen 6.240.000,00 TL'si için", singleRate: "% 1,5", multipleRate: "% 2,5"),
            TariffSecondPartBracket(number: 7, description: "Sonra gelen 12.480.000,00 TL'si için", singleRate: "% 1", multipleRate: "% 1,5"),
            TariffSecondPartBracket(number: 8, description: "26.520.000,00 TL'den yukarısı için", singleRate: "% 0,5", multipleRate: "% 1")
        ]
    )
    // swiftlint:enable function_body_length
}

// MARK: - 2026 Content

extension TariffDocumentContent {

    // swiftlint:disable function_body_length
    static let content2026 = TariffDocumentContent(
        year: 2026,
        gazetteInfo: "Resmî Gazete: 26 Aralık 2025, Sayı: 33119",
        effectiveDate: "1 Ocak 2026",
        articles: [
            TariffArticle(
                number: 1,
                title: "Amaç, Konu ve Kapsam",
                paragraphs: [
                    "Özel hukuk uyuşmazlıklarının arabuluculuk yoluyla çözümlenmesinde, arabulucu ile uyuşmazlığın tarafları arasında geçerli bir ücret sözleşmesi yapılmamış olan veya ücret miktarı konusunda arabulucu ile taraflar arasında ihtilaf bulunan durumlarda, 7/6/2012 tarihli ve 6325 sayılı Hukuk Uyuşmazlıklarında Arabuluculuk Kanunu, 2/6/2018 tarihli ve 30439 sayılı Resmî Gazete'de yayımlanan Hukuk Uyuşmazlıklarında Arabuluculuk Kanunu Yönetmeliği ve bu Tarife hükümleri uygulanır.",
                    "Bu Tarifede belirlenen ücretlerin altında arabuluculuk ücreti kararlaştırılamaz. Aksine yapılan sözleşmelerin ücrete ilişkin hükümleri geçersiz olup, ücrete ilişkin olarak bu Tarife hükümleri uygulanır."
                ]
            ),
            TariffArticle(
                number: 2,
                title: "Arabuluculuk Ücretinin Kapsadığı İşler",
                paragraphs: [
                    "Bu Tarifede yazılı arabuluculuk ücreti, uyuşmazlığın arabuluculuk yoluyla çözüme kavuşturulmasını sağlamak amacıyla, arabuluculuk faaliyetini yürüten arabulucular siciline kayıtlı kişiye, sarf ettiği emek ve mesainin karşılığında, uyuşmazlığın taraflarınca yapılan parasal ödemenin karşılığıdır.",
                    "Arabuluculuk faaliyeti süresince arabulucu tarafından düzenlenen evrak ve yapılan diğer işlemler ayrı ücreti gerektirmez.",
                    "Arabulucu, ihtiyari arabuluculuk süreci başlamadan önce arabuluculuk teklifinde bulunan taraf veya taraflardan ücret ve masraf isteyebilir. Bu fıkra uyarınca alınan ücret arabuluculuk süreci sonunda arabuluculuk ücretinden mahsup edilir. Arabuluculuk sürecinin başlamaması hâlinde bu ücret iade edilmez. Masraftan kullanılmayan kısım arabuluculuk süreci sonunda iade edilir.",
                    "Arabulucu, dava şartı arabuluculuk sürecinde taraflardan masraf isteyemez.",
                    "Arabulucu, arabuluculuk sürecine ilişkin olarak belirli kişiler için aracılık yapma veya belirli kişileri tavsiye etmenin karşılığı olarak herhangi bir ücret talep edemez. Bu yasağa aykırı olarak tesis edilen işlemler hükümsüzdür."
                ]
            ),
            TariffArticle(
                number: 3,
                title: "Arabuluculuk Ücretinin Sınırları",
                paragraphs: [
                    "Aksi kararlaştırılmadıkça arabuluculuk ücreti taraflarca eşit ödenir.",
                    "Aynı uyuşmazlığın çözümüne ilişkin bu Tarifenin eki Arabuluculuk Ücret Tarifesinin birinci kısmında belirtilen hallerde arabuluculuk faaliyetinin birden çok arabulucu tarafından yürütülmesi durumunda, her bir arabulucuya bu Tarifede belirtilen ücret ayrı ayrı ödenir.",
                    "Aynı uyuşmazlığın çözümüne ilişkin bu Tarifenin eki Arabuluculuk Ücret Tarifesinin ikinci kısmında belirtilen hallerde arabuluculuk faaliyetinin birden çok arabulucu tarafından yürütülmesi durumunda, bu Tarifede birden fazla arabulucu için belirtilen orandaki ücret her bir arabulucuya eşit bölünerek ödenir."
                ]
            ),
            TariffArticle(
                number: 4,
                title: "Ücretin Tümünü Hak Etme",
                paragraphs: [
                    "Arabuluculuk faaliyetinin, gerek tarafların uyuşmazlık konusu üzerinde anlaşmaya varmış olması, gerek taraflara danışıldıktan sonra arabuluculuk için daha fazla çaba sarf edilmesinin gereksiz olduğunun arabulucu tarafından tespit edilmesi, gerekse taraflardan birinin karşı tarafa veya arabulucuya, arabuluculuk faaliyetinden çekildiğini bildirmesi veya taraflardan birinin ölümü ya da iflası halinde veya tarafların anlaşarak arabuluculuk faaliyetini sona erdirmesi sebepleriyle sona ermesi hallerinde, arabuluculuk faaliyetini yürütme görevini kabul eden arabulucu, bu Tarife hükümleri ile belirlenen ücretin tamamına hak kazanır.",
                    "Arabuluculuk faaliyetine başlandıktan sonra, uyuşmazlığın arabuluculuğa elverişli olmadığı hususu ortaya çıkar ve bu sebeple arabuluculuk faaliyeti sona erdirilir ise, sonradan ortaya çıkan bu durumla ilgili olarak eğer arabulucunun herhangi bir kusuru yoksa arabuluculuk faaliyetini yürütme görevini kabul eden arabulucu, bu Tarife hükümleri ile belirlenen ücretin tamamına hak kazanır."
                ]
            ),
            TariffArticle(
                number: 5,
                title: "Arabuluculuk Faaliyetinin Konusuz Kalması, Feragat, Kabul ve Sulhte Ücret",
                paragraphs: [
                    "İhtiyari arabuluculuk sürecinde uyuşmazlık, arabuluculuk faaliyeti devam ederken, arabuluculuk faaliyetinin konusuz kalması, feragat, kabul veya sulh gibi arabuluculuk yolu dışındaki yöntem ve nedenlerle giderilirse ücretin tamamına hak kazanılır.",
                    "Dava şartı arabuluculuk sürecinde; sehven kayıt, mükerrer kayıt veya arabuluculuğa elverişli olmama nedeniyle sona erdirilmesi hallerinde arabulucuya ücret ödenmez."
                ]
            ),
            TariffArticle(
                number: 6,
                title: "Yeni Bir Uyuşmazlık Konusunun Ortaya Çıkmasında Ücret",
                paragraphs: [
                    "Somut bir uyuşmazlıkla ilgili arabuluculuk faaliyetinin yürütülmesi sırasında, yeni uyuşmazlık konularının ortaya çıkması halinde, her bir uyuşmazlık için ayrı ücrete hak kazanılır. Ancak dava şartı kapsamında yapılan arabuluculuk başvurularında anlaşmama durumunda bu hüküm uygulanmaz."
                ]
            ),
            TariffArticle(
                number: 7,
                title: "Arabuluculuk Ücret Tarifesine Göre Ücret",
                paragraphs: [
                    "Konusu para olmayan veya para ile değerlendirilemeyen hukuki uyuşmazlıklarda; arabuluculuk ücreti bu Tarifenin eki Arabuluculuk Ücret Tarifesinin birinci kısmına göre belirlenir.",
                    "Konusu para olan veya para ile değerlendirilebilen hukuki uyuşmazlıklarda; arabuluculuk ücreti bu Tarifenin eki Arabuluculuk Ücret Tarifesinin ikinci kısmına göre belirlenir.",
                    "Arabuluculuk sürecinin sonunda anlaşma sağlanamaması halinde, arabuluculuğun konusu para olan veya para ile değerlendirilebilen hukuki uyuşmazlık olsa bile arabulucu, arabuluculuk ücretini bu Tarifenin eki Arabuluculuk Ücret Tarifesinin birinci kısmına göre isteyebilir.",
                    "Arabuluculuk sürecinin sonunda seri uyuşmazlıklarda anlaşma sağlanması halinde, arabuluculuğun konusu para olan veya para ile değerlendirilebilen hukuki uyuşmazlık olsa bile arabulucu, her bir uyuşmazlık bakımından, ticari uyuşmazlıklarda 7.500,00 TL diğer uyuşmazlıklarda ise 6.000,00 TL ücret isteyebilir. Taraflardan birinin aynı olduğu ve bir ay içinde başvurulan en az on uyuşmazlık seri uyuşmazlık olarak kabul edilir.",
                    "Arabuluculuk sürecinin sonunda anlaşma sağlanması halinde, kira tespiti ve tahliye talepli uyuşmazlıklarda ücret; tahliye talepli uyuşmazlıklarda bir yıllık kira bedeli tutarının yarısı, kira tespiti uyuşmazlıklarında tespit olunan kira bedeli farkının bir yıllık tutarı üzerinden bu Tarifenin ikinci kısmına göre belirlenir.",
                    "Ortaklığın giderilmesine ilişkin uyuşmazlıklar ile ticari uyuşmazlıklarda, arabuluculuk sürecinin sonunda anlaşma sağlanması halinde, arabuluculuk ücreti bu Tarifenin ikinci kısmına göre belirlenir. Ancak bu ücret 13.000,00 TL'den az olamaz.",
                    "Arabuluculuk sürecinin sonunda anlaşma sağlanması halinde, anlaşma bedeline bakılmaksızın arabuluculuk ücreti 9.000,00 TL'den az olamaz."
                ]
            ),
            TariffArticle(
                number: 8,
                title: "Arabuluculuk Ücret Tarifesinde Yazılı Olmayan Hallerde Ücret",
                paragraphs: [
                    "Arabuluculuk Ücret Tarifesinde yazılı olmayan haller için, söz konusu Tarifenin birinci kısmındaki diğer tür uyuşmazlıklar için belirlenen ücret ödenir."
                ]
            ),
            TariffArticle(
                number: 9,
                title: "Uyuşmazlığın Arabuluculuk-Tahkim Yoluyla Çözülmesinin Önerilmesinde Ücret",
                paragraphs: [
                    "Arabuluculuk sürecinin sonunda anlaşma sağlanamaması halinde, anlaşamama son tutanağının düzenlenmesinden sonra, Arabulucu, tarafları arabuluculuk-tahkim yoluna devam etmeleri konusunda; arabuluculuk-tahkimin esasları, süreci ve hukuki sonuçları hakkında aydınlatıp, arabuluculuk-tahkim yoluyla uyuşmazlığın çözülmesinin sosyal, ekonomik ve psikolojik açıdan faydalarının olabileceğini hatırlatarak teşvik edebilir. Bu teşvik üzerine tarafların, arabuluculuk-tahkim yoluna devam etmeyi ve bir tahkim merkezinin arabuluculuk-tahkim kurallarını veya tahkim kurallarını uygulamayı kabul etmeleri halinde, ilgili tahkim merkezi tarafından arabulucuya, bilgilendirme ücreti ödenir."
                ]
            ),
            TariffArticle(
                number: 10,
                title: "Uygulanacak Tarife",
                paragraphs: [
                    "Arabuluculuk ücretinin takdirinde, arabuluculuk faaliyetinin sona erdiği tarihte yürürlükte olan tarife esas alınır."
                ]
            ),
            TariffArticle(
                number: 11,
                title: "Yürürlük",
                paragraphs: [
                    "Bu Tarife 1/1/2026 tarihinde yürürlüğe girer."
                ]
            )
        ],
        firstPartTitle: "Birinci Kısım – Konusu Para Olmayan veya Para ile Değerlendirilemeyen Hukuki Uyuşmazlıklar",
        firstPartCategories: [
            TariffFirstPartCategory(
                number: 1,
                title: "Aile Hukuku ile ilgili uyuşmazlıklar",
                tiers: [
                    TariffPartyTier(label: PartyTierLabels.twoPerson, amount: "1.000,00 TL"),
                    TariffPartyTier(label: PartyTierLabels.threeToFive, amount: "2.200,00 TL"),
                    TariffPartyTier(label: PartyTierLabels.sixToTen, amount: "2.300,00 TL"),
                    TariffPartyTier(label: PartyTierLabels.elevenPlus, amount: "2.400,00 TL")
                ]
            ),
            TariffFirstPartCategory(
                number: 2,
                title: "Ticari uyuşmazlıklar",
                tiers: [
                    TariffPartyTier(label: PartyTierLabels.twoPerson, amount: "1.500,00 TL"),
                    TariffPartyTier(label: PartyTierLabels.threeToFive, amount: "3.200,00 TL"),
                    TariffPartyTier(label: PartyTierLabels.sixToTen, amount: "3.300,00 TL"),
                    TariffPartyTier(label: PartyTierLabels.elevenPlus, amount: "3.400,00 TL")
                ]
            ),
            TariffFirstPartCategory(
                number: 3,
                title: "İşçi - İşveren uyuşmazlıkları",
                tiers: [
                    TariffPartyTier(label: PartyTierLabels.twoPerson, amount: "1.130,00 TL"),
                    TariffPartyTier(label: PartyTierLabels.threeToFive, amount: "2.460,00 TL"),
                    TariffPartyTier(label: PartyTierLabels.sixToTen, amount: "2.560,00 TL"),
                    TariffPartyTier(label: PartyTierLabels.elevenPlus, amount: "2.660,00 TL")
                ]
            ),
            TariffFirstPartCategory(
                number: 4,
                title: "Tüketici uyuşmazlıkları",
                tiers: [
                    TariffPartyTier(label: PartyTierLabels.twoPerson, amount: "1.000,00 TL"),
                    TariffPartyTier(label: PartyTierLabels.threeToFive, amount: "2.200,00 TL"),
                    TariffPartyTier(label: PartyTierLabels.sixToTen, amount: "2.300,00 TL"),
                    TariffPartyTier(label: PartyTierLabels.elevenPlus, amount: "2.400,00 TL")
                ]
            ),
            TariffFirstPartCategory(
                number: 5,
                title: "Kira, Komşu Hakkı ve Kat Mülkiyeti uyuşmazlıkları",
                tiers: [
                    TariffPartyTier(label: PartyTierLabels.twoPerson, amount: "1.170,00 TL"),
                    TariffPartyTier(label: PartyTierLabels.threeToFive, amount: "2.540,00 TL"),
                    TariffPartyTier(label: PartyTierLabels.sixToTen, amount: "2.640,00 TL"),
                    TariffPartyTier(label: PartyTierLabels.elevenPlus, amount: "2.740,00 TL")
                ]
            ),
            TariffFirstPartCategory(
                number: 6,
                title: "Ortaklığın Giderilmesi uyuşmazlıkları",
                tiers: [
                    TariffPartyTier(label: PartyTierLabels.twoPerson, amount: "1.170,00 TL"),
                    TariffPartyTier(label: PartyTierLabels.threeToFive, amount: "2.540,00 TL"),
                    TariffPartyTier(label: PartyTierLabels.sixToTen, amount: "2.640,00 TL"),
                    TariffPartyTier(label: PartyTierLabels.elevenPlus, amount: "2.740,00 TL")
                ]
            ),
            TariffFirstPartCategory(
                number: 7,
                title: "Diğer tür uyuşmazlıklar",
                tiers: [
                    TariffPartyTier(label: PartyTierLabels.twoPerson, amount: "1.000,00 TL"),
                    TariffPartyTier(label: PartyTierLabels.threeToFive, amount: "2.200,00 TL"),
                    TariffPartyTier(label: PartyTierLabels.sixToTen, amount: "2.300,00 TL"),
                    TariffPartyTier(label: PartyTierLabels.elevenPlus, amount: "2.400,00 TL")
                ]
            )
        ],
        secondPartTitle: "İkinci Kısım – Konusu Para Olan veya Para ile Değerlendirilebilen Hukuki Uyuşmazlıklar",
        secondPartBrackets: [
            TariffSecondPartBracket(number: 1, description: "İlk 600.000,00 TL'si için", singleRate: "% 6", multipleRate: "% 9"),
            TariffSecondPartBracket(number: 2, description: "Sonra gelen 960.000,00 TL'si için", singleRate: "% 5", multipleRate: "% 7,5"),
            TariffSecondPartBracket(number: 3, description: "Sonra gelen 1.560.000,00 TL'si için", singleRate: "% 4", multipleRate: "% 6"),
            TariffSecondPartBracket(number: 4, description: "Sonra gelen 3.120.000,00 TL'si için", singleRate: "% 3", multipleRate: "% 4,5"),
            TariffSecondPartBracket(number: 5, description: "Sonra gelen 9.360.000,00 TL'si için", singleRate: "% 2", multipleRate: "% 3"),
            TariffSecondPartBracket(number: 6, description: "Sonra gelen 12.480.000,00 TL'si için", singleRate: "% 1,5", multipleRate: "% 2,5"),
            TariffSecondPartBracket(number: 7, description: "Sonra gelen 24.960.000,00 TL'si için", singleRate: "% 1", multipleRate: "% 1,5"),
            TariffSecondPartBracket(number: 8, description: "53.040.000,00 TL'den yukarısı için", singleRate: "% 0,5", multipleRate: "% 1")
        ]
    )
    // swiftlint:enable function_body_length
}
