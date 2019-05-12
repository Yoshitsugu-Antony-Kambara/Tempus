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
import UserNotifications

// アクションをenumで宣言
enum ActionIdentifier: String {
    case actionOne
    case actionTwo
    case actionThree
}


class ViewController: UIViewController, UNUserNotificationCenterDelegate,FSCalendarDelegate,FSCalendarDataSource,FSCalendarDelegateAppearance {
    
    @IBOutlet weak var calendar: FSCalendar!
    
    var one: Int = 0
    var two: Int = 0
    var three: Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // デリゲートの設定
        self.calendar.dataSource = self
        self.calendar.delegate = self
        
        // アクション設定
        let actionOne = UNNotificationAction(identifier: ActionIdentifier.actionOne.rawValue,
                                             title: "投資",
                                             options: [.foreground])
        let actionTwo = UNNotificationAction(identifier: ActionIdentifier.actionTwo.rawValue,
                                             title: "消費",
                                             options: [.foreground])
        let actionThree = UNNotificationAction(identifier: ActionIdentifier.actionThree.rawValue,
                                               title: "浪費",
                                               options: [.foreground])
        
        let category = UNNotificationCategory(identifier: "category_select",
                                              actions: [actionOne, actionTwo, actionThree],
                                              intentIdentifiers: [],
                                              options: [])
        
        UNUserNotificationCenter.current().setNotificationCategories([category])
        UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
        
        
        let content = UNMutableNotificationContent()
        content.title = "この１時間はどうでしたか？"
        content.body = "時間の使い方を選択してください"
        content.sound = UNNotificationSound.default
        
        // categoryIdentifierを設定
        content.categoryIdentifier = "category_select"
        
        // 60秒ごとに繰り返し通知
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: true)
        let request = UNNotificationRequest(identifier: "notification",
                                            content: content,
                                            trigger: trigger)
        
        // 通知登録
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
   // @IBAction func buttonMonth(_ sender: Any) {
     //   calendar.setScope(.month, animated: true)
    //}
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate let gregorian: Calendar = Calendar(identifier: .gregorian)
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    

    // 祝日判定を行い結果を返すメソッド(True:祝日)
    func judgeHoliday(_ date : Date) -> Bool {
        //祝日判定用のカレンダークラスのインスタンス
        let tmpCalendar = Calendar(identifier: .gregorian)
        
        // 祝日判定を行う日にちの年、月、日を取得
        let year = tmpCalendar.component(.year, from: date)
        let month = tmpCalendar.component(.month, from: date)
        let day = tmpCalendar.component(.day, from: date)
        
        // CalculateCalendarLogic()：祝日判定のインスタンスの生成
        let holiday = CalculateCalendarLogic()
        
        return holiday.judgeJapaneseHoliday(year: year, month: month, day: day)
    }
    // date型 -> 年月日をIntで取得
    func getDay(_ date:Date) -> (Int,Int,Int){
        let tmpCalendar = Calendar(identifier: .gregorian)
        let year = tmpCalendar.component(.year, from: date)
        let month = tmpCalendar.component(.month, from: date)
        let day = tmpCalendar.component(.day, from: date)
        return (year,month,day)
    }
    
    //曜日判定(日曜日:1 〜 土曜日:7)
    func getWeekIdx(_ date: Date) -> Int{
        let tmpCalendar = Calendar(identifier: .gregorian)
        return tmpCalendar.component(.weekday, from: date)
    }
    
    // 土日や祝日の日の文字色を変える
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        //祝日判定をする（祝日は赤色で表示する）
        if self.judgeHoliday(date){
            return UIColor.red
        }
        
        //土日の判定を行う（土曜日は青色、日曜日は赤色で表示する）
        let weekday = self.getWeekIdx(date)
        if weekday == 1 {   //日曜日
            return UIColor.red
        }
        else if weekday == 7 {  //土曜日
            return UIColor.blue
        }
        
        return nil
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition){
        let selectDay = getDay(date)
        print(selectDay)
        
        calendar.scope = .week

    }
    
    // アクションを選択した際に呼び出されるメソッド
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: () -> Swift.Void) {
        //print("Debug\(response.actionIdentifier)")
        // 選択されたアクションごとに処理を分岐
        switch response.actionIdentifier {
            
        case ActionIdentifier.actionOne.rawValue:
            // 具体的な処理をここに記入
            // 変数oneをカウントアップしてラベルに表示
            one = one + 1
            print(one)
            
        case ActionIdentifier.actionTwo.rawValue:
            // 具体的な処理をここに記入
            two = two + 1
            print(String(two))
            
        case ActionIdentifier.actionThree.rawValue:
            three = three + 1
            print(String(three))
            
        default:
            ()
        }
        
        completionHandler()
    }

}


