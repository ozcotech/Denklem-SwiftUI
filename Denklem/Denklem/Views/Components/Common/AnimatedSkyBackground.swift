//
//  AnimatedSkyBackground.swift
//  Denklem
//
//  Created by ozkan on 27.02.2026.
//

import SwiftUI

// MARK: - Cloud Model

private struct Cloud {
    let layer: Int
    let baseY: CGFloat
    let scale: CGFloat
    let speed: CGFloat
    let opacity: Double
    let seed: CGFloat
    let variant: Int
}

// MARK: - Animated Sky Background

/// A reusable animated sky background with parallax cloud layers.
/// Uses `TimelineView` + `Canvas` for GPU-accelerated rendering.
///
/// Usage:
/// ```swift
/// .background {
///     AnimatedSkyBackground()
/// }
/// ```
@available(iOS 26.0, *)
struct AnimatedSkyBackground: View {

    // MARK: - Properties

    @Environment(\.colorScheme) var colorScheme

    // MARK: - Cloud Data

    private let clouds: [Cloud] = {
        var result: [Cloud] = []

        // Layer 0: Distant clouds (small, very slow, faint) — 2 clouds
        let layer0Configs: [(baseY: CGFloat, scale: CGFloat, speed: CGFloat, opacity: Double, seed: CGFloat, variant: Int)] = [
            (0.15, 0.35, 3,  0.20, 0.0,  0),
            (0.25, 0.30, 4,  0.18, 0.35, 1),
        ]

        // Layer 1: Mid clouds (medium, slow) — 3 clouds
        let layer1Configs: [(baseY: CGFloat, scale: CGFloat, speed: CGFloat, opacity: Double, seed: CGFloat, variant: Int)] = [
            (0.35, 0.55, 6,  0.35, 0.10, 1),
            (0.50, 0.50, 7,  0.30, 0.45, 2),
            (0.42, 0.60, 5.5, 0.38, 0.70, 0),
        ]

        // Layer 2: Near clouds (large, moderate) — 2 clouds
        let layer2Configs: [(baseY: CGFloat, scale: CGFloat, speed: CGFloat, opacity: Double, seed: CGFloat, variant: Int)] = [
            (0.60, 0.85, 10, 0.50, 0.20, 0),
            (0.72, 0.90, 12, 0.55, 0.55, 1),
        ]

        for config in layer0Configs {
            result.append(Cloud(layer: 0, baseY: config.baseY, scale: config.scale, speed: config.speed, opacity: config.opacity, seed: config.seed, variant: config.variant))
        }
        for config in layer1Configs {
            result.append(Cloud(layer: 1, baseY: config.baseY, scale: config.scale, speed: config.speed, opacity: config.opacity, seed: config.seed, variant: config.variant))
        }
        for config in layer2Configs {
            result.append(Cloud(layer: 2, baseY: config.baseY, scale: config.scale, speed: config.speed, opacity: config.opacity, seed: config.seed, variant: config.variant))
        }

        return result
    }()

    // MARK: - Body

    var body: some View {
        TimelineView(.animation) { timeline in
            let elapsed = timeline.date.timeIntervalSince1970

            Canvas { context, size in
                drawSkyGradient(in: &context, size: size)
                drawCelestialGlow(in: &context, size: size)

                for cloud in clouds {
                    drawCloud(in: &context, size: size, cloud: cloud, elapsed: elapsed)
                }
            }
        }
        .ignoresSafeArea()
    }

    // MARK: - Sky Gradient

    private func drawSkyGradient(in context: inout GraphicsContext, size: CGSize) {
        let colors: [Color]

        if colorScheme == .dark {
            // Near-black with subtle dark blue hint
            colors = [
                Color(red: 0.04, green: 0.04, blue: 0.08),
                Color(red: 0.06, green: 0.06, blue: 0.10),
                Color(red: 0.03, green: 0.03, blue: 0.06)
            ]
        } else {
            // Apple-style soft sky blue, slightly lighter
            colors = [
                Color(red: 0.75, green: 0.88, blue: 0.97),
                Color(red: 0.62, green: 0.82, blue: 0.96),
                Color(red: 0.52, green: 0.76, blue: 0.95)
            ]
        }

        let gradient = Gradient(colors: colors)
        let rect = CGRect(origin: .zero, size: size)

        context.fill(
            Path(rect),
            with: .linearGradient(
                gradient,
                startPoint: CGPoint(x: size.width / 2, y: 0),
                endPoint: CGPoint(x: size.width / 2, y: size.height)
            )
        )
    }

