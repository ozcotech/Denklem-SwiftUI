
// Placeholder AttorneyFeeTypeView
import SwiftUI

@available(iOS 26.0, *)
struct AttorneyFeeTypeView: View {
	var body: some View {
		VStack(spacing: 24) {
			// TODO: Implement actual UI for dispute type and agreement status selection
			Text("Bu özellik Şubat 2026 güncellemesiyle aktif olacaktır.\nGüncelleme geldiğinde otomatik olarak kullanıma açılacaktır.")
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
