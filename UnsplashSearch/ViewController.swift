//
//  ViewController.swift
//  UnsplashSearch
//
//  Created by Olha Pavliuk on 7/16/19.
//  Copyright © 2019 org. All rights reserved.
//

import UIKit

class TagCell: UITableViewCell {
    
}

class ViewController: UIViewController {
    private var welcomeImageLabel: UILabel?
    private var imageView: UIImageView?
    private var factory: ImageFinderFactory?
    private var curImage: UIImage?
    private var tagsView: TagView?
    private var photoSaved: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createSubviews()
        
        factory = createFinderFactory()
    }

    func createSubviews() {
        let frameW = view.bounds.width, frameH = view.bounds.height
        
        let imageSize = frameH*0.6
        imageView = UIImageView(frame: CGRect(x: (frameW-imageSize)/2,
                                              y: 0,
                                              width: imageSize,
                                              height: imageSize))
        imageView!.backgroundColor = UIColor.clear
        imageView!.contentMode = .scaleAspectFit
        imageView?.image = UIImage(named: "icon_dashed")
        
        welcomeImageLabel = UILabel(frame: imageView!.bounds)
        welcomeImageLabel!.text = "Search photos by tags..."
        welcomeImageLabel!.textAlignment = .center
        imageView?.addSubview(welcomeImageLabel!)
        
        view.addSubview(imageView!)
        
        tagsView = TagView(frame: CGRect(x: 0,
                                         y: imageView!.frame.maxY+5,
                                         width: frameW,
                                         height: 300))
        
        view.addSubview(tagsView!)

        let buttonW: CGFloat = frameW/4
        let buttonH: CGFloat = 44
        
        let searchButtonFrame = CGRect(x: frameW-buttonW,
                                       y: frameH-buttonH,
                                       width: buttonW,
                                       height: buttonH)
        let searchButton = createLowerButton(title: "Search", frame: searchButtonFrame)
        searchButton.addTarget(self, action: #selector(onSearchButtonPressed), for: .touchUpInside)
        view.addSubview(searchButton)
        
        let saveButtonFrame = CGRect(x: 0,
                                     y: frameH-buttonH,
                                     width: buttonW,
                                     height: buttonH)
        let saveButton = createLowerButton(title: "Save", frame: saveButtonFrame)
        saveButton.addTarget(self, action: #selector(onSaveButtonPressed), for: .touchUpInside)
        
        photoSaved = UILabel(frame: CGRect(x: saveButtonFrame.maxX,
                                               y: searchButtonFrame.minY,
                                               width: searchButtonFrame.minX-saveButtonFrame.maxX,
                                               height: buttonH))
        photoSaved!.alpha = 0
        photoSaved!.text = "Photo was saved"
        photoSaved!.textAlignment = .center
        
        view.addSubview(saveButton)
        view.addSubview(photoSaved!)
        
    }
    
    private func createLowerButton(title: String, frame: CGRect) -> UIButton {
        let button = UIButton(frame: frame)
        button.setTitle(title, for: .normal)
        button.layer.cornerRadius = 5
        button.backgroundColor = UIColor.blue
        view.addSubview(button)
        
        return button
    }

    @objc private func onSaveButtonPressed() {
        guard let image = curImage else {
            return
        }
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        print("Image was saved to gallery!")
        photoSaved!.alpha = 1
        UIView.animate(withDuration: 2.0) {
            self.photoSaved!.alpha = 0
        }
    }
    
    @objc private func onSearchButtonPressed() {
        guard let imageFinder = factory?.imageFinder() else {
            fatalError("Can't create image finder")
        }
        
        let actualTags = tagsView!.tags().filter { !$0.isEmpty }
        imageFinder.findImage(tags: actualTags) { (image) in
            self.curImage = image
            DispatchQueue.main.async {
                self.welcomeImageLabel!.isHidden = true
                self.imageView!.image = self.curImage
                self.imageView!.setNeedsDisplay()
            }
        }
    }
    
    func createFinderFactory() -> ImageFinderFactory {
        return UnsplashFinderFactory()
    }
}

