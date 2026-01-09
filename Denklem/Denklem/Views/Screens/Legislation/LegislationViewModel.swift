//
//  LegislationViewModel.swift
//  Denklem
//
//  Created by ozkan on 31.12.2025.
//

import SwiftUI
import Combine

// MARK: - Legislation Document
/// Model representing a legislation document
struct LegislationDocument: Identifiable, Hashable {
    let id: UUID
    let title: String
    let subtitle: String
    let year: Int
    let type: DocumentType
    let url: String?
    let pdfFileName: String?
    let isOfficial: Bool
    let lastUpdated: Date
    
    enum DocumentType: String, CaseIterable {
        case tariff = "tariff"
        case regulation = "regulation"
        case law = "law"
        case circular = "circular"
        
        var displayName: String {
            switch self {
            case .tariff:
                return LocalizationKeys.Legislation.typeTariff.localized
            case .regulation:
                return LocalizationKeys.Legislation.typeRegulation.localized
            case .law:
                return LocalizationKeys.Legislation.typeLaw.localized
            case .circular:
                return LocalizationKeys.Legislation.typeCircular.localized
            }
        }
        
        var systemImage: String {
            switch self {
            case .tariff:
                return "doc.text.fill"
            case .regulation:
                return "book.closed.fill"
            case .law:
                return "building.columns.fill"
            case .circular:
                return "envelope.fill"
            }
        }
    }
    
    /// Default initializer
    init(
        id: UUID = UUID(),
        title: String,
        subtitle: String,
        year: Int,
        type: DocumentType,
        url: String? = nil,
        pdfFileName: String? = nil,
        isOfficial: Bool = true,
        lastUpdated: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.year = year
        self.type = type
        self.url = url
        self.pdfFileName = pdfFileName
        self.isOfficial = isOfficial
        self.lastUpdated = lastUpdated
    }
}

