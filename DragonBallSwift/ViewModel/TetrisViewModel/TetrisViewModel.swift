//
//  TetrisViewModel.swift
//  DragonBallSwift
//
//  Created by Esteban Perez Castillejo on 30/7/24.
//

import Foundation
import Combine
import Observation

@Observable
class TetrisViewModel {
    let width: Int = 9
    let height: Int = 26
   
    var score: Int = 0 // Guuarda puntuaqcion
    var level: Int = 1  // Guaerda el nivel
    var lines: Int = 0  // y el numero de lines creadas
    
    // Para calcular cuantes las lineas
    private var linePerLevel: Int = 5 // cuantas lineas tenemos que conseguir en el nivel actual
    private var linesToLevelUp: Int = 5 // nos indica las lineas para subie de nivel
    
    var speed: Double = 0.5 // velocidad en la que cae lñas lineas
    
    var boardMatrix: [[SquereGame?]]
    var activeShape: Shape? = nil
    var nextActiveShape: Shape? = nil
    
    var gameIsOver: Bool = false
    var gameIsStopped : Bool = true
    
    var timer = Timer.publish(every: 0.5, on: .main, in: .common)
    var cancellableSet: Set<AnyCancellable> = []
    
    init() {
        boardMatrix = Array(repeating: Array(repeating: nil, count: width), count: height)
    }
    
    func moveDown(){
        if gameIsOver || gameIsStopped { // nos aseguramos que nuestro juego se termina
            return
        }
        activeShape?.moveDown()
        
        if let shape = activeShape {
            if !isInValidPosition(shape: shape){
                activeShape?.moveUp()
                if isOverLimit(shape: activeShape!){
                    gameOver() // Se implementa la funcion de Finde juego
                    return
                  
                }
                
                landShape ()
            }
        }
    }
    
    // Almacena nuestra ficha, en el tablero y calcula cuantas fila se han limpiado
    func landShape (){
        if let shape = activeShape {
            storeShapeInGrid (shape: shape)
            
            let cleared = clearAllRows() // lines que se han limpiado
            score += calculateScore(linesCleared: cleared, level: level) // Calcula la puntuación
            
            lines += cleared // Calcula el numero de lineas que llebamoas
            
            linesToLevelUp -= cleared // realiza elcaculo para subir de nivel
            
            if linesToLevelUp <= 0 {
                levelUp()
            }
        }
    }
    
    private func getSquereGameInMatrix(x: Int, y: Int) -> SquereGame? {
        if y >= 0, x >= 0, y < height, x < width {
            return boardMatrix[y][x]
        }else {
            return nil
        }
    }
    
    func storeShapeInGrid(shape: Shape){
        if isInValidPosition(shape: shape) {
            for position in shape.occuppiedPositions {
                boardMatrix[position.y][position.x] = SquereGame(x: position.x, y: position.y, occupied: true, color: shape.color)
            }
        }
        
        activeShape = nextActiveShape
        nextActiveShape = createRandonShape()
    }
    
    func getSquareGame(x: Int, y: Int) -> SquereGame? {
        if let activeShape = activeShape, activeShape.isInPosition(x: x, y: y) {
            return SquereGame(x: x, y: y, color: activeShape.color)
        }
        
        if let squareGame = getSquereGameInMatrix(x: x, y: y), squareGame.occupied {
            return squareGame
        }
        
        return nil
    }

    func moveLeft(){
        activeShape?.moveleft()
        
        if let shape = activeShape, !isInValidPosition(shape: shape) {
           
                activeShape?.moveRight()
        }
    }
    
    func moveRight(){
        activeShape?.moveRight()
        if let shape = activeShape, !isInValidPosition(shape: shape) {
           
            activeShape?.moveleft()
        }
    }
    
    func rotateShape(){
        activeShape?.rotateRight()
        
        if let shape = activeShape, !isInValidPosition(shape: shape) {
           
                activeShape?.rotateLeft()
        }
    }
    
    func createRandonShape() -> Shape {
        
        let value = Int.random(in: 0..<7)
        
        switch(value){
        case 0: return SquareShape()
        case 1: return IShape()
        case 2: return TShape()
        case 3: return LShape()
        case 4: return JShape()
        case 5: return SShape()
        case 6: return ZShape()
        default: return SquareShape()
        }
    }
    
