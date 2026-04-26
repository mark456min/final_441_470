//
//  RankingView.swift
//  FinalProject_441_470
//
//  Created by Ativit Tantipisit on 26/4/2569 BE.
//

import SwiftUI

struct RankingView: View {
    // ข้อมูลจำลองสำหรับโชว์
    let mockCities = [
        ("Chiang Mai, Thailand", 157, "🇹🇭"),
        ("Yangon, Myanmar", 155, "🇲🇲"),
        ("Riyadh, Saudi Arabia", 152, "🇸🇦"),
        ("Ulaanbaatar, Mongolia", 148, "🇲🇳"),
        ("Chongqing, China", 139, "🇨🇳")
    ]
    
    var body: some View {
        NavigationView {
            List(0..<mockCities.count, id: \.self) { index in
                HStack {
                    Text("\(index + 1)").font(.headline).frame(width: 30, alignment: .leading)
                    Text(mockCities[index].2).font(.title2) // ธงชาติ
                    Text(mockCities[index].0).font(.body) // ชื่อเมือง
                    
                    Spacer()
                    
                    // ป้าย AQI สีแดง/ส้ม
                    Text("\(mockCities[index].1)")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.vertical, 5)
                        .padding(.horizontal, 10)
                        .background(RoundedRectangle(cornerRadius: 8).fill(mockCities[index].1 > 150 ? Color.red : Color.orange))
                }
                .padding(.vertical, 4)
            }
            .navigationTitle("Ranking (Worldwide)")
            .listStyle(PlainListStyle())
        }
    }
}
