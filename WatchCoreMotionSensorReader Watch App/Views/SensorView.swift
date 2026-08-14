//
//  SensorView.swift
//  WatchCoreMotionSensorReader Watch App
//
//  Created by Maurice Richter on 17.06.24.
//

import SwiftUI

struct SensorView: View {
    
    @EnvironmentObject private var workoutManager : WorkoutManager
    
    @State var startedRunning: Bool = false
    
    @State private var showAlert = false
    
    let steps = [1, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100]
    
    var body: some View {
        
        VStack {
            
            if(startedRunning == false){
                Button("Starte Workout/Sensoren") {
                    workoutManager.startWorkout()
                    startedRunning = true
                    
                }
                .buttonStyle(.borderedProminent)
                .tint(.blue)
               
        
         
            } else {
                Button("Beende Workout/Sensor") {
                    workoutManager.endWorkout()
                    startedRunning = false
                    
                }
                .buttonStyle(.borderedProminent)
                .tint(.red)
            }
            // ── NEU: Rückwärts-Button, ausgelöst durch Double Tap ──
            Button("⏪ Rückwärts") {
                workoutManager.sendDoubleTap()
            }
            .buttonStyle(.bordered)
            .tint(.purple)
            .handGestureShortcut(.primaryAction)   // ← Double Tap löst DIESEN Button aus
            
            
        }.onAppear() {
            workoutManager.requestAuthorization()
        }
    }
    
}

#Preview {
    SensorView()
        .environmentObject(WorkoutManager())
}
