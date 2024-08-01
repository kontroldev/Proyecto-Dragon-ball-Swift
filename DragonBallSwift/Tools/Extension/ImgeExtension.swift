//
//  ImgeExtension.swift
//  DragonBallSwift
//
//  Created by Esteban Perez Castillejo on 1/8/24.
//

import Foundation
import SwiftUI

/// La extensión Image añade la función asUIImage() -> UIImage?, que convierte una vista SwiftUI en una imagen
/// UIImage utilizando un controlador de vista de alojamiento (UIHostingController).
extension Image {
    func asUIImage() -> UIImage? {
        let controller = UIHostingController(rootView: self)
        controller.view.frame = CGRect(x: 0, y: 0, width: 1, height: 1)
        let view = controller.view
        let size = controller.sizeThatFits(in: UIView.layoutFittingCompressedSize)
        view?.bounds = CGRect(origin: .zero, size: size)
        view?.backgroundColor = .clear

        let format = UIGraphicsImageRendererFormat()
        format.scale = 1
        let renderer = UIGraphicsImageRenderer(size: size, format: format)
        return renderer.image { context in
            view?.drawHierarchy(in: view?.bounds ?? .zero, afterScreenUpdates: true)
        }
    }
}
