//
//  PetFinderAuthViewModel.swift
//  Companion
//
//  Created by Simran Preet Singh Narang on 2022-06-02.
//

import Foundation

protocol PetFinderAuthViewable {
    func getCompanions() async throws
}

class PetFinderAuthViewModel: PetFinderAuthViewable, ObservableObject {
    
    @Published public var apiError: APIError? = nil
    @Published public var companions: [Companion] = []
    @Published public var searchText: String = ""
    @Published public var citySearchText: String = ""
    @Published public var worldCities: [City] = []
    @Published public var isLoading: Bool = false
    
    private let interactor: PetFinderAuthInteractable
    
    init(interactor: PetFinderAuthInteractable = PetFinderAuthInteractor()) {
        
        self.interactor = interactor
        Task {
            isLoading = true
            await loadCitiesList()
            await getCompanions()
            isLoading = false
        }
    }
    
    
    @MainActor
    func getCompanions() async {
        
        do {
            companions = try await interactor.getCompanions()
        } catch {
            print("❌", error)
            if let error = error as? APIError {
                self.apiError = error
                return
            }
            self.apiError = APIError.unknown(error.localizedDescription)
        }
    }
    
    @MainActor
    func authenticate() async {
        
        do {
            try await interactor.authenticate()
        } catch {
            print("❌", error)
            if let error = error as? APIError {
                self.apiError = error
                return
            }
            self.apiError = APIError.unknown(error.localizedDescription)
        }
    }
    
    
    @MainActor
    func loadCitiesList() async {
        guard let url = Bundle.main.url(forResource: "worldcities", withExtension: "json") else {
            fatalError()
        }
        
        guard
            let worldCitiesData = try? Data(contentsOf: url),
            let worldCities = try? JSONDecoder().decode([City].self, from: worldCitiesData) else {
            return
        }
        
        self.worldCities = worldCities.filter({ city in
            return city.country == "Canada" || city.country == "United States"
        })
        self.worldCities.removeDuplicates()
        
    }
}