    // MARK: - Celestial Glow (Sun Rays / Crescent Moon)

    private func drawCelestialGlow(in context: inout GraphicsContext, size: CGSize) {
        if colorScheme == .dark {
            drawCrescentMoon(in: &context, size: size)
        } else {
            drawSunRays(in: &context, size: size)
        }
    }

    // MARK: - Sun with Light Beams

    private func drawSunRays(in context: inout GraphicsContext, size: CGSize) {
        // Sun position: partially hidden behind top-left corner
        let sunCenter = CGPoint(x: size.width * 0.05, y: -size.height * 0.01)

        // Layer 1: Wide atmospheric glow (very soft, large)
        let atmosphereRadius = size.width * 0.6
        let atmosphereGradient = Gradient(stops: [
            .init(color: Color.white.opacity(0.18), location: 0),
            .init(color: Color.white.opacity(0.06), location: 0.3),
            .init(color: Color.white.opacity(0.02), location: 0.6),
            .init(color: Color.clear, location: 1.0),
        ])
        context.fill(
            Path(ellipseIn: CGRect(
                x: sunCenter.x - atmosphereRadius,
                y: sunCenter.y - atmosphereRadius,
                width: atmosphereRadius * 2,
                height: atmosphereRadius * 2
            )),
            with: .radialGradient(atmosphereGradient, center: sunCenter, startRadius: 0, endRadius: atmosphereRadius)
        )

        // Layer 2: Inner bright glow (blurred sun core)
        let coreRadius: CGFloat = 50
        let coreGradient = Gradient(stops: [
            .init(color: Color.white.opacity(0.55), location: 0),
            .init(color: Color.white.opacity(0.25), location: 0.3),
            .init(color: Color.white.opacity(0.08), location: 0.6),
            .init(color: Color.clear, location: 1.0),
        ])
        context.fill(
            Path(ellipseIn: CGRect(
                x: sunCenter.x - coreRadius,
                y: sunCenter.y - coreRadius,
                width: coreRadius * 2,
                height: coreRadius * 2
            )),
            with: .radialGradient(coreGradient, center: sunCenter, startRadius: 0, endRadius: coreRadius)
        )

        // Layer 3: Light beams (wide, soft, fading out like real sun rays)
        // Each beam is a wide triangle with gradient opacity, drawn with blur
        let beams: [(angle: CGFloat, length: CGFloat, width: CGFloat, opacity: Double)] = [
            (0.4,  180, 6,  0.12),
            (0.75, 220, 8,  0.15),
            (1.1,  260, 10, 0.18),
            (1.45, 200, 7,  0.14),
            (1.8,  240, 9,  0.16),
            (2.15, 190, 5,  0.10),
            (2.55, 210, 7,  0.13),
        ]

        for beam in beams {
            var beamContext = context
            beamContext.opacity = beam.opacity
            beamContext.addFilter(.blur(radius: 8))

            let endX = sunCenter.x + cos(beam.angle) * beam.length
            let endY = sunCenter.y + sin(beam.angle) * beam.length

            // Wide base at sun, tapering to point
            let perpX = -sin(beam.angle) * beam.width
            let perpY = cos(beam.angle) * beam.width

            var beamPath = Path()
            beamPath.move(to: CGPoint(x: sunCenter.x + perpX, y: sunCenter.y + perpY))
            beamPath.addLine(to: CGPoint(x: sunCenter.x - perpX, y: sunCenter.y - perpY))
            beamPath.addLine(to: CGPoint(x: endX, y: endY))
            beamPath.closeSubpath()

            beamContext.fill(beamPath, with: .color(.white))
        }
    }

    // MARK: - Crescent Moon

