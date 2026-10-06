//
//  SwiftUIView.swift
//  DragonBallSwift
//
//  Created by Raúl Gallego Alonso on 27/7/24.
//

import Kingfisher
import SwiftUI

struct SagasViewDetails: View {
    @State var character: CharactersModel
    @Binding var logoDB: String
    @State private var isLoading = false
    @State private var errorMessage: String?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                KFImage(URL(string: character.image))
                    .placeholder { Image(systemName: "photo").font(.largeTitle) }
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, maxHeight: 350)
                    .accessibilityHidden(true)
                Text(character.name).font(.largeTitle.bold())
                LabeledContent("Género", value: character.genre)
                LabeledContent("Raza", value: character.race)
                if !character.affiliation.isEmpty {
                    LabeledContent("Afiliación", value: character.affiliation)
                }
                LabeledContent(
                    "Planeta", value: character.planet.isEmpty ? "Sin información" : character.planet)
                Text(character.description)
                if isLoading { ProgressView("Cargando ficha completa…") }
                if let errorMessage {
                    Text(errorMessage).foregroundStyle(.secondary)
                    Button("Reintentar") { Task { await loadDetails() } }
                }
                if !character.transformations.isEmpty {
                    Text("Transformaciones").font(.title2.bold())
                    ForEach(Array(character.transformations.enumerated()), id: \.offset) {
                        _, transformation in
                        VStack(alignment: .leading, spacing: 8) {
                            Text(transformation.title ?? "Transformación").font(.headline)
                            KFImage(URL(string: transformation.image))
                                .placeholder { Image(systemName: "photo") }
                                .resizable().scaledToFit().frame(maxHeight: 220)
                                .accessibilityHidden(true)
                            Text(transformation.description)
                        }
                    }
                }
            }
            .padding(20)
        }
        .background(Color.backgroundColor)
        .navigationTitle(character.name)
        .navigationBarTitleDisplayMode(.inline)
        .task(id: character.id) { await loadDetails() }
    }

    private func loadDetails() async {
        guard !isLoading else { return }
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        do {
            let service = CharacterDetailService(networkClient: NetworkClient(urlSession: URLSession.shared))
            let details = try await service.fetchCharacter(id: character.id)
            guard !Task.isCancelled else { return }
            character = details.toCharactersModel()
        } catch {
            guard !Task.isCancelled else { return }
            errorMessage = "No se pudo completar la ficha. \(error.localizedDescription)"
        }
    }
}

#Preview { SagasViewDetails(character: Mocks().character, logoDB: .constant("DBLogo")) }
