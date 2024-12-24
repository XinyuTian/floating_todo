//
//  floating_todoApp.swift
//  floating_todo
//
//  Created by sarahtxy on 12/22/24.
//

import SwiftUI

@main
struct floating_todoApp: App {
    @StateObject private var taskManager = TaskManager.shared
    
    var body: some Scene {
        WindowGroup {
            Color.clear
                .frame(width: 0, height: 0)
        }
    }
}
