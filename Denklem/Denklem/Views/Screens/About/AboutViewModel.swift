//
//  AboutViewModel.swift
//  Denklem
//
//  Created by ozkan on 31.12.2025.
//

import SwiftUI
import Combine

// MARK: - About Section Item
/// Model representing an item in the about screen sections
struct AboutSectionItem: Identifiable, Hashable {
    let id: UUID
    let title: String
    let value: String?
    let systemImage: String?
    let action: AboutItemAction?
    
    enum AboutItemAction: Hashable {
        case openURL(String)
        case sendEmail(String)
        case shareApp
        case rateApp
        case showDisclaimer
        case none
    }
    
    init(
        id: UUID = UUID(),
        title: String,
        value: String? = nil,
        systemImage: String? = nil,
        action: AboutItemAction? = nil
    ) {
        self.id = id
        self.title = title
        self.value = value
        self.systemImage = systemImage
        self.action = action
    }
}

// MARK: - About Section
/// Model representing a section in the about screen
struct AboutScreenSection: Identifiable, Hashable {
    let id: UUID
    let title: String
    let items: [AboutSectionItem]
    
    init(
        id: UUID = UUID(),
        title: String,
        items: [AboutSectionItem]
    ) {
        self.id = id
        self.title = title
        self.items = items
    }
}

// MARK: - About ViewModel
/// ViewModel for AboutView - manages app information and about screen data
@available(iOS 26.0, *)
@MainActor
final class AboutViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    /// Sections displayed in the about screen (updated on language change)
    @Published private(set) var sections: [AboutScreenSection] = []
    
    /// Show share sheet
    @Published var showShareSheet: Bool = false
    
    /// Error message if any
    @Published var errorMessage: String?
    
    // MARK: - Computed Properties
    
    /// App version string
    var appVersion: String {
        return AboutData.fullVersionString
    }
    
    /// App name
    var appName: String {
        return AboutData.localizedAppName
    }
    
    /// Developer name
    var developerName: String {
        return AboutData.developerName
    }
    
    /// Copyright text
    var copyrightText: String {
        return AboutData.copyrightText
    }
    
    // MARK: - Initialization
    
    init() {
        loadSections()
    }
    
    // MARK: - Public Methods
    
    /// Loads about screen sections (called on init and language change)
    func loadSections() {
        sections = createSections()
    }
    
    /// Handles item action
    /// - Parameter item: The item that was tapped
    func handleAction(for item: AboutSectionItem) {
        guard let action = item.action else { return }
        
        switch action {
        case .openURL(let urlString):
            openURL(urlString)
        case .sendEmail(let email):
            sendEmail(to: email)
        case .shareApp:
            showShareSheet = true
        case .rateApp:
            openAppStore()
        case .showDisclaimer:
            break
        case .none:
            break
        }
    }
    
    /// Opens a URL in Safari
    /// - Parameter urlString: URL string to open
    func openURL(_ urlString: String) {
        guard let url = URL(string: urlString) else {
            errorMessage = LocalizationKeys.ErrorMessage.networkError.localized
            return
        }
        
        UIApplication.shared.open(url)
    }
    
    /// Opens email composer
    /// - Parameter email: Email address
    func sendEmail(to email: String) {
        let mailtoURL = "mailto:\(email)?subject=DENKLEM%20App%20Feedback"
        if let url = URL(string: mailtoURL) {
            UIApplication.shared.open(url)
        }
    }
    
    /// Opens App Store for rating
    func openAppStore() {
        if let url = URL(string: AboutData.appStoreReviewURL) {
            UIApplication.shared.open(url)
        }
    }
    
    /// Returns share items for the app
    func getShareItems() -> [Any] {
        let appStoreURL = AboutData.appStoreURL
        let shareText = "about.share.text".localized
        return [shareText, appStoreURL]
    }
    
    // MARK: - Private Methods
    
    /// Creates about screen sections
    private func createSections() -> [AboutScreenSection] {
        return [
            createAppInfoSection(),
            createDeveloperSection(),
            createSupportSection(),
            createLegalSection()
        ]
    }
    
    /// Creates app info section
    private func createAppInfoSection() -> AboutScreenSection {
        AboutScreenSection(
            title: LocalizationKeys.About.appInfo.localized,
            items: [
                AboutSectionItem(
                    title: LocalizationKeys.About.version.localized,
                    value: AboutData.fullVersionString,
                    systemImage: "info.circle"
                ),
                AboutSectionItem(
                    title: LocalizationKeys.About.supportedYears.localized,
                    value: AboutData.supportedYears.map { String($0) }.joined(separator: ", "),
                    systemImage: "calendar"
                ),
                AboutSectionItem(
                    title: LocalizationKeys.About.supportedLanguages.localized,
                    value: "about.supported_languages.values".localized,
                    systemImage: "globe"
                )
            ]
        )
    }
    
    /// Creates developer section
    private func createDeveloperSection() -> AboutScreenSection {
        AboutScreenSection(
            title: LocalizationKeys.About.developer.localized,
            items: [
                AboutSectionItem(
                    title: LocalizationKeys.About.developer.localized,
                    value: AboutData.developerName,
                    systemImage: "person.circle"
                ),
                AboutSectionItem(
                    title: LocalizationKeys.Contact.email.localized,
                    systemImage: "envelope",
                    action: .sendEmail(AboutData.developerEmail)
                ),
                AboutSectionItem(
                    title: LocalizationKeys.Contact.website.localized,
                    systemImage: "globe",
                    action: .openURL(AboutData.companyWebsite)
                )
            ]
        )
    }
    
    /// Creates support section
    private func createSupportSection() -> AboutScreenSection {
        AboutScreenSection(
            title: LocalizationKeys.About.contact.localized,
            items: [
                AboutSectionItem(
                    title: LocalizationKeys.Contact.rateApp.localized,
                    systemImage: "star",
                    action: .rateApp
                ),
                AboutSectionItem(
                    title: LocalizationKeys.Contact.shareApp.localized,
                    systemImage: "square.and.arrow.up",
                    action: .shareApp
                ),
                AboutSectionItem(
                    title: LocalizationKeys.Contact.sendFeedback.localized,
                    systemImage: "envelope",
                    action: .sendEmail(AboutData.developerEmail)
                )
            ]
        )
    }
    
    /// Creates legal section
    private func createLegalSection() -> AboutScreenSection {
        AboutScreenSection(
            title: LocalizationKeys.About.legal.localized,
            items: [
                AboutSectionItem(
                    title: LocalizationKeys.Legal.disclaimer.localized,
                    systemImage: "exclamationmark.triangle",
                    action: .showDisclaimer
                ),
                AboutSectionItem(
                    title: LocalizationKeys.Legal.privacyPolicy.localized,
                    systemImage: "hand.raised",
                    action: .openURL("https://denklem.org/en/privacy/")
                )
            ]
        )
    }
}

// MARK: - Preview Support

#if DEBUG
@available(iOS 26.0, *)
extension AboutViewModel {
    /// Creates a preview instance
    static var preview: AboutViewModel {
        return AboutViewModel()
    }
}
#endif
