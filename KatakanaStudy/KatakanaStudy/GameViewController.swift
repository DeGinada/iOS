//
//  GameViewController.swift
//  KatakanaStudy
//
//  Created by Sora Yeo on 2017. 7. 9..
//  Copyright © 2017년 DeGi. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

    @IBOutlet var lbKatakana:UILabel!
    @IBOutlet var btnAnswer1:UIButton!
    @IBOutlet var btnAnswer2:UIButton!
    @IBOutlet var btnAnswer3:UIButton!
    @IBOutlet var btnAnswer4:UIButton!
    
    
    var g_arKanakana:NSArray! = nil
    var g_isHiragana:Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        btnAnswer1.layer.cornerRadius = 6;
        btnAnswer2.layer.cornerRadius = 6;
        btnAnswer3.layer.cornerRadius = 6;
        btnAnswer4.layer.cornerRadius = 6;
        
        
        setKatakanaArray()
        showKatakana()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func setKatakanaArray() {
        
        // 파일 가져와서 array로 지정
        let path:String = Bundle.main.path(forResource: "katakana", ofType: "plist")!
        g_arKanakana = NSArray.init(contentsOfFile: path) as NSArray!
        
        print(g_arKanakana)
    }
    
    func showKatakana() {
        // 문제 출력
        // 현재 문제 보기를 히라가나로 할지, 영어로 할지 정하기
        if arc4random()%2 == 0 {
            g_isHiragana = true
        } else {
            g_isHiragana = false
        }
        
        // 문제 번호 
        let quizNum:Int = Int(arc4random()) % g_arKanakana.count
        lbKatakana.tag = quizNum
        
        // array에서 dic으로 가져온 후, string 적용
        let quiz:NSDictionary = g_arKanakana.object(at: quizNum) as! NSDictionary
        lbKatakana.text? = quiz.object(forKey: "ka") as! String
        
        let arAnswer:Array<String> = suffleAnswer()
        
        btnAnswer1.setTitle(arAnswer[0], for: .normal)
        btnAnswer2.setTitle(arAnswer[1], for: .normal)
        btnAnswer3.setTitle(arAnswer[2], for: .normal)
        btnAnswer4.setTitle(arAnswer[3], for: .normal)
        
    }
    
    
    func suffleAnswer() -> Array<String> {
        
        var answer:Array<String> = ["", "", "", ""]
        let numAnswer:Int = Int(arc4random()%4)
    
        let quiz:NSDictionary = g_arKanakana.object(at: lbKatakana.tag) as! NSDictionary
        if (g_isHiragana) {
//            answer.insert(quiz.object(forKey: "hi") as! String, at: numAnswer)
            answer[numAnswer] = quiz.object(forKey: "hi") as! String
        } else {
//            answer.insert(quiz.object(forKey: "en") as! String, at: numAnswer)
            answer[numAnswer] = quiz.object(forKey: "en") as! String
        }
        
        var count:Int = 0
        while (count < 4) {
            if (count != numAnswer) {
                let index:Int = Int(arc4random())%g_arKanakana.count
                let temp:NSDictionary = g_arKanakana.object(at: index) as! NSDictionary
                var strTemp:String = ""
                if (g_isHiragana) {
                    strTemp = temp.object(forKey: "hi") as! String
                } else {
                    strTemp = temp.object(forKey: "en") as! String
                }
                
                var isExist:Bool = false
                
                for str:String in answer {
                    if (strTemp.compare(str) == .orderedSame) {
                        isExist = true
                    }
                }
                
                if (!isExist) {
//                    answer.insert(strTemp, at: count)
                    answer[count] = strTemp
                    count += 1
                }
            } else {
                count += 1
            }
        }
        
        return answer
    }

    @IBAction func checkAnswer(sender: AnyObject) {
        // 정답확인 함수
        let button = sender as! UIButton
        
        
        let quiz:NSDictionary = g_arKanakana.object(at: lbKatakana.tag) as! NSDictionary
        var quizAnswer:String = ""
        if (g_isHiragana) {
            quizAnswer = quiz.object(forKey: "hi") as! String
        } else {
            quizAnswer = quiz.object(forKey: "en") as! String
        }
        
        if let userAnswer = button.title(for: .normal) {
            if (quizAnswer.compare(userAnswer) == .orderedSame) {
                NSLog("정답입니다", "")
                
                showKatakana()
            } else {
                NSLog("땡!!!!", "")
            }
        }
    }
}
