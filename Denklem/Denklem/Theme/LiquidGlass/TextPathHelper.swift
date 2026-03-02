//
//  TextPathHelper.swift
//  Denklem
//
//  Created by ozkan on 01.03.2026.
//
//  Converts an NSAttributedString into a SwiftUI Path by extracting
//  glyph outlines via CoreText. Used by LiquidGlassText to apply
//  .glassEffect to the shape of individual characters.
//

import SwiftUI
import CoreText

struct TextPathHelper {

    private init() {}

    static func path(for string: NSAttributedString) -> Path {
        let line = CTLineCreateWithAttributedString(string)
        let runs = CTLineGetGlyphRuns(line) as NSArray
        let outputPath = CGMutablePath()

        for i in 0..<CFArrayGetCount(runs) {
            let run = unsafeBitCast(CFArrayGetValueAtIndex(runs, i), to: CTRun.self)
            let attributes = CTRunGetAttributes(run) as NSDictionary
            let key = kCTFontAttributeName as NSAttributedString.Key

            guard let anyCTFont = attributes[key] else { continue }
            let ctFont = anyCTFont as! CTFont

            let glyphCount = CTRunGetGlyphCount(run)
            var glyphs = [CGGlyph](repeating: 0, count: glyphCount)
            var positions = [CGPoint](repeating: .zero, count: glyphCount)

            CTRunGetGlyphs(run, CFRangeMake(0, 0), &glyphs)
            CTRunGetPositions(run, CFRangeMake(0, 0), &positions)

            for j in 0..<glyphCount {
                if let glyphPath = CTFontCreatePathForGlyph(ctFont, glyphs[j], nil) {
                    let transform = CGAffineTransform(translationX: positions[j].x, y: positions[j].y)
                    outputPath.addPath(glyphPath, transform: transform)
                }
            }
        }

        let swiftUIPath = Path(outputPath)
        let bounds = swiftUIPath.boundingRect
        let flipped = swiftUIPath.applying(
            CGAffineTransform(scaleX: 1, y: -1).translatedBy(x: 0, y: -bounds.height)
        )
        return flipped
    }
}
