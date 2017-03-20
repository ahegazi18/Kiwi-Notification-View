//
//  KiwiNotificationView.swift
//
//  Created by Ahmad Hegazi on 3/20/17.
//  Copyright © 2017 Queue. All rights reserved.
//

import UIKit

let greenColor = UIColor(red: 91.0 / 255.0, green: 213.0 / 255.0, blue: 144.0 / 255.0, alpha: 1.0)
let purbleColor = UIColor(red: 102.0 / 255.0, green: 114.0 / 255.0, blue: 200.0 / 255.0, alpha: 1.0)
let redColor = UIColor(red: 255.0 / 255.0, green: 99.0 / 255.0, blue: 99.0 / 255.0, alpha: 1.0)
let orangeColor = UIColor(red: 255.0 / 255.0, green: 127.0 / 255.0, blue: 80.0 / 255.0, alpha: 1.0)

enum kiwiStates : Int {

	case success = 0
	case cuteSuccess = 1
	case error = 2
	case warning = 3
	case custom = 4
}

class KiwiNotificationView: UIView {

	class func instanceFromNib() -> KiwiNotificationView {

		return UINib(nibName: "KiwiNotificationView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! KiwiNotificationView
	}

	@IBOutlet private weak var messageLabel: UILabel!

	override func awakeFromNib() {

		let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
		swipeUp.direction = .up
		self.addGestureRecognizer(swipeUp)
	}

	func showNotification(view : UIView, message : String, color : UIColor?, state : kiwiStates, duration : Double) {

		self.setViewData(text: message, color: color, state: state)
		self.addViewToSuperView(view: view, duration: duration)
	}

	func showNotification(view : UIView, message : String, color : UIColor?, state : kiwiStates) {

		self.setViewData(text: message, color: color, state: state)
		self.addViewToSuperView(view: view, duration: 0.5)
	}

	func showNotification(view : UIView, message : String, state : kiwiStates) {

		self.setViewData(text: message, color: nil, state: state)
		self.addViewToSuperView(view: view, duration: 0.5)
	}

	func showNotification(view : UIView, message : String, color : UIColor?) {

		self.setViewData(text: message, color: color, state: nil)
		self.addViewToSuperView(view: view, duration: 0.5)
	}

	private func addViewToSuperView(view : UIView, duration : Double) {

		let y = 0 - self.frame.size.height

		self.frame.origin = CGPoint(x: 0.0, y: y)

		self.frame.size.width = view.frame.size.width

		view.addSubview(self)

		UIView.animate(withDuration: duration) {

			self.frame.origin = CGPoint(x: 0.0, y: 0.0)

			Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(KiwiNotificationView.removeView), userInfo: nil, repeats: true)
		}
	}

	@objc private func removeView() {

		UIView.animate(withDuration: 0.5) {

			self.frame.origin = CGPoint(x: 0.0, y: 0 - self.frame.size.height)
		}
	}

	private func setViewData(text : String, color : UIColor?, state : kiwiStates?) {

		if state == nil {

			self.setNotificationColor(color: color, state: kiwiStates.custom)
		} else {

			self.setNotificationColor(color: color, state: state!)
		}

		self.setLabelText(text: text)
	}

	private func setNotificationColor(color : UIColor?, state : kiwiStates) {

		guard color == nil else {

			self.backgroundColor = color
			return
		}

		switch state.rawValue {

		case kiwiStates.success.rawValue:

			self.backgroundColor = greenColor
			break
		case kiwiStates.cuteSuccess.rawValue:

			self.backgroundColor = purbleColor
			break
		case kiwiStates.error.rawValue:

			self.backgroundColor = redColor
			break
		case kiwiStates.warning.rawValue:

			self.backgroundColor = orangeColor
			break
		default:
			break
		}
	}

	private func setLabelText(text : String) {

		self.messageLabel.frame.size.height = CGFloat.greatestFiniteMagnitude
		self.messageLabel.numberOfLines = 0

		self.messageLabel.text = text

		self.messageLabel.sizeToFit()

		self.frame.size.height = self.messageLabel.frame.size.height + 43
		self.clipsToBounds = true 
	}

	@objc private func respondToSwipeGesture(gesture: UIGestureRecognizer) {

		if let swipeGesture = gesture as? UISwipeGestureRecognizer {


			switch swipeGesture.direction {
			case UISwipeGestureRecognizerDirection.right:
				print("Swiped right")
			case UISwipeGestureRecognizerDirection.down:
				print("Swiped down")
			case UISwipeGestureRecognizerDirection.left:
				print("Swiped left")
			case UISwipeGestureRecognizerDirection.up:
				print("Swiped up")
				UIView.animate(withDuration: 0.04) {

					self.frame.origin = CGPoint(x: 0.0, y: 0 - self.frame.size.height)
				}
			default:
				break
			}
		}
	}
}
