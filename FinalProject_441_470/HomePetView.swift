//
//  HomePetView.swift
//  FinalProject_441_470
//

import SwiftUI

struct HomePetView: View {
    @ObservedObject var viewModel: WeatherViewModel
    
    @State private var showMiniGame = false
    @State private var petScale: CGFloat = 1.0
    @State private var showShareSheet = false
    @State private var shareImage: UIImage?
    
    // อนิเมชั่นพื้นหลัง
    @State private var animateGradient = false
    
    var body: some View {
        ZStack {
            // 1. พื้นหลังแบบ Dynamic Gradient
            backgroundGradient
                .ignoresSafeArea()
                .hueRotation(.degrees(animateGradient ? 15 : 0))
                .animation(.easeInOut(duration: 5.0).repeatForever(autoreverses: true), value: animateGradient)
                .onAppear { animateGradient = true }
            
            VStack(spacing: 25) {
                // ส่วนหัว: Location & Status
                VStack(spacing: 8) {
                    HStack {
                        Image(systemName: "location.fill")
                        Text(viewModel.cityName)
                    }
                    .font(.system(size: 24, weight: .heavy, design: .rounded))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
                    
                    Text("สภาพอากาศปัจจุบัน")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.white.opacity(0.8))
                }
                .padding(.top, 20)
                
                // ส่วนสัตว์เลี้ยง: Glowing Orb
                ZStack {
                    // แสงออร่าด้านหลัง
                    Circle()
                        .fill(glowColor)
                        .frame(width: 260, height: 260)
                        .blur(radius: 40)
                        .opacity(0.6)
                    
                    // กระจกรองพื้น
                    Circle()
                        .fill(.ultraThinMaterial)
                        .frame(width: 220, height: 220)
                        .shadow(color: .black.opacity(0.15), radius: 20, x: 0, y: 10)
                        .overlay(
                            Circle().stroke(Color.white.opacity(0.3), lineWidth: 1)
                        )
                    
                    Text(viewModel.petState)
                        .font(.system(size: 130))
                        .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 10)
                        .scaleEffect(petScale)
                        // ให้ตัวละครลอยขึ้นลงเบาๆ
                        .offset(y: animateGradient ? -5 : 5)
                        .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: animateGradient)
                        .onTapGesture {
                            let impactMed = UIImpactFeedbackGenerator(style: .medium)
                            impactMed.impactOccurred()
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.4)) {
                                petScale = 1.2
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                withAnimation { petScale = 1.0 }
                                showMiniGame = true
                            }
                        }
                }
                .padding(.vertical, 10)
                
                // ส่วนค่าตัวเลขแบบ Glassmorphism Card
                VStack(spacing: 5) {
                    Text("\(viewModel.aqi)")
                        .font(.system(size: 85, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
                    
                    Text("US AQI")
                        .font(.headline)
                        .foregroundColor(.white.opacity(0.8))
                        .tracking(2) // เพิ่มช่องไฟตัวอักษรให้ดูพรีเมียม
                    
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.white.opacity(0.2))
                        .padding(.vertical, 10)
                    
                    Text(viewModel.healthMessage)
                        .font(.system(size: 18, weight: .medium, design: .rounded))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                }
                .padding(30)
                .background(.ultraThinMaterial) // ใช้ Material UI ของ Apple
                .clipShape(RoundedRectangle(cornerRadius: 35, style: .continuous))
                .shadow(color: .black.opacity(0.15), radius: 30, x: 0, y: 15)
                .overlay(
                    RoundedRectangle(cornerRadius: 35, style: .continuous)
                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                )
                .padding(.horizontal, 25)
                
                Spacer()
                
                // ปุ่มแชร์แบบ Premium
                Button(action: {
                    shareImage = renderShareCard()
                    showShareSheet = true
                }) {
                    HStack {
                        Image(systemName: "square.and.arrow.up.circle.fill")
                            .font(.system(size: 24))
                        Text("แชร์สภาพอากาศ")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(
                        LinearGradient(colors: [Color.white.opacity(0.2), Color.white.opacity(0.05)], startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
                    .clipShape(Capsule())
                    .overlay(Capsule().stroke(Color.white.opacity(0.3), lineWidth: 1))
                    .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
                }
                .padding(.horizontal, 25)
                .padding(.bottom, 20)
            }
        }
        .sheet(isPresented: $showMiniGame) {
            PetMiniGameView(petState: viewModel.petState)
        }
        .sheet(isPresented: $showShareSheet) {
            if let image = shareImage {
                ShareSheet(items: [image])
            }
        }
    }
    
    // MARK: - Premium Styling
    var backgroundGradient: LinearGradient {
        switch viewModel.aqi {
        case 0...50:
            return LinearGradient(colors: [Color(hex: "00B4DB"), Color(hex: "0083B0")], startPoint: .topLeading, endPoint: .bottomTrailing)
        case 51...100:
            return LinearGradient(colors: [Color(hex: "F2C94C"), Color(hex: "F2994A")], startPoint: .topLeading, endPoint: .bottomTrailing)
        case 101...150:
            return LinearGradient(colors: [Color(hex: "FF416C"), Color(hex: "FF4B2B")], startPoint: .topLeading, endPoint: .bottomTrailing)
        default:
            return LinearGradient(colors: [Color(hex: "8A2387"), Color(hex: "E94057")], startPoint: .topLeading, endPoint: .bottomTrailing)
        }
    }
    
    var glowColor: Color {
        switch viewModel.aqi {
        case 0...50: return .cyan
        case 51...100: return .yellow
        case 101...150: return .orange
        default: return .purple
        }
    }
    
    @MainActor
    func renderShareCard() -> UIImage? {
        let cardView = ZStack {
            backgroundGradient.ignoresSafeArea()
            VStack(spacing: 20) {
                Text("📍 \(viewModel.cityName)")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                Text(viewModel.petState)
                    .font(.system(size: 150))
                    .shadow(radius: 10)
                Text("AQI: \(viewModel.aqi)")
                    .font(.system(size: 60, weight: .black, design: .rounded))
                    .foregroundColor(.white)
                Text(viewModel.healthMessage)
                    .font(.title3).bold().foregroundColor(.white).multilineTextAlignment(.center)
                Text("ตรวจวัดโดย Weather Pet")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
                    .padding(.top, 30)
            }
            .padding(40)
        }
        let renderer = ImageRenderer(content: cardView)
        renderer.scale = UIScreen.main.scale
        return renderer.uiImage
    }
}

// Extension เพิ่มสี HEX
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default: (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(.sRGB, red: Double(r) / 255, green: Double(g) / 255, blue:  Double(b) / 255, opacity: Double(a) / 255)
    }
}

// โครงสร้างสำหรับเรียกหน้าต่างแชร์ (แก้ไข Error "Cannot find 'ShareSheet' in scope")
struct ShareSheet: UIViewControllerRepresentable {
    var items: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        // ไม่ต้องทำอะไรเพิ่มตรงนี้
    }
}
