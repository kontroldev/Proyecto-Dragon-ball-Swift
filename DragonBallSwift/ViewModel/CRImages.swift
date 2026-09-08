//
//  CRImages.swift
//  DragonBallSwift
//
//  Created by Esteban Perez Castillejo on 1/8/24.
//
//  ⚠️ ARREGLADO:
//  1. `CGContext(...)!` usaba un force-unwrap: si la creación del
//     contexto fallaba (memoria baja, imagen corrupta...) la app
//     crasheaba. Ahora se comprueba con `guard let`.
//  2. El análisis de píxeles (bucle sobre cada uno de 50x50 = 2500
//     píxeles) se ejecutaba directamente en el hilo desde el que se
//     llamaba, que normalmente es el principal (UI). Ahora se hace
//     en un Task con prioridad de background y se vuelve a `@MainActor`
//     solo para publicar el resultado.

import SwiftUI
import Observation

@Observable
@MainActor
final class CRImages {
    private struct PixelColor: Hashable, Sendable {
        let red: CGFloat
        let green: CGFloat
        let blue: CGFloat

        var swiftUIColor: Color {
            Color(red: red, green: green, blue: blue)
        }
    }

    private struct PixelBuffer: Sendable {
        let bytes: [UInt8]
        let width: Int
        let height: Int
    }

    private struct AnalysisResult: Sendable {
        let dominantColors: [PixelColor]
        let mostVibrantColor: PixelColor?
    }

    var dominantColors: [Color] = []
    var mostVibrantColor: Color = Color.white

    /// Analiza `image`, calcula sus colores dominantes y el más vibrante,
    /// y publica el resultado en el hilo principal.
    func detectColors(in image: UIImage) {
        guard let pixelBuffer = Self.makePixelBuffer(from: image) else { return }

        Task {
            let result = await Task.detached(priority: .userInitiated) {
                Self.analyze(pixelBuffer)
            }.value

            dominantColors = result.dominantColors.map(\.swiftUIColor)
            mostVibrantColor = result.mostVibrantColor?.swiftUIColor ?? .white
        }
    }

    /// Reduce la imagen a 50 x 50 y copia sus píxeles a un valor `Sendable`.
    /// El trabajo posterior puede salir del actor principal sin transferir `UIImage`.
    private static func makePixelBuffer(from image: UIImage) -> PixelBuffer? {
        let targetSize = CGSize(width: 50, height: 50)
        UIGraphicsBeginImageContext(targetSize)
        defer { UIGraphicsEndImageContext() }
        image.draw(in: CGRect(origin: .zero, size: targetSize))
        guard let inputImage = UIGraphicsGetImageFromCurrentImageContext()?.cgImage else { return nil }
        let width = inputImage.width
        let height = inputImage.height
        var bytes = [UInt8](repeating: 0, count: width * height * 4)
        let colorSpace = CGColorSpaceCreateDeviceRGB()

        // FIX: antes era `CGContext(...)!`, forzando el unwrap. Si esta
        // creación fallaba, la app crasheaba. Ahora se sale limpiamente.
        let didDraw = bytes.withUnsafeMutableBytes { rawBuffer -> Bool in
            guard let context = CGContext(data: rawBuffer.baseAddress,
                                          width: width,
                                          height: height,
                                          bitsPerComponent: 8,
                                          bytesPerRow: width * 4,
                                          space: colorSpace,
                                          bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) else {
                return false
            }
            context.draw(inputImage, in: CGRect(x: 0, y: 0, width: width, height: height))
            return true
        }

        return didDraw ? PixelBuffer(bytes: bytes, width: width, height: height) : nil
    }

    /// Cuenta y agrupa los píxeles fuera del actor principal.
    nonisolated private static func analyze(_ pixelBuffer: PixelBuffer) -> AnalysisResult {
        var colorCounts: [PixelColor: Int] = [:]

        for y in 0..<pixelBuffer.height {
            for x in 0..<pixelBuffer.width {
                let pixelIndex = ((pixelBuffer.width * y) + x) * 4
                let color = PixelColor(
                    red: CGFloat(pixelBuffer.bytes[pixelIndex]) / 255.0,
                    green: CGFloat(pixelBuffer.bytes[pixelIndex + 1]) / 255.0,
                    blue: CGFloat(pixelBuffer.bytes[pixelIndex + 2]) / 255.0
                )
                colorCounts[color, default: 0] += 1
            }
        }

        let colorClusters = clusterColors(colorCounts: colorCounts, maxClusters: 5)
        return AnalysisResult(
            dominantColors: colorClusters,
            mostVibrantColor: findMostVibrantColor(from: colorClusters)
        )
    }

    /// Agrupa colores similares limitando el número de grupos a un máximo especificado.
    nonisolated private static func clusterColors(
        colorCounts: [PixelColor: Int],
        maxClusters: Int
    ) -> [PixelColor] {
        var clusters: [PixelColor] = []

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

    /// Ordena los colores por saturación y devuelve el más vibrante.
    nonisolated private static func findMostVibrantColor(from colors: [PixelColor]) -> PixelColor? {
        colors.max { colorSaturation(from: $0) < colorSaturation(from: $1) }
    }

    nonisolated private static func colorSaturation(from color: PixelColor) -> CGFloat {
        max(color.red, color.green, color.blue) - min(color.red, color.green, color.blue)
    }

    nonisolated private static func colorDistance(from color1: PixelColor, to color2: PixelColor) -> CGFloat {
        let dr = color1.red - color2.red
        let dg = color1.green - color2.green
        let db = color1.blue - color2.blue
        return dr * dr + dg * dg + db * db
    }

    nonisolated private static func mixColors(color1: PixelColor, color2: PixelColor) -> PixelColor {
        PixelColor(
            red: (color1.red + color2.red) / 2,
            green: (color1.green + color2.green) / 2,
            blue: (color1.blue + color2.blue) / 2
        )
    }
}
