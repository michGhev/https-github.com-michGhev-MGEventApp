//
//  BaseVC.swift
//  MGEventApp
//
//  Created by Michael Ghevondyan on 14.08.23.
//


import UIKit

@objc protocol BaseVCProtocol: AnyObject {
    func initUIElements()
    func bindData()
}

class BaseVC: UIViewController {

    // MARK: - IBOutlets
    
    @IBOutlet private weak var bottomViewBottomConstraint: NSLayoutConstraint?


    // MARK: - Public properties
    
    var didBindViews = false
    
    // MARK: - Private properties
    
    private var keyboardIsOpen = false
    private var didAddObservers = false
    
    // MARK: - Lifecycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        if self.conforms(to: BaseVCProtocol.self) {
            (self as! BaseVCProtocol).bindData()
            (self as! BaseVCProtocol).initUIElements()
        }
        overrideUserInterfaceStyle = .light
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.conforms(to: BaseVCProtocol.self) {
        }
        addObservers()
    }

    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        removeObservers()
        
    }

    // MARK: - Public

    func showCombinedErrorFrom(collection: [String: String]) {
        let joined = collection.values.joined(separator: "\n")
        let alert = UIAlertController(title: "Alert", message: joined, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style{
                case .default:
                print("default")
                case .cancel:
                print("cancel")
                case .destructive:
                print("destructive")
            @unknown default:
                print("fatalError")
            }
        }))
        self.present(alert, animated: true, completion: nil)

    }

    // MARK: VMToVCExchange methods
    
    func dataFetched<T>(type: T.Type, data: [T], observerName: String) {
        
    }
    
    func dataFetched<T>(type: T.Type, data: T, observerName: String) {
        
    }
    
    func invalidDataErrorReceived<T>(fieldType: T.Type, data: [String: String]) {
        
    }

    
    // MARK: - Private
    // MARK: Init UI elements
    
    private func addObservers() {
        guard !didAddObservers else { return }
        didAddObservers = true

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShowNote(_:)),
                                               name: UIApplication.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHildeNote(_:)),
                                               name: UIApplication.keyboardWillHideNotification,
                                               object: nil)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillChangeFrameNote(_:)),
                                               name: UIApplication.keyboardWillChangeFrameNotification,
                                               object: nil)
    }
    
    private func removeObservers() {
        guard didAddObservers else { return }

        NotificationCenter.default.removeObserver(self, name: UIApplication.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.keyboardWillChangeFrameNotification, object: nil)
        didAddObservers = false
    }

    @objc func keyboardWillShowNote(_ note: Notification) {
        guard
            let value = note.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
            let duration = note.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber else { return }
        let frame = value.cgRectValue

        bottomViewBottomConstraint?.constant = frame.size.height
        UIView.animate(withDuration: duration.doubleValue, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
        keyboardIsOpen = true
    }

    @objc func keyboardWillHildeNote(_ note: Notification) {
        guard keyboardIsOpen else { return }
        guard let constraint = bottomViewBottomConstraint?.constant, constraint > 0 else { return }
        bottomViewBottomConstraint?.constant = 0

        UIView.animate(withDuration: 0.25, delay: 0, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
        keyboardIsOpen = false
    }

    @objc func keyboardWillChangeFrameNote(_ note: Notification) {
        guard keyboardIsOpen else { return }
        guard let constraint = bottomViewBottomConstraint?.constant, constraint > 0 else { return }

        if let nsvalue = note.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let rect = nsvalue.cgRectValue
            bottomViewBottomConstraint?.constant = UIScreen.main.bounds.height - rect.minY
            print(rect)
        }
    }

    @objc func ytPaymentsNavigationBarLeftButtonPressed(_ note: Notification) {
    }
    
    
    func endEditing(_ force: Bool) {
        view.endEditing(force)
    }
}

extension BaseVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
    }
}
