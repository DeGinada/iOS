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
    
    var selIndex: Int!

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
            
            DispatchQueue.main.async {
                if error != nil {
                    NSLog("error::\(String(describing: error))", "")
                } else {
                    do {
                        let json = try JSONSerialization.jsonObject(with:data!, options:.mutableContainers) as! [String:AnyObject]
                        
                        //                    let status = json["status"] as! String
                        //                    NSLog(String(data: data!, encoding: String.Encoding.utf8) as String!, "")
                        //                    print(json)
                        
                        let content = json["SJWHappySCHEDULE"] as! NSDictionary
                        let resultCode = (content.object(forKey: "RESULT") as! NSDictionary).object(forKey: "CODE") as! String
                        if (resultCode.compare("INFO-000") == .orderedSame) {
                            self.arHappyInfo = content.object(forKey: "row") as! NSArray
//                            print(self.arHappyInfo)
                            
//                            let dicInfo:NSDictionary = self.arHappyInfo.object(at: 1) as! NSDictionary
//                            let title:String = dicInfo.object(forKey: "TITLE") as! String
//                            let name:String = dicInfo.object(forKey: "PLACE_NAME") as! String
//                            
//                            print(title, "   //   ", name)
                            
                            self.tableView.reloadData()
                        }
                    } catch {
                        NSLog("error::\(String(describing: error))", "")
                    }
                }
            }
            
        }
        task.resume()
    
    }
    
    
    // table 행 수 설정 (필수)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (self.arHappyInfo == nil) {
            return 0
        }
        
        return self.arHappyInfo.count
    }
    
    // table cell 내용(필수)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        let cell:InfomationTableViewCell = InfomationTableViewCell(style: .default, reuseIdentifier: "Cell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "InfomationTableViewCell", for: indexPath) as! InfomationTableViewCell
        
        let dicData:NSDictionary = self.arHappyInfo.object(at: indexPath.row) as! NSDictionary
        
        //        cell.imgThumbnail.image = UIImage()
        
        let image = dicData.object(forKey: "FILE_URL_TI") as! String
        let title:String = dicData.object(forKey: "TITLE") as! String
        let date:String = (dicData.object(forKey: "START_DATE") as! String)+" ~ "+(dicData.object(forKey: "END_DATE") as! String)
        let place:String = dicData.object(forKey: "PLACE_NAME") as! String
        
        cell.lbTitle.text = title
        cell.lbDate.text = date
        cell.lbPlace.text = place
        setImage(imgView: cell.imgThumbnail!, url: image)
        cell.imgThumbnail.sizeThatFits(CGSize(width: 100, height: 100))
        cell.imgThumbnail.clipsToBounds = true
        cell.imgThumbnail.contentMode = .scaleAspectFill
        return cell
    }
    
    
    
    func setImage(imgView:UIImageView, url:String) {
        let imageUrl = URL(string: url)!
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: imageUrl) { (data, response, error) in
            
            DispatchQueue.main.async {
                if let e = error {
                    print("Error: \(e)")
                } else {
                    if let res = response as? HTTPURLResponse {
                        if let imgData = data {
                            let image = UIImage(data: imgData)
                            
                            imgView.image = image
                            
                        } else {
                            print("Couldn't get image: Image is nil")
                        }
                    } else {
                        print("Couldn't get response code for some reason")
                    }
                }
            }
            
        }
        task.resume()
        
    }
    
    
    @IBAction func exitFromSecondVC(segue: UIStoryboardSegue) {
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier?.compare("segDetail") == .orderedSame) {
            let detailVC:DetailViewController = segue.destination as! DetailViewController
            detailVC.dicInfomation = arHappyInfo.object(at: self.selIndex) as! NSDictionary
        }
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        self.selIndex = indexPath.row
        
        return indexPath
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        self.selIndex = indexPath.row
//    }
}

