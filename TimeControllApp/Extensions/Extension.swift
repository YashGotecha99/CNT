//
//  Extension.swift
//  Trun Up
//
//  Created by apple on 26/11/19.
//  Copyright © 2019 Stealth Technocrats. All rights reserved.
//

import Foundation
import UIKit
import Toast_Swift
import GoogleMaps
import GooglePlaces

@IBDesignable
class DesignableView: UIView {
}

@IBDesignable
class DesignableButton: UIButton {
}

@IBDesignable
class DesignableLabel: UILabel {
}

extension UIView {
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
}

extension UIView {
    private static let lineDashPattern: [NSNumber] = [6,6]
    private static let lineDashWidth: CGFloat = 1.0

    func makeDashedBorderLine() {
        let path = CGMutablePath()
        let shapeLayer = CAShapeLayer()
        shapeLayer.lineWidth = UIView.lineDashWidth
        shapeLayer.strokeColor = UIColor.lightGray.cgColor
        shapeLayer.lineDashPattern = UIView.lineDashPattern
        path.addLines(between: [CGPoint(x: bounds.minX, y: bounds.height/2),
                                CGPoint(x: bounds.maxX, y: bounds.height/2)])
        shapeLayer.path = path
        layer.addSublayer(shapeLayer)
    }
}

extension UIView {
    func addDashedBorder(conerRadius : CGFloat) {
    let color = UIColor.gray.cgColor

    let shapeLayer:CAShapeLayer = CAShapeLayer()
    let frameSize = self.frame.size
    let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)

    shapeLayer.bounds = shapeRect
    shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
    shapeLayer.fillColor = UIColor.clear.cgColor
    shapeLayer.strokeColor = color
    shapeLayer.lineWidth = 2
    shapeLayer.lineJoin = CAShapeLayerLineJoin.round
    shapeLayer.lineDashPattern = [6,3]
    shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: conerRadius).cgPath
        self.layer.addSublayer(shapeLayer)
    }
}

private var KeyMaxLength: Int = 0
 
extension UITextField {
    
    @IBInspectable var maxLength: Int {
        get {
            if let length = objc_getAssociatedObject(self, &KeyMaxLength) as? Int {
                return length
            } else {
                return Int.max
            }
        }
        set {
            objc_setAssociatedObject(self, &KeyMaxLength, newValue, .OBJC_ASSOCIATION_RETAIN)
            addTarget(self, action: #selector(checkMaxLength), for: .editingChanged)
        }
    }
    
    @objc func checkMaxLength(textField: UITextField) {
        guard let prospectiveText = self.text,
            prospectiveText.count > maxLength
            else {
                return
        }
        
        let selection = selectedTextRange
        let maxCharIndex = prospectiveText.index(prospectiveText.startIndex, offsetBy: maxLength)
        text = prospectiveText.substring(to: maxCharIndex)
        selectedTextRange = selection
    }
}

extension UIViewController {
    func setTitle(_ title: String, andImage image: UIImage) {
        let titleLbl = UILabel()
        titleLbl.text = title
        titleLbl.textColor = UIColor.black
        titleLbl.font = UIFont.systemFont(ofSize: 20.0, weight: .bold)
        let imageView = UIImageView(image: image)
        let titleView = UIStackView(arrangedSubviews: [imageView, titleLbl])
        titleView.axis = .horizontal
        titleView.spacing = 10.0
        navigationItem.titleView = titleView
    }
    
    func showAlert(message: String ,strtitle: String, handler:((UIAlertAction) -> Void)! = nil) {
      //  KRProgressHUD.dismiss()
      //  ActivityIndicator.sharedInstance.hideActivityIndicator()
        DispatchQueue.main.async {
            let alert = UIAlertController(title: strtitle, message: message, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertAction.Style.default, handler: handler))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
extension UITextField{
   @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
}

extension UIView {
    
    func fadeIn(duration: TimeInterval = 0.3, delay: TimeInterval = 0.0, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in }) {
        self.alpha = 0.0
        
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.isHidden = false
            self.alpha = 1.0
        }, completion: completion)
    }
    
    func fadeOut(duration: TimeInterval = 0.3, delay: TimeInterval = 0.0, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in }) {
        self.alpha = 1.0
        
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.alpha = 0.0
        }) { (completed) in
            self.isHidden = true
            completion(true)
        }
    }
}

extension UIViewController {
    
