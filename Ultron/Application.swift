//
//  Application.swift
//  Ultron
//
//  Created by Romain Pouclet on 2014-12-09.
//  Copyright (c) 2014 Romain Pouclet. All rights reserved.
//

import Cocoa

typealias Character = (id: String, name: String)
typealias Match = (a: Character, b: Character)

class Application: NSObject {
    let keyboard = NSFileHandle.fileHandleWithStandardInput()
    
    func run() {
        var running = true
        
        while running {
            let match = fetchMatch()
            
            println(match.a.name + "(1) vs " + match.b.name + "(2)")
            let answer = prompt("Who wins?")
            print("According to user: '\(answer)'")
            
            var winner: Character!
            switch answer {
                case "1":
                    winner = match.a
                case "2":
                    winner = match.b
            default:
                running = false
            }
        }
    }
    
    func prompt(prompt: String) -> String {
        print(prompt + "> ")
        let content = keyboard.availableData as NSData!

        let answer = NSString(data: content, encoding: NSUTF8StringEncoding)!
        return answer.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
    }
    
    func fetchMatch() -> Match {
        let content = NSData(contentsOfURL: NSURL(string: "https://young-tundra-4558.herokuapp.com/index.php/match")!)
        var error: NSError?;
        let payload = NSJSONSerialization.JSONObjectWithData(content!, options: NSJSONReadingOptions.allZeros, error: &error) as Dictionary<String, Dictionary<String, String>>
        
        let a = payload["character_a"]! as Dictionary<String, String>
        let b = payload["character_b"]! as Dictionary<String, String>
        
        return Match(a: Character(id: "1", name: a["name"] as String!), b: Character(id: "2", name: b["name"] as String!))
    }
}
