import SwiftUI

// MARK: - VISTA PRINCIPAL
/// Vista `ValorarTrabajador`: Permite al usuario calificar el servicio recibido mediante un sistema
/// de estrellas interactivas y dejar un comentario detallado con opciones para adjuntar archivos.
struct ValorarTrabajador: View {
    // Variable de entorno para cerrar la vista actual y volver a la anterior
    @Environment(\.dismiss) var dismiss
    
    // MARK: - Datos Recibidos
    // Variables que idealmente se inyectan desde la pantalla anterior (ej. lista de servicios)
    var workerName: String = "Marcos L."
    var workerImage: String = "hombre3"
    
    // MARK: - Estados de Interfaz
    // Almacenan la interacción del usuario en tiempo real
    @State private var rating: Int = 0 // Guarda el número de estrellas (0 a 5)
    @State private var comentario: String = "" // Guarda el texto escrito por el usuario
    
    // MARK: - Cuerpo de la Vista
    var body: some View {
        ZStack {
            // 1. FONDO
            // Imagen de fondo corporativa que cubre toda la pantalla
            Image("fondo")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
            
            // 2. CONTENIDO PRINCIPAL
            VStack(spacing: 0) {
                // ==========================================
                // --- BARRA SUPERIOR (HEADER) ---
                // ==========================================
                HStack {
                    // Botón de atrás (cierra la pantalla actual)
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 40, height: 40)
                    }
                    
                    Spacer() // Empuja los iconos hacia los extremos
                    
                    // Iconos decorativos a la derecha (Calendario y Perfil)
                    HStack(spacing: 20) {
                        Image(systemName: "calendar")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(.figmaBlue)
                            .scaledToFit()
                            .frame(width: 28, height: 28)
                        
                        Image(systemName: "person.circle")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(.figmaBlue)
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                    }
                }
                .padding(.horizontal, 25)
                .padding(.top, 80)     // Margen superior idéntico a tu primera pantalla
                .padding(.bottom, 10)
                .frame(maxWidth: .infinity)
                .background(Color.figmaLightBlue) // Tu color azul clarito unificado
                
                // ==========================================
                // --- CONTENIDO DESLIZABLE ---
                // ==========================================
                // Permite hacer scroll, vital para cuando el teclado tapa la pantalla al escribir
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 30) {
                        
                        // --- Título de la sección ---
                        Text("Comenta Tu Experiencia")
                            .font(.title2.bold())
                            .foregroundColor(.figmaBlue)
                            .padding(.top, 30)
                        
                        // --- PERFIL DEL TRABAJADOR Y ESTRELLAS ---
                        VStack(spacing: 15) {
                            // Foto de perfil circular con sombra
                            Image(workerImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 90, height: 90)
                                .clipShape(Circle())
                                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 3)
                            
                            // Nombre del trabajador
                            Text(workerName)
                                .font(.title3.bold())
                                .foregroundColor(.figmaBlue)
                            
                            //  ESTRELLAS INTERACTIVAS 
                            HStack(spacing: 8) {
                                // Bucle para crear 5 estrellas
                                ForEach(1...5, id: \.self) { index in
                                    // Pinta la estrella de azul ("fill") si el índice es menor o igual al rating actual
                                    Image(systemName: index <= rating ? "star.fill" : "star")
                                        .font(.title)
                                        .foregroundColor(.figmaBlue)
                                        .onTapGesture {
                                            // Actualiza la puntuación con una animación suave al tocar
                                            withAnimation(.easeInOut(duration: 0.2)) {
                                                rating = index
                                            }
                                        }
                                }
                            }
                        }
                        
                        // ==========================================
                        // --- BLOQUE DE COMENTARIO ESTILO CAJA ---
                        // ==========================================
                        VStack(spacing: 15) {
                            Text("¿Quieres añadir un comentario?")
                                .font(.headline)
                                .foregroundColor(.figmaBlue)
                            
                            // Caja blanca grande que agrupa el texto y los iconos adjuntos
                            VStack(alignment: .leading) {
                                // Campo de texto multilínea (axis: .vertical permite que crezca hacia abajo)
                                TextField("Cuéntanos tu experiencia...", text: $comentario, axis: .vertical)
                                    .lineLimit(5...8) // Permite expandirse entre 5 y 8 líneas visibles
                                    .padding(.horizontal, 15)
                                    .padding(.top, 15)
                                    .foregroundColor(.figmaBlue)
                                
                                Spacer() // Empuja los botones hacia la parte inferior de la caja
                                
                                // Iconos inferiores de acción (Clip y Cámara)
                                HStack(spacing: 15) {
                                    Button(action: {
                                        // Acción futura: abrir selector de archivos
                                    }) {
                                        Image(systemName: "paperclip")
                                            .font(.system(size: 20))
                                            .foregroundColor(.figmaBlue)
                                    }
                                    
                                    Button(action: {
                                        // Acción futura: abrir la cámara
                                    }) {
                                        Image(systemName: "camera.fill")
                                            .font(.system(size: 20))
                                            .foregroundColor(.figmaBlue)
                                    }
                                    Spacer() // Empuja los iconos hacia la izquierda
                                }
                                .padding(.horizontal, 15)
                                .padding(.bottom, 15)
                            }
                            .frame(minHeight: 150) // Altura mínima garantizada de la caja
                            .background(Color.white)
                            .cornerRadius(15)
                            .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 3)
                            .padding(.horizontal, 25)
                        }
                        .padding(.top, 0)
                        
                        // --- BOTÓN ENVIAR RESEÑA ---
                        Button(action: {
                            // Imprime en consola para testeo y cierra la pantalla
                            print("Enviada reseña de \(rating) estrellas. Texto: \(comentario)")
                            dismiss()
                        }) {
                            Text("Enviar reseña")
                                .font(.headline.bold())
                                .foregroundColor(.figmaBlue)
                                .padding(.horizontal, 40)
                                .padding(.vertical, 15)
                                .background(Color.white)
                                .clipShape(Capsule())
                                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 3)
                        }
                        .padding(.top, 30)
                        // Lógica de validación: El botón se ve semi-transparente y no se puede pulsar si hay 0 estrellas
                        .opacity(rating == 0 ? 0.5 : 1.0)
                        .disabled(rating == 0)
                        
                    }
                    .padding(.bottom, 40)
                }
            }
        }
        // Oculta el botón "Back" nativo de iOS para que solo se use nuestro botón del header
        .navigationBarBackButtonHidden(true)
    }
}

// MARK: - PREVIEW
#Preview {
    ValorarTrabajador()
}
