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
        
        // Force end a session
        //MParticle.sharedInstance().endSession()
        
    }
    
    @IBOutlet weak var textLabel: UITextField!
    @IBOutlet weak var cartLabel: UITextField!
    
    var txt = ""
    var cart = 0
    
    func showText(){
        textLabel.text = txt
    }
    
    func updateCart(){
        cartLabel.text = String(cart)
    }
    
    @IBAction func customEvent1(_ sender: Any) {
        //Tracking events
        let event = MPEvent(name: "eventName", type: MPEventType.navigation)

        event?.customAttributes = ["eventAttribute": "eventValue"];

        if (event != nil) {
            MParticle.sharedInstance().logEvent(event!)
        }
        txt = "Tracked event"
        showText()
        
        //Tracking screens
        let screen = MPEvent(name: "ScreenA", type: MPEventType.navigation)
        screen?.customAttributes = [ "screenAttribute": "screenValue"];
        if (screen != nil) {
            MParticle.sharedInstance().logScreenEvent(screen!)
        }
        
    }
    
    let currentUser = MParticle.sharedInstance().identity.currentUser;

    let commerce = MParticle.sharedInstance().commerce
    
    // 1. Create the products
    let product = MPProduct.init(name: "productName",
                                 sku: "sku123",
                                 quantity: 1,
                                 price: 100.00)
    
    
    @IBAction func addCart(_ sender: Any) {
        txt = "Added to Cart"
        showText()
    
        
        let action = MPCommerceEventAction.addToCart;
        let event = MPCommerceEvent.init(action: action, product: product)
        
        MParticle.sharedInstance().logEvent(event)
        
        cart = cart + 1
        
        
        updateCart()
    }
    
    @IBAction func removeCart(_ sender: Any) {
        txt = "Removed to Cart"
        showText()
        
        cart = cart - 1
        updateCart()
        
        let action = MPCommerceEventAction.removeFromCart;
        let event = MPCommerceEvent.init(action: action, product: product)
        
        MParticle.sharedInstance().logEvent(event)
    }
    
    @IBAction func purchaseButton(_ sender: Any) {
        // 2. Summarize the transaction
        let attributes = MPTransactionAttributes.init()
        attributes.transactionId = "transaction-1234"
        attributes.revenue = Int(truncating: product.quantity) * Int(truncating: product.price!) as NSNumber
        
        // 3. Log the purchase event
        let action = MPCommerceEventAction.purchase;
        let event = MPCommerceEvent.init(action: action, product: product)
        product.quantity = NSNumber(value: cart)
        
        event.currency = "USD"
        event.transactionAttributes = attributes
        
        func wasPurchased(quantity: NSNumber, completion: (_ result:Bool)->()){
            if (quantity == 0){
                txt = "No items in cart, no purchase"
                showText()
                print("Add at least 1 item to cart")
                completion(false)
            } else{
                MParticle.sharedInstance().logEvent(event)
                completion(true)
            }
        }

        wasPurchased(quantity: product.quantity) {(_ result) -> () in
            //Reset cart
            if(result){
                commerce.clearCart()
                cart = 0
                updateCart()
            }
        }
        
        txt = "Purchased Cart"
        showText()
    }
    
    
    @IBAction func attributeButton(_ sender: Any) {
        currentUser?.setUserAttribute("$age", value: "26")
        currentUser?.setUserAttributeList("interests", values: ["music", "tennis", "animals"])
        
        txt = "Set Attributes"
        showText()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showText()
        updateCart()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}
