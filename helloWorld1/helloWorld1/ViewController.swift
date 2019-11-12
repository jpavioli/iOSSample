//
//  ViewController.swift
//  helloWorld1
//
//  Created by Sue Chung on 10/23/19.
//  Copyright © 2019 Sue Chung. All rights reserved.
//

import UIKit
import mParticle_Apple_SDK

class ViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    
    var email = ""
    var username = ""
    
    @IBAction func loginButton(_ sender: Any) {
        performSegue(withIdentifier: "login", sender: self)
        let identityRequest = MPIdentityApiRequest.withEmptyUser()
    
        let identityCallback = {(result: MPIdentityApiResult?, error: Error?) in
            if (result?.user != nil) {
                //IDSync request succeeded, mutate attributes or query for the MPID as needed
                result?.user.setUserAttribute("Callback", value: "Value")
            } else {
                NSLog(error!.localizedDescription)
                let resultCode = MPIdentityErrorResponseCode(rawValue: UInt((error! as NSError).code))
                switch (resultCode!) {
                case .clientNoConnection,
                     .clientSideTimeout:
                    //retry the IDSync request
                    break;
                case .requestInProgress,
                     .retry:
                    //inspect your implementation if this occurs frequency
                    //otherwise retry the IDSync request
                    break;
                default:
                    // inspect error.localizedDescription to determine why the request failed
                    // this typically means an implementation issue
                    break;
                }
            }
        }
        
        identityRequest.email = String(emailField.text!)
        identityRequest.customerId = String(usernameField.text!)
        
        
        MParticle.sharedInstance().identity.login(identityRequest, completion: identityCallback)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

    }

    

}

