//
//  DynamicFilteredView.swift
//  Task Manager
//
//  Created by Nguyễn Thanh Sỹ on 11/05/2022.
//

import SwiftUI
import CoreData

struct DynamicFilteredView<Content: View, T>: View where T: NSManagedObject {
    //CoreData request
    @FetchRequest var request: FetchedResults<T>
    let content: (T)->Content
    
    init(currentTab: String, @ViewBuilder content: @escaping (T)->Content ){
        let calendar = Calendar.current
        var predicate: NSPredicate!
        let filterKey = "deadline"
        
        if currentTab == "Today" {
            let today = calendar.startOfDay(for: Date())
            let tommorow = calendar.date(byAdding: .day, value: 1, to: today)
          
   
            predicate = NSPredicate(format: "\(filterKey) >= %@ AND \(filterKey) < %@ AND isCompleted == %i", argumentArray: [today, tommorow!, 0])
            
        } else if currentTab == "Upcoming" {
            let today = calendar.startOfDay(for: calendar.date(byAdding: .day, value: 1, to: Date().startOfDay)!)
       
            
            predicate = NSPredicate(format: "\(filterKey) > %@ AND isCompleted == %i", argumentArray: [today, 0])
            
        } else {
            predicate = NSPredicate(format: "\(filterKey) < %@ OR isCompleted == %i", argumentArray: [Date().startOfDay, 1])
        
        }

        _request = FetchRequest(entity: T.entity(), sortDescriptors: [.init(keyPath: \Task.deadline, ascending: false)], predicate: predicate)
        self.content = content
    }
    var body: some View {
        Group{
            if request.isEmpty{
                Text("No tasks found!!!")
                    .font(.system(size: 16))
                    .fontWeight(.light)
                    .offset(y: 100)
            } else {
                ForEach(request, id: \.objectID){ object in
                    self.content(object)
                }
            }
        }
            
    }
}

