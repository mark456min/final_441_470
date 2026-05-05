//
//  HomePetView.swift
//  FinalProject_441_470
//

import SwiftUI

struct HomePetView: View {
    @ObservedObject var viewModel: WeatherViewModel
    
    @Environment(\.displayScale) var displayScale
    
    @State private var showMiniGame = false
    @State private var petScale: CGFloat = 1.0
    @State private var showShareSheet = false
    @State private var shareImage: UIImage?
    
    // อนิเมชั่น
    @State private var isFloating = false
    @State private var animateBackground = false
    
    var body: some View {
        ZStack {
            // 🌟 Dynamic Breathing Background
            AnimatedBackground(aqi: viewModel.aqi, animate: $animateBackground)
            
            VStack(spacing: 0) {
                
                // 📍 ส่วนหัว (หลบรอยบาก/Dynamic Island)
                VStack(spacing: 6) {
                    HStack {
                        Image(systemName: "location.fill")
                        Text(viewModel.cityName)
                    }
                    .font(.system(size: 26, weight: .heavy, design: .rounded))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
                    
                    Text("คุณภาพอากาศวันนี้")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.white.opacity(0.8))
                }
                .padding(.top, 40)
                
                Spacer(minLength: 10)
                
                // 🐶 ส่วนสัตว์เลี้ยง (Glass Orb)
                VStack(spacing: 16) {
                    ZStack {
                        Circle()
                            .fill(Color.white.opacity(0.1))
                            .frame(width: 210, height: 210)
                            .background(.ultraThinMaterial)
                            .clipShape(Circle())
                            .overlay(
                                Circle().stroke(LinearGradient(colors: [.white.opacity(0.6), .clear, .white.opacity(0.2)], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 1.5)
                            )
                            .shadow(color: Color.black.opacity(0.15), radius: 20, x: 0, y: 10)
                        
                        Image(viewModel.petState)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 130, height: 130)
                            .scaleEffect(petScale)
                            .offset(y: isFloating ? -8 : 8)
                            .animation(.easeInOut(duration: 2.5).repeatForever(autoreverses: true), value: isFloating)
                            .onAppear {
                                isFloating = true
                                animateBackground = true
                            }
                            .onTapGesture {
                                let impact = UIImpactFeedbackGenerator(style: .medium)
                                impact.impactOccurred()
                                
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
                                    petScale = 1.2
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                                    withAnimation { petScale = 1.0 }
                                    showMiniGame = true
                                }
                            }
                    }
                    
                    // ป้ายบอกอารมณ์แมว (Glass Capsule)
                    Text(getPetEmotionText(for: viewModel.aqi))
                        .font(.system(size: 15, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(.ultraThinMaterial)
                        .clipShape(Capsule())
                        .overlay(Capsule().stroke(Color.white.opacity(0.4), lineWidth: 1))
                        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 4)
                }
                
                Spacer(minLength: 15)
                
                // 📊 ส่วนการ์ดข้อมูล AQI (Glassmorphism) + 📤 ปุ่มแชร์ขวาบน
                ZStack(alignment: .topTrailing) {
                    VStack(spacing: 16) {
                        VStack(spacing: -4) {
                            Text("\(viewModel.aqi)")
                                .font(.system(size: 76, weight: .black, design: .rounded))
                                .foregroundColor(.white)
                                .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 2)
                            
                            Text("AQI (US)")
                                .font(.system(size: 14, weight: .bold, design: .rounded))
                                .foregroundColor(.white.opacity(0.7))
                        }
                        
                        // สัญญาณไฟ (Neon Glass Lights)
                        HStack(spacing: 15) {
                            GlassSignalLight(emoji: "😊", glowColor: .green, isActive: viewModel.aqi <= 50)
                            GlassSignalLight(emoji: "🤧", glowColor: .yellow, isActive: viewModel.aqi > 50 && viewModel.aqi <= 100)
                            GlassSignalLight(emoji: "😷", glowColor: .red, isActive: viewModel.aqi > 100)
                        }
                        .padding(.vertical, 5)
                        
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(.white.opacity(0.3))
                            .padding(.horizontal, 40)
                        
                        Text(viewModel.healthMessage)
                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                            .padding(.bottom, 5)
                    }
                    .padding(.vertical, 25)
                    .frame(maxWidth: .infinity)
                    
                    // 🌟 ปุ่มแชร์ (ย้ายมาไว้มุมขวาบนของการ์ด)
                    Button(action: {
                        shareImage = renderShareCard()
                        showShareSheet = true
                    }) {
                        ZStack {
                            Circle()
                                .fill(Color.white.opacity(0.15))
                                .frame(width: 40, height: 40)
                            Image(systemName: "square.and.arrow.up")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.white)
                        }
                    }
                    .padding(20) // ระยะขอบจากมุมการ์ด
                }
                .background(.ultraThinMaterial)
                .environment(\.colorScheme, .dark)
                .clipShape(RoundedRectangle(cornerRadius: 35, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 35, style: .continuous)
                        .stroke(LinearGradient(colors: [.white.opacity(0.8), .white.opacity(0.1)], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 1.5)
                )
                .shadow(color: Color.black.opacity(0.2), radius: 30, x: 0, y: 15)
                .padding(.horizontal, 24)
                
                Spacer(minLength: 15)
                
                // 💡 การ์ดกิจกรรมแนะนำ (ย้ายมาจาก DetailView แทนที่ปุ่มแชร์เดิม)
                let activity = getActivityRecommendation(aqi: viewModel.aqi)
                VStack(alignment: .leading, spacing: 10) {
                    Text("💡 กิจกรรมแนะนำ")
                        .font(.system(size: 14, weight: .bold, design: .rounded))
                        .foregroundColor(.white.opacity(0.7))
                    
                    HStack(spacing: 15) {
                        ZStack {
                            Circle()
                                .fill(activity.color.opacity(0.2))
                                .frame(width: 45, height: 45)
                            Image(systemName: activity.icon)
                                .font(.system(size: 22))
                                .foregroundColor(activity.color)
                                .shadow(color: activity.color.opacity(0.5), radius: 5)
                        }
                        
                        Text(activity.text)
                            .font(.system(size: 14, weight: .medium, design: .rounded))
                            .lineSpacing(4)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .padding(20)
                .background(.ultraThinMaterial)
                .environment(\.colorScheme, .dark)
                .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 25, style: .continuous)
                        .stroke(LinearGradient(colors: [.white.opacity(0.6), .white.opacity(0.1)], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.15), radius: 15, x: 0, y: 8)
                .padding(.horizontal, 24)
                .padding(.bottom, 25)
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
    
    // MARK: - Logic
    func getPetEmotionText(for aqi: Int) -> String {
        switch aqi {
        case 0...50: return "อากาศดี๊ดี น้องแฮปปี้! 😸"
        case 51...100: return "ฝุ่นเริ่มมา น้องเซ็งแล้วนะ 😾"
        case 101...150: return "แค่กๆ! น้องหายใจไม่ออก 🙀"
        default: return "ไม่ไหวแล้ววว! ฝุ่นเต็มปอด 😿"
        }
    }
    
    // 🌟 ดึงฟังก์ชันกิจกรรมแนะนำมาใช้งานในหน้านี้
    func getActivityRecommendation(aqi: Int) -> (text: String, icon: String, color: Color) {
        if aqi <= 50 {
            return ("อากาศเคลียร์! เหมาะกับการออกไปวิ่ง หรือซ้อมบาสเกตบอลกลางแจ้งมากๆ 🏀", "figure.basketball", .green)
        } else if aqi <= 100 {
            return ("อากาศปานกลาง เดินเล่นชิลๆ ได้ แต่เลี่ยงการเหนื่อยหอบหนักๆ นะ 🚶", "figure.walk", .yellow)
        } else if aqi <= 150 {
            return ("ฝุ่นเริ่มเยอะ แนะนำให้เข้ายิมไปเวทเทรนนิ่งสร้างกล้ามเนื้อดีกว่า 🏋️", "dumbbell.fill", .orange)
        } else {
            return ("อากาศอันตราย! งดออกบ้าน แล้วนั่งกด Valorant อยู่ห้องยาวๆ ไปเลย 🎮", "gamecontroller.fill", .red)
        }
    }
    
    var aqiTextColor: Color {
        switch viewModel.aqi {
        case 0...50: return .green
        case 51...100: return .yellow
        case 101...150: return .orange
        default: return .red
        }
    }
    
    @MainActor
    func renderShareCard() -> UIImage? {
        let cardView = ZStack {
            Color.black.ignoresSafeArea()
            AnimatedBackground(aqi: viewModel.aqi, animate: .constant(false))
            
            VStack(spacing: 20) {
                Text("📍 \(viewModel.cityName)")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                
                Image(viewModel.petState)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                
                VStack {
                    Text("AQI: \(viewModel.aqi)")
                        .font(.system(size: 50, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                    Text(viewModel.healthMessage)
                        .font(.body).bold()
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                }
                .padding(20)
                .background(.ultraThinMaterial)
                .environment(\.colorScheme, .dark)
                .clipShape(RoundedRectangle(cornerRadius: 20))
            }
            .padding(40)
        }
        
        let renderer = ImageRenderer(content: cardView)
        renderer.scale = displayScale
        return renderer.uiImage
    }
}

// 🌟 1. ระบบพื้นหลังขยับได้ (Dynamic Mesh Gradient Effect)
struct AnimatedBackground: View {
    var aqi: Int
    @Binding var animate: Bool
    
    var body: some View {
        ZStack {
            baseColor.ignoresSafeArea()
            
            GeometryReader { proxy in
                Circle()
                    .fill(glowColor)
                    .frame(width: proxy.size.width * 1.5)
                    .blur(radius: 60)
                    .offset(x: animate ? -50 : 50, y: animate ? -50 : 50)
                
                Circle()
                    .fill(glowColor2)
                    .frame(width: proxy.size.width * 1.2)
                    .blur(radius: 80)
                    .offset(x: animate ? 100 : -100, y: animate ? 100 : -50)
            }
            .animation(.easeInOut(duration: 7.0).repeatForever(autoreverses: true), value: animate)
        }
    }
    
    var baseColor: Color {
        switch aqi {
        case 0...50: return Color(red: 0.1, green: 0.6, blue: 0.8)
        case 51...100: return Color(red: 0.9, green: 0.6, blue: 0.1)
        case 101...150: return Color(red: 0.9, green: 0.3, blue: 0.2)
        default: return Color(red: 0.5, green: 0.1, blue: 0.5)
        }
    }
    
    var glowColor: Color {
        switch aqi {
        case 0...50: return .green
        case 51...100: return .orange
        case 101...150: return .red
        default: return .purple
        }
    }
    
    var glowColor2: Color {
        switch aqi {
        case 0...50: return .mint
        case 51...100: return .yellow
        case 101...150: return .pink
        default: return .red
        }
    }
}

// 🌟 2. สัญญาณไฟฝังในกระจก (Neon Glass Light)
struct GlassSignalLight: View {
    var emoji: String
    var glowColor: Color
    var isActive: Bool
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color.white.opacity(isActive ? 0.2 : 0.05))
                .background(.ultraThinMaterial)
                .environment(\.colorScheme, .light)
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                .frame(width: 55, height: 55)
            
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(isActive ? glowColor.opacity(0.8) : Color.white.opacity(0.2), lineWidth: isActive ? 2 : 0.5)
                .frame(width: 55, height: 55)
            
            Text(emoji)
                .font(.system(size: 26))
                .grayscale(isActive ? 0.0 : 1.0)
                .opacity(isActive ? 1.0 : 0.3)
        }
        .shadow(color: isActive ? glowColor.opacity(0.6) : .clear, radius: 10, x: 0, y: 0)
        .animation(.spring(response: 0.4, dampingFraction: 0.6), value: isActive)
    }
}

// ตัวช่วยสำหรับหน้าต่างแชร์
struct ShareSheet: UIViewControllerRepresentable {
    var items: [Any]
    func makeUIViewController(context: Context) -> UIActivityViewController {
        return UIActivityViewController(activityItems: items, applicationActivities: nil)
    }
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
