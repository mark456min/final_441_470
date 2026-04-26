import Foundation
import CoreLocation
import Combine

// MARK: - Models
struct AirQualityResponse: Codable, Sendable {
    let data: AirData
}

struct AirData: Codable, Sendable {
    let city: String
    let current: CurrentWeather
}

struct CurrentWeather: Codable, Sendable {
    let pollution: Pollution
    let weather: Weather // เพิ่มการรับค่า weather
}

struct Pollution: Codable, Sendable {
    let aqius: Int
}

struct Weather: Codable, Sendable {
    let tp: Int // อุณหภูมิอากาศ (องศาเซลเซียส)
}

// MARK: - ViewModel (คงเดิมไว้ทั้งหมด)
@MainActor
class WeatherViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var cityName: String = "กำลังค้นหาตำแหน่ง..."
    @Published var aqi: Int = 0
    @Published var temperature: Int = 0 // เพิ่มตัวแปรเก็บอุณหภูมิ
    @Published var petState: String = "normal"
    @Published var healthMessage: String = "รอสักครู่..."
    
    private let locationManager = CLLocationManager()
    private let apiKey = "c0d10439-025a-4223-8a0e-992a0c85173e"
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 100
        checkLocationAuthorization()
    }
    
    private func checkLocationAuthorization() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        case .denied, .restricted:
            self.cityName = "โปรดอนุญาตเข้าถึงตำแหน่งใน Settings"
        @unknown default:
            break
        }
    }
    
    nonisolated func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            Task { @MainActor in
                manager.startUpdatingLocation()
            }
        }
    }
    
    func fetchAirQuality(lat: Double, lon: Double) async {
        let urlString = "https://api.airvisual.com/v2/nearest_city?lat=\(lat)&lon=\(lon)&key=\(apiKey)"
        guard let url = URL(string: urlString) else { return }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decodedResponse = try JSONDecoder().decode(AirQualityResponse.self, from: data)
            
            self.aqi = decodedResponse.data.current.pollution.aqius
            self.cityName = decodedResponse.data.city
            self.temperature = decodedResponse.data.current.weather.tp // เก็บค่าอุณหภูมิ
            self.updatePetState()
            print("✅ Updated: \(self.cityName) AQI: \(self.aqi) Temp: \(self.temperature)")
        } catch {
            print("❌ Fetch Error: \(error.localizedDescription)")
            self.cityName = "ดึงข้อมูลผิดพลาด"
        }
    }
    
    func updatePetState() {
            switch aqi {
            case 0...50:
                petState = "normal" // 👈 ใส่ชื่อไฟล์รูปภาพตอนร่าเริง
                healthMessage = "อากาศดีมาก! ออกไปวิ่งเล่นกันเถอะ"
            case 51...100:
                petState = "normal" // 👈 ใส่ชื่อไฟล์รูปภาพตอนปกติ
                healthMessage = "อากาศปานกลาง ระวังตัวด้วยนะ"
            case 101...150:
                petState = "mad" // 👈 ใส่ชื่อไฟล์รูปภาพตอนหอบ/ใส่หน้ากาก
                healthMessage = "เริ่มหายใจลำบากแล้ว... ใส่หน้ากากด้วย"
            default:
                petState = "mad" // 👈 ใส่ชื่อไฟล์รูปภาพตอนป่วย
                healthMessage = "อากาศอันตราย! รีบเข้าที่ร่มด่วน"
            }
        }
    
    nonisolated func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let lat = location.coordinate.latitude
        let lon = location.coordinate.longitude
        Task { @MainActor in
            await self.fetchAirQuality(lat: lat, lon: lon)
        }
    }
}
