import SwiftUI

struct LeconsScreen: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 12) {
                    ForEach(CipherLessonCatalog.all) { lesson in
                        NavigationLink(destination: LessonDetail(lesson: lesson)) {
                            LessonCard(lesson: lesson)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 18)
                .padding(.vertical, 16)
            }
            .background(AtelierCanvas(opacity: 0.32, imageName: "Backdrops/bd-quill"))
            .navigationTitle("tab.lecons")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
