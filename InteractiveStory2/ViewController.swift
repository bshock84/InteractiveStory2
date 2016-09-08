//
//  ViewController.swift
//  InteractiveStory2
//
//  Created by Ben Shockley on 8/28/16.
//  Copyright © 2016 Ben Shockley. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var textFieldBottomConstraint: NSLayoutConstraint!
    var textFieldBottomConstraintOriginalPosition: CGFloat = 0.0
    
    
    enum Errors: Error {
        case NoName
    }
    
    @IBOutlet weak var nameTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyBoardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
    }
    
    func keyBoardWillShow(notification: Notification) {
        
        textFieldBottomConstraintOriginalPosition = textFieldBottomConstraint.constant
        if let userInfoDict = notification.userInfo, let keyboardFrameValue = userInfoDict[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardFrame = keyboardFrameValue.cgRectValue
            
            UIView.animate(withDuration: 0.8) {
                self.textFieldBottomConstraint.constant = keyboardFrame.size.height + 10
                self.view.layoutIfNeeded()
            }
            
        }
        
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
            do {
                if let name = nameTextField.text {
                    if name == "" {
                        throw Errors.NoName
                    }
                    if let pageController = segue.destination as? PageController {
                        pageController.page = Adventure.story(name: name)
                    }
                }
                
            } catch {
                let alertController = UIAlertController(title: "Name Not Provided", message: "Provide a name to start your story", preferredStyle: .alert)
                let action = UIAlertAction(title: "Okay", style: .default, handler: nil)
                alertController.addAction(action)
                
                present(alertController, animated: true, completion: nil)
            }
            
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    //MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        keyboardWillHide()
        return true
    }
    
    func keyboardWillHide() {
        UIView.animate(withDuration: 0.5) {
            self.textFieldBottomConstraint.constant = self.textFieldBottomConstraintOriginalPosition
            self.view.layoutIfNeeded()
        }
    }
    

}