    private func drawCrescentMoon(in context: inout GraphicsContext, size: CGSize) {
        // Position: near the navigation title area, slightly to the left
        let moonCenter = CGPoint(x: size.width * 0.12, y: size.height * 0.09)
        let moonRadius: CGFloat = 16

        // Subtle atmospheric glow
        let glowRadius: CGFloat = 55
        let glowGradient = Gradient(stops: [
            .init(color: Color(white: 0.85).opacity(0.08), location: 0),
            .init(color: Color(white: 0.8).opacity(0.03), location: 0.5),
            .init(color: Color.clear, location: 1.0),
        ])
        context.fill(
            Path(ellipseIn: CGRect(
                x: moonCenter.x - glowRadius,
                y: moonCenter.y - glowRadius,
                width: glowRadius * 2,
                height: glowRadius * 2
            )),
            with: .radialGradient(glowGradient, center: moonCenter, startRadius: 0, endRadius: glowRadius)
        )

        // Crescent using drawLayer + destinationOut (cookie cutter approach)
        // This draws the full moon, then cuts out a circle to leave only the crescent
        context.drawLayer { layerContext in
            // Step 1: Draw full moon disc
            let moonPath = Path(ellipseIn: CGRect(
                x: moonCenter.x - moonRadius,
                y: moonCenter.y - moonRadius,
                width: moonRadius * 2,
                height: moonRadius * 2
            ))

            layerContext.addFilter(.blur(radius: 0.8))
            layerContext.fill(moonPath, with: .color(Color(white: 0.92).opacity(0.65)))

            // Step 2: Cut out shadow circle — first crescent (very thin)
            // Shadow shifted RIGHT with slight UP → thin sliver on left, horns slightly upward-right
            let shadowRadius = moonRadius * 1.35
            let shadowCenter = CGPoint(
                x: moonCenter.x + moonRadius * 0.40,
                y: moonCenter.y - moonRadius * 0.22
            )

            let shadowPath = Path(ellipseIn: CGRect(
                x: shadowCenter.x - shadowRadius,
                y: shadowCenter.y - shadowRadius,
                width: shadowRadius * 2,
                height: shadowRadius * 2
            ))

            // destinationOut erases the moon where shadow overlaps → thin crescent remains
            layerContext.blendMode = .destinationOut
            layerContext.fill(shadowPath, with: .color(.white))
        }
    }

    // MARK: - Cloud Drawing

    private func drawCloud(in context: inout GraphicsContext, size: CGSize, cloud: Cloud, elapsed: TimeInterval) {
        let baseCloudWidth: CGFloat = 120
        let cloudWidth = baseCloudWidth * cloud.scale
        let totalTravel = size.width + cloudWidth * 2

        let rawX = (cloud.seed * totalTravel + CGFloat(elapsed) * cloud.speed)
        let x = rawX.truncatingRemainder(dividingBy: totalTravel) - cloudWidth
        let y = cloud.baseY * size.height

        let cloudColor: Color = colorScheme == .dark
            ? Color(white: 0.65)
            : .white

        var cloudContext = context
        cloudContext.opacity = cloud.opacity
        // Soft blur for natural cloud edges (more blur for closer clouds)
        let blurRadius: CGFloat = cloud.layer == 0 ? 2 : cloud.layer == 1 ? 3 : 4
        cloudContext.addFilter(.blur(radius: blurRadius * cloud.scale))

        let ellipses = cloudEllipses(variant: cloud.variant, scale: cloud.scale)

        for ellipse in ellipses {
            let ellipseRect = CGRect(
                x: x + ellipse.offsetX,
                y: y + ellipse.offsetY,
                width: ellipse.width,
                height: ellipse.height
            )
            cloudContext.fill(
                Path(ellipseIn: ellipseRect),
                with: .color(cloudColor)
            )
        }
    }

    // MARK: - Cloud Shape Variants

    private struct CloudEllipse {
        let offsetX: CGFloat
        let offsetY: CGFloat
        let width: CGFloat
        let height: CGFloat
    }

