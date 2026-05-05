//
//  RankingView.swift
//  FinalProject_441_470
//

import SwiftUI

struct RankingView: View {
    // โหลดข้อมูลมาจากไฟล์ JSON
    let allCities = DataLoader.load().topCities
    
    // State สำหรับรับค่าที่พิมพ์ค้นหา และ สถานะการเรียงลำดับ
    @State private var searchText = ""
    @State private var isAscending = false // ค่าเริ่มต้นคือ มากไปน้อย
    
    // ฟังก์ชันกรองข้อมูลและเรียงลำดับแบบ Real-time
    var filteredAndSortedCities: [CityRanking] {
        var result = allCities
        
        // 1. ถ้ามีการพิมพ์ค้นหา ให้กรองเอาเฉพาะชื่อที่ตรงกัน
        if !searchText.isEmpty {
            result = result.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
        
        // 2. เรียงลำดับ (มากไปน้อย หรือ น้อยไปมาก)
        result.sort { isAscending ? $0.aqi < $1.aqi : $0.aqi > $1.aqi }
        
        return result
    }
    
    var body: some View {
        NavigationView {
            List(Array(filteredAndSortedCities.enumerated()), id: \.element.id) { index, city in
                HStack {
                    // เลขอันดับ
                    Text("\(index + 1)")
                        .font(.headline)
                        .foregroundColor(.secondary)
                        .frame(width: 30, alignment: .leading)
                    
                    Text(city.flag)
                        .font(.title2)
                    
                    Text(city.name)
                        .font(.body)
                    
                    Spacer()
                    
                    // ป้ายค่า AQI
                    Text("\(city.aqi)")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .frame(width: 45, height: 30)
                        .background(RoundedRectangle(cornerRadius: 6).fill(getAqiColor(aqi: city.aqi)))
                }
                .padding(.vertical, 4)
            }
            .navigationTitle("จัดอันดับ AQI")
            .listStyle(InsetGroupedListStyle())
            // เพิ่มแถบค้นหา
            .searchable(text: $searchText, prompt: "ค้นหาเมือง หรือ ประเทศ...")
            // เพิ่มปุ่มจัดเรียงด้านขวาบน
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        withAnimation {
                            isAscending.toggle() // สลับโหมดการเรียง
                        }
                    }) {
                        Image(systemName: "arrow.up.arrow.down")
                            .foregroundColor(.blue)
                    }
                }
            }
        }
    }
    
    func getAqiColor(aqi: Int) -> Color {
        if aqi > 150 { return .red }
        if aqi > 100 { return .orange }
        if aqi > 50 { return .yellow }
        return .green
    }
}
