//
//  ConnectivityService.swift
//  WatchCoreMotionSensorReader Watch App
//
//  Created by Maurice Richter on 17.06.24.
//

import Foundation
import WatchConnectivity
import WatchKit

class ConnectivityService: NSObject, WCSessionDelegate {
    
    var session: WCSession
    
    var sensorBuffer: [SensorData] = []
    let bufferSize = 10
    
    init(session: WCSession = .default) {
        self.session = session
        super.init()
        session.delegate = self
        
        if session.activationState != .activated {
            session.activate()
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: (any Error)?) {
        print(activationState)
    }
    
    
    /*
    func sendSensorData(data: SensorData) {
        /*
        let dict: [String : Any] = ["data": data.encodeIt()]
        
        if session.activationState == .activated && session.isReachable {
            session.sendMessage(dict, replyHandler: nil, errorHandler: nil)
        } else {
            print("Session nicht erreichbar")
        }
       
        let encodedData = data.encodeIt()
        
        if session.activationState == .activated && session.isReachable {
            session.sendMessageData(encodedData, replyHandler: nil, errorHandler: nil)
        } else {
            print("Session nicht erreichbar")
        }
         */
        
        sensorBuffer.append(data)
        
        if sensorBuffer.count >= bufferSize {
            let encodedData = try? JSONEncoder().encode(sensorBuffer)
            sensorBuffer.removeAll()
            
            if session.activationState == .activated && session.isReachable {
                session.sendMessageData(encodedData!, replyHandler: nil, errorHandler: nil)
            } else {
                print("Session nicht erreichbar")
            }
        }
    }
     */
    
    func sendSensorDataBatch(data: [SensorData]) {
        guard session.activationState == .activated && session.isReachable else {
            print("Session nicht erreichbar")
            return
        }
        
        if let encodedData = try? JSONEncoder().encode(data) {
            session.sendMessageData(encodedData, replyHandler: nil, errorHandler: nil)
        }
    }
    
    func sendPayload(sensorBatch: [SensorData], heartRate: Double, averageHeartRate: Double) {
        guard session.activationState == .activated && session.isReachable else {
            print("Session nicht erreichbar")
            return
        }

        let payload = WatchPayload(
            sensorBatch: sensorBatch,
            heartRate: heartRate,
            averageHeartRate: averageHeartRate,
            timestamp: Date()
        )

        if let encodedData = try? JSONEncoder().encode(payload) {
            session.sendMessageData(encodedData, replyHandler: nil, errorHandler: nil)
        } else {
            print("Payload konnte nicht encodiert werden")
        }
    }
    
    func sendDoubleTap() {
            guard session.activationState == .activated && session.isReachable else {
                print("Session nicht erreichbar – Double Tap nicht gesendet")
                return
            }
            
            session.sendMessage(["doubleTap": true], replyHandler: nil) { error in
                print("Double Tap Sendefehler: \(error.localizedDescription)")
            }
            
            // Haptisches Feedback als Bestätigung für den Nutzer
            WKInterfaceDevice.current().play(.success)
        }

    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        if let hapticValue = message["haptic"] as? String, hapticValue == "true" {
            print("Haptic is set to true")
            WKInterfaceDevice.current().play(.failure)
            
        } else {
            print("Haptic is not set to true or is missing")
        }
    }
    
    /*
    
    func sendSensorDataBatch(data: [SensorData]) {
        guard session.activationState == .activated && session.isReachable else {
            print("Session nicht erreichbar")
            return
        }
        
        if let encodedData = try? JSONEncoder().encode(data) {
            session.sendMessageData(encodedData, replyHandler: nil, errorHandler: nil)
        }
    }
     */

    
}