    private func cloudEllipses(variant: Int, scale: CGFloat) -> [CloudEllipse] {
        let s = scale

        switch variant {
        case 0:
            // Cumulus cloud - flat base with puffy top bumps
            return [
                // Base body
                CloudEllipse(offsetX: 5 * s,   offsetY: 20 * s, width: 120 * s, height: 26 * s),
                // Main bumps (top)
                CloudEllipse(offsetX: 15 * s,  offsetY: 6 * s,  width: 42 * s,  height: 36 * s),
                CloudEllipse(offsetX: 40 * s,  offsetY: -2 * s, width: 48 * s,  height: 40 * s),
                CloudEllipse(offsetX: 72 * s,  offsetY: 4 * s,  width: 38 * s,  height: 32 * s),
                // Small detail bumps
                CloudEllipse(offsetX: 0 * s,   offsetY: 14 * s, width: 28 * s,  height: 22 * s),
                CloudEllipse(offsetX: 30 * s,  offsetY: 0 * s,  width: 24 * s,  height: 20 * s),
                CloudEllipse(offsetX: 58 * s,  offsetY: -4 * s, width: 20 * s,  height: 18 * s),
                CloudEllipse(offsetX: 95 * s,  offsetY: 12 * s, width: 26 * s,  height: 20 * s),
            ]
        case 1:
            // Towering cumulus - tall and puffy
            return [
                // Wide flat base
                CloudEllipse(offsetX: 0 * s,   offsetY: 28 * s, width: 110 * s, height: 22 * s),
                // Large central bumps
                CloudEllipse(offsetX: 12 * s,  offsetY: 8 * s,  width: 44 * s,  height: 38 * s),
                CloudEllipse(offsetX: 35 * s,  offsetY: -8 * s, width: 50 * s,  height: 48 * s),
                CloudEllipse(offsetX: 62 * s,  offsetY: 2 * s,  width: 40 * s,  height: 36 * s),
                // Top detail bumps for irregular edge
                CloudEllipse(offsetX: 22 * s,  offsetY: -2 * s, width: 22 * s,  height: 20 * s),
                CloudEllipse(offsetX: 48 * s,  offsetY: -12 * s, width: 26 * s, height: 22 * s),
                CloudEllipse(offsetX: 70 * s,  offsetY: 6 * s,  width: 20 * s,  height: 18 * s),
                CloudEllipse(offsetX: 82 * s,  offsetY: 16 * s, width: 24 * s,  height: 20 * s),
                // Side wisps
                CloudEllipse(offsetX: -4 * s,  offsetY: 22 * s, width: 22 * s,  height: 16 * s),
                CloudEllipse(offsetX: 92 * s,  offsetY: 22 * s, width: 20 * s,  height: 14 * s),
            ]
        default:
            // Stratocumulus - elongated with subtle bumps
            return [
                // Long flat base
                CloudEllipse(offsetX: 0 * s,   offsetY: 16 * s, width: 140 * s, height: 20 * s),
                // Gentle bumps along top
                CloudEllipse(offsetX: 10 * s,  offsetY: 6 * s,  width: 36 * s,  height: 26 * s),
                CloudEllipse(offsetX: 38 * s,  offsetY: 2 * s,  width: 42 * s,  height: 28 * s),
                CloudEllipse(offsetX: 72 * s,  offsetY: 4 * s,  width: 38 * s,  height: 24 * s),
                CloudEllipse(offsetX: 102 * s, offsetY: 8 * s,  width: 32 * s,  height: 22 * s),
                // Small accent bumps
                CloudEllipse(offsetX: 25 * s,  offsetY: 0 * s,  width: 18 * s,  height: 16 * s),
                CloudEllipse(offsetX: 55 * s,  offsetY: -2 * s, width: 20 * s,  height: 16 * s),
                CloudEllipse(offsetX: 88 * s,  offsetY: 4 * s,  width: 16 * s,  height: 14 * s),
            ]
        }
    }
}

// MARK: - Preview

@available(iOS 26.0, *)
#Preview("Light Mode") {
    AnimatedSkyBackground()
        .environment(\.colorScheme, .light)
}

@available(iOS 26.0, *)
#Preview("Dark Mode") {
    AnimatedSkyBackground()
        .environment(\.colorScheme, .dark)
}
