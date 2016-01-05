//
//  ViewController.swift
//
//  Copyright 2011-present Parse Inc. All rights reserved.
//

import UIKit
import Parse

var seguirUsuario = false

class ViewController: UIViewController {

    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var registerLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    
    
    var signupActivity = true
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    var errorMessege = "Por Favor tente novamente"
    
    func displayAlert(title: String, message: String){
        let alert = UIAlertController (title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
        }))
        self.presentViewController(alert, animated: true, completion: nil)

    }
    
    @IBAction func signUp(sender: AnyObject) {
        
        if userName.text == "" || password == "" {
                displayAlert("Erro", message: "Por favor preencha usuario e senha")
            
        } else {
            
            activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
            
            view.addSubview(activityIndicator)
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
            
            if signupActivity == true {
                let user = PFUser()
            
                user.username = userName.text
                user.password = password.text
            
                user.signUpInBackgroundWithBlock({ (suceess, error) -> Void in
                    self.activityIndicator.stopAnimating()
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()
                    if error == nil {
                        self.performSegueWithIdentifier("login", sender: self)
                    } else {
                        if let errorString = error!.userInfo["error"] as? String {
                        self.errorMessege = errorString
                    }
                    
                        self.displayAlert("Cadastro não realizado", message: self.errorMessege)
                    }
                })
            } else {
                
                PFUser.logInWithUsernameInBackground(userName.text!, password: password.text!){ (user, error) -> Void in
                    
                    self.activityIndicator.stopAnimating()
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()
                    
                    if user != nil {
                        self.performSegueWithIdentifier("login", sender: self)
                    } else {
                        
                        if let errorString = error!.userInfo["error"] as? String {
                            self.errorMessege = errorString
                            self.displayAlert("Erro ao entrar", message: self.errorMessege)
                        }
                        
                    }
                    
                }
            }
        }
    }
    
@IBAction func login(sender: AnyObject) {
        
        if signupActivity == true {
            
            signupActivity = false
            registerButton.setTitle("Entrar", forState: UIControlState.Normal)
            registerLabel.text = "Criar uma conta?"
            loginButton.setTitle("Registrar", forState: UIControlState.Normal)
            
        } else{
            signupActivity = true
            registerButton.setTitle("Registrar", forState: UIControlState.Normal)
            registerLabel.text = "Ja possui uma conta?"
            loginButton.setTitle("Entrar", forState: UIControlState.Normal)
        }
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
      
//        if PFUser.currentUser() != nil {
//            self.performSegueWithIdentifier("login", sender: self)
//            seguirUsuario = true
//        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

