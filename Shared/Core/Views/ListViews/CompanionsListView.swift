//
//  CompanionsListView.swift
//  Companion
//
//  Created by Simran Preet Singh Narang on 2022-06-02.
//

import SwiftUI

struct CompanionsListView: View {
    
    @EnvironmentObject var viewModel: PetFinderAuthViewModel
    
    var body: some View {
        List {
            ForEach(viewModel.companions) { companion in
                CompanionRowView(companion: companion)
            }
        }
        .listStyle(.plain)
    }
}

struct CompanionsListView_Previews: PreviewProvider {
    static var previews: some View {
        CompanionsListView()
    }
}
