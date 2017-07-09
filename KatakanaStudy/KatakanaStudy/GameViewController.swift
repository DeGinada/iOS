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
        
        let quiz:NSDictionary = g_arKanakana.object(at: quizNum) as! NSDictionary
        lbKatakana.text? = quiz.object(forKey: "ka") as! String
        
        
    }

    @IBAction func checkAnswer(sender: AnyObject) {
        // 정답확인 함수
    }
}
