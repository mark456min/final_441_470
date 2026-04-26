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
    
    @State private var isFloating = false
    
    var body: some View {
        ZStack {
            backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // 📍 ส่วนหัว: สถานที่
                VStack(spacing: 4) {
                    HStack {
                        Image(systemName: "location.fill")
                        Text(viewModel.cityName)
                    }
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                    
                    Text("คุณภาพอากาศวันนี้")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 20)
                
                Spacer()
                
                // 🐶 ส่วนสัตว์เลี้ยง
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.4))
                        .frame(width: 240, height: 240)
                    
                    Text(viewModel.petState)
                        .font(.system(size: 140))
                        .scaleEffect(petScale)
                        .offset(y: isFloating ? -8 : 8)
                        .animation(.easeInOut(duration: 2.5).repeatForever(autoreverses: true), value: isFloating)
                        .onAppear { isFloating = true }
                        .onTapGesture {
                            let impact = UIImpactFeedbackGenerator(style: .medium)
                            impact.impactOccurred()
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
                                petScale = 1.15
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                                withAnimation { petScale = 1.0 }
                                showMiniGame = true
                            }
                        }
                }
                
                Spacer()
                
                // 📊 ส่วนการ์ดข้อมูล
                VStack(spacing: 12) {
                    Text("\(viewModel.aqi)")
                        .font(.system(size: 72, weight: .bold, design: .rounded))
                        .foregroundColor(aqiTextColor)
                    
                    Text("AQI (US)")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    Divider()
                        .padding(.horizontal, 40)
                    
                    Text(viewModel.healthMessage)
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                .padding(.vertical, 30)
                .frame(maxWidth: .infinity)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                .shadow(color: Color.black.opacity(0.06), radius: 20, x: 0, y: 10)
                .padding(.horizontal, 24)
                
                // 📤 ปุ่มแชร์
                Button(action: {
                    shareImage = renderShareCard()
                    showShareSheet = true
                }) {
                    HStack {
                        Image(systemName: "square.and.arrow.up")
                            .font(.system(size: 18, weight: .semibold))
                        Text("แชร์ให้เพื่อน")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                    }
                    .foregroundColor(Color.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .shadow(color: Color.blue.opacity(0.3), radius: 8, x: 0, y: 4)
                }
                .padding(.horizontal, 24)
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
    
    // MARK: - Design Logic
    var backgroundGradient: LinearGradient {
        switch viewModel.aqi {
        case 0...50:
            return LinearGradient(colors: [Color.green.opacity(0.3), Color.green.opacity(0.05)], startPoint: .top, endPoint: .bottom)
        case 51...100:
            return LinearGradient(colors: [Color.yellow.opacity(0.3), Color.yellow.opacity(0.05)], startPoint: .top, endPoint: .bottom)
        case 101...150:
            return LinearGradient(colors: [Color.orange.opacity(0.3), Color.orange.opacity(0.05)], startPoint: .top, endPoint: .bottom)
        default:
            return LinearGradient(colors: [Color.red.opacity(0.3), Color.red.opacity(0.05)], startPoint: .top, endPoint: .bottom)
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
            Color.white.ignoresSafeArea()
            VStack(spacing: 20) {
                Text("📍 \(viewModel.cityName)")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                Text(viewModel.petState)
                    .font(.system(size: 120))
                Text("AQI: \(viewModel.aqi)")
                    .font(.system(size: 50, weight: .black, design: .rounded))
                    .foregroundColor(aqiTextColor)
                Text(viewModel.healthMessage)
                    .font(.body).bold().multilineTextAlignment(.center)
            }
            .padding(40)
        }
        let renderer = ImageRenderer(content: cardView)
        renderer.scale = UIScreen.main.scale
        return renderer.uiImage
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
