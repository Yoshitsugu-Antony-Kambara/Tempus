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
    
    
    var Dic: Dictionary = ["2019/05/18": 325]
    
    let f = DateFormatter()
    
    var one: Double = 0.0
    var two: Double = 0.0
    var three: Double = 0.0

    
    var resultOne: Int = 0
    var resultTwo: Int = 0
    var resultThree: Int = 0
    var Result: Int = 0
    
    //最終的にグラフに代入する変数
    var num1: Int = 0       //投資の比率
    var num2: Int = 0       //消費の比率
    var num3: Int = 0       //浪費の比率
    
    
    //ユーザデフォルトの定義
    var userDefaults = UserDefaults.standard
    
    
    
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
        UNUserNotificationCenter.current().delegate = self as UNUserNotificationCenterDelegate
  
        
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
    
    
    //セルをタップした時
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition){
        let selectDay = getDay(date)
       
        let mon = NSString(format: "%02d", selectDay.1)
        let d = NSString(format: "%02d", selectDay.2)
        
        
        //print(selectDay.0)
//        print("\(selectDay.0)/\(mon)/\(d)")
//        print(Dic["\(selectDay.0)/\(mon)/\(d)"] as Any)
//        print(Dic["2019/05/19"] as Any)
        calendar.scope = .week
        
        
        var getData = userDefaults.dictionary(forKey: "ratio")
        
        
        let data: Int = getData!["\(selectDay.0)/\(mon)/\(d)"] as! Int
        
        print(data)
        
        num1 = data / 100
        num2 = (data - (num1 * 100)) / 10
        num3 = (data - (num1 * 100 + num2 * 10))
        
        
        
        

        
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
            one = one + 1.0
            print(one)
            
        case ActionIdentifier.actionTwo.rawValue:
            // 具体的な処理をここに記入
            two = two + 1.0
            print(String(two))
            
        case ActionIdentifier.actionThree.rawValue:
            three = three + 1.0
            print(String(three))
            
        default:
            ()
        }
        
        
        /***
            resultOne = Double(one / one + two + three)
            resultTwo = Double(two / one + two + three)
            resultThree = Double(three / one + two + three)
            
            print(Int(resultOne * 100.0) + ":" + Int(resultTwo * 100.0) +  ":" +  Int(resultThree * 100.0))
        
        ***/
        completionHandler()
    }
    
    
    
    @IBAction func sleep(_ sender: Any) {
       
        f.dateStyle = .medium
        
        f.locale = Locale(identifier: "ja_JP")
        let now = Date()
        let today = f.string(from: now)
        
        resultOne = Int((one / (one + two + three)) * 10)
        resultTwo = Int((two / (one + two + three)) * 10)
        resultThree = Int((three / (one + two + three)) * 10)
        
        Result = resultOne * 100 + resultTwo * 10 + resultThree
        
        print("①" + String(resultOne))
        print("②" + String(resultTwo))
        print("③" + String(resultThree))
        print("④" + String(Result))
        
        Dic[today] = Result
        
        //DictionaryのDicを保存
        userDefaults.set(Dic, forKey: "ratio")
        
        
        
        
        
        
        //Result = resultOne + ":" + resultTwo + ":" + resultThree
        
        //① Resultをarrayに代入する
        //② arrayをUDに保存する
        //③ 
        
       // print(String(Result))
       /***
        one = 0
        two = 0
        three = 0
        
        print(String(one))
        print(String(two))
        print(String(three))
       ***/
    
    }
    
}


