//
//  ContentView.swift
//  FinalProject_441_470
//
//  Created by Ativit Tantipisit on 26/4/2569 BE.
//

import SwiftUI

struct ContentView: View {
    // 1. สร้าง ViewModel ไว้ที่หน้าหลักตัวเดียว
    @StateObject var viewModel = WeatherViewModel()
    
    var body: some View {
        TabView {
            HomePetView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("หน้าแรก")
                }
            
            RankingView()
                .tabItem {
                    Image(systemName: "list.number")
                    Text("จัดอันดับ")
                }
            
            MapAqiView()
                .tabItem {
                    Image(systemName: "map.fill")
                    Text("แผนที่")
                }
            
            DetailView()
                .tabItem {
                    Image(systemName: "info.circle.fill")
                    Text("รายละเอียด")
                }
        }
        .accentColor(.blue)
        // 2. แชร์ viewModel ให้ทุกหน้าใน TabView เข้าถึงได้
        .environmentObject(viewModel)
    }
}
