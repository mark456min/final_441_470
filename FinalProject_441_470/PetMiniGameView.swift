//
//  PetMiniGameView.swift
//  FinalProject_441_470
//

import SwiftUI

struct PetMiniGameView: View {
    @Environment(\.presentationMode) var presentationMode
    var petState: String
    
    @State private var isPlaying = false
    @State private var timeRemaining = 10
    @State private var score = 0
    @State private var happiness = 0
    
    @State private var dustPositions: [CGPoint] = []
    @State private var gameTimer: Timer?
    @State private var animateBg = false
    
    var body: some View {
        ZStack {
            // 🌟 พื้นหลังเกมแนว Sci-fi / Gaming Gradient
            LinearGradient(colors: [Color(red: 0.1, green: 0.1, blue: 0.4), Color(red: 0.3, green: 0.1, blue: 0.4)], startPoint: animateBg ? .topLeading : .bottomTrailing, endPoint: animateBg ? .bottomTrailing : .topLeading)
                .ignoresSafeArea()
                .animation(.easeInOut(duration: 5.0).repeatForever(autoreverses: true), value: animateBg)
                .onAppear { animateBg = true }
            
            VStack {
                // แถบเมนูด้านบน (Glass Capsule)
                HStack {
                    Button(action: {
                        gameTimer?.invalidate()
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 32))
                            .foregroundColor(.white.opacity(0.8))
                    }
                    Spacer()
                    Text("ความสุข: \(happiness) ❤️")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(.ultraThinMaterial)
                        .environment(\.colorScheme, .dark)
                        .clipShape(Capsule())
                        .overlay(Capsule().stroke(Color.white.opacity(0.3), lineWidth: 1))
                }
                .padding()
                
                Spacer()
                
                // กระดานคะแนนและเวลา (Glass Panel)
                if isPlaying {
                    HStack(spacing: 50) {
                        VStack {
                            Text("เวลา")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.7))
                            Text("\(timeRemaining)")
                                .font(.system(size: 40, weight: .black, design: .rounded))
                                .foregroundColor(timeRemaining <= 3 ? .red : .white)
                        }
                        VStack {
                            Text("คะแนน")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.7))
                            Text("\(score)")
                                .font(.system(size: 40, weight: .black, design: .rounded))
                                .foregroundColor(.yellow)
                        }
                    }
                    .padding(.horizontal, 40)
                    .padding(.vertical, 20)
                    .background(.ultraThinMaterial)
                    .environment(\.colorScheme, .dark)
                    .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                    .overlay(RoundedRectangle(cornerRadius: 30, style: .continuous).stroke(Color.white.opacity(0.3), lineWidth: 1))
                    .shadow(color: .black.opacity(0.3), radius: 20, x: 0, y: 10)
                } else {
                    // หน้าจอเริ่มเกม (Glass Panel)
                    VStack(spacing: 20) {
                        Text("🎮 ปัดฝุ่นช่วยน้อง!")
                            .font(.system(size: 32, weight: .heavy, design: .rounded))
                            .foregroundColor(.white)
                            .shadow(color: .blue.opacity(0.5), radius: 10)
                        
                        Text("จิ้มก้อนฝุ่น 💨 ที่ลอยมาให้ไวที่สุด\nก่อนที่น้องจะสูดเข้าไปเต็มปอด!")
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white.opacity(0.8))
                        
                        Button(action: startGame) {
                            Text("เริ่มเล่นเลย")
                                .font(.title3)
                                .bold()
                                .padding()
                                .frame(width: 220)
                                .background(LinearGradient(colors: [.green, .mint], startPoint: .leading, endPoint: .trailing))
                                .foregroundColor(.white)
                                .clipShape(Capsule())
                                .shadow(color: .green.opacity(0.5), radius: 10, x: 0, y: 5)
                        }
                        .padding(.top, 10)
                    }
                    .padding(40)
                    .background(.ultraThinMaterial)
                    .environment(\.colorScheme, .dark)
                    .clipShape(RoundedRectangle(cornerRadius: 35, style: .continuous))
                    .overlay(RoundedRectangle(cornerRadius: 35, style: .continuous).stroke(Color.white.opacity(0.3), lineWidth: 1))
                    .shadow(color: .black.opacity(0.4), radius: 30, x: 0, y: 15)
                }
                
                Spacer()
                
                // สัตว์เลี้ยง
                Image(petState)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 180, height: 180)
                    .shadow(color: .black.opacity(0.3), radius: 15, x: 0, y: 10)
                    .offset(y: isPlaying ? -20 : 0)
                    .animation(isPlaying ? .easeInOut(duration: 0.4).repeatForever(autoreverses: true) : .default, value: isPlaying)
                    .padding(.bottom, 50)
            }
            
            // Render ฝุ่น
            if isPlaying {
                ForEach(0..<dustPositions.count, id: \.self) { index in
                    if index < dustPositions.count {
                        Text("💨")
                            .font(.system(size: 60))
                            .shadow(color: .white.opacity(0.5), radius: 10) // เพิ่มเงาให้ฝุ่นดูพรีเมียม
                            .position(dustPositions[index])
                            .onTapGesture {
                                let impactLight = UIImpactFeedbackGenerator(style: .light)
                                impactLight.impactOccurred()
                                
                                withAnimation {
                                    score += 10
                                    happiness += 5
                                    dustPositions[index] = randomPosition()
                                }
                            }
                    }
                }
            }
        }
    }
    
    // MARK: - Game Logic
    func startGame() {
        isPlaying = true
        score = 0
        timeRemaining = 10
        happiness = 0
        dustPositions = [randomPosition(), randomPosition(), randomPosition()]
        
        gameTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            if timeRemaining > 0 {
                timeRemaining -= 1
                withAnimation(.easeInOut(duration: 0.8)) {
                    for i in 0..<dustPositions.count {
                        if i < dustPositions.count {
                            dustPositions[i] = randomPosition()
                        }
                    }
                }
            } else {
                timer.invalidate()
                withAnimation {
                    isPlaying = false
                    dustPositions.removeAll()
                }
            }
        }
    }
    
    func randomPosition() -> CGPoint {
        let x = CGFloat.random(in: 50...300)
        let y = CGFloat.random(in: 150...500)
        return CGPoint(x: x, y: y)
    }
}
