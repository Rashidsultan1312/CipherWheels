import SwiftUI

struct LessonDetail: View {
    let lesson: CipherLesson

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                heroBlock
                RoundedCard {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("lesson.what").upperLabel()
                        Text(LocalizedStringKey(lesson.bodyKey))
                            .font(.body)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                RoundedCard(tinted: AtelierAccent.surface(for: lesson.kind)) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("lesson.example").upperLabel()
                        Text(LocalizedStringKey(lesson.exampleKey))
                            .font(.system(.body, design: .monospaced))
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                RoundedCard {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("lesson.who").upperLabel()
                        Text(LocalizedStringKey(lesson.kind.inventorKey))
                            .font(.subheadline.weight(.semibold))
                        Text(LocalizedStringKey(lesson.kind.yearKey))
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 16)
        }
        .background(AtelierCanvas(opacity: 0.32, imageName: AtelierBackdrop.named(for: lesson.kind)))
        .navigationTitle(Text(LocalizedStringKey(lesson.kind.titleKey)))
        .navigationBarTitleDisplayMode(.inline)
    }

    private var heroBlock: some View {
        HStack(spacing: 14) {
            Image(systemName: lesson.kind.symbol)
                .font(.system(size: 44, weight: .semibold))
                .foregroundStyle(AtelierAccent.tint(for: lesson.kind))
            VStack(alignment: .leading, spacing: 4) {
                Text(LocalizedStringKey(lesson.kind.titleKey))
                    .font(.title2.weight(.bold))
                Text(LocalizedStringKey(lesson.kind.subtitleKey))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Spacer()
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(AtelierAccent.surface(for: lesson.kind))
        )
    }
}
