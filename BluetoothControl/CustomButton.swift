//
//  CustomButton.swift
//  BluetoothControl
//
//  Created by Дмитрий Федотов on 01.03.2023.
//

import UIKit

class CustomButton: UIButton {
    
    private var tapAction: (()->Void)?
    
    var buttonState: Bool = false
    
    convenience init(imageTitle: String, tapAction: (()->Void)?) {
        self.init(frame: .zero)
        self.backgroundColor = UIColor(red: 173/255, green: 216/255, blue: 230/255, alpha: 1)
        layer.cornerRadius = 10.0
        translatesAutoresizingMaskIntoConstraints = false
        self.setImage(UIImage(systemName: imageTitle) ?? UIImage(), for: .normal)
        self.tapAction = tapAction
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    @objc private func buttonTapped() {
        if let tapActionExist = tapAction {
            tapActionExist()
        }
    }
}
