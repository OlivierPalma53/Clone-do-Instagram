//
//  PostImageViewController.swift
//  Instagram
//
//  Created by Olivier Palma on 08/12/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import Parse

class PostImageViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate{

    var activityIndicator = UIActivityIndicatorView()
    
    @IBOutlet weak var imageToPost: UIImageView!
    @IBOutlet weak var message: UITextField!
    
    @IBAction func choseImage(sender: AnyObject) {
        
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        image.allowsEditing = false
        
        self.presentViewController(image, animated: true, completion: nil)
        
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        self.dismissViewControllerAnimated(true, completion: nil)
        imageToPost.image = image
    }
    
    @IBAction func postImage(sender: AnyObject) {
        
        activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
        let post = PFObject(className: "Post")
        post["message"] = message.text
        post["userId"] = PFUser.currentUser()?.objectId!
        let imageData = UIImageJPEGRepresentation(imageToPost.image!, 0.2)
        let imageFile = PFFile(name: "image.png", data: imageData!)
        post["imageFile"] = imageFile
        
        post.saveInBackgroundWithBlock { (success, error) -> Void in
            
            self.activityIndicator.stopAnimating()
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
            
            
            if error == nil {
                self.imageToPost.image = UIImage(named: "image_placeholder.png")
                self.message.text = ""
                self.message.resignFirstResponder()
                self.displayAlert("Sucesso", message: "Imagem postada com sucesso")
            } else {
                self.displayAlert("Erro", message: "Desculpe, não conseguimos salvar sua imagem. Verifique sua conexão e tente novamente")
            }
        }
        
    }
    
    func displayAlert(title: String, message: String){
        let alert = UIAlertController (title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
        }))
        self.presentViewController(alert, animated: true, completion: nil)
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
