//
//  MemoryGameViewModel.swift
//  DragonBallSwift
//
//  Created by Proyecto Dragon Ball on 1/6/24.
//

import Observation
import SwiftUI

// Enumera niveles de dificultad ...
enum Difficulty {
    case level_1 // Sin restricciones
    case level_2 // Límite de intentos
    case level_3 // Límite de tiempo y de intentos
}

/// ViewModel para manejar la lógica relacionada con la memoria de juego.
@Observable
class MemoryGameViewModel{
    
    var score: Int = 0 // Propiedad para almacenar el puntaje del usuario
    var attempts: Int = 0 // cuenta los intentos que realiza el usuario
    var completedScreens: Int = 0 // cuenta los paneles completados

    /// Definición de la cuadrícula para cuatro Filas
    var forColumGrid = [GridItem(.flexible()),
                        GridItem(.flexible()),
                        GridItem(.flexible()),
                        GridItem(.flexible())]
    
    /// Definición de la cuadrícula para seis columnas.
    var sixColumGrid = [GridItem(.flexible()),
                        GridItem(.flexible()),
                        GridItem(.flexible()),
                        GridItem(.flexible()),
                        GridItem(.flexible()),
                        GridItem(.flexible())]
    
    var cardList: [CardMemoryModel]            /// llama al modelo de cartas
    var difficulty: Difficulty                 /// llama el enumerado de niveles
    var cardMemoryModel: CardMemoryModel       /// Instancia de la clase Card.
    var matchedCards: [CardMemoryModel] = []   /// Lista de cartas emparejadas.
    var userChoices: [CardMemoryModel] = []    /// Lista de cartas elegidas por el usuario.
    
    // Constructor
    init(cardMemoryModel: CardMemoryModel = CardMemoryModel(text: ""),
         cardList: [CardMemoryModel] = [],
         difficulty: Difficulty = .level_1) {
        
        self.cardMemoryModel = cardMemoryModel
        self.cardList = cardList
        self.difficulty = difficulty
        
        
    }
    
    /// Matriz de referencias de imágenes para las cartas.
    let cardValues: [String] = [
        "GokuPeque", "Bulma", "cerdito", "Krilin", "Mutenroy", "Yamcha", "Tenshinhan", "Puar", "Karin", "drragon", "Chichi", "Chaoz"
    ]
    
    /// Método para crear una lista de cartas duplicada.
    func createCardList() -> [CardMemoryModel] {
        var cardList = [CardMemoryModel]()
        
        /// Duplica cada valor de la matriz de referencias de imágenes y agrega una nueva carta para cada uno.
        for cardValue in cardValues {
            cardList.append(CardMemoryModel(text: cardValue))
            cardList.append(CardMemoryModel(text: cardValue))
        }
        
        return cardList
    }
    
    /// Método para verificar si todas las cartas han sido emparejadas
    func checkGaneCompletion() -> Bool {
        if matchedCards.count == cardValues.count * 2{
            //.. logica para subir de nivel
            print("panel completado")
        }
        return matchedCards.count == cardValues.count * 2
    }
    
    /// Método para verificar si hay coincidencia entre las cartas elegidas por el usuario.
    func checkForMatch() {
        /// Si el texto de las dos cartas elegidas es el mismo, se considera una coincidencia y se agregan a la lista de cartas emparejadas.
        if userChoices[0].text == userChoices[1].text {
            matchedCards.append(userChoices[0])
            matchedCards.append(userChoices[1])
            score += 5 // aumenta la cantidad de puntos cada vez que el usuario acierta
            attempts -= 1
            print(attempts)
            if attempts <= 1{
                attempts = 0
            }
        } else {
            // disminulle la cantidad de punto si se equivoca
            
            if score <= 1{
               
                score = 0 // controla que los puntos no sean negativos
            }else if score >= 0 {
                score -= 1 // resta puntos
            }
            
            attempts += 1 // contabiliza el numero de intentos fallidos
            print(attempts)
        }
        /// Se limpia la lista de cartas elegidas por el usuario.
        userChoices.removeAll()
        
        // Si el juego está completo, aumentar el puntaje
        if checkGaneCompletion() {
            completedScreens += 1
            print("paneles completados \(completedScreens) ")
            // Aquí podrías también realizar alguna otra acción, mostrar un mensaje de felicitación.
            
        }
    }
    
    /// Metodo para reiniciar el juego
    func resetGameAll(cardMemoryModel: CardMemoryModel = CardMemoryModel(text: ""),  cardList: [CardMemoryModel], difficulty: Difficulty  = .level_1) {
        for i in userChoices {
            i.isFaceUp = false
        }
        matchedCards.removeAll()
        userChoices.removeAll()
        self.cardMemoryModel = cardMemoryModel
        self.cardList = cardList.shuffled()
        self.difficulty = difficulty
        
        // coloca todo los conteos de variables a 0
        score = 0 // Reiniciar el conteo
        attempts = 0  // Reiniciar los intentos
        completedScreens = 0 // Reiniciar los aciertos
        
    }
    

    
    /// Actualiza el nivel segun se ha completado paneles o no
    func updateDifficulty() {
        if completedScreens >= 4 {
            difficulty = .level_3
        }else if completedScreens >= 2 {
            difficulty = .level_2
        }
    }
  
    
    
    /// logica que permite poner una restriccion de tiempo
    func timeOff(){
        // lógica pendiente ...
    }
    
    /// Establece logic de fin de partida segun numero de intentos
    func gameOver(_ attempts: Int) -> Bool {
        if attempts >= 10 {
            return true
        }
        return false
    }
    
    /// Permite al usuario subir de nivel (Logica pensdiente de crear)
    func upNivelGame(){
        switch difficulty {
        case .level_1:
            // No hay restricciones adicionales
            break
        case .level_2:
            // Puedes agregar restricciones de intentos aquí
            break
        case .level_3:
            // Puedes agregar restricciones de tiempo y de intentos aquí
            break
        }
    }
    
}
