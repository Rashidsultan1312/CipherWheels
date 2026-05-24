import SwiftUI

struct LessonCard: View {
    let lesson: CipherLesson

    var body: some View {
        RoundedCard(tinted: AtelierAccent.surface(for: lesson.kind)) {
            HStack(spacing: 14) {
                ZStack {
                    Circle()
                        .fill(AtelierAccent.tint(for: lesson.kind).opacity(0.18))
                        .frame(width: 52, height: 52)
                    Image(systemName: lesson.kind.symbol)
                        .font(.title3.weight(.semibold))
                        .foregroundStyle(AtelierAccent.tint(for: lesson.kind))
                }
                VStack(alignment: .leading, spacing: 4) {
                    Text(LocalizedStringKey(lesson.kind.titleKey))
                        .font(.headline)
                    Text(LocalizedStringKey(lesson.kind.subtitleKey))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundStyle(.secondary)
            }
        }
    }
}
