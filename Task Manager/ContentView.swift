//
//  ContentView.swift
//  Task Manager
//
//  Created by Nguyễn Thanh Sỹ on 09/05/2022.
//

import SwiftUI

struct ContentView: View {

    var body: some View {
        NavigationView{
            Home()
                .navigationTitle("Task Manager")
                .navigationBarTitleDisplayMode(.inline)
            
        }
        
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

