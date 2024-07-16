//
//  ExampleViewBuilder.swift
//  DragonBallSwift
//
//  Created by Josep Cerdá Penadés on 16/7/24.
//

import Foundation

final class ExampleViewBuilder {
    func build() -> ExampleView {
        let networkClient = NetworkClient(urlSession: URLSession.shared)
        let allCharactersService = AllCheracteersService(networkClient: networkClient)
        let allCharactersViewModel = AllCheractersViewModel(allCheracteersService: allCharactersService)

        let allPlanetsService = AllPlanetsService(networkClient: networkClient)
        let allPlanetsViewModel = AllPlanetsViewModel(allplanetsService: allPlanetsService)

        let view = ExampleView(allCheractersViewModel: allCharactersViewModel, allPlanetsViewModel: allPlanetsViewModel)
        return view
    }
}
