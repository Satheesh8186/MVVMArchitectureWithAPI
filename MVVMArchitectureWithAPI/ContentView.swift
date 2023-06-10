//
//  ContentView.swift
//  MVVMArchitectureWithAPI
//
//  Created by satheesh kumar on 10/06/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var vm = UserVm()
    var body: some View {
        NavigationView{
            ZStack{
                if(vm.isRefresh){
                    ProgressView()
                }else{
                    List(vm.userData){ userData in
                        UserView(user: userData)
                            .listRowSeparator(.hidden)
                    }.listStyle(.plain)
                        
                        .navigationTitle("user")
                    
                }
            }.onAppear(perform: vm.fetchUser)
            .alert(isPresented: $vm.isApiFailed, error: vm.error, actions: {
                    
                    Button("retry") {
                        vm.fetchUser()
                    }
                    
                })
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
