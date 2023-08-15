//
//  AddEventVC.swift
//  MGEventApp
//
//  Created by Michael Ghevondyan on 15.08.23.
//

import UIKit
import RealmSwift
import RxSwift
import RxCocoa

class AddEventVC: BaseVC, BaseVCProtocol {
    
    //MARK: - IBOutlets -
    
    @IBOutlet weak var eventTitleTF: UITextField!
    @IBOutlet weak var eventDateTF: UITextField!
    @IBOutlet weak var eventTimeTF: UITextField!
    
    //MARK: - Dependencies -
    
    private let vm: AddEventVM = AddEventVM()
    private let bag = DisposeBag()
    
    var selectedModel: EventModel?
    
    // MARK: - Lifecycles -
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Bind data -
    
    func bindData() {
        self.vm.uploadIsSucces.subscribe { [weak self] _ in
            guard let self = self else { return }
            self.navigationController?.popViewController(animated: true)
        }.disposed(by: bag)
    }
    
    // MARK: - Initialization UI -
    
    func initUIElements() {
        self.initNavigation()
        self.initDatePickerView()
        self.initTimePickerView()
        self.initTextFields()
    }
    
    func initTextFields() {
        eventTitleTF.text = selectedModel?.title
        eventDateTF.text = selectedModel?.date
        eventTimeTF.text = selectedModel?.time
    }
    
    // MARK: - Initialization Navigation Bar -
    
    func initNavigation() {
        navigationItem.title = NavigationBarName.addEvent
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
    }
    
    @objc func addTapped () {
        guard let time = eventTimeTF.text else { return }
        guard let title = eventTitleTF.text else { return }
        guard let date = eventDateTF.text else  { return }
        var model = EventModel(date: date, time: time, title: title)
        guard let selectedModel = selectedModel else {
            self.vm.uploadToRealm(model: model)
            return
        }
        model.id = selectedModel.id
        self.vm.updateToRealm(model: model)
    }
    
    // MARK: - Initialization DatePickerView -
    
    func initDatePickerView() {
        let datePickerView = UIDatePicker()
        datePickerView.datePickerMode = .date
        eventDateTF.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
        datePickerView.preferredDatePickerStyle = .wheels
    }
    
    @objc func handleDatePicker(sender: UIDatePicker) {
        eventDateTF.text = Constants.Formatters.ddMMMyyyy.string(from: sender.date)
    }
    
    // MARK: - Initialization TimePickerView -
    
    func initTimePickerView() {
        let datePickerView = UIDatePicker()
        datePickerView.datePickerMode = .time
        eventTimeTF.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(handleTimePicker(sender:)), for: .valueChanged)
        datePickerView.preferredDatePickerStyle = .wheels
    }
    
    @objc func handleTimePicker(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        eventTimeTF.text = dateFormatter.string(from: sender.date)
    }
    
    // MARK: - Override functions -
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
