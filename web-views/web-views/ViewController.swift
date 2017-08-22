//
//  ViewController.swift
//  web-views
//
//  Created by Dan Austin on 22/08/2017.
//  Copyright © 2017 Dan Austin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if let url = URL(string: "https://stackoverflow.com"){
            
            let request = URLRequest(url: url)
            
            let task = URLSession.shared.dataTask(with: request) {
                data, response, error in
            
                if let err = error {
                    print(err)
                }else{
                    if let unwrappedData = data {
                        let dataString = String.init(data: unwrappedData, encoding: String.Encoding.utf8)
                        print(dataString!)
                        
                        DispatchQueue.main.sync {
                            // Execute some code
                        }
                    }
                }
            }
            
            task.resume()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

