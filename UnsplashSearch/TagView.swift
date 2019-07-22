//
//  TagView.swift
//  UnsplashSearch
//
//  Created by Olha Pavliuk on 7/22/19.
//  Copyright © 2019 org. All rights reserved.
//

import UIKit

class TagView: UIView, UITextFieldDelegate {
    private var addButton: UIButton?
    private let controlHeight: CGFloat = 44
    private var allTags: [String] = []
    private var allTextFields: [UITextField] = []
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initControls()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initControls()
    }
    
    private func initControls() {
        let headerLabel = UILabel(frame: CGRect(x: bounds.minX, y: bounds.minY, width: bounds.width, height: controlHeight))
        headerLabel.text = "Your tags:"
        self.addSubview(headerLabel)
        var minY: CGFloat = 0
        for tag in allTags {
            minY += controlHeight
            let textField = UITextField(frame: CGRect(x: bounds.minX, y: minY, width: bounds.width, height: controlHeight))
            textField.borderStyle = .line
            textField.autocorrectionType = .no
            textField.returnKeyType = .go
            textField.delegate = self
            textField.text = tag
            addSubview(textField)
            allTextFields.append(textField)
        }
        let canAddMore = allTags.count < 3
        if canAddMore {
            minY += controlHeight
            addButton = createAddTagButton(frame: CGRect(x: bounds.minX, y: minY, width: bounds.width, height: controlHeight))
            addSubview(addButton!)
        }
    }
    
    private func createAddTagButton(frame: CGRect) -> UIButton {
        let button = UIButton(frame: frame)
        button.setTitleColor(.blue, for: .normal)
        button.setTitle("Add tag", for: .normal)
        button.addTarget(self, action: #selector(onAddTagButtonPressed), for: .touchUpInside)
        return button
    }
    
    @objc private func onAddTagButtonPressed() {
        allTags = tags()
        addTag("")
    }
    
    func addTag(_ tag: String) {
        allTags.append(tag)
        allTextFields.removeAll()
        subviews.forEach { $0.removeFromSuperview() }
        initControls()
    }
    
    func tags() -> [String] {
        return allTextFields.map({ $0.text! })
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}

