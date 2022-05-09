//
//  Task_ManagerApp.swift
//  Task Manager
//
//  Created by Nguyễn Thanh Sỹ on 09/05/2022.
//

import SwiftUI

@main
struct Task_ManagerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
