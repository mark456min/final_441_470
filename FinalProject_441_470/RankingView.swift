//
//  RankingView.swift
//  FinalProject_441_470
//

import SwiftUI

struct RankingView: View {
    let cities = DataLoader.load().topCities
    @State private var animateBg = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // 🌟 พื้นหลัง Dark Glass
                LinearGradient(colors: [Color(red: 0.05, green: 0.1, blue: 0.2), Color(red: 0.1, green: 0.05, blue: 0.15)], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    LazyVStack(spacing: 12) {
                        ForEach(Array(cities.enumerated()), id: \.element.id) { index, city in
                            HStack(spacing: 15) {
                                // ลำดับ
                                Text("\(index + 1)")
                                    .font(.system(size: 20, weight: .black, design: .rounded))
                                    .foregroundColor(.white.opacity(0.5))
                                    .frame(width: 30, alignment: .leading)
                                
                                Text(city.flag)
                                    .font(.title)
                                
                                Text(city.name)
                                    .font(.system(size: 18, weight: .bold, design: .rounded))
                                    .foregroundColor(.white)
                                
                                Spacer()
                                
                                // ป้าย AQI แบบเรืองแสง
                                Text("\(city.aqi)")
                                    .font(.system(size: 16, weight: .black, design: .rounded))
                                    .foregroundColor(.white)
                                    .frame(width: 50, height: 32)
                                    .background(getAqiColor(aqi: city.aqi))
                                    .clipShape(Capsule())
                                    .shadow(color: getAqiColor(aqi: city.aqi).opacity(0.6), radius: 5, x: 0, y: 0)
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 16)
                            // 🌟 แถบกระจกแต่ละอันดับ
                            .background(.ultraThinMaterial)
                            .environment(\.colorScheme, .dark)
                            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                            .overlay(RoundedRectangle(cornerRadius: 20, style: .continuous).stroke(Color.white.opacity(0.15), lineWidth: 1))
                            .padding(.horizontal, 20)
                        }
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 40)
                }
            }
            .navigationTitle("10 อันดับโลก 🌍")
            // ทำให้ Navigation Bar เข้ากับธีมมืด
            .preferredColorScheme(.dark)
        }
    }
    
    func getAqiColor(aqi: Int) -> Color {
        if aqi > 150 { return .red }
        if aqi > 100 { return .orange }
        if aqi > 50 { return .yellow }
        return .green
    }
}
