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
    
    // Add MAX tweet count for request
    // 100 - MAX count tweet in free account developer Twitter
    let tweetCount = 100
    
    // Add object TweetSentimentClassifier models
    let sentimentClassifier = try? TweetSentimentClassifier(configuration: .init())
    
    // Add object for autentification with consumerKey and consumerSecret
    let swifter = Swifter(consumerKey: "TWITTER_CONSUMER_KEY", consumerSecret: "TWITTER_CONSUMER_SECRET")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func predictPressed(_ sender: Any) {
        
        fetchTweets()
        
    }
    
    func fetchTweets(){
        
        if let searchText = textField.text {
            
            // Add request with using searchText, get tweetCount EN tweets with 280 characters
            swifter.searchTweet(using: searchText, lang: "en", count: tweetCount, tweetMode: .extended) { (results, metadata) in
                
                var tweets = [TweetSentimentClassifierInput]()
                
                for index in 0..<self.tweetCount {
                    if let tweet = results[index]["full_text"].string {
                        tweets.append(TweetSentimentClassifierInput(text: tweet))
                    }
                }
                
                self.makePredictions(with: tweets)
                
            } failure: { (error) in
                print("There was an error with the Twitter API Request, \(error)")
            }
        }
        
    }
    
    func makePredictions(with tweets: [TweetSentimentClassifierInput]){
        
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
            updateUI(with: sentimentScore)
        }
            
        catch {
            print ("Error predictions \(error)")
        }
        
    }
    
    func updateUI(with sentimentScore: Int){
        
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
        
}
