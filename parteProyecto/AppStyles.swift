//
//  AppStyles.swift
//  parteProyecto
//
//  Created by dam1 on 13/2/26.
//
import SwiftUI

extension Color {
    static let figmaBlue = Color(red: 0, green: 0.38, blue: 0.66)
    static let figmaLightBlue = Color(red: 0.53, green: 0.82, blue: 0.92)
}

// Para las esquinas redondeadas personalizadas
struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}
