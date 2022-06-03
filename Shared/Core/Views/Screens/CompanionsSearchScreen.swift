//
//  CompanionsSearchSreen.swift
//  Companion
//
//  Created by Simran Preet Singh Narang on 2022-06-02.
//

import SwiftUI

struct CompanionsSearchScreen: View {
    
    @EnvironmentObject var viewModel: PetFinderAuthViewModel
    
    @State var list: [City] = []
    
    var body: some View {
        NavigationView {
            if viewModel.isLoading {
                ProgressView()
            } else {
                CompanionsListView()
                    .environmentObject(viewModel)
                    .refreshable(action: authenticateAndGetCompanions)
                    .task(authenticateAndGetCompanions)
                    .searchable(text: $viewModel.searchText) {
                        CompanionSearchSuggestionScreen()
                            .environmentObject(viewModel)
                    }
                    .navigationBarTitle("Companion")
            }
        }
    }
    
    @Sendable
    private func authenticateAndGetCompanions() async {
        await viewModel.authenticate()
        await viewModel.getCompanions()
    }
   
}

struct CompanionsSearchSreen_Previews: PreviewProvider {
    static var previews: some View {
        CompanionsSearchScreen()
    }
}
