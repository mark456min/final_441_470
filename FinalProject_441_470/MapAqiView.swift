//
//  MapAqiView.swift
//  FinalProject_441_470
//

import SwiftUI
import MapKit

struct MapAqiView: View {
    let pins = DataLoader.load().bkkDistricts
    
    @State private var position: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 13.7563, longitude: 100.5018),
            span: MKCoordinateSpan(latitudeDelta: 0.35, longitudeDelta: 0.35)
        )
    )
    
    // ตัวแปรเก็บข้อมูลว่าตอนนี้ผู้ใช้กำลังแตะ (Select) หมุดเขตไหนอยู่
    @State private var selectedDistrict: AqiPin?
    
    var body: some View {
        ZStack(alignment: .bottom) {
            
            // 1. ตัวแผนที่
            Map(position: $position) {
                ForEach(pins) { pin in
                    Annotation(pin.name, coordinate: pin.coordinate) {
                        VStack(spacing: 0) {
                            ZStack {
                                Circle()
                                    .fill(getPinColor(aqi: pin.aqi))
                                    // ถ้าโดนเลือกให้หมุดใหญ่ขึ้น
                                    .frame(width: selectedDistrict?.id == pin.id ? 45 : 32,
                                           height: selectedDistrict?.id == pin.id ? 45 : 32)
                                    .shadow(radius: 3)
                                
                                Text("\(pin.aqi)")
                                    .font(.system(size: selectedDistrict?.id == pin.id ? 14 : 11, weight: .bold))
                                    .foregroundColor(.black)
                            }
                        }
                        .scaleEffect(selectedDistrict?.id == pin.id ? 1.1 : 1.0)
                        .animation(.spring(response: 0.3, dampingFraction: 0.5), value: selectedDistrict?.id)
                        .onTapGesture {
                            // เมื่อแตะหมุด ให้เก็บข้อมูลเขตนั้น
                            withAnimation(.easeInOut) {
                                selectedDistrict = pin
                            }
                        }
                    }
                }
            }
            .ignoresSafeArea(edges: .top)
            // ถ้ากดที่ว่างๆ บนแผนที่ ให้ปิดการ์ด
            .onTapGesture {
                withAnimation {
                    selectedDistrict = nil
                }
            }
            
            // 2. การ์ดรายละเอียดที่จะโผล่ขึ้นมาด้านล่าง
            if let district = selectedDistrict {
                VStack(spacing: 12) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("เขต\(district.name)")
                                .font(.title3).bold()
                            Text("กรุงเทพมหานคร")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        // ปุ่มกากบาทปิด
                        Button(action: {
                            withAnimation { selectedDistrict = nil }
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.title2)
                                .foregroundColor(.gray.opacity(0.6))
                        }
                    }
                    
                    Divider()
                    
                    HStack {
                        Text("AQI: \(district.aqi)")
                            .font(.system(size: 20, weight: .black, design: .rounded))
                            .foregroundColor(getPinColor(aqi: district.aqi))
                        
                        Spacer()
                        
                        Text(getAqiStatus(aqi: district.aqi))
                            .font(.subheadline)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(getPinColor(aqi: district.aqi).opacity(0.2))
                            .clipShape(Capsule())
                    }
                }
                .padding(20)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                .shadow(color: Color.black.opacity(0.15), radius: 15, x: 0, y: 5)
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
                // อนิเมชั่นเลื่อนขึ้นมาจากขอบจอด้านล่าง
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
    }
    
    // ฟังก์ชันคำนวณสี
    func getPinColor(aqi: Int) -> Color {
        if aqi > 150 { return .red }
        if aqi > 100 { return .orange }
        if aqi > 50 { return .yellow }
        return .green
    }
    
    // ฟังก์ชันคำอธิบาย
    func getAqiStatus(aqi: Int) -> String {
        if aqi > 150 { return "อันตราย 🤮" }
        if aqi > 100 { return "ค่อนข้างสูง 😰" }
        if aqi > 50 { return "ปานกลาง 😐" }
        return "อากาศดี 🐶"
    }
}
