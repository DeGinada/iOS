//
//  ViewController.swift
//  Happy1000won
//
//  Created by Sora Yeo on 2017. 7. 11..
//  Copyright © 2017년 DeGi. All rights reserved.
//

import UIKit


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView:UITableView!
    var arHappyInfo:NSArray!
    
    var data: NSMutableData = NSMutableData()
    let API_URL:String = "http://openAPI.seoul.go.kr:8088/sample/json/SJWHappySCHEDULE/1/5/"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        setHappyInfo()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func setHappyInfo() {
        
        let url:URL = URL(string: API_URL.addingPercentEncoding(withAllowedCharacters:.urlQueryAllowed)!)!
        var request:URLRequest = URLRequest(url: url as URL)
        request.httpMethod = "GET"
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
//            guard let data = data, error == nil else {
//                print("error=\(String(describing: error))")
//                return
//            }
//            
//            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
//                print("statusCode should be 200, but is \(httpStatus.statusCode)")
//                print("response = \(String(describing: response))")
//            }
//            
//            let responseString = String(data: data, encoding: String.Encoding(rawValue: CFStringConvertEncodingToNSStringEncoding(0x0422)))
//            
//            // 현재 data에 값이 안 들어옴
//            NSLog(responseString!, "")
            if error != nil {
                NSLog("error::\(String(describing: error))", "")
            } else {
                do {
                    let json = try JSONSerialization.jsonObject(with:data!, options:.mutableContainers) as! [String:AnyObject]
                    
//                    let status = json["status"] as! String
                    NSLog(String(data: data!, encoding: String.Encoding.utf8) as String!, "")
                } catch {
                    NSLog("error::\(String(describing: error))", "")
                }
            }
        }
        task.resume()
    
    }
    
    
    // table 행 수 설정 (필수)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 0
    }
    
    // table cell 내용(필수)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        
        return cell
    }
    
}

