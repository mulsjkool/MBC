//
//  FormViewController.swift
//  MBC
//
//  Created by Voong Tan Quoc Cuong on 3/28/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit

enum FormType {
    case advertisement
    case contactUs
}

class FormViewController: BaseViewController {
    @IBOutlet weak private var tableView: UITableView!
    
    private var viewModel = FormViewModel(interactor: Components.formInteractor())
    
    var formType: StaticPageEnum = .contactus
    
    private let heightFooterCell: CGFloat = 80.0
    private var didRunAPISuccessful: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.bindEvents()
    }
    
    private func setupUI() {
        self.addBackButton()
        
        if formType == .contactus {
            title = R.string.localizable.formContactUsTitle()
            self.viewModel.refreshAllError(array: FormItemEnum.contactUsItems)
        } else {
            title = R.string.localizable.formAdvertisementTitle()
            self.viewModel.refreshAllError(array: FormItemEnum.advertisementItems)
        }
        
        tableView.register(R.nib.imageFormCell(),
                           forCellReuseIdentifier: R.reuseIdentifier.imageFormCellId.identifier)
        tableView.register(R.nib.labelFormCell(),
                           forCellReuseIdentifier: R.reuseIdentifier.labelFormCellId.identifier)
        tableView.register(R.nib.dropdownFormCell(),
                           forCellReuseIdentifier: R.reuseIdentifier.dropdownFormCellId.identifier)
        tableView.register(R.nib.textViewFormCell(),
                           forCellReuseIdentifier: R.reuseIdentifier.textViewFormCellId.identifier)
        tableView.register(R.nib.textFieldFormCell(),
                           forCellReuseIdentifier: R.reuseIdentifier.textFieldFormCellId.identifier)
        tableView.register(R.nib.radioGroupFormCell(),
                           forCellReuseIdentifier: R.reuseIdentifier.radioGroupFormCellId.identifier)
        tableView.register(R.nib.notificationFormCell(),
                           forCellReuseIdentifier: R.reuseIdentifier.notificationFormCellId.identifier)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.backgroundColor = Colors.defaultBg.color()
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
    }
    
    // MARK: - Events
    
    private func bindEvents() {
        let viewTapGesture = UITapGestureRecognizer()
        self.view.addGestureRecognizer(viewTapGesture)
        
        disposeBag.addDisposables([
            viewTapGesture.rx.event.bind(onNext: { [unowned self] _ in
                self.view.endEditing(true)
            }),
            viewModel.onNeedReloadTable.subscribe(onNext: { [unowned self] _ in
                self.tableView.reloadData()
            }),
            viewModel.onWillStartSendForm.subscribe(onNext: { [unowned self] _ in
                self.view.endEditing(true)
                self.showLoading(status: "", showInView: nil)
            }),
            viewModel.onWillStopSendForm.subscribe(onNext: { [unowned self] _ in
                self.hideLoading(showInView: nil)
            }),
            viewModel.onFinishSendForm.subscribe(onNext: { [unowned self] text in
                print("Message ID: \(text)")
                self.didRunAPISuccessful = true
                self.tableView.reloadData()
                self.perform(#selector(self.scrollToTop), with: nil, afterDelay: 0)
            }),
            viewModel.onShowError.subscribe(onNext: { [unowned self] error in
                if let text = error.errorString(), !text.isEmpty {
                    self.showMessage(message: text)
                }
            })
        ])
    }
    
    // MARK: - Private functions
    
    @objc
    private func scrollToTop() {
        self.tableView.scrollToNearestSelectedRow(at: .bottom, animated: true)
    }
    
    private func updateValue(type: FormItemEnum, value: String) {
        switch type {
        case .name: viewModel.strName = value
        case .email: viewModel.strEmail = value
        case .phone: viewModel.strPhone = value
        case .address: viewModel.strAddress = value
        case .company: viewModel.strCompany = value
        case .subject: viewModel.strSubject = value
        case .advertiseOn: viewModel.strAdvertiseOn = value
        case .message: viewModel.strMessage = value
        case .gender: viewModel.strGender = value
        case .preferredContactMethod: viewModel.strPreferredContactMethod = value
        }
    }
   
    private enum TableSection: Int {
        case coverPictureSection = 0
        case titleAndDescriptionSection = 1
        case formSection = 2
    }
    
    private func notificationCell() -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier:
            R.reuseIdentifier.notificationFormCellId.identifier) as? NotificationFormCell {
            if formType == .contactus { cell.loadContactUsData() } else { cell.loadAdvertisementData() }
            return cell
        }
        return UITableViewCell()
    }
    
    // swiftlint:disable:next cyclomatic_complexity
    private func formCell(indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == TableSection.coverPictureSection.rawValue {
            if let cell = tableView.dequeueReusableCell(withIdentifier:
                R.reuseIdentifier.imageFormCellId.identifier) as? ImageFormCell {
                if formType == .contactus { cell.loadContactUsCover() } else { cell.loadAdvertisementCover() }
                return cell
            }
        }
        
        if indexPath.section == TableSection.titleAndDescriptionSection.rawValue {
            if let cell = tableView.dequeueReusableCell(withIdentifier:
                R.reuseIdentifier.labelFormCellId.identifier) as? LabelFormCell {
                var title: String = ""
                var description: String = ""
                if formType == .contactus {
                    title = R.string.localizable.formContactUsLabelTitle()
                    description = R.string.localizable.formContactUsLabelDescription()
                } else {
                    title = R.string.localizable.formAdvertisementLabelTitle()
                    description = R.string.localizable.formAdvertisementLabelDescription()
                }
                cell.bindData(title: title, description: description)
                return cell
            }
        }
        
        if indexPath.section == TableSection.formSection.rawValue {
            if didRunAPISuccessful { return self.notificationCell() }
            
            var itemTemp: FormItem?
            if formType == .contactus {
                itemTemp = viewModel.contactUsItemAt(index: indexPath.row) as? FormItem
            } else { itemTemp = viewModel.advertisementItemAt(index: indexPath.row) as? FormItem }
            
            if let item = itemTemp {
                switch item.type {
                case .name, .email, .phone, .address, .company:
                    if let cell = tableView.dequeueReusableCell(withIdentifier:
                        R.reuseIdentifier.textFieldFormCellId.identifier) as? TextFieldFormCell {
                        cell.bindData(item: item)
                        cell.disposeBag.addDisposables([
                            cell.onDidSubmitRequest.subscribe(onNext: { [unowned self] value in
                                self.updateValue(type: item.type, value: value)
                            })
                        ])
                        return cell
                    }
                case .subject, .advertiseOn:
                    if let cell = tableView.dequeueReusableCell(withIdentifier:
                        R.reuseIdentifier.dropdownFormCellId.identifier) as? DropdownFormCell {
                        var array: [DropdownListFormItem] = [DropdownListFormItem]()
                        if item.type == .subject {
                            array = ArrayFormItemEnum.arraySubject
                        } else { array = ArrayFormItemEnum.arrayAdvertiseOn }
                        cell.bindData(item: item, arrayData: array)
                        cell.disposeBag.addDisposables([
                            cell.onDidSubmitRequest.subscribe(onNext: { [unowned self] value in
                                self.updateValue(type: item.type, value: value.value)
                            })
                        ])
                        return cell
                    }
                case .message:
                    if let cell = tableView.dequeueReusableCell(withIdentifier:
                        R.reuseIdentifier.textViewFormCellId.identifier) as? TextViewFormCell {
                        cell.bindData(item: item)
                        cell.disposeBag.addDisposables([
                            cell.onDidSubmitRequest.subscribe(onNext: { [unowned self] value in
                                self.updateValue(type: item.type, value: value)
                            })
                        ])
                        return cell
                    }
                default: break
                }
            }
            
            if let item = viewModel.contactUsItemAt(index: indexPath.row) as? RadioGroupFormItem {
                if let cell = tableView.dequeueReusableCell(withIdentifier:
                    R.reuseIdentifier.radioGroupFormCellId.identifier) as? RadioGroupFormCell {
                    cell.bindData(item: item)
                    cell.disposeBag.addDisposables([
                        cell.onDidSubmitGender.subscribe(onNext: { [unowned self] value in
                            self.updateValue(type: item.type, value: value?.genderCode() ?? "")
                            self.reloadHeightTableViewAtIndexPath(indexPath: indexPath)
                        }),
                        cell.onDidSubmitPreferredContactMethod.subscribe(onNext: { [unowned self] value in
                            self.updateValue(type: item.type, value: value?.preferredContactMethodCode() ?? "")
                            self.reloadHeightTableViewAtIndexPath(indexPath: indexPath)
                        })
                    ])
                    return cell
                }
            }
        }
        return UITableViewCell()
    }
    
    private func reloadHeightTableViewAtIndexPath(indexPath: IndexPath) {
        self.tableView.beginUpdates()
        _ = self.tableView(self.tableView, heightForRowAt: indexPath)
        self.tableView.endUpdates()
    }
}

