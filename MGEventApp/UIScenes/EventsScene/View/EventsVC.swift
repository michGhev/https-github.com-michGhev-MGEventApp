//
//  ViewController.swift
//  MGEventApp
//
//  Created by Michael Ghevondyan on 14.08.23.
//

import UIKit
import RxSwift
import RxCocoa
import RealmSwift

class EventsVC: BaseVC, BaseVCProtocol {
    
    //MARK: - IBOutlets -
    
    @IBOutlet weak var calendarView: UICalendarView!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Private properties -
    
    private let gregorianCalendar = Calendar(identifier: .gregorian)
    
    //MARK: - Dependencies -
    
    let bag = DisposeBag()
    var vm: EventsVM = EventsVM()
    
    // MARK: - Lifecycles -
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.vm.uploadEvents()
    }
    
    func initUIElements() {
        self.initNavigation()
        self.initCalendarView()
    }
    
    // MARK: - Bind data -
    
    func bindData() {
        bindTableView()
    }
    
    private func bindTableView() {
        vm.getEventList().bind(to: tableView.rx.items(cellIdentifier: EventTableViewCell.className, cellType: EventTableViewCell.self)) { (row,item,cell) in
            cell.setCell(model: item)
        }.disposed(by: bag)
        
        vm.getDatesList().bind() { [weak self] item in
            guard let self = self else { return }
            self.calendarView.reloadDecorations(forDateComponents: item, animated: true)
        }.disposed(by: bag)
        
        tableView.rx.itemSelected
          .subscribe(onNext: { [weak self] indexPath in
              guard let self = self else { return }
              let vc = UIStoryboard.main.instantiateViewController(withIdentifier: AddEventVC.className) as! AddEventVC
              vc.selectedModel = self.vm.getEventByIndex(indexPath.row)
              self.navigationController?.pushViewController(vc, animated: true)
          }).disposed(by: bag)
    }
    
    // MARK: - Initialization Navigation Bar -
    
    func initNavigation() {
        navigationItem.title = NavigationBarName.events
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
    }
    
    @objc func addTapped () {
        let vc = UIStoryboard.main.instantiateViewController(withIdentifier: AddEventVC.className) as! AddEventVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - Initialization Calendar View -
    
    func initCalendarView() {
        calendarView.calendar = gregorianCalendar
        calendarView.delegate = self
        calendarView.layer.cornerCurve = .continuous
        calendarView.availableDateRange = DateInterval.init(start: Date.now, end: Date.distantFuture)
        calendarView.tintColor = Colors.lightBlueColor
    }
}