    func presentAlert(withTitle title: String, message : String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { action in
            print("You've pressed OK Button")
        }
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
}


//////for displaying tost message
class Toast {
    static func show(message: String, controller: UIViewController) {
        let toastContainer = UIView(frame: CGRect())
        toastContainer.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastContainer.alpha = 0.0
        toastContainer.layer.cornerRadius = 25;
        toastContainer.clipsToBounds  =  true
        
        let toastLabel = UILabel(frame: CGRect())
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font.withSize(12.0)
        toastLabel.text = message
        toastLabel.clipsToBounds  =  true
        toastLabel.numberOfLines = 0
        
        toastContainer.addSubview(toastLabel)
        controller.view.addSubview(toastContainer)
        
        toastLabel.translatesAutoresizingMaskIntoConstraints = false
        toastContainer.translatesAutoresizingMaskIntoConstraints = false
        
        let a1 = NSLayoutConstraint(item: toastLabel, attribute: .leading, relatedBy: .equal, toItem: toastContainer, attribute: .leading, multiplier: 1, constant: 15)
        let a2 = NSLayoutConstraint(item: toastLabel, attribute: .trailing, relatedBy: .equal, toItem: toastContainer, attribute: .trailing, multiplier: 1, constant: -15)
        let a3 = NSLayoutConstraint(item: toastLabel, attribute: .bottom, relatedBy: .equal, toItem: toastContainer, attribute: .bottom, multiplier: 1, constant: -15)
        let a4 = NSLayoutConstraint(item: toastLabel, attribute: .top, relatedBy: .equal, toItem: toastContainer, attribute: .top, multiplier: 1, constant: 15)
        toastContainer.addConstraints([a1, a2, a3, a4])
        
        let c1 = NSLayoutConstraint(item: toastContainer, attribute: .leading, relatedBy: .equal, toItem: controller.view, attribute: .leading, multiplier: 1, constant: 65)
        let c2 = NSLayoutConstraint(item: toastContainer, attribute: .trailing, relatedBy: .equal, toItem: controller.view, attribute: .trailing, multiplier: 1, constant: -65)
        let c3 = NSLayoutConstraint(item: toastContainer, attribute: .bottom, relatedBy: .equal, toItem: controller.view, attribute: .bottom, multiplier: 1, constant: -75)
        controller.view.addConstraints([c1, c2, c3])
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseIn, animations: {
            toastContainer.alpha = 1.0
        }, completion: { _ in
            UIView.animate(withDuration: 0.5, delay: 1.5, options: .curveEaseOut, animations: {
                toastContainer.alpha = 0.0
            }, completion: {_ in
                toastContainer.removeFromSuperview()
            })
        })
    }
}

extension UIImage{
    func resizeWithWidth(width: CGFloat) -> UIImage? {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))))
        imageView.contentMode = .scaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return result
    }
}

extension UITextView {
    func setHTMLFromString(text: String) {
        let modifiedFont = NSString(format:"<span style=\"font-family: \(self.font!.fontName); font-size: \(self.font!.pointSize)\">%@</span>" as NSString, text)
        
        let attrStr = try! NSAttributedString(
            data: modifiedFont.data(using: String.Encoding.unicode.rawValue, allowLossyConversion: true)!,
            options: [NSAttributedString.DocumentReadingOptionKey.documentType:NSAttributedString.DocumentType.html, NSAttributedString.DocumentReadingOptionKey.characterEncoding: String.Encoding.utf8.rawValue],
            documentAttributes: nil)
        
        self.attributedText = attrStr
    }
    
}

extension String {
    func convertToDictionary() -> [String: Any]? {
        if let data = self.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
 
    
    //MARK: - isInValidEmail
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func hexStringToUIColor () -> UIColor {
        var cString:String = self.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        var rgbValue: UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

func displayToast(_ message:String)
{
    UIApplication.topViewController()?.view.makeToast(message)
}

extension UILabel {
    func setHTMLFromString(text: String) {
        let modifiedFont = NSString(format:"<span style=\"font-family: \(self.font!.fontName); font-size: \(self.font!.pointSize)\">%@</span>" as NSString, text)
        
        let attrStr = try! NSAttributedString(
            data: modifiedFont.data(using: String.Encoding.unicode.rawValue, allowLossyConversion: true)!,
            options: [NSAttributedString.DocumentReadingOptionKey.documentType:NSAttributedString.DocumentType.html, NSAttributedString.DocumentReadingOptionKey.characterEncoding: String.Encoding.utf8.rawValue],
            documentAttributes: nil)
        
        self.attributedText = attrStr
    }
}
 
class UnderlineTextButton: UIButton {
    
    override func setTitle(_ title: String?, for state: UIControl.State) {
        super.setTitle(title, for: .normal)
        self.setAttributedTitle(self.attributedString(), for: .normal)
    }
    
    private func attributedString() -> NSAttributedString? {
        let attributes : [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.font : UIFont(name: "Inter-Medium", size: 16),
            NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0.1450980392, green: 0.3137254902, blue: 0.6745098039, alpha: 1),
            NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue
        ]
        let attributedString = NSAttributedString(string: self.currentTitle!, attributes: attributes)
        return attributedString
    }
}

public extension UINavigationController {

    func push(viewController vc: UIViewController, transitionType type: CATransitionType = .push, duration: CFTimeInterval = 0.6) {
        self.addTransition(transitionType: type, subType: .fromRight, duration: duration)
        self.pushViewController(vc, animated: false)
    }
    func pop(transitionType type: CATransitionType = .push, duration: CFTimeInterval = 0.6) {
        self.addTransition(transitionType: type, subType: .fromLeft, duration: duration)
        self.popViewController(animated: false)
    }
    func popToRoot(transitionType type: CATransitionType = .moveIn, duration: CFTimeInterval = 0.6) {
        self.addTransition(transitionType: type, subType: .fromLeft, duration: duration)
        self.popToRootViewController(animated: false)
    }
    private func addTransition(transitionType type: CATransitionType,subType: CATransitionSubtype, duration: CFTimeInterval) {
        let transition = CATransition()
        transition.duration = duration
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.default)
        transition.type = type
        transition.subtype = subType
        self.view.layer.add(transition, forKey: nil)
    }
}


//ash


let SetCharacter = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ ")
var Currentlat = Double()
var Currentlong = Double()
private var __maxLengths = [UITextField: Int]()


extension String {
    
