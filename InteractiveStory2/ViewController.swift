//
//  ViewController.swift
//  InteractiveStory2
//
//  Created by Ben Shockley on 8/28/16.
//  Copyright © 2016 Ben Shockley. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //If it is the correct segue, identified by the string that we decided in the storyboard.
        // then we assign a constant, pageController, to the destination ViewController, and cast it as a PageController.
        // Then we assign the page property of pageController to the Adventure struct, and cause story to return to start of our story.
        if segue.identifier == "startAdventure" {
            if let pageController = segue.destination as? PageController {
                pageController.page = Adventure.story
            }
        }
    }

}

