//
//  ContentView.swift
//  FinalProject_441_470
//
//  Created by Ativit Tantipisit on 20/4/2569 BE.
//

import SwiftUI

struct HomePetView: View {
    @StateObject var viewModel = WeatherViewModel()
    
    var body: some View {
        ZStack {
            // พื้นหลังเปลี่ยนตามค่า AQI
            backgroundColor.ignoresSafeArea()
            
            VStack(spacing: 30) {
                // ส่วนหัว: ชื่อสถานที่
                VStack {
                    Text(viewModel.cityName)
                        .font(.system(size: 28, weight: .bold))
                    Text("ค่าคุณภาพอากาศในตอนนี้")
                        .font(.subheadline)
                }
                .foregroundColor(.white)
                
                // ส่วนสัตว์เลี้ยง: Iconic Pet
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.2))
                        .frame(width: 250, height: 250)
                    
                    Text(viewModel.petState)
                        .font(.system(size: 120))
                        .shadow(radius: 10)
                        // ใส่ Animation เล็กน้อยให้ดูมีชีวิต
                        .scaleEffect(viewModel.aqi > 100 ? 0.9 : 1.0)
                        .animation(.easeInOut(duration: 0.5).repeatForever(), value: viewModel.aqi)
                }
                
                // ส่วนค่าตัวเลข
                VStack {
                    Text("\(viewModel.aqi)")
                        .font(.system(size: 80, weight: .black))
                    Text("AQI (US)")
                        .font(.headline)
                    
                    Text(viewModel.healthMessage)
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .padding(.top, 10)
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 20).fill(.white.opacity(0.9)))
                .padding(.horizontal)
                
                Spacer()
            }
            .padding(.top, 50)
        }
    }
    
    // Logic สีพื้นหลัง
    var backgroundColor: Color {
        switch viewModel.aqi {
        case 0...50: return .green
        case 51...100: return .yellow
        case 101...150: return .orange
        default: return .purple
        }
    }
}

#Preview {
    HomePetView()
}
