//
//  DetailView.swift
//  FinalProject_441_470
//

import SwiftUI

struct DetailView: View {
    // รับ viewModel มาจาก ContentView
    @ObservedObject var viewModel: WeatherViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                
                // หัวข้อ (ใช้ชื่อเมืองจริงๆ จาก API)
                Text("📍 \(viewModel.cityName)")
                    .font(.title2)
                    .bold()
                    .padding(.top)
                
                // การ์ดหลัก (เปลี่ยนสีตามค่า AQI)
                VStack(spacing: 15) {
                    HStack {
                        VStack {
                            Text("\(viewModel.aqi)") // ดึง AQI จริงมาโชว์
                                .font(.system(size: 40, weight: .bold))
                            Text("US AQI")
                                .font(.caption)
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.white.opacity(0.3)))
                        
                        Text(getAqiStatus(aqi: viewModel.aqi)) // คำอธิบายภาษาอังกฤษ
                            .font(.title2).bold()
                        
                        Spacer()
                        
                        Text(viewModel.petState) // ใช้หน้า Pet ตัวเดิม
                            .font(.system(size: 50))
                    }
                    
                    Divider()
                    
                    HStack {
                        Text("Main pollutant: PM2.5")
                        Spacer()
                        // ค่าประมาณการ PM2.5 (ถ้าไม่มี API ให้มา)
                        Text("\(Double(viewModel.aqi) * 0.4, specifier: "%.1f") µg/m³").bold()
                    }
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 15).fill(backgroundColor(for: viewModel.aqi)))
                .padding(.horizontal)
                
                // พยากรณ์รายชั่วโมง (เลื่อนแนวนอน)
                VStack(alignment: .leading) {
                    Text("Hourly forecast")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 20) {
                            ForEach(0..<6, id: \.self) { i in
                                
                                // จำลองค่าฝุ่นในชั่วโมงถัดๆ ไป (บวกเพิ่มนิดหน่อยให้ดูสมจริง)
                                let forecastAqi = viewModel.aqi + (i * 2)
                                
                                VStack(spacing: 10) {
                                    // โชว์เวลาจริง (Now, 14:00, 15:00)
                                    Text(getFormattedTime(plusHours: i))
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                    
                                    Text("\(forecastAqi)")
                                        .font(.system(size: 18, weight: .bold))
                                        .padding(8)
                                        .background(RoundedRectangle(cornerRadius: 8).fill(backgroundColor(for: forecastAqi)))
                                    
                                    // ถ้าเป็นกลางคืนโชว์พระจันทร์ กลางวันโชว์พระอาทิตย์
                                    Image(systemName: isNightTime(plusHours: i) ? "moon.fill" : "sun.max.fill")
                                        .foregroundColor(isNightTime(plusHours: i) ? .gray : .orange)
                                    
                                    Text("30°")
                                        .font(.caption)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical)
                .background(RoundedRectangle(cornerRadius: 15).fill(Color.white).shadow(radius: 2))
                .padding(.horizontal)
                
            }
        }
        .background(Color(UIColor.systemGroupedBackground))
    }
    
    // MARK: - Functions คำนวณเวลาและสี
    
    // 1. ฟังก์ชันหาเวลาล่วงหน้า
    func getFormattedTime(plusHours: Int) -> String {
        if plusHours == 0 { return "Now" }
        let calendar = Calendar.current
        if let futureDate = calendar.date(byAdding: .hour, value: plusHours, to: Date()) {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:00" // ฟอร์แมตเวลา 24 ชั่วโมง
            return formatter.string(from: futureDate)
        }
        return ""
    }
    
    // 2. ฟังก์ชันเช็คเวลากลางคืน (หลัง 6 โมงเย็น ถึง ตี 5)
    func isNightTime(plusHours: Int) -> Bool {
        let calendar = Calendar.current
        if let futureDate = calendar.date(byAdding: .hour, value: plusHours, to: Date()) {
            let hour = calendar.component(.hour, from: futureDate)
            return hour >= 18 || hour <= 5
        }
        return false
    }
    
    // 3. ฟังก์ชันจัดสีตาม AQI มาตรฐานสากล
    func backgroundColor(for aqi: Int) -> Color {
        switch aqi {
        case 0...50: return .green
        case 51...100: return .yellow
        case 101...150: return .orange
        case 151...200: return .red
        default: return .purple
        }
    }
    
    // 4. คำอธิบายสถานะภาษาอังกฤษ
    func getAqiStatus(aqi: Int) -> String {
        switch aqi {
        case 0...50: return "Good"
        case 51...100: return "Moderate"
        case 101...150: return "Unhealthy"
        case 151...200: return "Unhealthy"
        default: return "Hazardous"
        }
    }
}
