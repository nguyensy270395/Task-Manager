//
//  Home.swift
//  Task Manager
//
//  Created by Nguyễn Thanh Sỹ on 09/05/2022.
//

import SwiftUI

struct Home: View {
    @StateObject var taskViewModel: TaskViewModel = .init()
    @Namespace var animation
    @FetchRequest(entity: Task.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Task.deadline, ascending: false)], predicate: nil, animation: .easeInOut) var tasks: FetchedResults<Task>
    @Environment(\.self) var env
    var body: some View {
        ScrollView(.vertical, showsIndicators: false){
            VStack{
                VStack(alignment: .leading, spacing: 8){
                    Text("Welcome Back")
                        .font(.callout)
                    Text("Here's Update Today.")
                        .font(.title.bold())
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical)
                
                CustomSegmentedBar()
                    .padding(.top, 5)
                
                TaskView()
            }
            .padding()
        }
        .overlay(alignment: .bottom){
            Button{
                taskViewModel.openEditTask.toggle()
            } label: {
                Label {
                    Text("Add task")
                        .font(.callout)
                        .fontWeight(.semibold)
                } icon: {
                    Image(systemName: "plus.app.fill")
                }
                .foregroundColor(.white)
                .padding(.vertical, 12)
                .padding(.horizontal, 12)
                .background(.black, in: Capsule())
            }
            .padding(.top, 10)
            .frame(maxWidth: .infinity)
            .background{
                LinearGradient(colors: [.white.opacity(0.05),
                                        .white.opacity(0.4),
                                        .white.opacity(0.7),
                                        .white
                ], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            }
        }
        .fullScreenCover(isPresented: $taskViewModel.openEditTask) {
            taskViewModel.resetTaskData()
        } content: {
            AddNewTask()
                .environmentObject(taskViewModel)
        }
        
    }
    
    @ViewBuilder
    func TaskView() -> some View{
        LazyVStack(spacing: 20){
            ForEach(tasks) { task in
                
                TaskRowView(task: task)
            }
        }
        .padding(.top, 20)
    }
    
    @ViewBuilder
    func TaskRowView(task: Task) -> some View {
        VStack(alignment: .leading, spacing: 10){
            HStack{
                Text(task.type ?? "")
                    .font(.callout)
                    .padding(.vertical, 5)
                    .padding(.horizontal)
                    .background{
                        Capsule()
                            .fill(.white.opacity(0.3))
                    }
                Spacer()
                
                if !task.isCompleted{
                    Button{
                        taskViewModel.editTask = task
                        taskViewModel.openEditTask = true
                        taskViewModel.setupTask()
                    } label: {
                        Image(systemName: "square.and.pencil")
                            .foregroundColor(.black)
                    }
                }
            }
            
            Text(task.title ?? "")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.black)
                .padding(.vertical, 10)
            HStack(alignment: .bottom, spacing: 0){
                VStack(alignment: .leading, spacing: 10) {
                    Label {
                        Text(((task.deadline ?? Date()).formatted(date: .long, time: .omitted)))
                    } icon: {
                        Image(systemName: "calendar")
                    }
                    .font(.caption)
                    
                    Label {
                        Text(((task.deadline ?? Date()).formatted(date: .omitted, time: .shortened)))
                    } icon: {
                        Image(systemName: "calendar")
                    }
                    .font(.caption)
                }.frame(maxWidth: .infinity, alignment: .leading)
                if !task.isCompleted{
                    Button {
                        task.isCompleted.toggle()
                        try? env.managedObjectContext.save()
                    } label: {
                        Circle()
                            .strokeBorder(.black, lineWidth: 1.5)
                            .frame(width: 25, height: 25)
                            .contentShape(Circle())
                    }
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background{
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color(task.color ?? "Yellow"))
        }
    }
    
    @ViewBuilder
    func CustomSegmentedBar() -> some View{
        let tabs = ["Today", "Upcoming", "Task Done"]
        HStack(spacing: 10){
            ForEach(tabs, id: \.self) { tab in
                Text(tab)
                    .font(.callout)
                    .fontWeight(.semibold)
                    .scaleEffect(0.9)
                    .foregroundColor(taskViewModel.currentTab == tab ? .white : .black)
                    .padding(.vertical, 6)
                    .frame(maxWidth: .infinity)
                    .background{
                        if taskViewModel.currentTab == tab {
                            Capsule()
                                .fill(.black)
                                .matchedGeometryEffect(id: "TAB", in: animation)
                        }
                    }
                    .contentShape(Capsule())
                    .onTapGesture {
                        withAnimation{taskViewModel.currentTab = tab}
                    }
            }
        }
    }
    
    
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension Date {

    func toString(format: String = "yyyy-MM-dd") -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    func dateAndTimetoString(format: String = "yyyy-MM-dd HH:mm") -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
   
    func timeIn24HourFormat() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: self)
    }
    
    func startOfMonth() -> Date {
        var components = Calendar.current.dateComponents([.year,.month], from: self)
        components.day = 1
        let firstDateOfMonth: Date = Calendar.current.date(from: components)!
        return firstDateOfMonth
    }
    
    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }
    
    func nextDate() -> Date {
        let nextDate = Calendar.current.date(byAdding: .day, value: 1, to: self)
        return nextDate ?? Date()
    }
    
    func previousDate() -> Date {
        let previousDate = Calendar.current.date(byAdding: .day, value: -1, to: self)
        return previousDate ?? Date()
    }
    
    func addMonths(numberOfMonths: Int) -> Date {
        let endDate = Calendar.current.date(byAdding: .month, value: numberOfMonths, to: self)
        return endDate ?? Date()
    }
    
    func removeMonths(numberOfMonths: Int) -> Date {
        let endDate = Calendar.current.date(byAdding: .month, value: -numberOfMonths, to: self)
        return endDate ?? Date()
    }
    
    func removeYears(numberOfYears: Int) -> Date {
        let endDate = Calendar.current.date(byAdding: .year, value: -numberOfYears, to: self)
        return endDate ?? Date()
    }
    
    func getHumanReadableDayString() -> String {
        let weekdays = [
            "Sunday",
            "Monday",
            "Tuesday",
            "Wednesday",
            "Thursday",
            "Friday",
            "Saturday"
        ]
        
        let calendar = Calendar.current.component(.weekday, from: self)
        return weekdays[calendar - 1]
    }
    
    
    func timeSinceDate(fromDate: Date) -> String {
        let earliest = self < fromDate ? self  : fromDate
        let latest = (earliest == self) ? fromDate : self
    
        let components:DateComponents = Calendar.current.dateComponents([.minute,.hour,.day,.weekOfYear,.month,.year,.second], from: earliest, to: latest)
        let year = components.year  ?? 0
        let month = components.month  ?? 0
        let week = components.weekOfYear  ?? 0
        let day = components.day ?? 0
        let hours = components.hour ?? 0
        let minutes = components.minute ?? 0
        let seconds = components.second ?? 0
        
        
        if year >= 2{
            return "\(year) years ago"
        }else if (year >= 1){
            return "1 year ago"
        }else if (month >= 2) {
             return "\(month) months ago"
        }else if (month >= 1) {
         return "1 month ago"
        }else  if (week >= 2) {
            return "\(week) weeks ago"
        } else if (week >= 1){
            return "1 week ago"
        } else if (day >= 2) {
            return "\(day) days ago"
        } else if (day >= 1){
           return "1 day ago"
        } else if (hours >= 2) {
            return "\(hours) hours ago"
        } else if (hours >= 1){
            return "1 hour ago"
        } else if (minutes >= 2) {
            return "\(minutes) minutes ago"
        } else if (minutes >= 1){
            return "1 minute ago"
        } else if (seconds >= 3) {
            return "\(seconds) seconds ago"
        } else {
            return "Just now"
        }
        
    }
}
