import SwiftUI

// MARK: - 1. สร้าง Extension สำหรับจับการเขย่าเครื่อง
extension UIDevice {
    static let deviceDidShakeNotification = Notification.Name(rawValue: "deviceDidShakeNotification")
}

extension UIWindow {
    open override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            NotificationCenter.default.post(name: UIDevice.deviceDidShakeNotification, object: nil)
        }
    }
}

// Modifier เพื่อความสะดวกในการใช้งาน
struct DeviceShakeViewModifier: ViewModifier {
    let action: () -> Void

    func body(content: Content) -> some View {
        content
            .onAppear()
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.deviceDidShakeNotification)) { _ in
                action()
            }
    }
}

extension View {
    func onShake(perform action: @escaping () -> Void) -> some View {
        self.modifier(DeviceShakeViewModifier(action: action)) // ✅ ส่งค่า action ต่อเข้าไป
    }
}

// MARK: - 2. หน้า Mini Game
struct PetMiniGameView: View {
    var petState: String
    
    // ระดับฝุ่น 1.0 คือฝุ่นเต็ม 100%, 0.0 คือสะอาด
    @State private var dustLevel: CGFloat = 1.0
    @State private var isShaking = false
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 40) {
                // หัวข้อ
                Text(dustLevel > 0 ? "เขย่าโทรศัพท์เพื่อไล่ฝุ่น! 📱💨" : "น้องสะอาดแล้ว! ✨")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                // กราฟิกสัตว์เลี้ยงและฝุ่น
                                ZStack {
                                    // 1. รูปสัตว์เลี้ยง
                                    Image(petState)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 220, height: 220)
                                        // 🌟 ทำให้ภาพสัตว์เลี้ยงดูมัวและสีซีดลงตอนที่ฝุ่นเยอะ
                                        .grayscale(Double(dustLevel))
                                        .blur(radius: dustLevel * 6)
                                        // เอฟเฟกต์ตอนเขย่า
                                        .offset(x: isShaking ? CGFloat.random(in: -10...10) : 0,
                                                y: isShaking ? CGFloat.random(in: -10...10) : 0)
                                        .animation(.default, value: isShaking)
                                    
                                    // 2. กลุ่มก้อนฝุ่นที่บังหน้าสัตว์เลี้ยง
                                    ZStack {
                                        // สุ่มสร้างก้อนฝุ่นขึ้นมา 6 ก้อนเพื่อบังให้มิด
                                        ForEach(0..<6, id: \.self) { _ in
                                            Image(systemName: "cloud.dust.fill")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: CGFloat.random(in: 120...220))
                                                // ใช้สลับสีฝุ่นเข้ม-อ่อนให้ดูมีมิติ
                                                .foregroundColor(Color(white: Double.random(in: 0.4...0.7)))
                                                .offset(
                                                    x: CGFloat.random(in: -90...90),
                                                    y: CGFloat.random(in: -90...90)
                                                )
                                                // หมุนก้อนฝุ่นแบบสุ่มให้ดูเป็นธรรมชาติ
                                                .rotationEffect(.degrees(Double.random(in: -45...45)))
                                        }
                                    }
                                    // 🌟 ผูกค่าความทึบแสง (Opacity) กับระดับฝุ่น เมื่อเขย่า ฝุ่นจะค่อยๆ จาง
                                    .opacity(Double(dustLevel))
                                    // เพิ่มแอนิเมชันให้ฝุ่นจางลงแบบนุ่มนวล
                                    .animation(.easeInOut(duration: 0.5), value: dustLevel)
                                }
                // หลอดความคืบหน้า (Progress Bar)
                VStack(spacing: 12) {
                    Text("ระดับฝุ่นควัน")
                        .font(.headline)
                        .foregroundColor(.white.opacity(0.8))
                    
                    GeometryReader { proxy in
                        ZStack(alignment: .leading) {
                            Capsule()
                                .fill(Color.white.opacity(0.15))
                            
                            Capsule()
                                // เปลี่ยนสีหลอดตามระดับฝุ่น
                                .fill(dustLevel > 0.5 ? Color.red : (dustLevel > 0 ? Color.yellow : Color.green))
                                .frame(width: proxy.size.width * dustLevel)
                        }
                    }
                    .frame(height: 24)
                    .padding(.horizontal, 40)
                }
                
                // ปุ่มเสร็จสิ้น จะแสดงเมื่อฝุ่นหมด
                if dustLevel <= 0 {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("กลับหน้าหลัก")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundColor(.black)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.green)
                            .cornerRadius(16)
                            .padding(.horizontal, 40)
                    }
                    .transition(.scale.combined(with: .opacity))
                } else {
                    // ดัน Layout ไม่ให้ขยับตอนปุ่มโผล่มา
                    Spacer().frame(height: 56)
                }
            }
            .padding(.vertical, 30)
        }
        // ตรวจจับการเขย่าเครื่อง
        .onShake {
            if dustLevel > 0 {
                // สั่น Haptic Feedback ที่มือถือเพื่อให้รู้ว่ากำลังเขย่าอยู่
                let impact = UIImpactFeedbackGenerator(style: .heavy)
                impact.impactOccurred()
                
                // แอนิเมชันลดฝุ่นและการสั่นของตัวการ์ตูน
                withAnimation(.easeOut(duration: 0.2)) {
                    isShaking = true
                    dustLevel -= 0.15 // เขย่า 1 ครั้งลดฝุ่น 15% (ปรับเลขนี้เพื่อเพิ่ม/ลดความยาก)
                    if dustLevel < 0 { dustLevel = 0 }
                }
                
                // หยุดสั่นตัวการ์ตูนหลังจากเขย่า
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    isShaking = false
                }
            }
        }
    }
}
