//
//  Appdata.swift
//  FinalProject_441_470
//
//  Created by Ativit Tantipisit on 26/4/2569 BE.
//

import Foundation
import CoreLocation

// ตัวรับข้อมูลโครงสร้างใหญ่สุด
struct AppDataInfo: Codable {
    let topCities: [CityRanking]
    let bkkDistricts: [AqiPin]
}

// โครงสร้างของข้อมูล Ranking
struct CityRanking: Codable, Identifiable {
    var id = UUID() // สร้าง ID อัตโนมัติสำหรับ List
    let name: String
    let aqi: Int
    let flag: String
    
    // บอก Swift ว่าตอนดึง JSON ไม่ต้องหาค่า id (เพราะเราตั้งค่าอัตโนมัติไว้แล้ว)
    private enum CodingKeys: String, CodingKey {
        case name, aqi, flag
    }
}

// โครงสร้างของข้อมูลพิกัด
struct AqiPin: Codable, Identifiable {
    var id = UUID()
    let name: String
    let lat: Double
    let lon: Double
    let aqi: Int
    
    private enum CodingKeys: String, CodingKey {
        case name, lat, lon, aqi
    }
    
    // ตัวแปรนี้คำนวณจาก lat, lon ไม่ต้องดึงจาก JSON
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: lat, longitude: lon)
    }
}

// MARK: - ตัวอ่านไฟล์ JSON (DataLoader)
class DataLoader {
    static func load() -> AppDataInfo {
        // หาไฟล์ aqi_data.json ในโปรเจกต์
        guard let url = Bundle.main.url(forResource: "aqi_data.json", withExtension: nil),
              let data = try? Data(contentsOf: url),
              let decodedData = try? JSONDecoder().decode(AppDataInfo.self, from: data) else {
            // ถ้าไม่เจอไฟล์หรือโครงสร้างพัง ให้พ่น Error ออกมา
            fatalError("ไม่สามารถโหลดหรือถอดรหัสไฟล์ aqi_data.json ได้")
        }
        return decodedData
    }
}
