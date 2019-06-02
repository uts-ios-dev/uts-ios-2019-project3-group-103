import Foundation

extension NSDate {
    class func creatTimeWithString(timeString : String) -> String {
//        1.创建时间格式化对象
        let formatter = DateFormatter()
        formatter.locale = Locale.init(identifier: "en")
        formatter.dateFormat = "EEE MM dd HH:mm:ss Z yyyy"
        
        
//        2.将字符串时间，转成NSDate类型
        guard let createDate = formatter.date(from: timeString) else {
            return ""
        }
        
//        3.创建当前时间
        let nowDate = Date()
        
//        4.计算创建时间和当前时间的时间差
        let interval = Int(nowDate.timeIntervalSince(createDate))
        
//        5.对时间间隔处理
//        5.1显示刚刚
        if interval < 60 {
            return "刚刚"
        }
        
//        5.2 一小时内
        if interval < 60 * 60 {
            return "\(interval / 60)分钟前"
        }
        
//        5.3 一天之内
        if interval < 60 * 60 * 24 {
            return "\(interval / (60 * 60))小时前"
        }
        
//        5.4 创建日历对象
        let calender = Calendar.current
        
        
//        5.5 处理昨天的数据:昨天12：23
        if calender.isDateInYesterday(createDate) {
            formatter.date(from: "HH:mm")
            let timeString = formatter.string(from: createDate)
            return "昨天 \(timeString)"
        }
        
//        5.6 一年之内
        let components = calender.dateComponents([.year], from: createDate, to: nowDate)
        if components.year! < 1 {
            let timeString = formatter.string(from: createDate)
            return timeString
        }
        
//        5.7 超过一年
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        let timeString = formatter.string(from: createDate)
        return timeString
        
    }
}