extension FormViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2 {
            if didRunAPISuccessful { return 1 }
            if formType == .contactus {
                return viewModel.totalContactUsItems
            } else { return viewModel.totalAdvertisementItems }
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 2 {
            if didRunAPISuccessful { return CGFloat.leastNormalMagnitude }
            return heightFooterCell
        }
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return self.formCell(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 2 {
            if didRunAPISuccessful { return UIView() }
            let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: heightFooterCell))
            view.backgroundColor = UIColor.white
            let button = UIButton(type: .system)
            button.frame = CGRect(x: 0, y: 0, width: tableView.frame.size.width - 32, height: heightFooterCell / 2)
            button.center = view.center
            button.backgroundColor = Colors.defaultAccentColor.color()
            button.layer.cornerRadius = 5.0
            button.clipsToBounds = true
            button.setTitle(R.string.localizable.commonButtonSend(), for: .normal)
            button.tintColor = UIColor.white
            view.addSubview(button)
            
            disposeBag.addDisposables([
                button.rx.tap.subscribe(onNext: { [unowned self] _ in
                    self.view.endEditing(true)
                    self.viewModel.printValue()
                    if self.formType == .contactus {
                        self.viewModel.sendContactUsForm(array: FormItemEnum.contactUsItems)
                    } else {
                        self.viewModel.sendAdvertisementForm(array: FormItemEnum.advertisementItems)
                    }
                })
            ])
            return view
        }
        return UIView()
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint,
                                   targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        showHideNavigationBar(shouldHide: velocity.y > 0, animated: true)
    }
}
