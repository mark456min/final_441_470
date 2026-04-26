//
//  DetailView.swift
//  FinalProject_441_470
//

//
//  DetailView.swift
//  FinalProject_441_470
//

//
//  DetailView.swift
//  FinalProject_441_470
//

import SwiftUI

struct DetailView: View {
    @ObservedObject var viewModel: WeatherViewModel
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                
                // หัวข้อ
                HStack {
                    Image(systemName: "mappin.and.ellipse")
                        .foregroundColor(.red)
                    Text(viewModel.cityName)
                        .font(.system(size: 26, weight: .bold, design: .rounded))
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 10)
                
                // Bento Box 1: การ์ดหลักใหญ่สุด
                HStack(spacing: 20) {
                    // กล่อง AQI
                    VStack(alignment: .leading, spacing: 10) {
                        Text("ดัชนีคุณภาพอากาศ")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.white.opacity(0.8))
                        
                        Text("\(viewModel.aqi)")
                            .font(.system(size: 55, weight: .heavy, design: .rounded))
                            .foregroundColor(.white)
                        
                        Text(getAqiStatus(aqi: viewModel.aqi))
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(Color.black.opacity(0.2))
                            .clipShape(Capsule())
                    }
                    .padding(20)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(premiumGradient(for: viewModel.aqi))
                    .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                    .shadow(color: .black.opacity(0.15), radius: 15, x: 0, y: 10)
                    
                    // กล่อง PM 2.5
                    VStack(alignment: .leading) {
                        Image(systemName: "wind")
                            .font(.title)
                            .foregroundColor(statusColor(for: viewModel.aqi))
                        
                        Spacer()
                        
                        Text("PM 2.5")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        Text("\(Double(viewModel.aqi) * 0.4, specifier: "%.1f")")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                        Text("µg/m³")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .padding(20)
                    .frame(width: 140)
                    .background(Color(UIColor.secondarySystemGroupedBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                    .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 5)
                }
                .padding(.horizontal)
                
                // Bento Box 2: พยากรณ์รายชั่วโมง
                VStack(alignment: .leading) {
                    Text("พยากรณ์รายชั่วโมง")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            ForEach(0..<6, id: \.self) { i in
                                let forecastAqi = viewModel.aqi + (i * 2)
                                VStack(spacing: 12) {
                                    Text(getFormattedTime(plusHours: i))
                                        .font(.subheadline)
                                        .fontWeight(i == 0 ? .bold : .medium)
                                        .foregroundColor(i == 0 ? .primary : .secondary)
                                    
                                    ZStack {
                                        Circle()
                                            .fill(premiumGradient(for: forecastAqi))
                                            .frame(width: 50, height: 50)
                                        
                                        Text("\(forecastAqi)")
                                            .font(.system(size: 18, weight: .bold, design: .rounded))
                                            .foregroundColor(.white)
                                    }
                                    
                                    Image(systemName: isNightTime(plusHours: i) ? "moon.fill" : "sun.max.fill")
                                        .foregroundColor(isNightTime(plusHours: i) ? .blue : .orange)
                                        .font(.system(size: 20))
                                }
                                .padding(.vertical, 15)
                                .padding(.horizontal, 10)
                                .background(Color(UIColor.secondarySystemGroupedBackground))
                                .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 10)
                    }
                }
                
                // Bento Box 3: ระบบแนะนำกิจกรรม (Activity Recommender)
                VStack(alignment: .leading, spacing: 15) {
                    Text("AI แนะนำกิจกรรม")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    let activity = getActivityRecommendation(aqi: viewModel.aqi)
                    
                    HStack(spacing: 20) {
                        ZStack {
                            Circle()
                                .fill(activity.color.opacity(0.2))
                                .frame(width: 60, height: 60)
                            Image(systemName: activity.icon)
                                .font(.system(size: 30))
                                .foregroundColor(activity.color)
                        }
                        
                        Text(activity.text)
                            .font(.system(size: 16, weight: .medium, design: .rounded))
                            .lineSpacing(4)
                        
                        Spacer()
                    }
                    .padding(20)
                    .background(Color(UIColor.secondarySystemGroupedBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                    .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 5)
                    .padding(.horizontal)
                }
                .padding(.bottom, 30)
                
            }
        }
        .background(Color(UIColor.systemGroupedBackground).ignoresSafeArea())
    }
    
    // MARK: - Helper Functions
    func premiumGradient(for aqi: Int) -> LinearGradient {
        switch aqi {
        case 0...50:
            return LinearGradient(colors: [Color(hex: "11998e"), Color(hex: "38ef7d")], startPoint: .topLeading, endPoint: .bottomTrailing)
        case 51...100:
            return LinearGradient(colors: [Color(hex: "f12711"), Color(hex: "f5af19")], startPoint: .topLeading, endPoint: .bottomTrailing)
        case 101...150:
            return LinearGradient(colors: [Color(hex: "FF416C"), Color(hex: "FF4B2B")], startPoint: .topLeading, endPoint: .bottomTrailing)
        default:
            return LinearGradient(colors: [Color(hex: "cb2d3e"), Color(hex: "ef473a")], startPoint: .topLeading, endPoint: .bottomTrailing)
        }
    }
    
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
