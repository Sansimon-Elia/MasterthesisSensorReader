//
//  ContentView.swift
//  WatchCoreMotionSensorReader Watch App
//
//  Created by Maurice Richter on 15.06.24.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var workoutManager = WorkoutManager()

    var body: some View {
        TabNavView()
            .environmentObject(workoutManager)
    }
}

#Preview {
    ContentView()
}
