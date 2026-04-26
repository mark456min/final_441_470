//
//  DetailView.swift
//  FinalProject_441_470
//

import SwiftUI

struct DetailView: View {
    @ObservedObject var viewModel: WeatherViewModel
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 16) {
                
                // หัวข้อ
                HStack {
                    Text(viewModel.cityName)
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                    Spacer()
                    Image(systemName: "location.circle.fill")
                        .font(.title)
                        .foregroundColor(.blue)
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)
                
                // 📦 การ์ด 1: สรุปค่ามลพิษ
                VStack(spacing: 0) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("ดัชนีคุณภาพอากาศ")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Text("\(viewModel.aqi)")
                                .font(.system(size: 48, weight: .bold, design: .rounded))
                                .foregroundColor(statusColor(for: viewModel.aqi))
                            Text(getAqiStatus(aqi: viewModel.aqi))
                                .font(.headline)
                                .foregroundColor(.primary)
                        }
                        Spacer()
                        Text(viewModel.petState)
                            .font(.system(size: 60))
                    }
                    .padding(20)
                    
                    Divider()
                        .padding(.leading, 20)
                    
                    // ค่า PM 2.5
                    HStack {
                        Image(systemName: "wind")
                            .foregroundColor(.gray)
                        Text("ฝุ่นละออง PM 2.5")
                            .font(.subheadline)
                        Spacer()
                        Text("\(Double(viewModel.aqi) * 0.4, specifier: "%.1f") µg/m³")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                    }
                    .padding(20)
                }
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                .padding(.horizontal, 20)
                
                // 📦 การ์ด 2: พยากรณ์รายชั่วโมง
                VStack(alignment: .leading, spacing: 12) {
                    Text("พยากรณ์รายชั่วโมง")
                        .font(.headline)
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(0..<6, id: \.self) { i in
                                let forecastAqi = viewModel.aqi + (i * 2)
                                VStack(spacing: 12) {
                                    Text(getFormattedTime(plusHours: i))
                                        .font(.caption)
                                        .foregroundColor(i == 0 ? .blue : .secondary)
                                        .fontWeight(i == 0 ? .bold : .regular)
                                    
                                    Image(systemName: isNightTime(plusHours: i) ? "moon.fill" : "sun.max.fill")
                                        .font(.title2)
                                        .foregroundColor(isNightTime(plusHours: i) ? .gray : .orange)
                                    
                                    Text("\(forecastAqi)")
                                        .font(.system(size: 16, weight: .bold, design: .rounded))
                                        .foregroundColor(statusColor(for: forecastAqi))
                                }
                                .padding(.vertical, 16)
                                .frame(width: 70)
                                .background(Color(UIColor.secondarySystemBackground))
                                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)
                    }
                }
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                .padding(.horizontal, 20)
                
                // 📦 การ์ด 3: แนะนำกิจกรรม
                VStack(alignment: .leading, spacing: 16) {
                    Text("กิจกรรมแนะนำวันนี้")
                        .font(.headline)
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                    
                    let activity = getActivityRecommendation(aqi: viewModel.aqi)
                    
                    HStack(spacing: 16) {
                        Image(systemName: activity.icon)
                            .font(.system(size: 24))
                            .foregroundColor(.white)
                            .frame(width: 50, height: 50)
                            .background(activity.color)
                            .clipShape(Circle())
                        
                        Text(activity.text)
                            .font(.system(size: 15))
                            .lineSpacing(4)
                            .foregroundColor(.primary)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
                
            }
        }
        .background(Color(UIColor.systemGroupedBackground).ignoresSafeArea())
    }
    
    // MARK: - Helper Functions
    func statusColor(for aqi: Int) -> Color {
        switch aqi {
        case 0...50: return .green
        case 51...100: return .yellow
        case 101...150: return .orange
        default: return .red
        }
    }
    
    func getFormattedTime(plusHours: Int) -> String {
        if plusHours == 0 { return "ตอนนี้" }
        let calendar = Calendar.current
        if let futureDate = calendar.date(byAdding: .hour, value: plusHours, to: Date()) {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:00"
            return formatter.string(from: futureDate)
        }
        return ""
    }
    
    func isNightTime(plusHours: Int) -> Bool {
        let calendar = Calendar.current
        if let futureDate = calendar.date(byAdding: .hour, value: plusHours, to: Date()) {
            let hour = calendar.component(.hour, from: futureDate)
            return hour >= 18 || hour <= 5
        }
        return false
    }
    
    func getAqiStatus(aqi: Int) -> String {
        switch aqi {
        case 0...50: return "คุณภาพดีมาก"
        case 51...100: return "ปานกลาง"
        case 101...150: return "เริ่มมีผลกระทบ"
        default: return "อันตราย"
        }
    }
    
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
}
