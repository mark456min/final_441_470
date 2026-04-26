import SwiftUI

struct DetailView: View {
    // รับข้อมูลจาก ContentView
    @EnvironmentObject var viewModel: WeatherViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("📍 \(viewModel.cityName)")
                    .font(.title2)
                    .bold()
                    .padding(.top)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                VStack(spacing: 15) {
                    HStack {
                        VStack {
                            Text("\(viewModel.aqi)")
                                .font(.system(size: 40, weight: .bold))
                            Text("US AQI")
                                .font(.caption)
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.white.opacity(0.3)))
                        
                        Text(aqiLevelText)
                            .font(.title3).bold()
                        
                        Spacer()
                        
                        Text(viewModel.petState)
                            .font(.system(size: 50))
                    }
                    
                    Divider()
                    
                    HStack {
                        Text("Temperature")
                        Spacer()
                        Text("\(viewModel.temperature)°C").bold() // แสดงอุณหภูมิจริง
                    }
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 15).fill(cardColor))
                .foregroundColor(viewModel.aqi > 50 ? .black : .white)
                .padding(.horizontal)
                
                VStack(alignment: .leading) {
                    Text("Hourly forecast (Mock)")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 20) {
                            ForEach(0..<6) { i in
                                VStack(spacing: 10) {
                                    Text(i == 0 ? "Now" : "2\(i):00")
                                    Text("\(max(0, viewModel.aqi + (i * 2 - 5)))")
                                        .padding(8)
                                        .background(RoundedRectangle(cornerRadius: 8).fill(Color.gray.opacity(0.1)))
                                    Image(systemName: i < 3 ? "sun.max.fill" : "moon.fill")
                                        .foregroundColor(i < 3 ? .orange : .gray)
                                    Text("\(viewModel.temperature + i)°")
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
    
    var aqiLevelText: String {
        switch viewModel.aqi {
        case 0...50: return "Good"
        case 51...100: return "Moderate"
        case 101...150: return "Unhealthy for Sensitive Groups"
        case 151...200: return "Unhealthy"
        case 201...300: return "Very Unhealthy"
        default: return "Hazardous"
        }
    }
    
    var cardColor: Color {
        switch viewModel.aqi {
        case 0...50: return .green
        case 51...100: return .yellow
        case 101...150: return .orange
        case 151...200: return .red
        case 201...300: return .purple
        default: return Color(red: 0.5, green: 0, blue: 0)
        }
    }
}

#Preview {
    DetailView().environmentObject(WeatherViewModel())
}
