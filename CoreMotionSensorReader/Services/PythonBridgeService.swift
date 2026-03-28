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

    func sendSensorData(_ data: SensorData) {

        guard let motion = data.deviceMotionData else { return }

        let payload: [String: Any] = [
            "motionUserAccelerationX": motion.userAccelX,
            "motionUserAccelerationY": motion.userAccelY,
            "motionUserAccelerationZ": motion.userAccelZ,
            "motionYaw": motion.yaw,
            "motionPitch": motion.pitch,
            "motionRoll": motion.roll,
            "rotationRateZ": motion.rotationRateZ
        ]

        var request = URLRequest(url: serverURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: payload)
            URLSession.shared.dataTask(with: request).resume()
        } catch {
            print("JSON Fehler:", error)
        }
    }
}
