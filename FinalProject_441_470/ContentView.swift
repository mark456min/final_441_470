import SwiftUI

struct ContentView: View {
    // สร้าง ViewModel ไว้ตรงกลาง เพื่อแชร์ข้อมูลให้ทุกหน้า
    @StateObject var viewModel = WeatherViewModel()

    var body: some View {
        TabView {
            // 1. หน้าสัตว์เลี้ยง (ส่ง viewModel เข้าไป)
            HomePetView(viewModel: viewModel)
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

            // 4. หน้ารายละเอียด (ส่ง viewModel เข้าไป)
            DetailView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: "info.circle.fill")
                    Text("รายละเอียด")
                }
        }
        .accentColor(.blue) // สีของปุ่ม Tab ที่ถูกเลือก
    }
}
