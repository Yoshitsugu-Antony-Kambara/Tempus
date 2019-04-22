//
//  ViewController.swift
//  Tempus
//
//  Created by 神原良継 on 2019/04/18.
//  Copyright © 2019 YoshitsuguKambara. All rights reserved.
//

import UIKit
import FSCalendar
import CalculateCalendarLogic
class ViewController: UIViewController,FSCalendarDelegate,FSCalendarDataSource,FSCalendarDelegateAppearance {

    @IBOutlet var labelDate: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
    }




}

