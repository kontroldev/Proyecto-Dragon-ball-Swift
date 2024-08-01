//
//  CRImages.swift
//  DragonBallSwift
//
//  Created by Esteban Perez Castillejo on 1/8/24.
//

import SwiftUI
import Observation

@Observable
class CRImages{
    var dominantColors: [Color] = []
    var mostVibrantColor: Color = Color.white
    
    ///La función detectColors(in image: UIImage) reduce el tamaño de una imagen, extrae sus datos de píxeles,
    ///cuenta la frecuencia de los colores y determina los colores dominantes y más vibrantes.
    func detectColors(in image: UIImage) {
        let targetSize = CGSize(width: 50, height: 50)
        UIGraphicsBeginImageContext(targetSize)
        image.draw(in: CGRect(origin: .zero, size: targetSize))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let inputImage = resizedImage?.cgImage else { return }
        let width = inputImage.width
        let height = inputImage.height
        
        let bitmapData = calloc(width * height * 4, MemoryLayout<UInt8>.size)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: bitmapData,
                                width: width,
                                height: height,
                                bitsPerComponent: 8,
                                bytesPerRow: width * 4,
                                space: colorSpace,
                                bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
        
        context.draw(inputImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        
        let ptr = bitmapData!.assumingMemoryBound(to: UInt8.self)
        
        var colorCounts: [UIColor: Int] = [:]
        
        for y in 0..<height {
            for x in 0..<width {
                let pixelIndex = ((width * y) + x) * 4
                let r = CGFloat(ptr[pixelIndex]) / 255.0
                let g = CGFloat(ptr[pixelIndex + 1]) / 255.0
                let b = CGFloat(ptr[pixelIndex + 2]) / 255.0
                let color = UIColor(red: r, green: g, blue: b, alpha: 1.0)
                
                colorCounts[color, default: 0] += 1
            }
        }
        
        let colorClusters = clusterColors(colorCounts: colorCounts, maxClusters: 5)
        
        dominantColors = colorClusters.map { Color($0) }
        
        mostVibrantColor = findMostVibrantColor(from: colorClusters)
        
        free(bitmapData)
    }
    
    /// La función clusterColors(colorCounts: [UIColor: Int], maxClusters: Int) agrupa colores similares de una lista
    ///  de colores frecuentes, limitando el número de grupos a un máximo especificado,
    ///  y ajusta los grupos mezclando colores cercanos.
    func clusterColors(colorCounts: [UIColor: Int], maxClusters: Int) -> [UIColor] {
        var clusters: [UIColor] = []
        
        for (color, _) in colorCounts {
            if clusters.count < maxClusters {
                clusters.append(color)
            } else {
                var minDistance = CGFloat.greatestFiniteMagnitude
                var closestClusterIndex = 0
                for (index, clusterColor) in clusters.enumerated() {
                    let distance = colorDistance(from: color, to: clusterColor)
                    if distance < minDistance {
                        minDistance = distance
                        closestClusterIndex = index
                    }
                }
                clusters[closestClusterIndex] = mixColors(color1: clusters[closestClusterIndex], color2: color)
            }
        }
        
        return clusters
    }
    
    /// La función findMostVibrantColor(from colors: [UIColor]) -> Color ordena los colores por saturación y devuelve el color más vibrante.
    func findMostVibrantColor(from colors: [UIColor]) -> Color {
        let sortedColors = colors.sorted { colorSaturation(from: $0) > colorSaturation(from: $1) }
        return Color(sortedColors.first ?? UIColor.white)
    }
    
    /// La función colorSaturation(from color: UIColor) -> CGFloat calcula y devuelve la saturación de un color
    /// al medir la diferencia entre sus componentes de color máximo y mínimo.
    func colorSaturation(from color: UIColor) -> CGFloat {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        let maxColor = max(r, g, b)
        let minColor = min(r, g, b)
        let saturation = maxColor - minColor
        
        return saturation
    }
    
    /// La función colorDistance(from color1: UIColor, to color2: UIColor) -> CGFloat calcula la distancia entre
    /// dos colores en el espacio RGB utilizando la suma de las diferencias cuadradas de sus componentes de color.
    func colorDistance(from color1: UIColor, to color2: UIColor) -> CGFloat {
        var r1: CGFloat = 0
        var g1: CGFloat = 0
        var b1: CGFloat = 0
        var a1: CGFloat = 0
        var r2: CGFloat = 0
        var g2: CGFloat = 0
        var b2: CGFloat = 0
        var a2: CGFloat = 0
        
        color1.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
        color2.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)
        
        let dr = r1 - r2
        let dg = g1 - g2
        let db = b1 - b2
        
        return dr * dr + dg * dg + db * db
    }
    
    /// La función mixColors(color1: UIColor, color2: UIColor) -> UIColor mezcla dos colores calculando el promedio
    /// de sus componentes RGB y devuelve el color resultante.
    func mixColors(color1: UIColor, color2: UIColor) -> UIColor {
        var r1: CGFloat = 0
        var g1: CGFloat = 0
        var b1: CGFloat = 0
        var a1: CGFloat = 0
        var r2: CGFloat = 0
        var g2: CGFloat = 0
        var b2: CGFloat = 0
        var a2: CGFloat = 0
        
        color1.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
        color2.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)
        
        let r = (r1 + r2) / 2
        let g = (g1 + g2) / 2
        let b = (b1 + b2) / 2
        
        return UIColor(red: r, green: g, blue: b, alpha: 1.0)
    }
    
    
}
