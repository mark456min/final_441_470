//
//  RankingView.swift
//  FinalProject_441_470
//
//  Created by Ativit Tantipisit on 26/4/2569 BE.
//

import SwiftUI

struct RankingView: View {
    // ข้อมูลจำลอง 10 อันดับเมืองที่มีมลพิษสูงสุด (ข้อมูลสมมติเพื่อการแสดงผล)
    let cities = DataLoader.load().topCities
    var body: some View {
        NavigationView {
            List(Array(cities.enumerated()), id: \.element.id) { index, city in
                HStack {
                                    Text("\(index + 1)")
                                        .font(.headline)
                                        .frame(width: 30, alignment: .leading)
                                    
                                    Text(city.flag) // เข้าถึงข้อมูลผ่านชื่อตัวแปรที่อ่านง่าย
                                        .font(.title2)
                                    
                                    Text(city.name)
                                        .font(.body)
                                    
                                    Spacer()
                                    
                                    Text("\(city.aqi)")
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(.white)
                                        .frame(width: 45, height: 30)
                                        .background(RoundedRectangle(cornerRadius: 6).fill(getAqiColor(aqi: city.aqi)))
                                }
                                .padding(.vertical, 4)
                            }
                            .navigationTitle("10 อันดับโลก")
                            .listStyle(InsetGroupedListStyle())
                        }
                    }
                    
                    func getAqiColor(aqi: Int) -> Color {
                        if aqi > 150 { return .purple }
                        if aqi > 100 { return .red }
                        return .orange
                    }
                }
