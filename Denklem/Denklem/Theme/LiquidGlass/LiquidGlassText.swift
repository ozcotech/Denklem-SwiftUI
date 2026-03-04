//
//  LiquidGlassText.swift
//  Denklem
//
//  Created by ozkan on 01.03.2026.
//
//  NOTE: This file is currently not used in any screen.
//
//  A SwiftUI view that renders text with Apple's Liquid Glass effect.
//  Converts the text into glyph paths via TextPathHelper, then applies
//  .glassEffect to fill each character shape with glass material —
//  similar to the iOS lock screen clock style.
//

import SwiftUI

@available(iOS 26.0, *)
struct LiquidGlassText: View {

    // MARK: - Properties

    private let attributedString: NSAttributedString
    private let glass: Glass

    // MARK: - Initializers

    init(
        _ text: String,
        glass: Glass = .regular,
        size: CGFloat = UIFont.systemFontSize,
        weight: UIFont.Weight = .regular,
        design: UIFontDescriptor.SystemDesign = .default
    ) {
        let baseDescriptor = UIFont.systemFont(ofSize: size).fontDescriptor
        let designDescriptor = baseDescriptor.withDesign(design) ?? baseDescriptor
        let descriptor = designDescriptor.addingAttributes([
            .traits: [UIFontDescriptor.TraitKey.weight: weight]
        ])
        let font = UIFont(descriptor: descriptor, size: size)

        self.attributedString = NSAttributedString(
            string: text,
            attributes: [.font: font]
        )
        self.glass = glass
    }

    // MARK: - Body

    var body: some View {
        let path = TextPathHelper.path(for: attributedString)

        Color.clear
            .glassEffect(glass, in: path)
            .frame(width: path.boundingRect.width, height: path.boundingRect.height)
    }
}
