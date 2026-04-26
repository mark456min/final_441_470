//
//  ContentView.swift
//  FinalProject_441_470
//
//  Created by Ativit Tantipisit on 26/4/2569 BE.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            // 1. หน้าสัตว์เลี้ยงดึง API จริง (โค้ดเดิมของคุณ)
            HomePetView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("หน้าแรก")
                }
            
            // 2. หน้าจัดอันดับ
            RankingView()
                .tabItem {
                    Image(systemName: "list.number")
                    Text("จัดอันดับ")
                }
            
            // 3. หน้าแผนที่
            MapAqiView()
                .tabItem {
                    Image(systemName: "map.fill")
                    Text("แผนที่")
                }
            
            // 4. หน้ารายละเอียด
            DetailView()
                .tabItem {
                    Image(systemName: "info.circle.fill")
                    Text("รายละเอียด")
                }
        }
        .accentColor(.blue) // สีของปุ่ม Tab ที่ถูกเลือก
    }
}
