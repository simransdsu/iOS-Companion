//
//  CompanionSearchSuggestionScreen.swift
//  Companion
//
//  Created by Simran Preet Singh Narang on 2022-06-02.
//

import SwiftUI

struct CompanionSearchSuggestionScreen: View {
    
    @EnvironmentObject var viewModel: PetFinderAuthViewModel
    
    var body: some View {
        ForEach(viewModel.worldCities.filter { $0.city.localizedCaseInsensitiveContains(viewModel.searchText)} ) { city in
            Text("\(city.city), \(city.country)").searchCompletion("\(city.city), \(city.country)")
        }
    }
}

struct CompanionSearchSuggestionScreen_Previews: PreviewProvider {
    static var previews: some View {
        CompanionSearchSuggestionScreen()
    }
}
