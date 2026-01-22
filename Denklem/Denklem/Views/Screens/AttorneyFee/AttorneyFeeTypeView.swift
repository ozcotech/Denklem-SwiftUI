
// Placeholder AttorneyFeeTypeView
import SwiftUI

@available(iOS 26.0, *)
struct AttorneyFeeTypeView: View {
	var body: some View {
		VStack(spacing: 24) {
			Text("Attorney Fee Type View")
				.font(.title)
				.foregroundColor(.secondary)
			Text("Bu ekran yakında eklenecek.")
				.font(.body)
				.foregroundColor(.gray)
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		.background(Color(.systemBackground))
	}
}

@available(iOS 26.0, *)
struct AttorneyFeeTypeView_Previews: PreviewProvider {
	static var previews: some View {
		AttorneyFeeTypeView()
	}
}
