//
//  DetailView.swift
//  FinalProject_441_470
//
//  Created by Ativit Tantipisit on 26/4/2569 BE.
//

import SwiftUI

struct DetailView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                
                // หัวข้อ
                Text("📍 Shrewsbury City Campus")
                    .font(.title2)
                    .bold()
                    .padding(.top)
                
                // การ์ดหลัก (สีเหลือง)
                VStack(spacing: 15) {
                    HStack {
                        VStack {
                            Text("60")
                                .font(.system(size: 40, weight: .bold))
                            Text("US AQI")
                                .font(.caption)
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.white.opacity(0.3)))
                        
                        Text("Moderate")
                            .font(.title2).bold()
                        
                        Spacer()
                        
                        Text("😐") // หน้าคน/สัตว์
                            .font(.system(size: 50))
                    }
                    
                    Divider()
                    
                    HStack {
                        Text("Main pollutant: PM2.5")
                        Spacer()
                        Text("14.0 µg/m³").bold()
                    }
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 15).fill(Color.yellow))
                .padding(.horizontal)
                
                // พยากรณ์รายชั่วโมง (เลื่อนแนวนอน)
                VStack(alignment: .leading) {
                    Text("Hourly forecast")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 20) {
                            ForEach(0..<6) { i in
                                VStack(spacing: 10) {
                                    Text(i == 0 ? "Now" : "2\(i):00")
                                    Text("\(60 + i)")
                                        .padding(8)
                                        .background(RoundedRectangle(cornerRadius: 8).fill(Color.yellow))
                                    Image(systemName: "moon.fill").foregroundColor(.gray)
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
}
