import SwiftUI

// MARK: - VISTA PRINCIPAL
/// Vista `DescribirProblema`: Permite al usuario detallar una incidencia o solicitud,
/// escribiendo un texto y adjuntando opcionalmente una fotografía desde la cámara o galería.
struct DescribirProblema: View {
    // Texto introducido por el usuario para describir el problema
    @State private var issueDescription: String = ""
    // Variable de entorno para cerrar esta vista y volver atrás
    @Environment(\.dismiss) var dismiss
    
    // MARK: - Variables para Cámara y Galería
    // Controlan cuándo se muestran las pantallas modales (sheets) de cámara o galería
    @State private var showCamera = false
    @State private var showGallery = false
    // Almacena la imagen seleccionada o capturada. Si es 'nil', no hay foto.
    @State private var capturedImage: UIImage? = nil
    
    // MARK: - Cuerpo de la Vista
    var body: some View {
        // Envolvemos todo en NavigationStack para habilitar la navegación a la siguiente pantalla
        NavigationStack {
            ZStack {
                // --- FONDO COMPLETO ---
                // Imagen de fondo que ocupa toda la pantalla ignorando los bordes seguros
                Image("fondo")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    
                    // ==========================================
                    // --- BARRA SUPERIOR UNIFICADA ---
                    // ==========================================
                                HStack {
                                    // 1. Flecha Izquierda (Botón para volver atrás)
                                    Button(action: { dismiss() }) {
                                        Image(systemName: "chevron.left")
                                            .font(.system(size: 22, weight: .bold))
                                            .foregroundColor(.white)
                                            .frame(width: 40, height: 40)
                                    }
                                    
                                    Spacer() // Empuja los elementos a los extremos
                                    
                                    // 2. Iconos Derecha (Decorativos: Calendario y Perfil)
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
                                .padding(.top, 80)
                                .padding(.bottom, 5)
                                .frame(maxWidth: .infinity)
                                .background(Color.figmaLightBlue)
                                .ignoresSafeArea() // El fondo azul sube hasta el notch/isla
                    
                    // --- CONTENIDO ---
                    VStack(spacing: 20) {
                        Spacer().frame(height: 20)
                        
                        // Título de la sección con un icono
                        HStack(spacing: 10) {
                            Image(systemName: "bubble.left.fill")
                                .font(.title3)
                            Text("¿Qué ocurre?")
                                .font(.title2)
                                .bold()
                        }
                        .foregroundColor(Color.figmaBlue)
                        
                        // --- CAJA DE TEXTO BLANCA ---
                        // Contenedor principal de la caja de descripción y adjuntos
                        VStack(alignment: .leading) {
                            ZStack(alignment: .topLeading) {
                                // Placeholder simulado: solo se muestra si el texto está vacío
                                if issueDescription.isEmpty {
                                    Text("Describa el problema")
                                        .foregroundColor(.gray.opacity(0.6))
                                        .padding(.top, 8)
                                        .padding(.leading, 5)
                                }
                                
                                // Área de texto real donde escribe el usuario
                                TextEditor(text: $issueDescription)
                                    .frame(height: 150)
                                    .scrollContentBackground(.hidden) // Quita el fondo gris por defecto
                            }
                            
                            // ==================================================
                            // === NUEVO: MUESTRA LA FOTO CON BOTÓN DE BORRAR ===
                            // ==================================================
                            // Si 'capturedImage' tiene una foto, renderizamos este bloque
                            if let image = capturedImage {
                                ZStack(alignment: .topTrailing) { // Alineamos la X arriba a la derecha
                                    // Muestra la imagen seleccionada
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(height: 80)
                                        .cornerRadius(8)
                                        .clipped() // Evita que la foto se salga de sus bordes redondeados
                                    
                                    // Botón "X" para borrar la imagen
                                    Button(action: {
                                        // Al pulsar, vaciamos la variable y la foto desaparece instantáneamente
                                        capturedImage = nil
                                    }) {
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundColor(.red)
                                            .background(Color.white.clipShape(Circle())) // Fondo blanco para que resalte la X
                                            .offset(x: 5, y: -5) // La sacamos un pelín de la esquina para mejor estética
                                    }
                                }
                                .padding(.bottom, 10)
                                .padding(.trailing, 5) // Dejamos sitio para la X
                            }
                            // ==================================================
                            
                            // --- ICONOS INFERIORES ---
                            // Botones para abrir los selectores de imágenes
                            HStack(spacing: 20) {
                                // BOTÓN CLIP (Abre la galería de fotos)
                                Button(action: {
                                    showGallery = true
                                }) {
                                    Image(systemName: "paperclip")
                                }
                                
                                // BOTÓN CÁMARA (Abre la cámara)
                                Button(action: {
                                    showCamera = true
                                }) {
                                    Image(systemName: "camera.fill")
                                }
                            }
                            .font(.title3)
                            .foregroundColor(Color.figmaBlue)
                        }
                        // Estilos de la caja blanca principal
                        .padding(15)
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                        .padding(.horizontal, 25)
                        
                        Spacer().frame(height: 40)
                        
                        // --- BOTÓN SOLICITAR ---
                        // Navega a la siguiente pantalla (SeleccionarProfesional)
                        NavigationLink(destination: SeleccionarProfesional()) {
                            Text("Solicitar Servicio")
                            .font(.headline)
                            .bold()
                            .foregroundColor(Color.figmaBlue)
                            .padding(.vertical, 16)
                            .padding(.horizontal, 45)
                            .background(Color.white)
                            .clipShape(Capsule())
                            .shadow(color: .black.opacity(0.15), radius: 5, x: 0, y: 3)
                            }
                        
                        Spacer()
                    }
                }
            }
        }
        // Oculta la barra de navegación nativa para usar nuestro header personalizado
        .navigationBarBackButtonHidden(true)
        
        // MARK: - Modales de Selección de Imagen (Sheets)
        
        // SHEET DE LA CÁMARA
        // Verifica si la cámara está disponible (para no crashear en el Simulador de Mac)
        .sheet(isPresented: $showCamera) {
            ImagePicker(selectedImage: $capturedImage, sourceType: UIImagePickerController.isSourceTypeAvailable(.camera) ? .camera : .photoLibrary)
        }
        
        // SHEET DE LA GALERÍA
        // Abre directamente la librería de fotos
        .sheet(isPresented: $showGallery) {
            ImagePicker(selectedImage: $capturedImage, sourceType: .photoLibrary)
        }
    }
}

// MARK: - PREVIEW
#Preview {
    DescribirProblema()
}
