import SwiftUI

enum Halo {
    // MARK: — Colours (exact from HTML mockup)
    static let bg      = Color(hex: "#faf7f1")
    static let bg2     = Color(hex: "#f2e8d8")
    static let bg3     = Color(hex: "#fffcf7")
    static let dark    = Color(hex: "#4a3828")
    static let mid     = Color(hex: "#8a7060")
    static let light   = Color(hex: "#b8a090")
    static let faint   = Color(hex: "#d8c8b8")
    static let border  = Color(hex: "#e4d8c8")
    static let accent  = Color(hex: "#c4a090")
    static let rose    = Color(hex: "#c8a090")
    static let rose2   = Color(hex: "#d4b0a0")
    static let roseL   = Color(hex: "#f5eae4")

    // MARK: — Typography (Georgia is a built-in iOS serif, similar feel)
    static func serif(_ size: CGFloat, weight: Font.Weight = .light) -> Font {
        .custom("Georgia", size: size).weight(weight)
    }
    static func sans(_ size: CGFloat, weight: Font.Weight = .regular) -> Font {
        .system(size: size, weight: weight, design: .default)
    }
}

extension Color {
    init(hex: String) {
        let h = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: h).scanHexInt64(&int)
        let r = Double((int >> 16) & 0xFF) / 255
        let g = Double((int >> 8)  & 0xFF) / 255
        let b = Double(int         & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }
}
