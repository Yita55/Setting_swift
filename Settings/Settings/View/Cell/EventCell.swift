//
//  SwitchCell.swift
//  settings
//
//  Created by waltoncob on 2016/9/26.
//  Copyright © 2016年 waltoncob. All rights reserved.
//

import UIKit

public class EventCell:UITableViewCell{

    private var tapListeners:[CellTapListener] = []
    private var cellContent:CellContent

    private var boolSwitch = UISwitch()
    private var coverButton = UIButton()

    public var modifySwitch = {(origin:UISwitch) -> UISwitch in return origin}
    public var modifyColorButton = {(origin:UIButton) -> UIButton in return origin}
    public var modifyCoverButton = {(origin:UIButton) -> UIButton in return origin}

    public init(cellContent:CellContent){
        self.cellContent = cellContent
        super.init(style: UITableViewCellStyle.value1,reuseIdentifier: nil)
        setupViews()
        updateView()
        setTrigger()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupViews(){
        coverButton.isHidden = cellContent.getCoverHidden()
        boolSwitch.isHidden = cellContent.getSwitchHidden()

        if let buttonColor = cellContent.getButtonColor(){
            coverButton.backgroundColor = buttonColor
            coverButton.setTitle(cellContent.getTitle(), for:.normal)
            self.textLabel?.isHidden = true
            self.detailTextLabel?.isHidden = true
        }else{
            coverButton.backgroundColor = UIColor.clear
//            coverButton.backgroundColor = UIColor(red: 0.8, green: 0.5, blue: 0.8, alpha: 0.5)
        }

        if cellContent.getPushTableContent() != nil {
            self.accessoryType = .disclosureIndicator
        }
        addSubview(coverButton)
        addSubview(boolSwitch)
        boolSwitch.translatesAutoresizingMaskIntoConstraints = false
        coverButton.translatesAutoresizingMaskIntoConstraints = false
    }

    private func setTrigger(){
        boolSwitch.addTarget(self, action: #selector(self.tapAction), for: .valueChanged)
        coverButton.addTarget(self, action: #selector(self.tapAction), for: .touchUpInside)
    }

    public func modifySubViews(){
        if cellContent.getButtonColor() == nil{
            self.coverButton = modifyCoverButton(coverButton)
        }else{
            self.coverButton = modifyColorButton(coverButton)
        }

        self.boolSwitch = modifySwitch(boolSwitch)
    }

    public func tapAction(){
        print("\(self.cellContent.getTitle()) tapAction")
        cellContent.set(value: boolSwitch.isOn)
        for tapL in tapListeners{
            tapL.tapAction(sender: self)
        }
    }

    public func updateView(){
        self.textLabel?.text = cellContent.getTitle()
        self.detailTextLabel?.text = cellContent.getDetail()
        self.boolSwitch.isOn = cellContent.getIsOn()
    }

    public func makeTableView() -> SettingTableView{
        let stView = SettingTableView(content:cellContent.getPushTableContent()!)
        return stView
    }

    //MARK:get set

    public func set(tapListeners:[CellTapListener]){
        self.tapListeners = tapListeners
    }

    public func getCellContent() -> CellContent{
        return cellContent
    }

    public func getIsOn() -> Bool{
        return boolSwitch.isOn
    }

    public func setContent(detail:String){
        self.cellContent.set(detail:detail)
    }

    //MARK:AutoLayout
    override public func layoutSubviews() {
        updateConstraints()
        super.layoutSubviews()
    }

    override public func updateConstraints() {
        //boolSwitch
        let constraint = NSLayoutConstraint(item: boolSwitch, attribute: .trailing, relatedBy: .equal, toItem: self , attribute: .trailing, multiplier: 1, constant: -15)
        constraint.priority = 999
        self.addConstraint(constraint)
        self.addConstraint(NSLayoutConstraint(item: boolSwitch,attribute: .trailing,relatedBy: .lessThanOrEqual,toItem: self,attribute: .centerX,multiplier: 1.0,constant: 350))

        self.addConstraint(NSLayoutConstraint(item: boolSwitch, attribute: .centerY, relatedBy: .equal, toItem: self , attribute: .centerY, multiplier: 1, constant: 0))

        if cellContent.getButtonColor() == nil{
            //coverButton
            self.addConstraint(NSLayoutConstraint(item: coverButton, attribute: .trailing, relatedBy: .equal, toItem: self , attribute: .trailing, multiplier: 1, constant: 0))
            self.addConstraint(NSLayoutConstraint(item: coverButton, attribute: .leading, relatedBy: .equal, toItem: self , attribute: .leading, multiplier: 1, constant: 0))
            self.addConstraint(NSLayoutConstraint(item: coverButton, attribute: .height, relatedBy: .equal, toItem: self , attribute: .height, multiplier: 1, constant: 0))
            self.addConstraint(NSLayoutConstraint(item: coverButton, attribute: .centerY, relatedBy: .equal, toItem: self , attribute: .centerY, multiplier: 1, constant: 0))
        }else{
            //ColorButton
            let trailingC = NSLayoutConstraint(item: coverButton, attribute: .trailing, relatedBy: .equal, toItem: self , attribute: .trailing, multiplier: 1, constant: -15)
            trailingC.priority = 999
            self.addConstraint(trailingC)
            self.addConstraint(NSLayoutConstraint(item: coverButton, attribute: .trailing, relatedBy: .lessThanOrEqual, toItem: self , attribute: .centerX, multiplier: 1, constant: 350))

            let leadingC = NSLayoutConstraint(item: coverButton, attribute: .leading, relatedBy: .equal, toItem: self , attribute: .leading, multiplier: 1, constant: 15)
            leadingC.priority = 999
            self.addConstraint(leadingC)
            self.addConstraint(NSLayoutConstraint(item: coverButton, attribute: .leading, relatedBy: .greaterThanOrEqual, toItem: self , attribute: .centerX, multiplier: 1, constant: -350))

            self.addConstraint(NSLayoutConstraint(item: coverButton, attribute: .height, relatedBy: .equal, toItem: self , attribute: .height, multiplier: 1, constant: 0))
            self.addConstraint(NSLayoutConstraint(item: coverButton, attribute: .centerY, relatedBy: .equal, toItem: self , attribute: .centerY, multiplier: 1, constant: 0))
        }
        super.updateConstraints()
    }
    
}