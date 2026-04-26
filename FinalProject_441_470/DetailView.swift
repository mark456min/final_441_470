//
//  DetailView.swift
//  FinalProject_441_470
//
//  Created by Ativit Tantipisit on 26/4/2569 BE.
//

import SwiftUI

struct DetailView: View {
    // 1. รับค่า ViewModel ตัวเดียวกันมาใช้
    @EnvironmentObject var viewModel: WeatherViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                
                // หัวข้อ: ใช้ชื่อเมืองจริง
                Text("📍 \(viewModel.cityName)")
                    .font(.title2)
                    .bold()
                    .padding(.top)
                    // เพิ่ม multilineTextAlignment เผื่อชื่อเมืองยาว
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                // การ์ดหลัก (เปลี่ยนสีตาม AQI จริง)
                VStack(spacing: 15) {
                    HStack {
                        VStack {
                            // ใช้ค่า AQI จริง
                            Text("\(viewModel.aqi)")
                                .font(.system(size: 40, weight: .bold))
                            Text("US AQI")
                                .font(.caption)
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.white.opacity(0.3)))
                        
                        // แปลงระดับ AQI เป็นคำภาษาอังกฤษ
                        Text(aqiLevelText)
                            .font(.title3).bold() // ปรับเล็กลงนิดนึงเผื่อคำยาว
                        
                        Spacer()
                        
                        // ใช้หน้าสัตว์/Emoji จริง
                        Text(viewModel.petState)
                            .font(.system(size: 50))
                    }
                    
                    Divider()
                    
                    HStack {
                        Text("Main pollutant: PM2.5")
                        Spacer()
                        Text("Real-time data").bold() // API ฟรีไม่มีบอกค่า ug/m3 ตรงๆ เลยใช้คำนี้แทน
                    }
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 15).fill(cardColor))
                .foregroundColor(viewModel.aqi > 50 ? .black : .white) // ปรับสีตัวอักษรให้อ่านง่าย
                .padding(.horizontal)
                
                // ส่วนของพยากรณ์ล่วงหน้า (ใช้ข้อมูลจำลองไปก่อน เพราะ API ฟรีไม่มีให้)
                VStack(alignment: .leading) {
                    Text("Hourly forecast (Mock)")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 20) {
                            ForEach(0..<6) { i in
                                VStack(spacing: 10) {
                                    Text(i == 0 ? "Now" : "2\(i):00")
                                    // จำลองค่าใกล้เคียงกับปัจจุบัน
                                    Text("\(max(0, viewModel.aqi + (i * 2 - 5)))")
                                        .padding(8)
                                        .background(RoundedRectangle(cornerRadius: 8).fill(Color.gray.opacity(0.2)))
                                    Image(systemName: i < 3 ? "sun.max.fill" : "moon.fill")
                                        .foregroundColor(i < 3 ? .orange : .gray)
                                    Text("3\(1-i)°")
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
    
    // MARK: - Logic แปลงคำอธิบาย
    var aqiLevelText: String {
        switch viewModel.aqi {
        case 0...50: return "Good"
        case 51...100: return "Moderate"
        case 101...150: return "Unhealthy for Sensitive Groups"
        case 151...200: return "Unhealthy"
        case 201...300: return "Very Unhealthy"
        default: return "Hazardous"
        }
    }
    
    // MARK: - Logic เปลี่ยนสีการ์ด
    var cardColor: Color {
        switch viewModel.aqi {
        case 0...50: return .green
        case 51...100: return .yellow
        case 101...150: return .orange
        case 151...200: return .red
        case 201...300: return .purple
        default: return Color(red: 0.5, green: 0, blue: 0) // สีเลือดหมู
        }
    }
}

#Preview {
    DetailView().environmentObject(WeatherViewModel())
}
