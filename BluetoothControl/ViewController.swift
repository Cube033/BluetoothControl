//
//  ViewController.swift
//  BluetoothControl
//
//  Created by Дмитрий Федотов on 28.02.2023.
//

import UIKit

protocol BluetoothHandler: AnyObject {
    func handleBluetoothConnection()
    func setTextLabel(newText: String)
    func printLog(newText: String)
}

class ViewController: UIViewController, BluetoothHandler {
    
    // MARK: - Variables
    
    var bluetoothManager = BluetoothManager()
    let buttonSideSize: CGFloat = 70
    
    var textLabel = {
        let label = UILabel()
        label.text = "no distance"
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.numberOfLines = 2
        return label
    }()
    
    lazy var goForwardButton = CustomButton(imageTitle: "arrow.up.circle",
                                       tapAction: {self.sendGoForward()})
    
    lazy var goBackButton = CustomButton(imageTitle: "arrow.down.circle",
                                       tapAction: {self.sendGoBack()})
    
    lazy var goLeftForwardButton = CustomButton(imageTitle: "arrow.up.left.circle",
                                       tapAction: {self.sendGoLeftForward()})
    
    lazy var goRightForwardButton = CustomButton(imageTitle: "arrow.up.right.circle",
                                       tapAction: {self.sendGoRightForward()})
    
    lazy var goLeftBackButton = CustomButton(imageTitle: "arrow.down.left.circle",
                                       tapAction: {self.sendGoLeftBack()})
    
    lazy var goRightBackButton = CustomButton(imageTitle: "arrow.down.right.circle",
                                       tapAction: {self.sendGoRightBack()})
    
    lazy var cruiseControlButton = CustomButton(imageTitle: "",
                                       tapAction: {self.cruiseControlToggle()})
    
    lazy var ccGoBackButton = CustomButton(imageTitle: "arrow.clockwise.circle",
                                       tapAction: {self.ccGoBackToggle()})
    
    var logField = {
        let logField = UITextView()
        logField.font = UIFont.systemFont(ofSize: 18)
        logField.textColor = UIColor.black
        logField.backgroundColor = UIColor(red: 173/255, green: 216/255, blue: 230/255, alpha: 1)
        logField.translatesAutoresizingMaskIntoConstraints = false
        logField.textAlignment = .left
        logField.layer.cornerRadius = 10.0
        return logField
    }()
    
