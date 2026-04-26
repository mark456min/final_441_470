//
//  MapAqiView.swift
//  FinalProject_441_470
//
//  Created by Ativit Tantipisit on 26/4/2569 BE.
//

import SwiftUI
import MapKit

struct MapAqiView: View {
    // ตั้งพิกัดเริ่มต้นไปที่กรุงเทพฯ
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 13.7563, longitude: 100.5018),
        span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
    )
    
    // พิกัดจำลองสำหรับปักหมุด
    let mockPins = [
        AqiPin(lat: 13.7563, lon: 100.5018, aqi: 110),
        AqiPin(lat: 13.8000, lon: 100.5500, aqi: 82),
        AqiPin(lat: 13.7200, lon: 100.4500, aqi: 55)
    ]
    
    var body: some View {
        Map(coordinateRegion: $region, annotationItems: mockPins) { pin in
            MapAnnotation(coordinate: pin.coordinate) {
                // ออกแบบวงกลมบอกค่า AQI บนแผนที่
                ZStack {
                    Circle()
                        .fill(pin.aqi > 100 ? Color.orange : Color.yellow)
                        .frame(width: 40, height: 40)
                        .shadow(radius: 3)
                    Text("\(pin.aqi)")
                        .font(.caption)
                        .bold()
                }
            }
        }
        .ignoresSafeArea(edges: .top)
    }
}

// Model สำหรับหมุดแผนที่
struct AqiPin: Identifiable {
    let id = UUID()
    let lat: Double
    let lon: Double
    let aqi: Int
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: lat, longitude: lon)
    }
}
