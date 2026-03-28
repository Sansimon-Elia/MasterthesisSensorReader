//
//  WatchPayload.swift
//  CoreMotionSensorReader
//
//  Created by Sansimon Elia on 28.03.26.
//

import Foundation

struct WatchPayload: Codable {
    let sensorBatch: [SensorData]
    let heartRate: Double
    let averageHeartRate: Double
    let timestamp: Date
}
