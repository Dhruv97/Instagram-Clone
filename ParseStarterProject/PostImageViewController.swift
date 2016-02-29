//
//  PostImageViewController.swift
//  Instagram Clone
//
//  Created by Dhruv Upadhyay on 10/18/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import Parse

class PostImageViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func displayAlert(title: String, message: String) {
        
        var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction((UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            
            self.dismissViewControllerAnimated(true, completion: nil)
            
        })))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
        
    }
    
    var activityIndicator =  UIActivityIndicatorView()
    
    @IBOutlet var imageToPost: UIImageView!
    
    @IBAction func chooseImage(sender: AnyObject) {
        
        var image = UIImagePickerController()
        
        image.delegate = self
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            image.sourceType = .Camera
            
        } else {
            image.sourceType = .PhotoLibrary
        }
        image.allowsEditing = false
        
        self.presentViewController(image, animated: true, completion: nil)
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        imageToPost.image = image
        
        
    }

    @IBOutlet var message: UITextField!
    
    

    @IBAction func postImage(sender: AnyObject) {
        
        activityIndicator = UIActivityIndicatorView(frame: self.view.frame)
        activityIndicator.backgroundColor = UIColor(white: 1.0, alpha: 0.5)
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
       
        var post = PFObject(className: "Post")
        
        
        post["message"] = message.text
        
        post["userId"] = PFUser.currentUser()?.objectId
        
        let imageData = UIImageJPEGRepresentation(imageToPost.image!, 0.2)
        
        let imageFile = PFFile(name: "image.jpg", data: imageData!)
        
        post["imageFile"] = imageFile
        
        
        
        post.saveInBackgroundWithBlock{(succes, error) -> Void in
            
            self.activityIndicator.stopAnimating()
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
            
            if error == nil {
                
                
                self.displayAlert("Image Posted", message: "Your image has been posted succesfully!")
                
                
               self.imageToPost.image = UIImage(named: "default_image_01.png")
                
                self.message.text = ""
                
            } else {
                
                 self.displayAlert("Error", message: "Could not post Image")
                
                print(error)
                
            }
        
        }
    
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
