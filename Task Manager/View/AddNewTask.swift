//
//  AddNewTaskView.swift
//  Task Manager
//
//  Created by Nguyễn Thanh Sỹ on 09/05/2022.
//

import SwiftUI

struct AddNewTask: View {
    @EnvironmentObject var taskViewModel: TaskViewModel
    @Environment(\.self) var env
    @Namespace private var animation
    var body: some View {
        VStack(spacing: 12){
            Text("Edit Task")
                .font(.title.bold())
                .frame(maxWidth: .infinity)
                .overlay(alignment: .leading){
                    Button{
                        env.dismiss()
                    } label: {
                        Image(systemName: "arrow.left")
                            .font(.title3)
                            .foregroundColor(.black)
                    }
                }
            VStack(alignment: .leading, spacing: 12){
                Text("Task Color")
                    .font(.caption)
                    .foregroundColor(.gray)
                
            let colors: [String] = ["Yellow", "Green", "Blue", "Purple", "Red", "Orange"]
                HStack(spacing: 15){
                    ForEach(colors, id:\.self){color in
                        Circle()
                            .fill(Color(color))
                            .frame(width: 25, height: 25)
                            .background{
                                if taskViewModel.taskColor == color {
                                    Circle()
                                        .strokeBorder(.gray)
                                        .padding(-3)
                                }
                            }
                            .contentShape(Circle())
                            .onTapGesture {
                                taskViewModel.taskColor = color
                            }
                        
                    }
                }
                .padding(.top, 10)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 30)
            
            Divider()
                .padding(.vertical, 10)
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Task Deadline")
                    .font(.caption)
                    .foregroundColor(.gray)
                Text(taskViewModel.taskDeadline.formatted(date: .abbreviated, time:.omitted) + ", " + taskViewModel.taskDeadline.formatted(date: .omitted, time: .shortened) )
                    .fontWeight(.semibold)
                    .font(.callout)
                    .padding(.top, 8)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .overlay(alignment: .bottomTrailing) {
                Button {
                    taskViewModel.showDatePicker = true
                } label: {
                    Image(systemName: "calendar")
                        .foregroundColor(.black)
                }
            }
            
            Divider()
            let taskType: [String] = ["Basic", "Urgent", "Important"]
            VStack(alignment: .leading, spacing: 12) {
                Text("Task Title")
                    .font(.caption)
                    .foregroundColor(.gray)
                TextField("", text: $taskViewModel.taskTitle)
                    .frame(maxWidth: .infinity)
                    .padding(.top, 10)
            }
            Divider()
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Task Type")
                    .font(.caption)
                    .foregroundColor(.gray)
                HStack(spacing: 12){
                    ForEach(taskType, id: \.self){ type in
                        Text(type)
                            .font(.callout)
                            .padding(.vertical, 8)
                            .frame(maxWidth: .infinity)
                            .foregroundColor(taskViewModel.taskType == type ? .white : .black)
                            .background{
                                if taskViewModel.taskType == type {
                                    Capsule()
                                        .fill(.black)
                                        .matchedGeometryEffect(id: "TYPE", in: animation, isSource: true)
                                } else {
                                    Capsule()
                                        .strokeBorder(.black)
                                        
                                }
                            }
                            .contentShape(Capsule())
                            .onTapGesture {
                                withAnimation{taskViewModel.taskType = type}
                            }
                    }
                   
                }
            }
            Divider()
                .padding(.vertical, 10)
            
            Button {
                taskViewModel.addTask(context: env.managedObjectContext) ? env.dismiss() : ()
            } label: {
                Text("Save Task")
                    .font(.callout)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .foregroundColor(.white)
                    .background{
                        Capsule()
                            .fill(.black)
                    }
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
            .padding(.bottom, 10)
            .disabled(taskViewModel.taskTitle == "")
            .opacity(taskViewModel.taskTitle == "" ? 0.6 : 1)
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .padding()
        .overlay {
            ZStack{
                if taskViewModel.showDatePicker{
                    Rectangle()
                        .fill(.ultraThinMaterial)
                        .ignoresSafeArea()
                        .onTapGesture {
                            taskViewModel.showDatePicker = false
                        }
                    DatePicker.init("", selection: $taskViewModel.taskDeadline, in: Date.now...Date.distantFuture)
                        .datePickerStyle(.graphical)
                        .labelsHidden()
                        .padding()
                        .background(.white, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                        .padding()
                }
            }
            .animation(.easeInOut, value: taskViewModel.showDatePicker)
        }
    }
}

struct AddNewTask_Previews: PreviewProvider {
    static var previews: some View {
        AddNewTask()
            .environmentObject(TaskViewModel())
    }
}