// MARK: - Legislation ViewModel
/// ViewModel for LegislationView - manages legislation documents and PDF viewing
@available(iOS 26.0, *)
@MainActor
final class LegislationViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    /// List of legislation documents
    @Published private(set) var documents: [LegislationDocument] = []
    
    /// Currently selected document
    @Published var selectedDocument: LegislationDocument?
    
    /// Search text for filtering documents
    @Published var searchText: String = ""
    
    /// Currently selected filter
    @Published var selectedFilter: LegislationDocument.DocumentType?
    
    /// Loading state
    @Published private(set) var isLoading: Bool = false
    
    /// Error message if any
    @Published var errorMessage: String?
    
    /// Show PDF viewer sheet
    @Published var showPDFViewer: Bool = false
    
    // MARK: - Computed Properties
    
    /// Filtered documents based on search and filter
    var filteredDocuments: [LegislationDocument] {
        var result = documents
        
        // Apply type filter
        if let filter = selectedFilter {
            result = result.filter { $0.type == filter }
        }
        
        // Apply search filter
        if !searchText.isEmpty {
            result = result.filter {
                $0.title.localizedCaseInsensitiveContains(searchText) ||
                $0.subtitle.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        return result
    }
    
    /// Groups documents by year for section display
    var documentsByYear: [Int: [LegislationDocument]] {
        Dictionary(grouping: filteredDocuments) { $0.year }
    }
    
    /// Sorted years for section headers
    var sortedYears: [Int] {
        documentsByYear.keys.sorted(by: >)
    }
    
    // MARK: - Initialization
    
    init() {
        loadDocuments()
    }
    
    // MARK: - Public Methods
    
    /// Loads legislation documents
    func loadDocuments() {
        isLoading = true
        
        // Simulate loading - in real app, this would fetch from a data source
        documents = Self.createDefaultDocuments()
        
        isLoading = false
    }
    
    /// Selects a document and opens PDF viewer
    /// - Parameter document: Document to select
    func selectDocument(_ document: LegislationDocument) {
        selectedDocument = document
        showPDFViewer = true
    }
    
    /// Opens document URL in Safari
    /// - Parameter document: Document with URL to open
    func openInSafari(_ document: LegislationDocument) {
        guard let urlString = document.url,
              let url = URL(string: urlString) else {
            errorMessage = NSLocalizedString(LocalizationKeys.ErrorMessage.fileError, comment: "")
            return
        }
        
        UIApplication.shared.open(url)
    }
    
    /// Clears all filters
    func clearFilters() {
        searchText = ""
        selectedFilter = nil
    }
    
    /// Shares document
    /// - Parameter document: Document to share
    func shareDocument(_ document: LegislationDocument) {
        // Sharing logic would go here
        // For now, just log
        #if DEBUG
        print("Sharing document: \(document.title)")
        #endif
    }
    
    // MARK: - Private Methods
    
    /// Creates default legislation documents
    private static func createDefaultDocuments() -> [LegislationDocument] {
        return [
            // 2026 Tarifesi
            LegislationDocument(
                title: NSLocalizedString("legislation.tariff.2026.title", value: "2026 Yılı Arabuluculuk Asgari Ücret Tarifesi", comment: ""),
                subtitle: NSLocalizedString("legislation.tariff.2026.subtitle", value: "Resmi Gazete: 31 Aralık 2025", comment: ""),
                year: 2026,
                type: .tariff,
                url: "https://www.resmigazete.gov.tr/eskiler/2025/12/20251226-3.htm",
                pdfFileName: "arabuluculuk_tarifesi_2026.pdf",
                isOfficial: true
            ),
            // 2025 Tarifesi
            LegislationDocument(
                title: NSLocalizedString("legislation.tariff.2025.title", value: "2025 Yılı Arabuluculuk Asgari Ücret Tarifesi", comment: ""),
                subtitle: NSLocalizedString("legislation.tariff.2025.subtitle", value: "Resmi Gazete: 31 Aralık 2024", comment: ""),
                year: 2025,
                type: .tariff,
                url: "https://adb.adalet.gov.tr/Resimler/SayfaDokuman/251220241628282024.pdf",
                pdfFileName: "arabuluculuk_tarifesi_2025.pdf",
                isOfficial: true
            ),
            // Arabuluculuk Kanunu
            LegislationDocument(
                title: NSLocalizedString("legislation.law.title", value: "6325 Sayılı Hukuk Uyuşmazlıklarında Arabuluculuk Kanunu", comment: ""),
                subtitle: NSLocalizedString("legislation.law.subtitle", value: "Kabul Tarihi: 07.06.2012", comment: ""),
                year: 2012,
                type: .law,
                url: "https://adb.adalet.gov.tr/Resimler/SayfaDokuman/11120231556551.5.6325.pdf",
                isOfficial: true
            ),
            // Yönetmelik
            LegislationDocument(
                title: NSLocalizedString("legislation.regulation.title", value: "Hukuk Uyuşmazlıklarında Arabuluculuk Kanunu Yönetmeliği", comment: ""),
                subtitle: NSLocalizedString("legislation.regulation.subtitle", value: "Resmi Gazete: 26.01.2013", comment: ""),
                year: 2013,
                type: .regulation,
                url: "https://adb.adalet.gov.tr/Resimler/SayfaDokuman/30120221536271.pdf",
                isOfficial: true
            ),
            // İş Mahkemeleri Kanunu
            LegislationDocument(
                title: NSLocalizedString("legislation.laborcourt.title", value: "7036 Sayılı İş Mahkemeleri Kanunu", comment: ""),
                subtitle: NSLocalizedString("legislation.laborcourt.subtitle", value: "Kabul Tarihi: 12.10.2017", comment: ""),
                year: 2017,
                type: .law,
                url: "https://adb.adalet.gov.tr/Resimler/SayfaDokuman/15120210744381.5.7036.pdf",
                isOfficial: true
            )
        ]
    }
}

// MARK: - Preview Support

#if DEBUG
@available(iOS 26.0, *)
extension LegislationViewModel {
    /// Creates a preview instance with sample data
    static var preview: LegislationViewModel {
        let viewModel = LegislationViewModel()
        return viewModel
    }
}
#endif