    // MARK: - Lyfe cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        
    }
    
    // MARK: - Functions

    private func setView() {
        view.backgroundColor = .white
        cruiseControlButton.setTitle("Cruise control", for: .normal)
        bluetoothManager = BluetoothManager()
        bluetoothManager.delegate = self
        addElements()
        setConstraints()
    }

    func handleBluetoothConnection() {
        addElements()
        setConstraints()
    }
    
    func sendGoForward() {
        bluetoothManager.sendMessage("forward")
    }
    
    func sendGoBack() {
        bluetoothManager.sendMessage("back")
    }
    
    func sendGoLeftForward() {
        bluetoothManager.sendMessage("leftForward")
    }
    
    func sendGoRightForward() {
        bluetoothManager.sendMessage("rightForward")
    }
    
    func sendGoLeftBack() {
        bluetoothManager.sendMessage("leftBack")
    }
    
    func sendGoRightBack() {
        bluetoothManager.sendMessage("rightBack")
    }
    
    func cruiseControlToggle() {
        bluetoothManager.sendMessage("cruiseControl")
        cruiseControlButton.buttonState.toggle()
        textLabel.isHidden = ccGoBackButton.buttonState || cruiseControlButton.buttonState
        cruiseControlButton.backgroundColor = getColorByState(state: cruiseControlButton.buttonState)
    }
    
    func ccGoBackToggle() {
        bluetoothManager.sendMessage("ccGoBack")
        ccGoBackButton.buttonState.toggle()
        textLabel.isHidden = ccGoBackButton.buttonState || cruiseControlButton.buttonState
        ccGoBackButton.backgroundColor = getColorByState(state: ccGoBackButton.buttonState)
    }
    
    func getColorByState(state: Bool) -> UIColor {
        return state ? UIColor(red: 152/255, green: 251/255, blue: 152/255, alpha: 1) : UIColor(red: 173/255, green: 216/255, blue: 230/255, alpha: 1)
    }
    
    func setTextLabel(newText: String) {
        textLabel.text = "Dist: \(newText) cm"
    }
    
    func printLog(newText: String) {
        logField.text!  += "\n\(newText)"
        let range = NSMakeRange(logField.text.count - 1, 1)
        logField.scrollRangeToVisible(range)
    }
    
    // MARK: - Constraints

    func addElements() {
        view.addSubview(textLabel)
        view.addSubview(goForwardButton)
        view.addSubview(goBackButton)
        view.addSubview(logField)
        view.addSubview(goLeftForwardButton)
        view.addSubview(goRightForwardButton)
        view.addSubview(goLeftBackButton)
        view.addSubview(goRightBackButton)
        view.addSubview(cruiseControlButton)
        view.addSubview(ccGoBackButton)
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            textLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textLabel.heightAnchor.constraint(equalToConstant: 100),
            textLabel.widthAnchor.constraint(equalToConstant: 200),
            
            goForwardButton.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 10),
            goForwardButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            goForwardButton.heightAnchor.constraint(equalToConstant: buttonSideSize),
            goForwardButton.widthAnchor.constraint(equalToConstant: buttonSideSize),
            
            goBackButton.topAnchor.constraint(equalTo: goForwardButton.bottomAnchor, constant: 10),
            goBackButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            goBackButton.heightAnchor.constraint(equalToConstant: buttonSideSize),
            goBackButton.widthAnchor.constraint(equalToConstant: buttonSideSize),
            
            goLeftForwardButton.centerYAnchor.constraint(equalTo: goForwardButton.centerYAnchor),
            goLeftForwardButton.trailingAnchor.constraint(equalTo: goForwardButton.leadingAnchor, constant: -20),
            goLeftForwardButton.heightAnchor.constraint(equalToConstant: buttonSideSize),
            goLeftForwardButton.widthAnchor.constraint(equalToConstant: buttonSideSize),
            
            goRightForwardButton.centerYAnchor.constraint(equalTo: goForwardButton.centerYAnchor),
            goRightForwardButton.leadingAnchor.constraint(equalTo: goForwardButton.trailingAnchor, constant: 20),
            goRightForwardButton.heightAnchor.constraint(equalToConstant: buttonSideSize),
            goRightForwardButton.widthAnchor.constraint(equalToConstant: buttonSideSize),
            
            goLeftBackButton.centerYAnchor.constraint(equalTo: goBackButton.centerYAnchor),
            goLeftBackButton.trailingAnchor.constraint(equalTo: goBackButton.leadingAnchor, constant: -20),
            goLeftBackButton.heightAnchor.constraint(equalToConstant: buttonSideSize),
            goLeftBackButton.widthAnchor.constraint(equalToConstant: buttonSideSize),
            
            goRightBackButton.centerYAnchor.constraint(equalTo: goBackButton.centerYAnchor),
            goRightBackButton.leadingAnchor.constraint(equalTo: goBackButton.trailingAnchor, constant: 20),
            goRightBackButton.heightAnchor.constraint(equalToConstant: buttonSideSize),
            goRightBackButton.widthAnchor.constraint(equalToConstant: buttonSideSize),
            
            cruiseControlButton.topAnchor.constraint(equalTo: goLeftBackButton.bottomAnchor, constant: 20),
            cruiseControlButton.leadingAnchor.constraint(equalTo: goLeftBackButton.leadingAnchor),
            cruiseControlButton.trailingAnchor.constraint(equalTo: goBackButton.trailingAnchor),
            cruiseControlButton.heightAnchor.constraint(equalToConstant: buttonSideSize),
            
            ccGoBackButton.topAnchor.constraint(equalTo: cruiseControlButton.topAnchor),
            ccGoBackButton.leadingAnchor.constraint(equalTo: goRightBackButton.leadingAnchor),
            ccGoBackButton.heightAnchor.constraint(equalToConstant: buttonSideSize),
            ccGoBackButton.widthAnchor.constraint(equalToConstant: buttonSideSize),
            
            logField.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            logField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            logField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            logField.heightAnchor.constraint(equalToConstant: 300),
        ])
    }
    
}

