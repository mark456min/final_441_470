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
    
    var body: some View {
        ZStack {
            Color.blue.opacity(0.7).ignoresSafeArea()
            
            VStack {
                // แถบเมนูด้านบน
                HStack {
                    Button(action: {
                        gameTimer?.invalidate()
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title)
                            .foregroundColor(.white)
                    }
                    Spacer()
                    Text("ความสุข: \(happiness) ❤️")
                        .font(.headline)
                        .padding(8)
                        .background(Capsule().fill(Color.white.opacity(0.8)))
                }
                .padding()
                
                Spacer()
                
                // กระดานคะแนนและเวลา
                if isPlaying {
                    HStack(spacing: 40) {
                        VStack {
                            Text("เวลา")
                            Text("\(timeRemaining)")
                                .font(.title).bold()
                        }
                        VStack {
                            Text("คะแนน")
                            Text("\(score)")
                                .font(.title).bold()
                        }
                    }
                    .foregroundColor(.white)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 15).fill(Color.black.opacity(0.4)))
                } else {
                    // หน้าจอเริ่มเกม
                    VStack(spacing: 20) {
                        Text("🎮 ปัดฝุ่นช่วยน้อง!")
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(.white)
                        
                        Text("จิ้มก้อนฝุ่น 💨 ที่ลอยมาให้ไวที่สุด\nก่อนที่น้องจะสูดเข้าไปเต็มปอด!")
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white)
                        
                        Button(action: startGame) {
                            Text("เริ่มเล่นเลย")
                                .font(.title2)
                                .bold()
                                .padding()
                                .frame(width: 200)
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(15)
                                .shadow(radius: 5)
                        }
                    }
                }
                
                Spacer()
                
                // สัตว์เลี้ยง
                Text(petState)
                    .font(.system(size: 150))
                    .offset(y: isPlaying ? -20 : 0)
                    .animation(isPlaying ? .easeInOut(duration: 0.4).repeatForever(autoreverses: true) : .default, value: isPlaying)
                    .padding(.bottom, 50)
            }
            
            // 🌟 แก้ไขจุดที่ทำให้แอปแครช (ใส่เงื่อนไข if ป้องกัน)
            if isPlaying {
                ForEach(0..<dustPositions.count, id: \.self) { index in
                    // เช็คก่อนว่ายังมีข้อมูลใน Array อยู่จริงๆ ไหม
                    if index < dustPositions.count {
                        Text("💨")
                            .font(.system(size: 60))
                            .position(dustPositions[index])
                            .onTapGesture {
                                let impactLight = UIImpactFeedbackGenerator(style: .light)
                                impactLight.impactOccurred()
                                
                                withAnimation {
                                    score += 10
                                    happiness += 5
                                    // สุ่มตำแหน่งใหม่เมื่อกดโดน
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
                // ให้ฝุ่นขยับตำแหน่ง
                withAnimation(.easeInOut(duration: 0.8)) {
                    for i in 0..<dustPositions.count {
                        if i < dustPositions.count {
                            dustPositions[i] = randomPosition()
                        }
                    }
                }
            } else {
                // หมดเวลา
                timer.invalidate()
                withAnimation {
                    isPlaying = false
                    // ล้างข้อมูลฝุ่นทิ้งอย่างปลอดภัย
                    dustPositions.removeAll()
                }
            }
        }
    }
    
    // ฟังก์ชันสุ่มพิกัดให้ฝุ่น
    func randomPosition() -> CGPoint {
        let x = CGFloat.random(in: 50...300)
        let y = CGFloat.random(in: 150...500)
        return CGPoint(x: x, y: y)
    }
}
