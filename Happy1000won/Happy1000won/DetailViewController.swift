//
//  DetailViewController.swift
//  Happy1000won
//
//  Created by Sora Yeo on 2017. 7. 14..
//  Copyright © 2017년 DeGi. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var dicInfomation:NSDictionary!
    
    @IBOutlet weak var imgMain:UIImageView!
    @IBOutlet weak var lbTitle:UILabel!
    @IBOutlet weak var txContent:UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.lbTitle.text = dicInfomation.object(forKey: "TITLE") as? String
        
        
        let imageUrl = URL(string: (dicInfomation.object(forKey: "FILE_URL_MI") as? String)!)!
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: imageUrl) { (data, response, error) in
            
            DispatchQueue.main.async {
                if let e = error {
                    print("Error: \(e)")
                } else {
                    if let res = response as? HTTPURLResponse {
                        if let imgData = data {
                            let image = UIImage(data: imgData)
                            
                            self.imgMain.image = image
                            
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

}