    func isInValidPosition (shape: Shape) -> Bool {
        for position in shape.occuppiedPositions {
            if (!isWithInBoard(x: position.x, y: position.y)){
                return false
            }
            
            if isOccupied(x: position.x, y: position.y, shape: shape){
                return false
            }
            
        }
        
        return true
    }
    
    func isWithInBoard(x: Int, y: Int) -> Bool{
        if x < width, y < height, x >= 0{
            return true
        }
        return false
    }
    
    func isOccupied(x: Int, y: Int, shape: Shape) -> Bool {
        if let squareGame = getSquareBoard(x: x, y: y), squareGame.occupied{
            return true
        }
        return false
    }
    
    private func getSquareBoard(x: Int, y: Int) -> SquereGame? {
        if y >= 0, x >= 0, y < height, x < width {
            return boardMatrix[y][x]
        } else {
            return nil
        }
        
    }
    
    func isOverLimit(shape: Shape) -> Bool {
        for position in shape.occuppiedPositions {
            if position.y <= -1 || position.y >= height {
                return true
              
            }
        }
        return false
    }
    
    func clearAllRows() -> Int{
        var cleared = 0
        
        for (index, _) in  boardMatrix.enumerated() {
            if isRowComplete(y: index) {
                clearRow(y: index)
                shiftRowsDown (end: index)
                
                cleared += 1
            }
        }
        
        return cleared
    }
    
    func isRowComplete(y: Int) -> Bool{
        boardMatrix[y].filter{ squaregame in
            squaregame == nil || squaregame?.occupied == false
        }.count == 0
    }
    
    func clearRow(y: Int){
        for index in boardMatrix[y].indices {
            boardMatrix[y][index] = nil
        }
    }
    
    func shiftRowsDown(end: Int){
        for index in (0..<end).reversed() {
            shitfOneRowDown(y: index)
        }
    }
    
    func shitfOneRowDown (y: Int){
        for index in boardMatrix[y].indices {
            if let squareGame = boardMatrix[y][index] {
                boardMatrix[y + 1][index] = SquereGame(x: squareGame.x, y: squareGame.y, occupied: true, color: squareGame.color)
            }else {
                boardMatrix[y + 1][index] = nil
            }
            
            boardMatrix[y][index] = nil
        }
    }
    
    //Calcular las lineas
    func calculateScore(linesCleared: Int, level: Int) -> Int{
        //clear one line --> 40 points x level
        //clear two lines --> 100 points x lev
        //clear three lines --> 300 points x level
        //clear four lines --> 1200 points x level
        
        var score = 0
        switch (linesCleared){
        case 1: score = 40 * level    //clear one line -> 40 points x level
        case 2: score = 100 * level   //clear two lines -> 100 points x level
        case 3: score = 300 * level   //clear three lines -> 300 points x level
        case 4: score = 1200 * level  //clear four lines --> 1200 points x level
        default: score = 0
        }
        return score
    }
    
    // Para subir de nivel
    func levelUp(){
        level += 1 // subir de nivel
        linesToLevelUp = level * linePerLevel // se incrementa las lineas que hace falta para subir de nivel
        
        //Cambiaer la velocidad
        if speed >= 0.1 {
            speed -= 0.05 // Ir decrementando la velocidad
            
            cancellableSet = []
            
            timer = Timer.publish(every: speed, on: .main, in: .common) // se setea el tiempo, indicando la nueva velocidad
            
            timer
                .autoconnect().sink{ timer in
                    self.moveDown()
                }.store(in: &cancellableSet)
        }
    }
    
    // Funcion de final de juego
    func gameOver(){
        gameIsOver = true
        gameIsStopped = true
        activeShape = nil
        nextActiveShape = nil
        
        boardMatrix = Array(repeating: Array(repeating: nil, count: width), count: height)
    }
    
    func restartGame(){
        cancellableSet = []
        
        level = 1
        lines = 0
        score = 0
        speed = 0.5
        linesToLevelUp = 5
        
        timer = Timer.publish(every: speed, on: .main, in: .common)
        
        timer
            .autoconnect().sink{ timer in
                self.moveDown()
            }.store(in: &cancellableSet)
        
        gameIsOver = false
        gameIsStopped = false
        
        if activeShape == nil {
            activeShape = createRandonShape()
            nextActiveShape = createRandonShape()
        }
    }
}
 
 