    var stripped: String {
        let okayChars = Set("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890")
        return self.filter {okayChars.contains($0) }
    }
    
    func localize(bundle: Bundle = .main, tableName: String = "LocalizableString") -> String {
        return NSLocalizedString(self, tableName: tableName, value: self, comment: "")
    }
    
    func safelyLimitedTo(length n: Int)->String {
      if (self.count <= n) {
        return self
      }
      return String( Array(self).prefix(upTo: n) )
    }
    var numberValue: NSNumber? {
      if let value = Int(self) {
        return NSNumber(value: value)
      }
      return nil
    }
    
    // formatting text for currency textField
    func currencyInputFormatting() -> String {
        var number: NSNumber!
        let formatter = NumberFormatter()
        formatter.numberStyle = .currencyAccounting
        formatter.currencySymbol = "$"
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        
        var amountWithPrefix = self
        
        // remove from String: "$", ".", ","
        let regex = try! NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
        amountWithPrefix = regex.stringByReplacingMatches(in: amountWithPrefix, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count), withTemplate: "")
        
        let double = (amountWithPrefix as NSString).doubleValue
        number = NSNumber(value: (double / 100))
        
        // if first number is 0 or all numbers were deleted
        guard number != 0 as NSNumber else {
            return ""
        }
        return formatter.string(from: number)!
    }
    
