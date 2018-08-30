
extension String
{
   
    func datesetting () -> String
    {
        let startDate = changedate(strinTochan: self)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-ddHH:mm:ss"
        let formatedStartDate = dateFormatter.date(from: startDate)
        let currentDate = Date()
        let components = Set<Calendar.Component>([.year,.month,.day,.hour,.minute,.second])
        let differenceOfDate = Calendar.current.dateComponents(components, from: formatedStartDate!, to: currentDate)
        if differenceOfDate.year! > 0 {
            let formatednewDate = ("\(String(describing: differenceOfDate.year!)) year Ago")
            let newdate = formatednewDate
            return  newdate
        }
        if differenceOfDate.month! > 0 && differenceOfDate.year! <= 0{
            let formatednewDate = ("\(String(describing: differenceOfDate.month!)) month Ago")
            let newdate = formatednewDate
            return  newdate
        }
        if differenceOfDate.day! > 0 && differenceOfDate.month! <= 0 {
            let formatednewDate = ("\(String(describing: differenceOfDate.day!)) days Ago")
            let newdate = formatednewDate
            return  newdate
        }
        if differenceOfDate.day! <= 0 && differenceOfDate.hour! > 0 {
            let formatednewDate = ("\(String(describing: differenceOfDate.hour!)) hours Ago")
            let newdate = formatednewDate
            return  newdate
        }
        if differenceOfDate.day! <= 0 && differenceOfDate.hour! <= 0 && differenceOfDate.minute! > 0 {
            let formatednewDate = ("\(String(describing: differenceOfDate.minute!)) mins Ago")
            let newdate = formatednewDate
            return  newdate
        }
        if differenceOfDate.day! <= 0 && differenceOfDate.hour! <= 0 && differenceOfDate.minute! <= 0 && differenceOfDate.second! <= 60 {
            let formatednewDate = "Just now"
            let newdate = formatednewDate
            return  newdate
        }
        
        let formatednewDate = ("\(String(describing: differenceOfDate.day!))days")
        let newdate = formatednewDate
        return newdate
    }
    
    func changedate(strinTochan:String) ->String {
        let str = strinTochan.replacingOccurrences(of: "T", with: "", options: .regularExpression, range: nil)
        return str
    }
}
