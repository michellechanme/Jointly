//: Playground - noun: a place where people can play

import UIKit


class Settings {
    

private var settings = [String : String]()

    func setBrightness(asdf: String) {
        println(asdf)
        var boba = asdf
        settings["brightness"] = boba
    }
    
    func setString(object : String, forKey: String) {
        settings[forKey] = object
    }
    



}

var s = Settings()
s.setBrightness("50%")

s.setString("50%", forKey: "brightness")


var obj  = PFObject("class")
object.setObject(note.title, forKey:"title")
