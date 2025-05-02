//
//  GetDoneApp.swift
//  GetDone
//
//  Created by Vinicius on 4/22/25.
//

import SwiftUI

/*
 MVVM - architecture
 
 Model - data point
 View - UI
 ViewModel - manage models for View
 
 */

@main
struct GetDoneApp: App {
    
    @StateObject var listViewModel: ListViewModel = ListViewModel()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ListView()
            }
            .environmentObject(listViewModel)
        }
    }
}
