//
//  ServiceCard.swift
//  parteProyecto
//
//  Created by dam1 on 13/2/26.
//

import SwiftUI

// MARK: - COMPONENTE REUTILIZABLE
/// `ServiceCard`: Tarjeta visual que representa una categoría de servicio (ej. Fontanería, Limpieza).
/// Muestra una cabecera con imagen y un pie con el título del servicio.
struct ServiceCard: View {
    
    // MARK: - Propiedades (Parámetros)
    // Texto que aparecerá en la parte inferior de la tarjeta
    var title: String
    // Nombre del archivo de imagen (asset) que se mostrará en la parte superior
    var imageName: String
    
    // MARK: - Cuerpo de la Vista
    var body: some View {
        // ZStack para superponer capas: Fondo blanco con sombra + Contenido (Imagen y Texto)
        ZStack {
            
            // --- FONDO DE LA TARJETA ---
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white.opacity(0.95)) // Fondo blanco casi sólido
                .shadow(color: Color.black.opacity(0.1), radius: 5, y: 5) // Sombra suave para dar profundidad (efecto carta)
            
            // --- CONTENIDO DE LA TARJETA ---
            VStack(spacing: 0) { // spacing: 0 asegura que no haya huecos automáticos entre los elementos
                
                // 1. Imagen Superior
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill) // Rellena el contenedor manteniendo la proporción
                    .frame(width: 368, height: 150) // Altura fija para la foto
                    .clipped() // Recorta cualquier parte de la foto que sobresalga de estas medidas
                    // (Nota: Este modificador asume el uso de una extensión personalizada en tu proyecto
                    // para redondear únicamente las esquinas superiores)
                    .cornerRadius(20, corners: [.topLeft, .topRight])
                
                Spacer() // Empuja el texto hacia el fondo de la tarjeta
                
                // 2. Título Inferior
                Text(title)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.figmaBlue) // Color corporativo personalizado
                    .padding(.bottom, 15) // Separación para que no quede pegado al borde inferior
            }
        }
        // Tamaño total fijo del componente completo
        .frame(width: 368, height: 211)
    }
}
