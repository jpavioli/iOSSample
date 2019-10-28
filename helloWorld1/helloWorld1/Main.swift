//
//  Main.swift
//  helloWorld1
//
//  Created by Sue Chung on 10/23/19.
//  Copyright © 2019 Sue Chung. All rights reserved.
//

import Foundation
import UIKit
import mParticle_Apple_SDK

class MainViewController: UIViewController {
    
    @IBAction func logoutButton(_ sender: Any) {
        performSegue(withIdentifier: "logout", sender: self)
        
        let identityCallback = {(result: MPIdentityApiResult?, error: Error?) in
            if (result?.user != nil) {
                //IDSync request succeeded, mutate attributes or query for the MPID as needed
                result?.user.setUserAttribute("example attribute key", value: "example attribute value")
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
        MParticle.sharedInstance().identity.logout(MPIdentityApiRequest.withEmptyUser(),completion: identityCallback)
        
    }
    
    @IBAction func customEvent1(_ sender: Any) {
        let event = MPEvent(name: "Button Clicked", type: MPEventType.navigation)

        event?.customAttributes = ["buttonColor": "pink"];

        if (event != nil) {
            MParticle.sharedInstance().logEvent(event!)
        }
    }
    
    let currentUser = MParticle.sharedInstance().identity.currentUser;
    
    // 1. Create the products
    let chicken = MPProduct.init(name: "chicken",
                                 sku: "sku1234",
                                 quantity: 1,
                                 price: 100.00)
    
    @IBAction func addCart(_ sender: Any) {
        if let cart = currentUser?.cart {
            cart.addProduct(chicken)
        }
        let event = MPEvent(name: "Added to Cart", type: MPEventType.navigation)

         event?.customAttributes = ["buttonColor": "orange"];

         if (event != nil) {
             MParticle.sharedInstance().logEvent(event!)
         }
    }
    
    @IBAction func removeCart(_ sender: Any) {
        if let cart = currentUser?.cart {
            cart.removeProduct(chicken)
        }
        let event = MPEvent(name: "Removed from Cart", type: MPEventType.navigation)

         event?.customAttributes = ["buttonColor": "yellow"];

         if (event != nil) {
             MParticle.sharedInstance().logEvent(event!)
         }
    }
    
    @IBAction func purchaseButton(_ sender: Any) {
        // 2. Summarize the transaction
        let attributes = MPTransactionAttributes.init()
        attributes.transactionId = "transaction-1234"
        attributes.revenue = 210.00
        attributes.tax = 10.00

//        let action = MPCommerceEventAction.purchase;
//        let event = MPCommerceEvent.init(action: action, product: chicken)
//        event.transactionAttributes = attributes
//        MParticle.sharedInstance().logEvent(event)
        
        // 3. Log a purchase with all items currently in the cart
        let commerce = MParticle.sharedInstance().commerce
        commerce.purchase(with: attributes,
                          clearCart: true)
        
    }
    
    @IBAction func attributeButton(_ sender: Any) {
        currentUser?.setUserAttribute("age", value: "26")
        currentUser?.setUserAttributeList("interests", values: ["music", "tennis", "animals"])
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}
