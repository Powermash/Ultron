//
//  main.swift
//  Ultron
//
//  Created by Romain Pouclet on 2014-12-08.
//  Copyright (c) 2014 Romain Pouclet. All rights reserved.
//

import Foundation

let endpoint = NSURL(string: "https://young-tundra-4558.herokuapp.com/index.php/match")!
let keyboard = NSFileHandle.fileHandleWithStandardInput();

func fetchMatch() {
    let task = NSURLSession.sharedSession().dataTaskWithURL(endpoint, completionHandler: { (data, response, error) -> Void in
        if (error != nil) {
            println("Got error fetching match \(error.localizedDescription)")
            return;
        }
        
        var error: NSError?
        
        if let fetchedMatch: NSDictionary! = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.allZeros, error: &error) as? NSDictionary! {
//            println("Got match")
            let a = fetchedMatch.valueForKeyPath("character_a.name") as NSString!
//            println("a = \(a)")
            
            let b = fetchedMatch.valueForKeyPath("character_b.name") as NSString!
//            println("a = \(b)")
            
            println("\(a) (1) vs \(b) (2). Who wins?")
            print("> ")
            
            let inputData = keyboard.availableData
            var input: NSString
            
            if let input = NSString(data: inputData, encoding: NSUTF8StringEncoding) {
                println("Input was \(input)")
                switch input {
                    case "1":
                        println("User voted for \(a)")
                case "2":
                        println("User voted for \(b)")
                default:
                    println("Invalid answer")
                }
                
                // TODO send match
                fetchMatch()
            }
        } else {
            println("Unable to fetch match, got error \(error)")
        }
    })
    
    task.resume()
}

fetchMatch()

// Meh?
while NSRunLoop.currentRunLoop().runMode(NSDefaultRunLoopMode, beforeDate: NSDate.distantFuture() as NSDate) {}
