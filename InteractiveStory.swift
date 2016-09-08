//
//  InteractiveStory.swift
//  InteractiveStory2
//
//  Created by Ben Shockley on 9/4/16.
//  Copyright © 2016 Ben Shockley. All rights reserved.
//

import UIKit
import Foundation

// Enum contains a case for all the chapters of the story.  Also has rawValues in String format attached to each case.
enum Story {
    case ReturnTrip(String)
    case TouchDown
    case Homeward
    case Rover(String)
    case Cave
    case Crate
    case Monster
    case Droid(String)
    case Home
    
    var rawValue: String {
        switch self {
        case .ReturnTrip: return "ReturnTrip"
        case .Homeward: return "Homeward"
        case .TouchDown: return "TouchDown"
        case .Rover: return "Rover"
        case .Cave: return "Cave"
        case .Crate: return "Crate"
        case .Monster: return "Monster"
        case .Droid: return "Droid"
        case.Home: return "Home"
        }
    }
}

extension Story {
    
    // Assigns the image to the artwowkr variable based on the rawvalue in the enum case.
    var artwork: UIImage {
        return UIImage(named: self.rawValue)!
    }
    
    var soundEffectURL: NSURL {
        let fileName: String
        
        switch self {
        case .Droid, .Home: fileName = "HappyEnding"
        case .Monster: fileName = "Ominous"
        default: fileName = "PageTurn"
            
        }
        
        let path = Bundle.main.path(forResource: fileName, ofType: "wav")!
        
        return NSURL(fileURLWithPath: path)
    }
    
    
    // A computed value that returns a chapter's text based on the enum case that is being used.
    var text: String {
        switch self {
        case .ReturnTrip(let name):
            return "On your return trip from studying Saturn's rings, you hear a distress signal that seems to be coming from the surface of Mars. It's strange because there hasn't been a colony there in years. \"Help me, \(name) you're my only hope.\""
        case .TouchDown:
            return "You deftly land your ship near where the distress signal originated. You didn't notice anything strange on your fly-by, behind you is an abandoned rover from the early 21st century and a small crate."
        case .Homeward:
            return "You continue your course to Earth. Two days later, you receive a transmission from HQ saing that they have detected some sort of anomaly on the surface of Mars near an abandoned rover. They ask you to investigate, but ultimately the decision is yours because your mission has already run much longer than planned and supplies are low."
        case .Rover(let name):
            return "The rover is covered in dust and most of the solar panels are broken. But you are quite surprised to see the on-board system booted up and running. In fact, there is a message on the screen. \"\(name), Come to 28.2342, -81.08273\". These coordinates aren't far but you don't know if your oxygen will last there and back."
        case .Cave:
            return "Your EVA suit is equipped with a headlamp which you use to navigate to a cave. After searching for a while your oxygen levels are starting to get pretty low. You know you should go refill your tank, but there's a faint light up ahead."
        case .Crate:
            return "Unlike everything else around you the crate seems new and...alien. As you examine the create you notice something glinting on the ground beside it. Aha, a key! It must be for the crate..."
        case .Monster:
            return "You pick up the key and try to unlock the crate, but the key breaks off in the keyhole.You scream out in frustration! Your scream alerts a creature that captures you and takes you away..."
        case .Droid(let name):
            return "After a long walk slightly uphill, you end up at the top of a small crater. You look around and are overjoyed to see your robot friend, \(name)-S1124. It had been lost on a previous mission to Mars. You take it back to your ship and fly back to Earth."
        case .Home:
            return "You arrive home on Earth. While your mission was a success, you forever wonder what was sending that signal. Perhaps a future mission will be able to investigate."
        }
    }
}


class Page {
    
    let story: Story
    
    // A touple that contains the title for the button choice, and the page that the button is assigned to.
    typealias Choice = (title: String, page: Page)
    
    // Variables of type Choice that represent the two buttons that will be on each page.
    var firstChoice: Choice?
    var secondChoice: Choice?
    
    // You pass the story enum case to Page when it is created, so page knows what chapter it needs to do stuff with.
    init(story: Story) {
        self.story = story
    }
}


extension Page {
    
    // adds the title and story connection to the button choices for each page.  
    
    
    func addChoice(title: String, story: Story) -> Page {
        
        // crates an instance of Page, called page, with the enum member of Story that was passed to the function.
        let page = Page(story: story)
        
        // calls the second addChoice function passing the same title, and the instance of page along with it.
        return addChoice(title: title, page: page)
    }
    
    
    func addChoice(title: String, page: Page) -> Page {
        
        // decides which choice button to assign the the page and title to.
        switch (firstChoice, secondChoice) {
        case (.some, .some): break
        case (.none, .none), (.none, .some): firstChoice = (title, page)
        case (.some, .none): secondChoice = (title, page)
        
        }
        
        // Returns the instance of page that was created in the first addChoice function.
        return page
    }
}


struct Adventure {
    
    // creating a computed variable called story, 
    
    static func story(name: String) -> Page {
        
        // creates and instance of Page called returnTrip
        let returnTrip = Page(story: .ReturnTrip(name))
        // creates a choice with the provided title, linking the Story enum member .Touchdown.
        let touchDown = returnTrip.addChoice(title: "Stop and investigate", story: .TouchDown)
        
        let homeward = returnTrip.addChoice(title: "Continue home to Earth", story: .Homeward)
        let rover = touchDown.addChoice(title: "Explore the rover", story: .Rover(name))
        let crate = touchDown.addChoice(title: "Open the crate", story: .Crate)
        
        homeward.addChoice(title: "Head back to Mars", page: touchDown)
        let home = homeward.addChoice(title: "Continue home to Earth", story: .Home)
        
        let cave = rover.addChoice(title: "Explore the coordinates", story: .Cave)
        rover.addChoice(title: "Return to Earth", story: .Home)
        
        cave.addChoice(title: "Continue towards faint light", story: .Droid(name))
        cave.addChoice(title: "Refill the ship and explore the rover", page: rover)
        
        crate.addChoice(title: "Explore the rover", page: rover)
        crate.addChoice(title: "Use the key", story: .Monster)
        
        return returnTrip
    }
    
    
}

































