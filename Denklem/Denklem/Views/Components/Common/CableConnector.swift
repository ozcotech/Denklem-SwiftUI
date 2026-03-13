//
//  CableConnector.swift
//  Denklem
//
//  Created by ozkan on 13.03.2026.
//

import SwiftUI

// MARK: - Cable Connector

/// Decorative cable connector that visually links UI sections
/// Cables carry the active color of the selected path (green/red/primary)
/// Inactive cables appear as dim gray lines
@available(iOS 26.0, *)
struct CableConnector: View {

    /// Horizontal anchor position as a fraction of the total width
    enum HorizontalAnchor {
        case left    // 25%
        case center  // 50%
        case right   // 75%

        var fraction: CGFloat {
            switch self {
            case .left: return 0.25
            case .center: return 0.50
            case .right: return 0.75
            }
        }
    }

    enum Mode {
        /// Vertical cable at center
        case straight(active: Bool, color: Color)
        /// Fork splitting from a source position to left (25%) and right (75%) targets
        /// When hideInactive is true, only the active branch is drawn (inactive branch hidden)
        case fork(leftActive: Bool, rightActive: Bool, leftColor: Color, rightColor: Color, from: HorizontalAnchor, hideInactive: Bool = false)
        /// L-shaped cable from a quarter position bending to center
        case bend(active: Bool, color: Color, from: HorizontalAnchor)
    }

    let mode: Mode

    @Environment(\.theme) var theme

    // MARK: - Constants

    private let lineWidth: CGFloat = 2.5
    private let cableHeight: CGFloat = 12
    private let bendHeight: CGFloat = 20
    private let cornerRadius: CGFloat = 3
    private let activeOpacity: Double = 0.75
    private let inactiveOpacity: Double = 0.3

    // MARK: - Body

    var body: some View {
        Group {
            switch mode {
            case .straight(let active, let color):
                straightCable(active: active, color: color)
            case .fork(let leftActive, let rightActive, let leftColor, let rightColor, let from, let hideInactive):
                forkCable(leftActive: leftActive, rightActive: rightActive,
                          leftColor: leftColor, rightColor: rightColor,
                          sourceAnchor: from, hideInactive: hideInactive)
            case .bend(let active, let color, let from):
                bendCable(active: active, color: color, fromAnchor: from)
            }
        }
        .accessibilityHidden(true)
    }

    // MARK: - Straight Cable

    private func straightCable(active: Bool, color: Color) -> some View {
        GeometryReader { geometry in
            let midX = geometry.size.width / 2
            let path = Path { p in
                p.move(to: CGPoint(x: midX, y: 0))
                p.addLine(to: CGPoint(x: midX, y: cableHeight))
            }
            cableStroke(path: path, active: active, color: color)
        }
        .frame(height: cableHeight)
    }

    // MARK: - Fork Cable

    private func forkCable(
        leftActive: Bool, rightActive: Bool,
        leftColor: Color, rightColor: Color,
        sourceAnchor: HorizontalAnchor,
        hideInactive: Bool
    ) -> some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let sourceX = width * sourceAnchor.fraction
            let leftTargetX = width * 0.25
            let rightTargetX = width * 0.75
            let barY = cableHeight * 0.35
            let bottom = cableHeight

            let trunkActive = leftActive || rightActive
            let trunkColor = trunkActive
                ? (leftActive ? leftColor : rightColor)
                : theme.textTertiary

            // When hideInactive is true, only show the active branch
            let bothInactive = !leftActive && !rightActive
            let showLeft = !hideInactive || leftActive || bothInactive
            let showRight = !hideInactive || rightActive || bothInactive

            // Trunk: source top → bar level (show if any branch is visible)
            let trunkPath = Path { p in
                p.move(to: CGPoint(x: sourceX, y: 0))
                p.addLine(to: CGPoint(x: sourceX, y: barY))
            }

            // Left branch: source → left target
            let leftPath = forkBranchPath(from: sourceX, to: leftTargetX, barY: barY, bottom: bottom)

            // Right branch: source → right target
            let rightPath = forkBranchPath(from: sourceX, to: rightTargetX, barY: barY, bottom: bottom)

            ZStack {
                if showLeft || showRight {
                    cableStroke(path: trunkPath, active: trunkActive, color: trunkColor)
                }
                if showLeft {
                    cableStroke(path: leftPath, active: leftActive, color: leftColor)
                }
                if showRight {
                    cableStroke(path: rightPath, active: rightActive, color: rightColor)
                }
            }
        }
        .frame(height: cableHeight)
    }

    // MARK: - Bend Cable (L-Shape from Quarter to Center)

    private func bendCable(active: Bool, color: Color, fromAnchor: HorizontalAnchor) -> some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let sourceX = width * fromAnchor.fraction
            let targetX = width / 2
            let bendY = bendHeight * 0.45

            let path = Path { p in
                p.move(to: CGPoint(x: sourceX, y: 0))
                p.addLine(to: CGPoint(x: sourceX, y: bendY - cornerRadius))

                let bendToRight = targetX > sourceX
                p.addQuadCurve(
                    to: CGPoint(
                        x: sourceX + (bendToRight ? cornerRadius : -cornerRadius),
                        y: bendY
                    ),
                    control: CGPoint(x: sourceX, y: bendY)
                )

                let horizontalEnd = bendToRight
                    ? targetX - cornerRadius
                    : targetX + cornerRadius
                p.addLine(to: CGPoint(x: horizontalEnd, y: bendY))

                p.addQuadCurve(
                    to: CGPoint(x: targetX, y: bendY + cornerRadius),
                    control: CGPoint(x: targetX, y: bendY)
                )

                p.addLine(to: CGPoint(x: targetX, y: bendHeight))
            }

            cableStroke(path: path, active: active, color: color)
        }
        .frame(height: bendHeight)
    }

    // MARK: - Helpers

    @ViewBuilder
    private func cableStroke(path: Path, active: Bool, color: Color) -> some View {
        let cableColor = active ? color : theme.textTertiary
        let opacity = active ? activeOpacity : inactiveOpacity

        path.stroke(
            cableColor.opacity(opacity),
            style: StrokeStyle(lineWidth: lineWidth, lineCap: .round, lineJoin: .round)
        )
        .shadow(color: active ? color.opacity(0.25) : .clear, radius: 3)
    }

    private func forkBranchPath(from startX: CGFloat, to endX: CGFloat, barY: CGFloat, bottom: CGFloat) -> Path {
        Path { path in
            path.move(to: CGPoint(x: startX, y: barY))

            if abs(endX - startX) < 1 {
                // Same position: straight vertical (no horizontal segment)
                path.addLine(to: CGPoint(x: endX, y: bottom))
            } else {
                // L-shaped branch with rounded corner
                let isLeft = endX < startX
                let horizontalEnd = isLeft ? endX + cornerRadius : endX - cornerRadius

                path.addLine(to: CGPoint(x: horizontalEnd, y: barY))

                path.addQuadCurve(
                    to: CGPoint(x: endX, y: barY + cornerRadius),
                    control: CGPoint(x: endX, y: barY)
                )

                path.addLine(to: CGPoint(x: endX, y: bottom))
            }
        }
    }
}
