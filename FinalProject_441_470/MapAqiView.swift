//
//  MapAqiView.swift
//  FinalProject_441_470
//

import SwiftUI
import MapKit // อย่าลืม import MapKit

struct MapAqiView: View {
    // โหลดข้อมูลพิกัดมาจากไฟล์ JSON (แบบที่คุณมาร์คทำไว้)
    let pins = DataLoader.load().bkkDistricts
    
    // [แก้ไข 1]: เปลี่ยนจาก MKCoordinateRegion มาใช้ MapCameraPosition (สำหรับ iOS 17+)
    @State private var position: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 13.7563, longitude: 100.5018),
            span: MKCoordinateSpan(latitudeDelta: 0.35, longitudeDelta: 0.35)
        )
    )
    
    var body: some View {
        // [แก้ไข 2]: โครงสร้าง Map แบบใหม่
        Map(position: $position) {
            // ใช้ ForEach วนลูปสร้างหมุดบนแผนที่
            ForEach(pins) { pin in
                // [แก้ไข 3]: ใช้ Annotation แทน MapAnnotation
                Annotation(pin.name, coordinate: pin.coordinate) {
                    VStack(spacing: 0) {
                        ZStack {
                            Circle()
                                .fill(getPinColor(aqi: pin.aqi))
                                .frame(width: 32, height: 32)
                                .shadow(radius: 2)
                            
                            Text("\(pin.aqi)")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(.black)
                        }
                    }
                }
            }
        }
        .ignoresSafeArea(edges: .top)
    }
    
    // ฟังก์ชันคำนวณสีตามค่า AQI เหมือนเดิม
    func getPinColor(aqi: Int) -> Color {
        if aqi > 150 { return Color.red }
        if aqi > 100 { return Color.orange }
        if aqi > 50 { return Color.yellow }
        return Color.green
    }
}
