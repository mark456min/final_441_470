import Foundation
import CoreLocation
import Combine

// MARK: - Models (ประกาศนอก Class และใช้ Sendable เพื่อ Swift 6)
struct AirQualityResponse: Codable, Sendable {
    let data: AirData
}

struct AirData: Codable, Sendable {
    let city: String
    let current: CurrentWeather
}

struct CurrentWeather: Codable, Sendable {
    let pollution: Pollution
}

struct Pollution: Codable, Sendable {
    let aqius: Int
}

// MARK: - ViewModel
@MainActor
class WeatherViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var cityName: String = "กำลังค้นหาตำแหน่ง..."
    @Published var aqi: Int = 0
    @Published var petState: String = "🐶"
    @Published var healthMessage: String = "รอสักครู่..."
    
    private let locationManager = CLLocationManager()
    private let apiKey = "c0d10439-025a-4223-8a0e-992a0c85173e"
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 100 // อัปเดตทุกๆ 100 เมตร
        
        // [จุดที่แก้ที่ 1]: เปลี่ยนมาเรียกฟังก์ชันเช็กสิทธิ์ก่อน
        checkLocationAuthorization()
    }
    
    // [จุดที่แก้ที่ 2]: ฟังก์ชันเช็กสิทธิ์
    private func checkLocationAuthorization() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            // ถ้ายังไม่เคยขอ ให้ขอก่อน
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            // ถ้าเคยอนุญาตแล้ว ให้เริ่มหาตำแหน่งเลย
            locationManager.startUpdatingLocation()
        case .denied, .restricted:
            // ถ้าผู้ใช้กดไม่อนุญาต ให้แจ้งเตือน
            self.cityName = "โปรดอนุญาตเข้าถึงตำแหน่งใน Settings"
        @unknown default:
            break
        }
    }
    
    // [จุดที่แก้ที่ 3]: ฟังก์ชันดักฟังตอนผู้ใช้กดปุ่ม Allow บน Pop-up
    nonisolated func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            Task { @MainActor in
                // พออนุญาตปุ๊บ สั่งให้เริ่มหาตำแหน่งทันที
                manager.startUpdatingLocation()
            }
        }
    }
    
    // ใช้ async เพื่อให้เรียกทำงานแบบไม่ค้าง
    func fetchAirQuality(lat: Double, lon: Double) async {
        let urlString = "https://api.airvisual.com/v2/nearest_city?lat=\(lat)&lon=\(lon)&key=\(apiKey)"
        guard let url = URL(string: urlString) else { return }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decodedResponse = try JSONDecoder().decode(AirQualityResponse.self, from: data)
            
            // อัปเดตค่าบน Main Actor (UI)
            self.aqi = decodedResponse.data.current.pollution.aqius
            self.cityName = decodedResponse.data.city
            self.updatePetState()
            print("✅ Updated AQI: \(self.aqi) at \(self.cityName)")
        } catch {
            print("❌ Fetch Error: \(error.localizedDescription)")
            self.cityName = "ดึงข้อมูลผิดพลาด"
        }
    }
    
    func updatePetState() {
        switch aqi {
        case 0...50:
            petState = "🐶"
            healthMessage = "อากาศดีมาก! ออกไปวิ่งเล่นกันเถอะ"
        case 51...100:
            petState = "😐"
            healthMessage = "อากาศปานกลาง ระวังตัวด้วยนะ"
        case 101...150:
            petState = "😰"
            healthMessage = "เริ่มหายใจลำบากแล้ว... ใส่หน้ากากด้วย"
        default:
            petState = "🤮"
            healthMessage = "อากาศอันตราย! รีบเข้าที่ร่มด่วน"
        }
    }
    
    // MARK: - Delegate (แกไขให้เข้ากับ Swift 6)
    nonisolated func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let lat = location.coordinate.latitude
        let lon = location.coordinate.longitude
        
        print("📍 ได้พิกัดแล้ว: \(lat), \(lon)") // เพิ่ม Print เพื่อให้รู้ว่าพิกัดมาแล้ว
        
        // ส่งกลับมาทำงานที่ MainActor เพื่อเรียก fetchAirQuality
        Task { @MainActor in
            await fetchAirQuality(lat: lat, lon: lon)
        }
    }
}
