//
//  ViewController.swift
//  Twittermenti
//
//  Created by Sergey Starchenkov on 01/02/2021.
//  Copyright © 2021 Sergey Starchenkov. All rights reserved.
//

import UIKit
import SwifteriOS
import CoreML
import SwiftyJSON

class ViewController: UIViewController {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var sentimentLabel: UILabel!
    
    // Add object TweetSentimentClassifier models
    let sentimentClassifier = try? TweetSentimentClassifier(configuration: .init())
    
    // Add object for autentification with consumerKey and consumerSecret
    let swifter = Swifter(consumerKey: "TWITTER_CONSUMER_KEY", consumerSecret: "TWITTER_CONSUMER_SECRET")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func predictPressed(_ sender: Any) {
        
        if let searchText = textField.text {
            
            // Add request with using searchText, get 100 EN tweets with 280 characters
            swifter.searchTweet(using: searchText, lang: "en", count: 100, tweetMode: .extended) { (results, metadata) in
                
                var tweets = [TweetSentimentClassifierInput]()
                
                for index in 0..<100 {
                    if let tweet = results[index]["full_text"].string {
                        tweets.append(TweetSentimentClassifierInput(text: tweet))
                    }
                }
                
                do{
                    let predictions = try self.sentimentClassifier?.predictions(inputs: tweets)
                    var sentimentScore = 0
                    
                    for prediction in predictions! {
                        
                        let sentiment = prediction.label
                        if  sentiment == "Pos"{
                            sentimentScore += 1
                        } else if sentiment == "Neg"{
                            sentimentScore -= 1
                        }
                    }
                    
                    if sentimentScore > 20 {
                        self.sentimentLabel.text = "😍"
                    } else if sentimentScore > 10 {
                        self.sentimentLabel.text = "😃"
                    } else if sentimentScore > 0 {
                        self.sentimentLabel.text = "🙂"
                    } else if sentimentScore == 0 {
                        self.sentimentLabel.text = "😐"
                    } else if sentimentScore > -10 {
                        self.sentimentLabel.text = "😕"
                    } else if sentimentScore > -20 {
                        self.sentimentLabel.text = "😡"
                    } else {
                        self.sentimentLabel.text = "🤮"
                    }
                    
                }
                catch {
                    print ("Error predictions \(error)")
                }
                
            } failure: { (error) in
                print("There was an error with the Twitter API Request, \(error)")
            }
        }
    }
    
}
