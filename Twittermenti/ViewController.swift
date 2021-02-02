//
//  ViewController.swift
//  Twittermenti
//
//  Created by Sergey Starchenkov on 01/02/2021.
//  Copyright © 2021 Sergey Starchenkov. All rights reserved.
//

import UIKit
import SwifteriOS

class ViewController: UIViewController {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var sentimentLabel: UILabel!
    
    // Add object for autentification with consumerKey and consumerSecret
    let swifter = Swifter(consumerKey: "TWITTER_CONSUMER_KEY", consumerSecret: "TWITTER_CONSUMER_SECRET")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add request with using searchText, get 100 EN tweets with 280 characters
        swifter.searchTweet(using: "@Apple", lang: "en", count: 100, tweetMode: .extended) { (results, metadata) in
            print(results)
        } failure: { (error) in
            print("There was an error with the Twitter API Request, \(error)")
        }

    }

    @IBAction func predictPressed(_ sender: Any) {
    
    
    }
    
}

