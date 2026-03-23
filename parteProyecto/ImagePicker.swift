//
//  ImagePicker.swift
//  parteProyecto
//
//  Created by dam1 on 19/2/26.
//

import SwiftUI
import UIKit

// MARK: - COMPONENTE PUENTE (SwiftUI <-> UIKit)
/// `ImagePicker`: Es un envoltorio (wrapper) que permite usar `UIImagePickerController` de UIKit
/// dentro de una vista moderna de SwiftUI. Adopta el protocolo `UIViewControllerRepresentable`.
struct ImagePicker: UIViewControllerRepresentable {
    
    // MARK: - Variables de Control
    // Enlace bidireccional (Binding) con la vista padre. Lo que se asigne aquí, aparecerá en la otra vista.
    @Binding var selectedImage: UIImage?
    
    // Determina si abrimos la cámara de fotos o el carrete/galería de imágenes.
    var sourceType: UIImagePickerController.SourceType // <-- NUEVO: Para elegir entre Cámara o Galería
    
    // Variable de entorno que nos permite cerrar esta pantalla modal programáticamente.
    @Environment(\.presentationMode) private var presentationMode

    // MARK: - Métodos de Ciclo de Vida del Representable
    
    /// 1. Crea y configura el controlador de UIKit.
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        // Asignamos el Coordinador como el "delegado" que escuchará los eventos (ej. cuando se toma la foto)
        picker.delegate = context.coordinator
        picker.sourceType = sourceType // <-- Le pasamos el modo que elijamos
        return picker
    }

    /// 2. Actualiza el controlador de UIKit si hay cambios en SwiftUI (En este caso no lo necesitamos)
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    /// 3. Crea el Coordinador, que es la clase que hace de traductor entre los eventos de UIKit y nuestra vista SwiftUI.
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    // MARK: - COORDINADOR (Delegado)
    /// Clase encargada de recibir las respuestas del `UIImagePickerController` (cuando el usuario elige foto o cancela).
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        // Referencia a nuestro struct principal de SwiftUI para poder enviarle los datos de vuelta
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        // MARK: Eventos del Delegado
        
        /// Se llama cuando el usuario ha seleccionado una imagen o tomado una foto.
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            // Buscamos la imagen original dentro del diccionario de información que nos devuelve Apple
            if let image = info[.originalImage] as? UIImage {
                // Se la pasamos a la variable Binding, lo que actualizará automáticamente la vista padre
                parent.selectedImage = image
            }
            // Por último, cerramos el selector de imágenes
            parent.presentationMode.wrappedValue.dismiss()
        }

        /// Se llama cuando el usuario pulsa el botón de "Cancelar" sin elegir ninguna foto.
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            // Simplemente cerramos la pantalla modal
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
