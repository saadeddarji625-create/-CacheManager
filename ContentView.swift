import SwiftUI

struct PatchModel: Identifiable {
    var id = UUID()
    var name: String
    var targetPath: String
    var isApplied: Bool
}

class CacheEngine: ObservableObject {
    @Published var isAuthenticated = false
    @Published var keyInput = ""
    @Published var statusMessage = "أدخل مفتاح الاشتراك"
    @Published var patches = [
        PatchModel(name: "Unlock 144 FPS Cache", targetPath: "Library/Caches/FPS.plist", isApplied: false),
        PatchModel(name: "Aim Assist Textures", targetPath: "Documents/GameData/Textures.bundle", isApplied: false),
        PatchModel(name: "Clear Trash & Temp Cache", targetPath: "tmp/CacheCleaner.tmp", isApplied: false)
    ]
    
    func verifyKey() {
        if keyInput == "3105-VIP-2026" || keyInput == "ADMIN" {
            isAuthenticated = true
            statusMessage = "تم تسجيل الدخول بنجاح!"
        } else {
            statusMessage = "المفتاح غير صحيح!"
        }
    }
    
    func togglePatch(at index: Int) {
        patches[index].isApplied.toggle()
        statusMessage = patches[index].isApplied ? "تم تطبيق: \(patches[index].name)" : "تم إلغاء: \(patches[index].name)"
    }
}

@main
struct CacheManagerApp: App {
    @StateObject private var engine = CacheEngine()
    
    var body: some Scene {
        WindowGroup {
            if engine.isAuthenticated {
                NavigationView {
                    List {
                        Section(header: Text("الـ Patches المتاحة")) {
                            ForEach(0..<engine.patches.count, id: \.self) { i in
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(engine.patches[i].name).font(.headline)
                                        Text(engine.patches[i].targetPath).font(.caption).foregroundColor(.gray)
                                    }
                                    Spacer()
                                    Button(engine.patches[i].isApplied ? "مفعل" : "تفعيل") {
                                        engine.togglePatch(at: i)
                                    }
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 5)
                                    .background(engine.patches[i].isApplied ? Color.green : Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                                }
                            }
                        }
                    }
                    .navigationTitle("Cache Manager 3105")
                }
            } else {
                VStack(spacing: 20) {
                    Text("CACHE MANAGER").font(.largeTitle).bold()
                    SecureField("أدخل الـ Key هنا", text: $engine.keyInput)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                    Button("تسجيل الدخول") {
                        engine.verifyKey()
                    }
                    .padding()
                    .background(Color.yellow)
                    .foregroundColor(.black)
                    .cornerRadius(10)
                    Text(engine.statusMessage).foregroundColor(.gray)
                }
            }
        }
    }
}
