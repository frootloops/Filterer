//
//  ViewController.swift
//  Filterer
//
//  Created by Jack on 2015-09-22.
//  Copyright © 2015 UofT. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private var instagram: Instagram?
    private var originalImage: UIImage? {
        didSet {
            filteredImage = nil
            imageView.image = originalImage
            compareButton.enabled = false
            originalLabel.hidden = false
            editButton.enabled = false
            
            let filters = [Instagram(filter: "CISepiaTone", deltaKey: kCIInputIntensityKey),
                Instagram(filter: "CIGammaAdjust", deltaKey: "inputPower"),
                Instagram(filter: "CIVignetteEffect", deltaKey: "inputIntensity"),
                Instagram(filter: "CIHueAdjust", deltaKey: "inputAngle"),
                Instagram(filter: "CIColorMonochrome", deltaKey: "inputIntensity")]
            
            filterButton1.setImage(filters[0].apply(originalImage!, delta:  0.5), forState: .Normal)
            filterButton2.setImage(filters[1].apply(originalImage!, delta:  0.5), forState: .Normal)
            filterButton3.setImage(filters[2].apply(originalImage!, delta:  0.5), forState: .Normal)
            filterButton4.setImage(filters[3].apply(originalImage!, delta:  0.5), forState: .Normal)
            filterButton5.setImage(filters[4].apply(originalImage!, delta:  0.5), forState: .Normal)
        }
    } 
    
    private var filteredImage: UIImage? {
        didSet {
            guard let _ = filteredImage else { return }
            compareButton.enabled = true
            originalLabel.hidden = true
            
            UIView.transitionWithView(imageView, duration: 0.5, options: .TransitionCrossDissolve, animations: {
                self.imageView.image = self.filteredImage
            }, completion: nil)
            editButton.enabled = true
        }
    }
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var secondaryMenu: UIView!
    @IBOutlet weak var bottomMenu: UIView!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var compareButton: UIButton!
    @IBOutlet weak var originalLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var editMenu: UIView!
    
    @IBOutlet weak var filterSlider: UISlider!
    @IBOutlet weak var filterButton1: UIButton!
    @IBOutlet weak var filterButton2: UIButton!
    @IBOutlet weak var filterButton3: UIButton!
    @IBOutlet weak var filterButton4: UIButton!
    @IBOutlet weak var filterButton5: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        secondaryMenu.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
        secondaryMenu.translatesAutoresizingMaskIntoConstraints = false
        
        originalImage = UIImage(named: "scenery")
        imageView.image = originalImage
        
        compareButton.addTarget(self, action: #selector(ViewController.showFilteredImage), forControlEvents: .TouchUpInside)
        compareButton.addTarget(self, action: #selector(ViewController.showOriginalImage), forControlEvents: .TouchDown)
    }
    
    @IBAction func onFilterSliderChange(sender: UISlider) {
        guard let image = originalImage else { return }
        filteredImage = instagram?.apply(image, delta: sender.value)
    }
    
    // MARK: Compare
    
    func showOriginalImage() {
        imageView.image = originalImage
        originalLabel.hidden = false
    }
    
    func showFilteredImage() {
        imageView.image = filteredImage
        originalLabel.hidden = true
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        showOriginalImage()
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        if let _ = filteredImage {
            showFilteredImage()
        }
    }

    // MARK: Edit
    
    @IBAction func onEdit(sender: UIButton) {
        if (sender.selected) {
            hideEditMenu()
            sender.selected = false
        } else {
            if filterButton.selected {
                onFilter(filterButton)
            }
            
            showEditMenu()
            sender.selected = true
        }
    }
    
    // MARK: Share
    
    @IBAction func onShare(sender: AnyObject) {
        let activityController = UIActivityViewController(activityItems: ["Check out our really cool app", imageView.image!], applicationActivities: nil)
        presentViewController(activityController, animated: true, completion: nil)
    }
    
    // MARK: New Photo
    
    @IBAction func onNewPhoto(sender: AnyObject) {
        let actionSheet = UIAlertController(title: "New Photo", message: nil, preferredStyle: .ActionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            actionSheet.addAction(UIAlertAction(title: "Camera", style: .Default) { action in
                self.showCamera()
            })
        }
        
        actionSheet.addAction(UIAlertAction(title: "Album", style: .Default) { action in
            self.showAlbum()
        })
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    func showCamera() {
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = .Camera
        
        presentViewController(cameraPicker, animated: true, completion: nil)
    }
    
    func showAlbum() {
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = .PhotoLibrary
        
        presentViewController(cameraPicker, animated: true, completion: nil)
    }
    
    // MARK: UIImagePickerControllerDelegate
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        dismissViewControllerAnimated(true, completion: nil)
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            originalImage = image
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: Filters
    
    
    @IBAction func applyRedFilter(sender: UIButton) {
        guard let image = originalImage else { return }
        instagram = Instagram(filter: "CISepiaTone", deltaKey: kCIInputIntensityKey)
        filteredImage = instagram?.apply(image, delta: 0.5)
    }
    
    @IBAction func applyFilter2(sender: UIButton) {
        guard let image = originalImage else { return }
        instagram = Instagram(filter: "CIGammaAdjust", deltaKey: "inputPower")
        filteredImage = instagram?.apply(image, delta: 0.5)
    }
    
    @IBAction func applyFilter3(sender: UIButton) {
        guard let image = originalImage else { return }
        instagram = Instagram(filter: "CIVignetteEffect", deltaKey: "inputIntensity")
        filteredImage = instagram?.apply(image, delta: 0.5)
    }
    
    
    @IBAction func applyFilter4(sender: UIButton) {
        guard let image = originalImage else { return }
        instagram = Instagram(filter: "CIHueAdjust", deltaKey: "inputAngle")
        filteredImage = instagram?.apply(image, delta: 0.5)
    }
    
    
    @IBAction func applyFilter5(sender: UIButton) {
        guard let image = originalImage else { return }
        instagram = Instagram(filter: "CIColorMonochrome", deltaKey: "inputIntensity")
        filteredImage = instagram?.apply(image, delta: 0.5)
    }
    
    
    // MARK: Filter Menu
    
    @IBAction func onFilter(sender: UIButton) {
        if (sender.selected) {
            hideSecondaryMenu()
            sender.selected = false
        } else {
            if editButton.selected {
                onEdit(editButton)
            }
            
            showSecondaryMenu()
            sender.selected = true
        }
    }
    
    private func showSecondaryMenu() {
        view.addSubview(secondaryMenu)
        
        let bottomConstraint = secondaryMenu.bottomAnchor.constraintEqualToAnchor(bottomMenu.topAnchor)
        let leftConstraint = secondaryMenu.leftAnchor.constraintEqualToAnchor(view.leftAnchor)
        let rightConstraint = secondaryMenu.rightAnchor.constraintEqualToAnchor(view.rightAnchor)
        let heightConstraint = secondaryMenu.heightAnchor.constraintEqualToConstant(44)
        
        NSLayoutConstraint.activateConstraints([bottomConstraint, leftConstraint, rightConstraint, heightConstraint])
        
        view.layoutIfNeeded()
        
        secondaryMenu.alpha = 0
        UIView.animateWithDuration(0.4) {
            self.secondaryMenu.alpha = 1.0
        }
    }

    private func hideSecondaryMenu() {
        UIView.animateWithDuration(0.4, animations: { self.secondaryMenu.alpha = 0 }) { completed in
            if completed == true {
                self.secondaryMenu.removeFromSuperview()
            }
        }
    }
    
    private func showEditMenu() {
        editMenu.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(editMenu)
        
        let bottomConstraint = editMenu.bottomAnchor.constraintEqualToAnchor(bottomMenu.topAnchor)
        let leftConstraint = editMenu.leftAnchor.constraintEqualToAnchor(view.leftAnchor)
        let rightConstraint = editMenu.rightAnchor.constraintEqualToAnchor(view.rightAnchor)
        let heightConstraint = editMenu.heightAnchor.constraintEqualToConstant(44)
        
        NSLayoutConstraint.activateConstraints([bottomConstraint, leftConstraint, rightConstraint, heightConstraint])
        
        view.layoutIfNeeded()
        
        editMenu.alpha = 0
        UIView.animateWithDuration(0.4) {
            self.editMenu.alpha = 1.0
        }
    }
    
    private func hideEditMenu() {
        UIView.animateWithDuration(0.4, animations: { self.editMenu.alpha = 0 }) { completed in
            if completed == true {
                self.editMenu.removeFromSuperview()
            }
        }
    }

}