    func intToString(val:Int) -> String {
        let x : Int = val
        let xNSNumber = x as NSNumber
        let xString : String = xNSNumber.stringValue
        return xString
    }
    func attributedString(subStr: String) -> NSMutableAttributedString{
        let range = (self as NSString).range(of: subStr)
        let attributedString = NSMutableAttributedString(string:self)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(named: "appColor") ?? UIColor() , range: range)
        return attributedString
    }
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
    func substringEmoji(from : Int) -> String {
        let fromIndex = self.utf16.index(self.utf16.startIndex, offsetBy: from)
        return String(self.utf16[fromIndex...]) ?? ""
    }
    func substringEmoji(_ r: NSRange) -> String {
        let fromIndex = self.utf16.index(self.utf16.startIndex, offsetBy: r.lowerBound)
        let toIndex = self.utf16.index(self.utf16.startIndex, offsetBy: r.upperBound - 1)
        let indexRange = fromIndex..<toIndex
        return String(self.utf16[indexRange]) ?? ""
    }
    func trimTrailingWhitespace() -> String {
        if let trailingWs = self.range(of: "\\s+$", options: .regularExpression) {
            return self.replacingCharacters(in: trailingWs, with: "")
        } else {
            return self
        }
    }
    func intValue() -> Int{
        if let myNumber = NumberFormatter().number(from: self) {
            let myInt = myNumber.intValue
            return Int(myInt)
        } else {
            return 0
        }
        
    }
    
    func validateName() -> Bool {
        if self.count < 3{
            return false
        }else if self.count > 25{
            return false
        }else{
            let regex =  ".*[^A-Za-z].*"
            let nameTest = NSPredicate(format: "SELF MATCHES %@", regex)
            return nameTest.evaluate(with:self)
        }
    }
    func validateLength() -> Bool {
        if self.count < 3{
            return false
        }else if self.count > 25{
            return false
        }
        return true
    }
    
    func validateCahercter() -> Bool {
        if(self.rangeOfCharacter(from: SetCharacter.inverted) != nil ){
            return false
        } else {
            return true
        }
    }
    func validateSpace() -> Bool {
        if self.hasPrefix(" ") || self.hasSuffix(" ") {
            return false
        }
        return true
    }
    
    func validatePhone() -> Bool {
        if self.count <= 7{
            return false
        }else if self.count > 15{
            return false
        }else{
            let phoneRegex = "^[0-9+]{0,1}+[0-9]{7,16}$"
            let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
            return phoneTest.evaluate(with:self)
        }
    }
    func validatePassword() -> Bool {
        if self.count < 8{
            return false
        }else if self.count > 25{
            return false
        }else{
            return true
        }
    }
    func checkWhiteSpace() -> Bool {
        if self.contains(" ") {
            return false
        } else {
            return true
        }
        
    }
    
    func validatePasswordRegex(regex: String) -> Bool {
        let passRegEx = regex
        let passwordTest = NSPredicate(format:"SELF MATCHES %@", passRegEx)
        return passwordTest.evaluate(with: self)
    }
    
    var floatValue: Float {
        return (self as NSString).floatValue
    }
    
    func calcAge(birthday: String,fromFormet: String) -> Int {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = fromFormet
        var birthdayDate = dateFormater.date(from: birthday)
        if birthdayDate == nil {
            dateFormater.dateFormat = "dd/MM/yyyy"
            birthdayDate = dateFormater.date(from: birthday)
        }
        let calendar: NSCalendar! = NSCalendar(calendarIdentifier: .gregorian)
        let now = Date()
        let calcAge = calendar.components(.year, from: birthdayDate!, to: now, options: [])
        let age = calcAge.year
        return age!
    }
    
    func convertAllFormater(formated: String) -> String {
        let dat = self
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        if dateFormatter.date(from: dat) == nil {
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSZ"
            if dateFormatter.date(from: dat) == nil {
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
                if dateFormatter.date(from: dat) == nil {
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
                    if dateFormatter.date(from: dat) == nil {
                        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                        if dateFormatter.date(from: dat) == nil {
                            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
                            if dateFormatter.date(from: dat) == nil {
                                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss a"
                                if dateFormatter.date(from: dat) == nil {
                                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ssa"
                                    if dateFormatter.date(from: dat) == nil {
                                        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
                                        if dateFormatter.date(from: dat) == nil {
                                            dateFormatter.dateFormat = "yyyy-MM-dd HH"
                                            if dateFormatter.date(from: dat) == nil {
                                                dateFormatter.dateFormat = "yyyy-MM-dd HH"
                                                if dateFormatter.date(from: dat) == nil {
                                                    dateFormatter.dateFormat = "yyyy-MM-dd"
                                                    if dateFormatter.date(from: dat) == nil {
                                                        dateFormatter.dateFormat = "EEE, MMM-dd-yyyy"
                                                        if dateFormatter.date(from: dat) == nil {
                                                            dateFormatter.dateFormat = "EEEE, MMM-dd-yyyy, hh:mm"
                                                            if dateFormatter.date(from: dat) == nil {
                                                                dateFormatter.dateFormat = "EEEE MMM dd,yyyy"
                                                                if dateFormatter.date(from: dat) == nil {
                                                                    dateFormatter.dateFormat = "dd.MM"
                                                                    if dateFormatter.date(from: dat) == nil {
                                                                        dateFormatter.dateFormat = GlobleVariables.clientControlPanelConfiguration?.data?.dateTimeRules?.short_date_format
                                                                        if dateFormatter.date(from: dat) == nil {
                                                                            
                                                                        }
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        guard let date = dateFormatter.date(from: dat) else {
            return ""
        }
        
        dateFormatter.dateFormat = formated
        let timeStamp = dateFormatter.string(from: date)
        
        return timeStamp
    }
    
    func convertStringDate() -> String {
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date / server String
        formatter.dateFormat = "yyyy-MM-dd"

        let myString = formatter.string(from: Date()) // string purpose I add here
        // convert your string to date
        let yourDate = formatter.date(from: self)
        //then again set the date format whhich type of output you need
        formatter.dateFormat = "E dd MMM"
        // again convert your date to string
        let myStringDate = formatter.string(from: yourDate!)
        return myStringDate
    }
    
    func convertforDate() -> String {
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date / server String
        formatter.dateFormat = "yyyy-MM-dd"

        let myString = formatter.string(from: Date()) // string purpose I add here
        // convert your string to date
        let yourDate = formatter.date(from: self)
        //then again set the date format whhich type of output you need
        formatter.dateFormat = "yyyy-MM-dd"
        // again convert your date to string
        let myStringDate = formatter.string(from: yourDate!)
        return myStringDate
    }
    
    
    func localizing()->String {
        let currentLang = UserDefaults.standard.string(forKey: UserDefaultKeys.selectedLanguageCode) ?? "en"
        let path = Bundle.main.path(forResource: currentLang, ofType: "lproj")
        let bundle = Bundle(path: path!)
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    }
    
}

extension UITextField{
  
    
      @objc func fix(textField: UITextField) {
        let t = textField.text
        textField.text = t?.safelyLimitedTo(length: maxLength)
      }
    
    func setRightPaddingPoints(_ width:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
    
    func setLeftPaddingImage(_ leftImage:UIImage) {
        let paddingView = UIImageView(frame: CGRect(x: 0, y: (self.frame.size.height / 2) / 2, width: self.frame.size.height, height: self.frame.size.height / 2))
        paddingView.image = leftImage
        paddingView.clipsToBounds = true
        paddingView.contentMode = .scaleAspectFit
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    
    func addInputViewDatePicker(type: UIDatePicker.Mode,target: Any, selector: Selector) {
        let screenWidth = UIScreen.main.bounds.width
        //Add DatePicker as inputView
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = type
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        datePicker.minimumDate = Date()
        self.inputView = datePicker
        //Add Tool Bar as input AccessoryView
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 44))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelBarButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPressed))
        let doneBarButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: selector)
        toolBar.setItems([cancelBarButton, flexibleSpace, doneBarButton], animated: false)
        self.inputAccessoryView = toolBar
    }
    
    @objc func cancelPressed() {
        self.resignFirstResponder()
    }
}

extension UIView{

    
    @IBInspectable
    var roundCorners: Bool {
        get {
            return false
        }
        set {
            layer.cornerRadius = newValue == true ? self.frame.height / 2 : 0.0
            layer.masksToBounds = newValue
        }
    }
    
    @IBInspectable
    var boarderWidth : CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }

    
    @IBInspectable var underlineColour :UIColor? {
        set {
            layer.borderColor = newValue!.cgColor
        }
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            else {
                return nil
            }
        }
    }
    
    @IBInspectable var underLine : CGFloat {
        get {
            return 0.0
        }
        set {
            let border = CALayer()
            let width = CGFloat(newValue)
            border.borderColor = underlineColour?.cgColor
            border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width +
                                  self.frame.size.height, height: self.frame.size.height)
            border.borderWidth = width
            self.layer.addSublayer(border)
            self.layer.masksToBounds = true
        }
    }
    
    @IBInspectable var topCorners : CGFloat {
        get {
            return 0.0
        }
        set {
            self.layer.masksToBounds = false
            self.layer.cornerRadius = newValue
            self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
    }
    
    @IBInspectable var bottomCorners : CGFloat {
        get {
            return 0.0
        }
        set {
            self.layer.masksToBounds = false
            self.layer.cornerRadius = newValue
            self.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        }
    }
    
    @IBInspectable var rightCorners : CGFloat {
        get {
            return 0.0
        }
        set {
            self.layer.masksToBounds = false
            self.layer.cornerRadius = newValue
            self.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        }
    }
    
    @IBInspectable var leftCorners : CGFloat {
        get {
            return 0.0
        }
        set {
            self.layer.masksToBounds = false
            self.layer.cornerRadius = newValue
            self.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
        }
    }
    
    func startRotating(duration: Double = 1) {
        let kAnimationKey = "rotation"
        if self.layer.animation(forKey: kAnimationKey) == nil {
            let animate = CABasicAnimation(keyPath: "transform.rotation")
            animate.duration = duration
            animate.repeatCount = Float.infinity
            animate.fromValue = 0.0
            animate.toValue = Float(.pi * 2.0)
            self.layer.add(animate, forKey: kAnimationKey)
        }
    }
    
    func stopRotating() {
        let kAnimationKey = "rotation"
        if self.layer.animation(forKey: kAnimationKey) != nil {
            self.layer.removeAnimation(forKey: kAnimationKey)
        }
    }
    
    func TopViewConers(Radius:CGFloat) {
        layer.cornerRadius = Radius
        layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
    }
    
    func BottumViewConers(Radius:CGFloat) {
        layer.cornerRadius = Radius
        layer.maskedCorners = [.layerMinXMaxYCorner, . layerMaxXMaxYCorner]
        
    }
    
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.6
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        layer.add(animation, forKey: "shake")
    }
    func shakeFace() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.6
        animation.values = [-5.0, 5.0, -5.0, 5.0, -5.0, 5.0, -5.0, 5.0, 0.0 ]
        layer.add(animation, forKey: "shake")
    }
    func shakeBtn() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.1
        animation.values = [-5.0, 5.0, -5.0, 5.0, -5.0, 5.0, -5.0, 5.0, 0.0 ]
        layer.add(animation, forKey: "shake")
    }
}

//extension UIImageView{
//    func loadImg(url: String, placeholder: String) -> Void{
//        guard let url = URL(string: url) else {
//            return
//        }
//        
//        DispatchQueue.main.async { [weak self] in
//            if let imageData = try? Data(contentsOf: url) {
//                if let loadedImage = UIImage(data: imageData) {
//                    self?.image = loadedImage
//                }
//            }
//        }
//    }
//}

//extension Date{
//    static func getFormattedDate(string: String , formatter:String) -> String{
//        let dateFormatterGet = DateFormatter()
//        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
//        let dateFormatterPrint = DateFormatter()
//        dateFormatterPrint.dateFormat = formatter
//        let date: Date? = dateFormatterGet.date(from: string)
//        return dateFormatterPrint.string(from: date!);
//    }
//    var timeStamp:Int64 {
//        return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
//    }
//    
////    init(milliseconds:Int64) {
////        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
////    }
//    
//    var formattedDate:String {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
//        dateFormatter.timeZone = TimeZone.current
//        dateFormatter.amSymbol = "AM"
//        dateFormatter.pmSymbol = "PM"
//        let date = dateFormatter.string(from: self)
//        return date
//    }
//    var formatedDate:String {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "MMM dd,yyyy"
//        dateFormatter.timeZone = TimeZone.current
//        dateFormatter.amSymbol = "AM"
//        dateFormatter.pmSymbol = "PM"
//        let date = dateFormatter.string(from: self)
//        return date
//    }
//
//    
//    func timeAgoSinceDate() -> String {
//
//        // From Time
//        let fromDate = self
//
//        // To Time
//        let toDate = Date()
//
//        // Estimation
//        // Year
//        if let interval = Calendar.current.dateComponents([.year], from: fromDate, to: toDate).year, interval > 0  {
//
//            return interval == 1 ? "\(interval)" + " " + "year ago" : "\(interval)" + " " + "years ago"
//        }
//
//        // Month
//        if let interval = Calendar.current.dateComponents([.month], from: fromDate, to: toDate).month, interval > 0  {
//
//            return interval == 1 ? "\(interval)" + " " + "month ago" : "\(interval)" + " " + "months ago"
//        }
//
//        // Day
//        if let interval = Calendar.current.dateComponents([.day], from: fromDate, to: toDate).day, interval > 0  {
//
//            return interval == 1 ? "\(interval)" + " " + "day ago" : "\(interval)" + " " + "days ago"
//        }
//
//        // Hours
//        if let interval = Calendar.current.dateComponents([.hour], from: fromDate, to: toDate).hour, interval > 0 {
//
//            return interval == 1 ? "\(interval)" + " " + "hour ago" : "\(interval)" + " " + "hours ago"
//        }
//
//        // Minute
//        if let interval = Calendar.current.dateComponents([.minute], from: fromDate, to: toDate).minute, interval > 0 {
//
//            return interval == 1 ? "\(interval)" + " " + "minute ago" : "\(interval)" + " " + "minutes ago"
//        }
//
//        return "a moment ago"
//    }
//
//    
//    func timeAgosDate(date: Date) -> String {
//
//        // From Time
//        let fromDate = self
//
//        // To Time
//        let toDate = date
//
//        // Estimation
//        // Year
//        var final : String = ""
//        
//        if let interval = Calendar.current.dateComponents([.year], from: fromDate, to: toDate).year, interval > 0  {
//
//            return interval == 1 ? "\(interval)" + " " + "year ago" : "\(interval)" + " " + "years ago"
//        }
//
//        // Month
//        if let interval = Calendar.current.dateComponents([.month], from: fromDate, to: toDate).month, interval > 0  {
//            final = "\((1 != 0) ? "\(interval)" + " " + "month ago" : "\(interval)" + " " + "months ago")"
////            return interval == 1 ? "\(interval)" + " " + "month ago" : "\(interval)" + " " + "months ago"
//        }
//
//        // Day
//        if let interval = Calendar.current.dateComponents([.day], from: fromDate, to: toDate).day, interval > 0  {
//
//            final = "\(final) \((1 != 0) ? "\(interval)" + " " + "day" : "\(interval)" + " " + "days")"
//
//        }
//
//        // Hours
//        if let interval = Calendar.current.dateComponents([.hour], from: fromDate, to: toDate).hour, interval > 0 {
//
//            final = "\(final) \((1 != 0) ? "\(interval)" + " " + "hour" : "\(interval)" + " " + "hours")"
//
//        }
//
//        // Minute
//        if let interval = Calendar.current.dateComponents([.minute], from: fromDate, to: toDate).minute, interval > 0 {
//
//            final = "\(final) \((1 != 0) ? "\(interval)" + " " + "minute" : "\(interval)" + " " + "minutes")"
//
//        }
//
//        if let interval = Calendar.current.dateComponents([.minute], from: fromDate, to: toDate).second, interval > 0 {
//
//            final = "\(final) \((1 != 0) ? "\(interval)" + " " + "second" : "\(interval)" + " " + "second")"
//
//        }
//
//        return final
//    }
//
//    var millisecondsSince1970:Int {
//      return Int((self.timeIntervalSince1970 * 1000.0).rounded())
//    }
//    init(milliseconds:Int64) {
//      self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
//    }
//    func getOrderTime() -> String {
//      let dF = DateFormatter()
//      dF.timeZone = NSTimeZone.local
//      dF.dateFormat = "h:mm a"
//      return dF.string(from: self)
//    }
//    func getDatefromMilli(format : String) -> String {
//      let dF = DateFormatter()
//      dF.timeZone = NSTimeZone.local
//      dF.dateFormat = format
//      return dF.string(from: self)
//    }
//    func getDateString(format: String) -> String {
//      let formatter = DateFormatter()
//      formatter.dateFormat = format
//      return formatter.string(from: self)
//    }
//
//}

extension Date {
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> String {
        if years(from: date)   > 0 { return "\(years(from: date))y"   }
        if months(from: date)  > 0 { return "\(months(from: date))M"  }
        if weeks(from: date)   > 0 { return "\(weeks(from: date))w"   }
        if days(from: date)    > 0 { return "\(days(from: date))d"    }
        if hours(from: date)   > 0 { return "\(hours(from: date))h"   }
        if minutes(from: date) > 0 { return "\(minutes(from: date))m" }
        if seconds(from: date) > 0 { return "\(seconds(from: date))s" }
        return ""
    }
}
public extension UITextView {
    func setToInitial() -> Void {

        self.text = ""
        self.textContainerInset = UIEdgeInsets(top: -10, left: 0, bottom: -10, right: 0)
        self.contentSize = CGSize.zero
        self.textContainer.lineFragmentPadding = 0

        self.layoutIfNeeded()
        self.setNeedsLayout()
    }
    func setTop(top:CGFloat) -> Void {
//        self.textColor = UIColor(named: "custom_extra_black_text_colour")
        self.text = ""
        self.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 3, right: 0)
        self.contentSize = CGSize.zero
        self.textContainer.lineFragmentPadding = top
//        self.bounds.height = .zero
        self.layoutIfNeeded()
        self.setNeedsLayout()
    }

    func configure(text:String) -> Void {
        self.textContainer.lineFragmentPadding = 0
        self.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.text = text
        self.layoutIfNeeded()
        self.setNeedsLayout()
        self.updateConstraints()
    }
    
    func configureWithTop(text:String, top:CGFloat) -> Void {
//        self.textColor = UIColor(named: "custom_extra_black_text_colour")
        self.textContainer.lineFragmentPadding = 0
        self.textContainerInset = UIEdgeInsets(top: top, left: 0, bottom: 0, right: 0)
        self.text = text
        self.layoutIfNeeded()
        self.setNeedsLayout()
    }
    
    func configureAttributedWithTop(text:NSAttributedString, top:CGFloat) -> Void {
//        self.textColor = UIColor(named: "custom_extra_black_text_colour")
        self.textContainer.lineFragmentPadding = 0
        self.textContainerInset = UIEdgeInsets(top: top, left: 0, bottom: 0, right: 0)
        self.attributedText = text
        self.layoutIfNeeded()
        self.setNeedsLayout()
    }

    func configureAttributedWithImage(text:String, top:CGFloat) -> Void {
//        self.textColor = UIColor(named: "custom_extra_black_text_colour")
        self.textContainer.lineFragmentPadding = 0
        self.textContainerInset = UIEdgeInsets(top: top, left: 0, bottom: 0, right: 0)
        let attributedString = NSMutableAttributedString(string: "\(text)  ")
        let textAttachment = NSTextAttachment()
        textAttachment.image = UIImage(named: "icon_green_tick")
        textAttachment.bounds = CGRect(x: textAttachment.bounds.origin.x, y: -2, width: 18, height: 14)
        let attrStringWithImage = NSAttributedString(attachment: textAttachment)
//        attributedString.addAttribute(.font, value: KDFont.sharedInstance.setSemiBoldCustomFont(ofSize: 15) as Any, range: NSRange(location: 0, length: attributedString.length))
        attributedString.addAttribute(.foregroundColor, value: UIColor(red: 50.0 / 255.0, green: 50.0 / 255.0, blue: 50.0 / 255.0, alpha: 1), range: NSRange(location: 0, length: attributedString.length))
        attributedString.replaceCharacters(in: NSRange(location: attributedString.length - 1, length: 1), with: attrStringWithImage)
        self.attributedText = attributedString
        self.layoutIfNeeded()
        self.setNeedsLayout()
    }
    func configureAttributedWithText(text:String, top:CGFloat) -> Void {
//        self.textColor = UIColor(named: "custom_extra_black_text_colour")
        self.textContainer.lineFragmentPadding = 0
        self.textContainerInset = UIEdgeInsets(top: top, left: 0, bottom: 0, right: 0)
        let attributedString = NSMutableAttributedString(string: "\(text)  ")
        let textAttachment = NSTextAttachment()
        textAttachment.image = UIImage(named: "icon_green_tick")
        textAttachment.bounds = CGRect(x: textAttachment.bounds.origin.x, y: -2, width: 18, height: 14)
        let attrStringWithImage = NSAttributedString(attachment: textAttachment)
//        attributedString.addAttribute(.font, value: KDFont.sharedInstance.setSemiBoldCustomFont(ofSize: 15) as Any, range: NSRange(location: 0, length: attributedString.length))
        attributedString.addAttribute(.foregroundColor, value: UIColor(red: 50.0 / 255.0, green: 50.0 / 255.0, blue: 50.0 / 255.0, alpha: 1), range: NSRange(location: 0, length: attributedString.length))
        attributedString.replaceCharacters(in: NSRange(location: attributedString.length - 1, length: 1), with: attrStringWithImage)
        self.attributedText = attributedString
        self.layoutIfNeeded()
        self.setNeedsLayout()
    }

    func configureWithImage(text:String) -> Void {
//        self.textColor = UIColor(named: "custom_extra_black_text_colour")
//        self.textContainer.lineFragmentPadding = 0
//        self.textContainerInset = UIEdgeInsets(top: top, left: 0, bottom: 0, right: 0)
        let attributedString = NSMutableAttributedString(string: text)
        let textAttachment = NSTextAttachment()
        textAttachment.image = UIImage(named: "icon_tick")
        textAttachment.bounds = CGRect(x: textAttachment.bounds.origin.x, y: -2, width: 20, height: 14)
        let attrStringWithImage = NSAttributedString(attachment: textAttachment)
//        attributedString.addAttribute(.font, value: KDFont.sharedInstance.setSemiBoldCustomFont(ofSize: 15) as Any, range: NSRange(location: 0, length: attributedString.length))
        attributedString.addAttribute(.foregroundColor, value: UIColor(red: 50.0 / 255.0, green: 50.0 / 255.0, blue: 50.0 / 255.0, alpha: 1), range: NSRange(location: 0, length: attributedString.length))
        attributedString.replaceCharacters(in: NSRange(location: attributedString.length - 1, length: 1), with: attrStringWithImage)
//        self.attributedText = attributedString
//        self.layoutIfNeeded()
//        self.setNeedsLayout()
    }
}
extension NSObject {
    var className: String {
        return String(describing: type(of: self))
    }
    
    class var className: String {
        return String(describing: self)
    }
}
extension UIApplication {
    static var topMostViewController: UIViewController? {
        return UIWindow.window?.rootViewController?.visibleViewControllerforvc
    }
}

extension UIWindow {
    static var window: UIWindow? {
        if #available(iOS 13, *) {
            if let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }){
                return window
            }else{
                let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                return (windowScene?.delegate as? SceneDelegate)?.window
            }
        } else {
            return UIApplication.shared.keyWindow
        }
    }
}

extension UIViewController {
    var visibleViewControllerforvc: UIViewController? {
        if let navigationController = self as? UINavigationController {
            return navigationController.topViewController?.visibleViewControllerforvc
        } else if let tabBarController = self as? UITabBarController {
            return tabBarController.selectedViewController?.visibleViewControllerforvc
        } else if let presentedViewController = presentedViewController {
            return presentedViewController.visibleViewControllerforvc
        } else {
            return self
        }
    }
    
    func NavigationBarHidden(hidden: Bool){
        self.navigationController?.isNavigationBarHidden = hidden
    }

    func animateConstraint(constraint: NSLayoutConstraint, value: CGFloat){
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            constraint.constant = value
            self.view.layoutIfNeeded()
        })
    }
//    func logTime(time:Int) -> String {
//        let interval = time * 60
//        let formatter = DateComponentsFormatter()
//        let formattedString = formatter.string(from: TimeInterval(interval))!
//        print(formattedString)
//        
//        let dateAsString = formattedString
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "HH:mm:ss"
//
//        let date = dateFormatter.date(from: dateAsString) ?? Date()
//        //MARK: Change the time formate from configuration
////        dateFormatter.dateFormat = "h:mm a"
//        dateFormatter.dateFormat = GlobleVariables.clientControlPanelConfiguration?.data?.dateTimeRules?.time_format
//
//        let Date12 = dateFormatter.string(from: date)
//        return Date12
//    }
    
    
    func logTime(time:Int) -> String {
        let interval = time * 60
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.zeroFormattingBehavior = .pad // Ensure leading zeros for single-digit values

        // Format the time interval
        var formattedString = formatter.string(from: TimeInterval(interval))!

        // If the time is less than 1 hour, manually format as "00:XX:YY"
        if time < 60 {
            let minutes = time
            formattedString = String(format: "00:%02d:%02d", minutes, 0)
        }

        // Parse the formatted string as a date to extract hours and minutes
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        let date = dateFormatter.date(from: formattedString) ?? Date()

        // Use the custom time format
        if let customTimeFormat = GlobleVariables.clientControlPanelConfiguration?.data?.dateTimeRules?.time_format {
            dateFormatter.dateFormat = customTimeFormat
        } else {
            // Default to "HH:mm" if the custom format is not available
            dateFormatter.dateFormat = "HH:mm"
        }

        let formattedTime = dateFormatter.string(from: date)
        return formattedTime
    }
    
    func getDateFormattedString(date:Date,dateFormat:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        let formattedString = dateFormatter.string(from: date)
        return formattedString
    }
    func convertImageToBase64String(img: UIImage) -> String? {
        let imageData:NSData = img.jpegData(compressionQuality: 0.50)! as NSData //UIImagePNGRepresentation(img)
        let imgString = imageData.base64EncodedString(options: .init(rawValue: 0))
        return imgString
    }
    func convertBase64StringToImage(imageBase64String:String) -> UIImage? {
        if let url = URL(string: imageBase64String),let data = try? Data(contentsOf: url),let image = UIImage(data: data) {
            return image
        }
        return nil
    }
    
    func getCurrentDateFromGMT() -> Date {
        let timezoneOffset = GlobleVariables.timezoneGMT ?? 0
        let serverTimeZone = "\(timezoneOffset)"
        var timezoneOffsetData = ""
        if serverTimeZone.contains("-") {
            timezoneOffsetData = serverTimeZone
        } else {
            timezoneOffsetData = "+\(serverTimeZone)"
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "GMT\(timezoneOffsetData)")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let currentDateInGMT = Date()
        return currentDateInGMT
    }
}

extension Calendar {
    static let iso8601 = Calendar(identifier: .iso8601)
}
extension Date {
    var startOfWeek: Date {
        return Calendar.iso8601.date(from: Calendar.iso8601.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))!
    }
    var daysOfWeek: [Date] {
        let startOfWeek = self.startOfWeek
        return (0...6).compactMap{ Calendar.current.date(byAdding: .day, value: $0, to: startOfWeek)}
    }
    
    var daysOfWeekAvailability: [Date] {
        let startOfWeek = self.startOfWeek
        return (1...7).compactMap{ Calendar.current.date(byAdding: .day, value: $0, to: startOfWeek)}
    }
    
    func allDates(till endDate: Date) -> [Date] {
        var date = self
        var array: [Date] = []
        while date <= endDate {
            array.append(date)
            date = Calendar.current.date(byAdding: .day, value: 1, to: date)!
        }
        return array
    }
    
    var startOfMonth: Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!

//        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: self))!
    }
    
    func addOrSubtractDay(day:Int)->Date{
      return Calendar.current.date(byAdding: .day, value: day, to: Date())!
    }

    func addOrSubtractMonth(month:Int)->Date{
      return Calendar.current.date(byAdding: .month, value: month, to: Date())!
    }

    func addOrSubtractYear(year:Int)->Date{
      return Calendar.current.date(byAdding: .year, value: year, to: Date())!
    }
}

