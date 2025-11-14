import SwiftUI
import UIKit

/// Helper para verificar que las fuentes custom están instaladas correctamente
struct FontDebugger {
    
    /// Imprime todas las familias de fuentes disponibles en el sistema
    static func printAllFontFamilies() {
        print("========================================")
        print("🔤 TODAS LAS FAMILIAS DE FUENTES")
        print("========================================")
        
        for family in UIFont.familyNames.sorted() {
            print("\n📦 Familia: \(family)")
            let names = UIFont.fontNames(forFamilyName: family)
            for name in names {
                print("   → \(name)")
            }
        }
        print("\n========================================")
    }
    
    /// Verifica si Manrope está instalada y muestra todos los pesos disponibles
    static func checkManropeInstallation() {
        print("========================================")
        print("🔍 VERIFICACIÓN DE MANROPE")
        print("========================================")
        
        let manropeFonts = UIFont.fontNames(forFamilyName: "Manrope")
        
        if manropeFonts.isEmpty {
            print("❌ ERROR: Manrope NO está instalada")
            print("Verifica que:")
            print("  1. Los archivos .ttf están en el proyecto")
            print("  2. Los archivos tienen Target Membership")
            print("  3. Info.plist tiene la key UIAppFonts")
            print("  4. Los nombres en Info.plist coinciden con los archivos")
        } else {
            print("✅ Manrope está instalada correctamente!")
            print("\nPesos disponibles:")
            for fontName in manropeFonts.sorted() {
                print("  → \(fontName)")
            }
        }
        
        print("\n========================================")
    }
    
    /// Verifica si un peso específico de Manrope funciona
    static func testManropeWeight(_ weightName: String, size: CGFloat = 20) -> Bool {
        let font = UIFont(name: weightName, size: size)
        if let font = font {
            print("✅ \(weightName) funciona correctamente")
            print("   Font Family: \(font.familyName)")
            print("   Font Name: \(font.fontName)")
            return true
        } else {
            print("❌ \(weightName) NO se pudo cargar")
            return false
        }
    }
    
    /// Prueba todos los pesos de Manrope que esperas tener
    static func testAllManropeWeights() {
        print("========================================")
        print("🧪 PRUEBA DE TODOS LOS PESOS")
        print("========================================\n")
        
        let expectedWeights = [
            "Manrope-ExtraLight",
            "Manrope-Light",
            "Manrope-Regular",
            "Manrope-Medium",
            "Manrope-SemiBold",
            "Manrope-Bold",
            "Manrope-ExtraBold"
        ]
        
        var successCount = 0
        
        for weight in expectedWeights {
            if testManropeWeight(weight) {
                successCount += 1
            }
            print("")
        }
        
        print("========================================")
        print("Resultado: \(successCount)/\(expectedWeights.count) pesos funcionan")
        print("========================================")
    }
}

// MARK: - SwiftUI Preview Helper

struct FontDebugView: View {
    @State private var showConsole = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Text("Font Debugger")
                    .font(.system(size: 30, weight: .bold))
                    .padding(.top, 40)
                
                Divider()
                
                // Test con fuente del sistema
                VStack(alignment: .leading, spacing: 8) {
                    Text("San Francisco (Sistema)")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.gray)
                    
                    Group {
                        Text("Ultralight").font(.system(size: 24, weight: .ultraLight))
                        Text("Light").font(.system(size: 24, weight: .light))
                        Text("Regular").font(.system(size: 24, weight: .regular))
                        Text("Medium").font(.system(size: 24, weight: .medium))
                        Text("Semibold").font(.system(size: 24, weight: .semibold))
                        Text("Bold").font(.system(size: 24, weight: .bold))
                        Text("Black").font(.system(size: 24, weight: .black))
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
                
                Divider()
                
                // Test con Manrope
                VStack(alignment: .leading, spacing: 8) {
                    Text("Manrope (Custom)")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.blue)
                    
                    Group {
                        Text("ExtraLight")
                            .font(.custom("Manrope-ExtraLight", size: 24))
                        Text("Light")
                            .font(.custom("Manrope-Light", size: 24))
                        Text("Regular")
                            .font(.custom("Manrope-Regular", size: 24))
                        Text("Medium")
                            .font(.custom("Manrope-Medium", size: 24))
                        Text("SemiBold")
                            .font(.custom("Manrope-SemiBold", size: 24))
                        Text("Bold")
                            .font(.custom("Manrope-Bold", size: 24))
                        Text("ExtraBold")
                            .font(.custom("Manrope-ExtraBold", size: 24))
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color.blue.opacity(0.1))
                .cornerRadius(12)
                
                Divider()
                
                // Botones de debug
                VStack(spacing: 16) {
                    Button("🔍 Verificar Instalación de Manrope") {
                        FontDebugger.checkManropeInstallation()
                        showConsole = true
                    }
                    .buttonStyle(.bordered)
                    
                    Button("🧪 Probar Todos los Pesos") {
                        FontDebugger.testAllManropeWeights()
                        showConsole = true
                    }
                    .buttonStyle(.borderedProminent)
                    
                    Button("📦 Ver Todas las Fuentes del Sistema") {
                        FontDebugger.printAllFontFamilies()
                        showConsole = true
                    }
                    .buttonStyle(.bordered)
                    
                    if showConsole {
                        Text("✅ Revisa la consola de Xcode para ver los resultados")
                            .font(.caption)
                            .foregroundColor(.green)
                            .padding(.top, 8)
                    }
                }
                .padding(.vertical, 20)
                
                Text("Instrucciones:\n1. Corre esta preview\n2. Toca los botones\n3. Revisa la consola de Xcode\n4. Compara SF vs Manrope arriba")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding()
            }
            .padding(.horizontal, 24)
        }
        .onAppear {
            // Auto-check on appear
            FontDebugger.checkManropeInstallation()
        }
    }
}

#Preview {
    FontDebugView()
}

