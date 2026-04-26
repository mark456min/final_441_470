import SwiftUI

struct ContentView: View {
    // สร้าง ViewModel ตัวหลักที่นี่
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
        // แชร์ข้อมูลให้หน้าลูกๆ ทุกหน้า
        .environmentObject(viewModel)
    }
}
