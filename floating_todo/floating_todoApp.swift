//
//  floating_todoApp.swift
//  floating_todo
//
//  Created by sarahtxy on 12/22/24.
//

import SwiftUI

@main
struct floating_todoApp: App {
    var body: some Scene {
        WindowGroup("Task Manager") {
            TaskManagerView()
                .environmentObject(TaskManager.shared)
        }
    }
}
