//
//  ViewController.swift
//  tic-tac-toe
//
//  Created by Dan Austin on 23/08/2017.
//  Copyright © 2017 Dan Austin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    enum Player {
        case X
        case O
    }
    @IBOutlet weak var lblStatus: UILabel!
    
    @IBAction func btnResetPressed(_ sender: Any) {
        resetGame()
    }
    let imgCross = #imageLiteral(resourceName: "cross.png")
    let imgNought = #imageLiteral(resourceName: "nought.png")
    
    // Array to represent the board. Each position can be .O, .X or nil
    var board = [Player?](repeating: nil, count: 9)
    var gameFinished = false
    var currentPlayer = Player.O
    
    @IBAction func buttonWasClicked(_ sender: UIButton){
        processTurn(onSpace: sender.tag-1)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func togglePlayer(){
        if currentPlayer == .O {
            currentPlayer = .X
            updateHeadLabel(to: "Crosses' turn!", withColour: .black)
        } else {
            currentPlayer = .O
            updateHeadLabel(to: "Noughts' turn!", withColour: .black)
        }
    }
    
    func processTurn(onSpace space: Int){
        if board[space] == nil && !gameFinished{
            board[space] = currentPlayer
            if let button = view.viewWithTag(space+1) as? UIButton{
                if currentPlayer == .O{
                    button.setImage(imgNought, for: .normal)
                } else{
                    button.setImage(imgCross, for: .normal)
                }
            }
            if playerHasWon(){
                displayWinningText()
                gameFinished = true
                return
            }
            togglePlayer()
        }
    }
    
    func displayWinningText(){
        let winningText = "\(currentPlayer == .O ? "Noughts" : "Crosses") have won!"
        updateHeadLabel(to: winningText, withColour: .green)
    }
    
    func updateHeadLabel(to text: String, withColour colour: UIColor){
        lblStatus.text = text
        lblStatus.textColor = colour
    }
    
    func playerHasWon() -> Bool{
        return horizontalWin() || verticalWin() || diagonalWin()
    }
    
    func horizontalWin() -> Bool{
        let row1Win = board[0] == board[1] && board[1] == board[2] && board[2] != nil
        let row2Win = board[3] == board[4] && board[4] == board[5] && board[5] != nil
        let row3Win = board[6] == board[7] && board[7] == board[8] && board[8] != nil
        return row1Win || row2Win || row3Win
    }
    
    func verticalWin() -> Bool{
        let col1Win = board[0] == board[3] && board[3] == board[6] && board[6] != nil
        let col2Win = board[1] == board[4] && board[4] == board[7] && board[7] != nil
        let col3Win = board[2] == board[5] && board[5] == board[8] && board[8] != nil
        return col1Win || col2Win || col3Win
    }
    
    func diagonalWin() -> Bool{
        let diag1Win = board[0] == board[4] && board[4] == board[8] && board[8] != nil
        let diag2Win = board[2] == board[4] && board[4] == board[6] && board[6] != nil
        return diag1Win || diag2Win
    }
    
    func resetGame(){
        gameFinished = false
        currentPlayer = .O
        // Set all elements to nil
        board = board.map { (ele) -> Player? in
            nil
        }
        // Clear button images
        for i in 1...10 {
            if let button = view.viewWithTag(i) as? UIButton{
                button.setImage(nil, for: .normal)
            }
        }
        updateHeadLabel(to: "Noughts' turn!", withColour: .black)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

