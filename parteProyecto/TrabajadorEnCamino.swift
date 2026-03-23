import SwiftUI

// MARK: - VISTA PRINCIPAL
/// Vista `TrabajadorEnCamino`: Pantalla de seguimiento que muestra la ubicación del trabajador asignado,
/// sus datos de contacto y opciones para gestionar (finalizar, cancelar, reportar o reprogramar) el servicio.
struct TrabajadorEnCamino: View {
    // Variable de entorno para gestionar el botón de retroceso nativo
    @Environment(\.dismiss) var dismiss
    
    // MARK: - Estado de la Interfaz (Popup)
    // Controla la visibilidad de la alerta modal para cancelar el trabajo
    @State private var mostrarAlertaCancelar = false
    // Activa la navegación programática hacia la pantalla de inicio al confirmar cancelación
    @State private var navegarInicio = false
    
    // MARK: - Datos del Trabajador (Parámetros)
    // Estos valores deberían inyectarse desde la vista anterior (ej. SeleccionarProfesional)
    var workerName: String = "Marcos L."
    var workerImage: String = "hombre3" // Asegúrate de que la foto de tus Assets tenga buena calidad
    var workerRating: Int = 5 // 🔥 Modifica esto para probar la lógica de estrellas (ej. 4 o 5)
    