extension UITableViewCell {
    func getDateFormattedString(date:Date,dateFormat:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        let formattedString = dateFormatter.string(from: date)
        return formattedString
    }
    
    func getStringDateFromISOString(date:String,dateFormate:String) -> String {
        let isoFormatter = ISO8601DateFormatter()
        let d = isoFormatter.date(from: date)!
        return getDateFormattedString(date: d, dateFormat: dateFormate)
    }
}

extension UIView {
    func makeSecure() {
        DispatchQueue.main.async {
            let field = UITextField()
            field.isSecureTextEntry = true
            self.addSubview(field)
            field.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
            field.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
            self.layer.superlayer?.addSublayer(field.layer)
            field.layer.sublayers?.first?.addSublayer(self.layer)
        }
    }
}
extension UITableViewCell {
    func logTime(time:Int) -> String {
        let interval = time * 60
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.zeroFormattingBehavior = .pad // Ensure leading zeros for single-digit values

        // Format the time interval
        var formattedString = formatter.string(from: TimeInterval(interval))!

        // If the time is less than 1 hour, manually format as "00:XX:YY"
        if time < 60 {
            let minutes = time
            formattedString = String(format: "00:%02d:%02d", minutes, 0)
        }

        // Parse the formatted string as a date to extract hours and minutes
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        let date = dateFormatter.date(from: formattedString) ?? Date()

        // Use the custom time format
        if let customTimeFormat = GlobleVariables.clientControlPanelConfiguration?.data?.dateTimeRules?.time_format {
            dateFormatter.dateFormat = customTimeFormat
        } else {
            // Default to "HH:mm" if the custom format is not available
            dateFormatter.dateFormat = "HH:mm"
        }

        let formattedTime = dateFormatter.string(from: date)
        return formattedTime
    }
}









