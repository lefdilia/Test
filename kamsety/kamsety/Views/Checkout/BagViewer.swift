//
//  BagViewer.swift
//  kamsety
//
//  Created by Lefdili Alaoui Ayoub on 31/3/2022.
//

import UIKit

class BagViewer: UIViewController {
    
    var products = APIManager.shared.listProducts()
    
    lazy var BagViewerList: UITableView = {
        let table = UITableView()
        table.register(BagViewerListCell.self, forCellReuseIdentifier: BagViewerListCell.cellId)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = .white
        table.showsVerticalScrollIndicator = false
        
        table.separatorStyle = .singleLine
        table.separatorInset = .zero
        table.layoutMargins = .zero
        
        return table
    }()
    
    var topAnchorConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.clear
        
        //MARK: - Setup Blured Background
        let blurBgView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
        blurBgView.alpha = 0.90
        blurBgView.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(blurBgView, at: 0)
        
        blurBgView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(didPanView(_:))))

        topAnchorConstraint = blurBgView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0)

        NSLayoutConstraint.activate([
            topAnchorConstraint,
            blurBgView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blurBgView.heightAnchor.constraint(equalTo: view.heightAnchor),
            blurBgView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        
        view.addSubview(BagViewerList)
        NSLayoutConstraint.activate([
            BagViewerList.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            BagViewerList.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            BagViewerList.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            BagViewerList.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.45)
        ])
        
        BagViewerList.layoutIfNeeded()
    }
    
    @objc func didPanView(_ gesture: UIPanGestureRecognizer){
         
        if gesture.state == .changed {
            let translation = gesture.translation(in: self.view)
            topAnchorConstraint.constant = -abs(translation.y)
            
            if translation.y < 0 {
                self.view.transform = .identity
            }else{
                self.view.transform = CGAffineTransform(translationX: 0, y: translation.y)
            }
        }else if gesture.state == .ended {
            topAnchorConstraint.constant = 0
            let translation = gesture.translation(in: self.view)
            
            let velocity = gesture.velocity(in: self.view)
            if translation.y > 10 || velocity.y > 600 {
                UIView.animate(withDuration: 0.3) {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    @objc func didTapCloseButton(_ sender: UIButton){
        //Animated Collapsed Menu
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut) {
            sender.transform = CGAffineTransform(rotationAngle: .pi)
        } completion: { _ in
            UIView.animate(withDuration: 0.2, delay: 0.3, options: .curveEaseOut) {
                sender.transform = .identity
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    //MARK: - FooterView
    let footerView: UIView = {
        let _view = UIView()
        return _view
    }()
    
    lazy var checkoutButton: UIButton = { [weak self] in
        let button = UIButton(type: .custom)
        
        let title = "Checkout"
        
        if #available(iOS 15.0, *) {
            var configuration = UIButton.Configuration.filled()
            configuration.baseBackgroundColor = .buttonBackgroundColor
            
            var container = AttributeContainer()
            container.font = UIFont(name: Theme.CenturyGothicBold, size: 18)
            configuration.attributedTitle = AttributedString("\(title)", attributes: container)
            
            configuration.buttonSize = .large
            button.configuration = configuration
        }else{
            let attributedText = NSAttributedString(string: "\(title)", attributes: [
                .font : UIFont(name: Theme.CenturyGothicBold, size: 18) as Any,
                .foregroundColor : UIColor.white
            ])
            button.backgroundColor = .buttonBackgroundColor
            button.setAttributedTitle(attributedText, for: .normal)
            button.layer.cornerRadius = 8
            button.tintColor = .black
            button.contentEdgeInsets = UIEdgeInsets(top: 15, left: 10, bottom: 15, right: 10)
        }
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setContentHuggingPriority(.required, for: .horizontal)
        button.addTarget(self, action: #selector(self?.didTapcheckOut), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        //MARK: - Table Footer View
        BagViewerList.tableFooterView = footerView
        BagViewerList.tableFooterView?.frame.size.height = 70

        footerView.addSubview(checkoutButton)

        NSLayoutConstraint.activate([
            checkoutButton.centerXAnchor.constraint(equalTo: footerView.centerXAnchor),
            checkoutButton.leadingAnchor.constraint(equalTo: footerView.leadingAnchor, constant: 10),
            checkoutButton.trailingAnchor.constraint(equalTo: footerView.trailingAnchor, constant: -10),
            checkoutButton.bottomAnchor.constraint(equalTo: footerView.bottomAnchor),
        ])
        
        BagViewerList.layoutIfNeeded()
        
    }
}


extension BagViewer: UITableViewDelegate, UITableViewDataSource {

    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .normal, title: "") { [weak self] (_, _, completion) in
            
                self?.products.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                
                DispatchQueue.main.async {
                    tableView.reloadData()
                }
        }
        
        deleteAction.backgroundColor = .trashBackground
        deleteAction.image = UIImage(named: "delete-bin")?.withTintColor(.red).withRenderingMode(.alwaysOriginal)
        
        let swipes = UISwipeActionsConfiguration(actions: [deleteAction])
        swipes.performsFirstActionWithFullSwipe = false
        
        return swipes
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView: UIView = {
            let _view = UIView()
            return _view
        }()
        
        let headerLabel: UILabel = {
            let label = UILabel()
            let attributedText = NSMutableAttributedString(string: "Bag", attributes: [
                .font : UIFont(name: Theme.CenturyGothic, size: 18) as Any,
                .foregroundColor : UIColor.buttonBackgroundColor as Any ])
            label.attributedText = attributedText
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        let closeButton: UIButton = {
            let button = UIButton(type: .custom)
            let image = UIImage(named: "close-fill")
            
            if #available(iOS 15.0, *) {
                var configuration = UIButton.Configuration.plain()
                configuration.image = image
                configuration.baseForegroundColor = .buttonBackgroundColor
                configuration.imagePlacement = .trailing
                button.configuration = configuration
            }else{
                button.setImage(image, for: .normal)
                button.tintColor = .buttonBackgroundColor
                button.contentHorizontalAlignment = .trailing
            }
            
            button.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
        }()
        
        headerView.addSubview(headerLabel)
        headerView.addSubview(closeButton)

        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 10),
            headerLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            
            closeButton.topAnchor.constraint(equalTo: headerView.topAnchor),
            closeButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
        ])
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: BagViewerListCell.cellId, for: indexPath) as! BagViewerListCell
        cell.product = products[indexPath.row]
        
        if indexPath.row == products.count-1 {
            cell.separatorInset.right = cell.bounds.size.width
        }
        return cell
    }
    
    
    //MARK: - Checkout
    
    @objc func didTapcheckOut(_ sender: UIButton){
        print("To checkout...")
    }
    
}
