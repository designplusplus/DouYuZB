import UIKit

extension UIBarButtonItem {
    convenience init(imageName:String, highImageName:String = "", size:CGSize = CGSize.zero) {
        let btn = UIButton()
        btn.setImage(UIImage(named:imageName), for: .normal)
        if highImageName != "" {
            btn.setImage(UIImage(named:highImageName), for: .highlighted)
        }
        if size == CGSize.zero {
            btn.sizeToFit() //自適應圖示大小
        } else {
            btn.frame = CGRect(origin: CGPoint.zero, size: size)
        }
        btn.frame = CGRect(origin: CGPoint.zero, size: size)
        self.init(customView:btn)
    }
}
