//
//  PythonBridgeService.swift
//  CoreMotionSensorReader
//
//  Created by Sansimon Elia on 16.03.26.
//

import Foundation

class PythonBridgeService {
    
    // HIER DEINE WINDOWS IP EINTRAGEN
    private let serverURL = URL(string: "http://192.168.178.20:56671/sensorlog")!
    
    func sendSensorData(_ data: SensorData, heartRate: Double, averageHeartRate: Double) {
        guard let motion = data.deviceMotionData else { return }
        
        let payload: [String: Any] = [
            "motionUserAccelerationX": motion.userAccelX,
            "motionUserAccelerationY": motion.userAccelY,
            "motionUserAccelerationZ": motion.userAccelZ,
            "motionYaw": motion.yaw,
            "motionPitch": motion.pitch,
            "motionRoll": motion.roll,
            "rotationRateZ": motion.rotationRateZ,
            "heartRate": heartRate,
            "averageHeartRate": averageHeartRate
        ]
        
        var request = URLRequest(url: serverURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: payload)
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("HTTP Fehler:", error.localizedDescription)
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    print("Python Server Antwort:", httpResponse.statusCode)
                } else {
                    print("Keine HTTP Antwort erhalten")
                }
            }.resume()
            
        } catch {
            print("JSON Fehler:", error)
        }
    }
}