    // MARK: - Cuerpo de la Vista
    var body: some View {
        ZStack {
            // ==========================================
            // --- 1. FONDO COMPLETO ---
            // ==========================================
            Image("fondo")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
            
            // ==========================================
            // --- 2. ESTRUCTURA PRINCIPAL ---
            // ==========================================
            VStack(spacing: 0) {
                
                // --- BARRA SUPERIOR (HEADER) AZUL CLARO ---
                HStack {
                    // Botón de atrás
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 40, height: 40)
                    }
                    
                    Spacer()
                    
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
                .padding(.top, 80)      // Margen superior idéntico a tu primera pantalla para consistencia
                .padding(.bottom, 10)
                .frame(maxWidth: .infinity)
                .background(Color.figmaLightBlue) // Tu color corporativo azul clarito
                
                // --- CONTENIDO CENTRAL DESLIZABLE ---
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        
                        // Título principal dinámico
                        Text("\(workerName) en camino")
                            .font(.title2.bold())
                            .foregroundColor(.figmaBlue)
                            .padding(.top, 20)
                        
                        // Subtítulo de ubicación
                        HStack {
                            Image(systemName: "mappin.and.ellipse")
                            Text("Ubicación en Tiempo Real")
                        }
                        .font(.headline)
                        .foregroundColor(.figmaBlue)
                        
                        // IMAGEN DEL MAPA
                        Image("mapa") // Cambia por el nombre de tu activo de mapa real
                            .resizable()
                            .scaledToFill()
                            .frame(height: 200)
                            .cornerRadius(15)
                            .padding(.horizontal, 20)
                            .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 3)
                        
                        // ==========================================
                        // --- TARJETA DEL TRABAJADOR ---
                        // ==========================================
                        HStack {
                            // Foto de perfil
                            Image(workerImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 60, height: 60)
                                .clipShape(Circle())
                            
                            // Info del trabajador
                            VStack(alignment: .leading, spacing: 4) {
                                Text(workerName)
                                    .font(.headline)
                                    .foregroundColor(.figmaBlue)
                                
                                HStack {
                                    Text("Puntuación media")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                    
                                    // 🔥 LÓGICA DE ESTRELLAS INTELIGENTES 🔥
                                    HStack(spacing: 2) {
                                        // Filtro: Fuerza visualmente a que el rating esté siempre entre 4 y 5
                                        let ratingFijo = max(4, min(workerRating, 5))
                                        
                                        // Estrellas conseguidas (Rellenas de azul)
                                        ForEach(0..<ratingFijo, id: \.self) { _ in
                                            Image(systemName: "star.fill")
                                                .font(.caption)
                                                .foregroundColor(.figmaBlue)
                                        }
                                        
                                        // Estrellas restantes hasta 5 (Vacías/Grises)
                                        if ratingFijo < 5 {
                                            ForEach(0..<(5 - ratingFijo), id: \.self) { _ in
                                                Image(systemName: "star")
                                                    .font(.caption)
                                                    .foregroundColor(.gray.opacity(0.5))
                                            }
                                        }
                                    }
                                }
                            }
                            Spacer() // Empuja los botones a la derecha
                            
                            // 🔥 BOTONES DE CONTACTO FUNCIONALES 🔥
                            // Llamada telefónica nativa (tel://)
                            Button(action: {
                                if let phoneURL = URL(string: "tel://600123456") {
                                    UIApplication.shared.open(phoneURL)
                                }
                            }) {
                                Image(systemName: "phone.fill")
                                    .font(.title3)
                                    .foregroundColor(.figmaBlue)
                                    .padding(.trailing, 10)
                            }
                            
                            // Envío de SMS nativo (sms://)
                            Button(action: {
                                if let smsURL = URL(string: "sms://600123456") {
                                    UIApplication.shared.open(smsURL)
                                }
                            }) {
                                Image(systemName: "message.fill")
                                    .font(.title3)
                                    .foregroundColor(.figmaBlue)
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(15)
                        .padding(.horizontal, 20)
                        
                        // ==========================================
                        // --- BOTONES DE ACCIÓN (GESTIÓN DEL SERVICIO) ---
                        // ==========================================
                        VStack(spacing: 15) {
                            
                            // 1. Finalizado con Éxito (Navega a la pantalla de valoración)
                            NavigationLink(destination: ValorarTrabajador(workerName: workerName, workerImage: workerImage)) {
                                Text("Finalizado con éxito")
                                    .font(.headline)
                                    .foregroundColor(.figmaBlue)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 15)
                                    .background(Color.white)
                                    .cornerRadius(25)
                                    .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 3)
                            }
                            
                            // 2. Cancelar Trabajo (Abre el popup de confirmación)
                            Button(action: {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    mostrarAlertaCancelar = true
                                }
                            }) {
                                Text("Cancelar trabajo")
                                    .font(.headline)
                                    .foregroundColor(.figmaBlue)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 15)
                                    .background(Color.white)
                                    .cornerRadius(25)
                                    .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 3)
                            }
                            // 👇 TRUCO TÉCNICO: Anclamos una navegación oculta al fondo del botón.
                            // Esto permite activar la navegación desde el popup (usando la variable $navegarInicio)
                            // sin necesidad de añadir elementos visuales extra en la interfaz.
                            .background(
                                NavigationLink(destination: ContentView(), isActive: $navegarInicio) {
                                    EmptyView()
                                }
                                .hidden()
                            )
                            
                            // 3. Reportar Problema (Navega al formulario de incidencias)
                            NavigationLink(destination: ReportarIncidencia()) {
                                Text("Reportar problema")
                                    .font(.headline)
                                    .foregroundColor(.figmaBlue)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 15)
                                    .background(Color.white)
                                    .cornerRadius(25)
                                    .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 3)
                            }
                            
                            // 4. Programar Otra Cita (Vuelve al flujo de selección de fecha/hora)
                            NavigationLink(destination: TipoServicioView()) {
                                Text("Programar otra cita")
                                    .font(.headline)
                                    .foregroundColor(.figmaBlue)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 15)
                                    .background(Color.white)
                                    .cornerRadius(25)
                                    .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 3)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 10)
                        
                    }
                    .padding(.bottom, 40)
                }
            }
            
            // ==========================================
            // 🔥 POPUP MODAL: CANCELAR TRABAJO 🔥
            // ==========================================
            // Se renderiza por encima de toda la vista (ZStack)
            if mostrarAlertaCancelar {
                ZStack {
                    // Fondo oscuro semitransparente (overlay)
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                        .onTapGesture {
                            // Permite cerrar la alerta tocando fuera de la tarjeta blanca
                            withAnimation { mostrarAlertaCancelar = false }
                        }
                    
                    // Tarjeta blanca central con el diálogo
                    VStack(spacing: 30) {
                        Text("¿Estás seguro de que quieres cancelar el trabajo?")
                            .font(.title2.bold())
                            .foregroundColor(.figmaBlue)
                            .multilineTextAlignment(.center) // Asegura que se vea bien en dos líneas
                        
                        HStack(spacing: 15) {
                            
                            // Botón de Confirmación (Aceptar)
                            Button(action: {
                                withAnimation { mostrarAlertaCancelar = false }
                                navegarInicio = true // Dispara el NavigationLink oculto para volver a ContentView
                            }) {
                                Text("Aceptar")
                                    .font(.headline)
                                    .foregroundColor(.white) // Invertido para destacar
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 50)
                                    .background(Color.figmaBlue)
                                    .clipShape(Capsule())
                                    .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 3)
                            }
                            
                            // Botón de Rechazo (Cancelar)
                            Button(action: {
                                withAnimation { mostrarAlertaCancelar = false } // Solo cierra el popup
                            }) {
                                Text("Cancelar")
                                    .font(.headline)
                                    .foregroundColor(.figmaBlue)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 50)
                                    .background(Color.white)
                                    .clipShape(Capsule())
                                    .overlay(
                                        // Añade un contorno (borde) azul para diferenciarlo del fondo blanco general
                                        Capsule()
                                            .stroke(Color.figmaBlue, lineWidth: 1)
                                    )
                                    .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 3)
                            }
                        }
                    }
                    .padding(.horizontal, 25)
                    .padding(.vertical, 35)
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
                    .padding(.horizontal, 40) // Margen de respiro respecto a los bordes de la pantalla
                }
                .zIndex(100) // Z-Index alto asegura que la alerta se dibuje siempre por encima de mapas e imágenes
            }
        }
        // Ocultamos la barra de navegación nativa de iOS para usar nuestro propio diseño (Header)
        .toolbar(.hidden, for: .navigationBar)
        .navigationBarBackButtonHidden(true)
    }
}

// MARK: - COMPONENTES AUXILIARES
/// `BotonAccionBlanco`: Componente de diseño para botones genéricos sin lógica especial anidada.
/// (Nota: Mantenlo si planeas refactorizar la vista para usarlo más adelante).
struct BotonAccionBlanco: View {
    var texto: String
    var body: some View {
        Button(action: {}) {
            Text(texto)
                .font(.headline)
                .foregroundColor(.figmaBlue)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 15)
                .background(Color.white)
                .cornerRadius(25)
                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 3)
        }
    }
}

// MARK: - PREVIEW
#Preview {
    TrabajadorEnCamino(workerName: "Marcos L.", workerImage: "hombre3", workerRating: 4)
}
