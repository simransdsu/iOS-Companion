//
//  ContentView.swift
//  Shared
//
//  Created by Simran Preet Singh Narang on 2022-06-01.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var viewModel = PetFinderAuthViewModel()
    
    var body: some View {
        CompanionsSearchScreen()
            .environmentObject(viewModel)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
