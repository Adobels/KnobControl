import UIKit

class Knob: UIControl {
  /** Contains the minimum value of the receiver. */
  var minimumValue: Float = 0

  /** Contains the maximum value of the receiver. */
  var maximumValue: Float = 1

  /** Contains the receiver’s current value. */
  private (set) var value: Float = 0

  /** Sets the receiver’s current value, allowing you to animate the change visually. */
  func setValue(_ newValue: Float, animated: Bool = false) {
    value = min(maximumValue, max(minimumValue, newValue))

    let angleRange = endAngle - startAngle
    let valueRange = maximumValue - minimumValue
    let angleValue = CGFloat(value - minimumValue) / CGFloat(valueRange) * angleRange + startAngle
    renderer.setPointerAngle(angleValue, animated: animated)
  }

  /** Contains a Boolean value indicating whether changes
   in the sliders value generate continuous update events. */
  var isContinuous = true

  private let renderer = KnobRenderer()

  /** Specifies the width in points of the knob control track. Defaults to 2 */
  var lineWidth: CGFloat {
    get { return renderer.lineWidth }
    set { renderer.lineWidth = newValue }
  }

  /** Specifies the angle of the start of the knob control track. Defaults to -11π/8 */
  var startAngle: CGFloat {
    get { return renderer.startAngle }
    set { renderer.startAngle = newValue }
  }

  /** Specifies the end angle of the knob control track. Defaults to 3π/8 */
  var endAngle: CGFloat {
    get { return renderer.endAngle }
    set { renderer.endAngle = newValue }
  }

  /** Specifies the length in points of the pointer on the knob. Defaults to 6 */
  var pointerLength: CGFloat {
    get { return renderer.pointerLength }
    set { renderer.pointerLength = newValue }
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    commonInit()
  }

  private func commonInit() {
    renderer.updateBounds(bounds)
    renderer.color = tintColor
    renderer.setPointerAngle(renderer.startAngle)

    layer.addSublayer(renderer.trackLayer)
    layer.addSublayer(renderer.pointerLayer)

    let gestureRecognizer = RotationGestureRecognizer(target: self, action: #selector(Knob.handleGesture(_:)))
    addGestureRecognizer(gestureRecognizer)
  }

  @objc private func handleGesture(_ gesture: RotationGestureRecognizer) {
    // 1
    let midPointAngle = (2 * CGFloat(Double.pi) + startAngle - endAngle) / 2 + endAngle
    // 2
    var boundedAngle = gesture.touchAngle
    if boundedAngle > midPointAngle {
      boundedAngle -= 2 * CGFloat(Double.pi)
    } else if boundedAngle < (midPointAngle - 2 * CGFloat(Double.pi)) {
      boundedAngle -= 2 * CGFloat(Double.pi)
    }

    // 3
    boundedAngle = min(endAngle, max(startAngle, boundedAngle))

    // 4
    let angleRange = endAngle - startAngle
    let valueRange = maximumValue - minimumValue
    let angleValue = Float(boundedAngle - startAngle) / Float(angleRange) * valueRange + minimumValue

    // 5
    setValue(angleValue)

    if isContinuous {
      sendActions(for: .valueChanged)
    } else {
      if gesture.state == .ended || gesture.state == .cancelled {
        sendActions(for: .valueChanged)
      }
    }
  }
}
