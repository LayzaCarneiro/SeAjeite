import SwiftUI

struct PremiumProfileSection: View {
    let displayName: String
    let displayAge: String
    let displayIssue: String

    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            ZStack {
                Circle()
                    .foregroundColor(.accentColor.opacity(0.7))
                    .frame(width: 72, height: 72)

                Image(systemName: "person.fill").resizable().aspectRatio(contentMode: .fit).frame(width: 30).foregroundColor(.white)
            }
            .overlay(Circle().stroke(Color(.systemGray5), lineWidth: 1))
            
            VStack(alignment: .leading, spacing: 6) {
                Text(displayName)
                    .font(.system(.title3, design: .rounded))
                    .fontWeight(.bold)
                
                HStack(spacing: 8) {
                    Text("\(displayAge) years")
                    Text("•").foregroundColor(.accentColor)
                    Text(displayIssue)
                        .foregroundColor(.accentColor)
                        .fontWeight(.semibold)
                }
                .font(.subheadline)
                .foregroundColor(.secondary)
            }
            Spacer()
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.03), radius: 10, x: 0, y: 4)
        )
        .padding(.horizontal)
    }
}
