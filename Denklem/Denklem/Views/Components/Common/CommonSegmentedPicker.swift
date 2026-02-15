//
//  CommonSegmentedPicker.swift
//  Denklem
//
//  Created by ozkan on 15.02.2026.
//
//  Reusable segmented picker for shared iOS 26 native segmented controls.
//
//  Current adopters with .large control size:
//  - TenancySelectionView (required enum selection)
//  - MediationFeeView (optional enum selection + dynamic tint)
//  - AttorneyFeeView (optional enum selection)
//  - ReinstatementSheet (optional enum selection)
//
//  Intentionally not adopted yet:
//  - AboutView (kept as-is without .large to preserve current UX)
//

import SwiftUI

@available(iOS 26.0, *)
enum CommonSegmentedSelection<Option: Hashable> {
    case required(Binding<Option>)
    case optional(Binding<Option?>)
}

/// Shared segmented picker wrapper supporting both required and optional enum-based selection.
@available(iOS 26.0, *)
struct CommonSegmentedPicker<Option: Hashable, Label: View>: View {
    private let selection: CommonSegmentedSelection<Option>
    private let options: [Option]
    private let controlSize: ControlSize
    private let tint: Color?
    private let labelFont: Font
    private let minimumLabelScaleFactor: CGFloat
    private let labelBuilder: (Option) -> Label

    init(
        selection: CommonSegmentedSelection<Option>,
        options: [Option],
        controlSize: ControlSize = .large,
        tint: Color? = nil,
        labelFont: Font = .subheadline.weight(.semibold),
        minimumLabelScaleFactor: CGFloat = 0.75,
        @ViewBuilder label: @escaping (Option) -> Label
    ) {
        self.selection = selection
        self.options = options
        self.controlSize = controlSize
        self.tint = tint
        self.labelFont = labelFont
        self.minimumLabelScaleFactor = minimumLabelScaleFactor
        self.labelBuilder = label
    }

    var body: some View {
        Group {
            switch selection {
            case .required(let binding):
                Picker("", selection: binding) {
                    ForEach(options, id: \.self) { option in
                        labelBuilder(option)
                            .tag(option)
                    }
                }
            case .optional(let binding):
                Picker("", selection: binding) {
                    ForEach(options, id: \.self) { option in
                        labelBuilder(option)
                            .tag(option as Option?)
                    }
                }
            }
        }
        .font(labelFont)
        .lineLimit(1)
        .minimumScaleFactor(minimumLabelScaleFactor)
        .pickerStyle(.segmented)
        .controlSize(controlSize)
        .applyTintIfNeeded(tint)
    }
}

@available(iOS 26.0, *)
private extension View {
    @ViewBuilder
    func applyTintIfNeeded(_ tint: Color?) -> some View {
        if let tint {
            self.tint(tint)
        } else {
            self
        }
    }
}
