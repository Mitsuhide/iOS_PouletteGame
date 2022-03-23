//
//  ViewController.swift
//  PouletteGame
//
//  Created by OCTO-TTOP on 01/03/2022.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var pouleImageView: UIImageView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var noBtn: UIButton!
    @IBOutlet weak var yesBtn: UIButton!
    
    var score : Int = 0
    var isGameOn = false
    var currentChicken: Int = 0
    let wrongAnswers : [Int] = [1, 3, 6]
    var chickenCenter: CGPoint?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        updateUI()
        resultLabel.text = ""
    }
    
    func play() {
        isGameOn = true
        score = 0
        updateScore()
        updateUI()
        setupChicken()
    }
    
    func stop() {
        isGameOn = false
        updateUI()
        pouleImageView.image = UIImage(named: "bg")
    }
    
    func checkAnswer(tag: Int){
        let wrong = wrongAnswers.contains(currentChicken)
        let saidNo = tag == 1
        let success = wrong == saidNo
        if success {
            score += 1
            updateScore()
        }
        updateAnswer(success: success)
        setupChicken()
        setupBackground(color: .systemBackground)
    }
    
    func updateUI() {
        yesBtn.isHidden = !isGameOn
        noBtn.isHidden = !isGameOn
        playBtn.setTitle(!isGameOn ? "Play" : "Stop", for: .normal)
        resultLabel.isHidden = !isGameOn
        pouleImageView.layer.cornerRadius = 20
        pouleImageView.isUserInteractionEnabled = !isGameOn
    }
    
    func updateScore() {
        scoreLabel.text = "Score: \(score)"
    }
    
    func updateAnswer(success: Bool) {
        resultLabel.text = success ? "Gagné" : "Perdu"
    }
    
    func setupChicken() {
        currentChicken = Int.random(in: 0...7)
        let imageString = "poule\(currentChicken)"
        let image = UIImage(named: imageString)
        pouleImageView.image = image
    }
    
    func getTouch(touches: Set<UITouch>) -> CGPoint? {
        guard let touch = touches.first else { return nil }
        let center =  touch.location(in: self.view)
        return center
    }
    
    func leftOrRight(x: CGFloat) -> Int {
        let viewX = self.view.center.x
        let valueX = viewX - x
        print(valueX)
        if (valueX > 75) {
            return 0
        } else if (valueX < -75) {
            return 1
        } else {
            return 2
        }
    }
    
    func setupBackground(color: UIColor) {
        self.view.backgroundColor = color
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard chickenCenter == nil else { return }
        chickenCenter = pouleImageView.center
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let center = getTouch(touches: touches) else { return }
        let y = chickenCenter!.y
        let x = center.x
        pouleImageView.center = CGPoint(x: x, y: y)
        
        let tag = leftOrRight(x: center.x)
        switch(tag) {
        case 0: setupBackground(color: .systemGreen)
        case 1:setupBackground(color: .systemRed)
        default:setupBackground(color: .systemBackground)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let center = getTouch(touches: touches) else { return }
        pouleImageView.center = chickenCenter!
        
        let tag = leftOrRight(x: center.x)
        if tag != 2 {
            checkAnswer(tag: tag)
        }
    }

    @IBAction func playBtnPressed(_ sender: Any) {
        isGameOn ? stop() : play()
    }
    
    @IBAction func answerPressed(_ sender: UIButton) {
        let tag = sender.tag
       checkAnswer(tag: tag)
    }
    
}

