// We are a way for the cosmos to know itself. -- C. Sagan

import CoreGraphics
import GameplayKit

extension CGPoint {
    static func + (_ lhs: CGPoint, _ rhs: CGPoint) -> CGPoint {
        CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }

    static func + (_ lhs: CGPoint, _ rhs: CGSize) -> CGPoint {
        CGPoint(x: lhs.x + rhs.width, y: lhs.y + rhs.height)
    }

    static func += (_ L: inout CGPoint, _ R: CGPoint) { L = L + R }

    static func += (_ L: inout CGPoint, _ R: CGSize) { L = L + R }

    static func - (_ lhs: CGPoint, _ rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }

    static func - (_ lhs: CGPoint, _ rhs: CGSize) -> CGPoint {
        return CGPoint(x: lhs.x - rhs.width, y: lhs.y - rhs.height)
    }

    static func -= (_ L: inout CGPoint, _ R: CGPoint) { L = L - R }

    static func -= (_ L: inout CGPoint, _ R: CGSize) { L = L - R }

    static func * (_ lhs: CGPoint, _ rhs: CGFloat) -> CGPoint {
        return CGPoint(x: lhs.x * Double(rhs), y: lhs.y * Double(rhs))
    }

    static func *= (_ L: inout CGPoint, R: CGFloat) { L = L * R }

    static func / (_ lhs: CGPoint, _ rhs: CGFloat) -> CGPoint {
        return CGPoint(x: lhs.x / Double(rhs), y: lhs.y / Double(rhs))
    }

    static func /= (_ L: inout CGPoint, R: CGFloat) { L = L / R }

    init(_ size: CGSize) { self.init(x: size.width, y: size.height) }

    func constrained<T>(raw: T, min: T, max: T) -> T where T: Comparable & AdditiveArithmetic & ExpressibleByIntegerLiteral {
        var result = raw
        if result < min { result = min }
        if result > max { result = max }
        return result
    }

    func constrained(to area: CGSize) -> CGPoint {
        let x = constrained(raw: self.x, min: -area.width / 2, max: area.width / 2)
        let y = constrained(raw: self.y, min: -area.height / 2, max: area.height / 2)
        return CGPoint(x: x, y: y)
    }

    func distance(to otherPoint: CGPoint) -> CGFloat {
        let dx = otherPoint.x - x
        let dy = otherPoint.y - y
        return sqrt(dx * dx + dy * dy)
    }
}

extension CGPoint: CustomStringConvertible {
    public var description: String {
        String(format: "(%.2f, %.2f)", x, y)
    }
}

extension CGSize {
    static func + (_ lhs: CGSize, _ rhs: CGSize) -> CGSize {
        CGSize(width: lhs.width + rhs.width, height: lhs.height + rhs.height)
    }

    static func + (_ lhs: CGSize, _ rhs: CGPoint) -> CGSize {
        CGSize(width: lhs.width + rhs.x, height: lhs.height + rhs.y)
    }

    static func += (_ L: inout CGSize, _ R: CGSize) { L = L + R }

    static func += (_ L: inout CGSize, _ R: CGPoint) { L = L + R }

    static func - (_ lhs: CGSize, _ rhs: CGSize) -> CGSize {
        return CGSize(width: lhs.width - rhs.width, height: lhs.height - rhs.height)
    }

    static func - (_ lhs: CGSize, _ rhs: CGPoint) -> CGSize {
        return CGSize(width: lhs.width - rhs.x, height: lhs.height - rhs.y)
    }

    static func -= (_ L: inout CGSize, _ R: CGSize) { L = L - R }

    static func -= (_ L: inout CGSize, _ R: CGPoint) { L = L - R }

    static func * (_ lhs: CGSize, _ rhs: CGFloat) -> CGSize {
        return CGSize(width: lhs.width * Double(rhs), height: lhs.height * Double(rhs))
    }

    static func *= (_ L: inout CGSize, R: CGFloat) { L = L * R }

    static func / (_ lhs: CGSize, _ rhs: CGFloat) -> CGSize {
        return CGSize(width: lhs.width / Double(rhs), height: lhs.height / Double(rhs))
    }

    static func /= (_ L: inout CGSize, R: CGFloat) { L = L / R }

    init(_ position: CGPoint) { self.init(width: position.x, height: position.y) }
}

extension CGRect {
    init(startVertex: CGPoint, endVertex: CGPoint) {
        self.init(
            origin: startVertex,
            size: CGSize(
                width: abs(endVertex.x - startVertex.x),
                height: abs(endVertex.y - startVertex.y)
            )
        )
    }
}
