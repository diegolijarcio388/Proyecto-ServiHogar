import SwiftUI

// MARK: - VISTA PRINCIPAL
/// Vista `ReportarIncidencia`: Permite al usuario notificar problemas ocurridos durante el servicio.
/// Contiene opciones predefinidas y un campo de texto dinámico para incidencias personalizadas.
struct ReportarIncidencia: View {
    // Variable de entorno para gestionar el retroceso a la pantalla anterior
    @Environment(\.dismiss) var dismiss
    
    // MARK: - Estados de Interfaz (Checkboxes)
    // Variables booleanas que controlan si cada opción está seleccionada (true) o no (false)
    @State private var trabajoNoCompletado = false
    @State private var malComportamiento = false
    @State private var llegoTarde = false
    @State private var danosPropiedad = false
    
    // Estados específicos para la opción "Otros" y su bloque de texto asociado
    @State private var otros = false
    @State private var otrosTexto = ""
    
    // MARK: - Cuerpo de la Vista
    var body: some View {
        ZStack {
            // 1. FONDO
            // Imagen de fondo que cubre toda la pantalla, ignorando los márgenes seguros (notch/isla dinámica)
            Image("fondo")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
            
            // 2. CONTENIDO PRINCIPAL
            // VStack principal que agrupa el header y el contenido deslizable
            VStack(spacing: 0) {
                // ==========================================
                // --- BARRA SUPERIOR UNIFICADA ---
                // ==========================================
                HStack {
                    // 1. Flecha Izquierda (Botón para retroceder)
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 40, height: 40)
                    }
                    Spacer() // Empuja los elementos a los extremos
                    
                    // 2. Iconos Derecha (Acceso a calendario y perfil decorativos)
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
                .ignoresSafeArea() // Hace que el fondo azul ocupe la parte más alta de la pantalla
                
                // ==========================================
                // --- CONTENIDO DESLIZABLE ---
                // ==========================================
                // Usamos ScrollView para que el contenido sea accesible si se abre el teclado del dispositivo
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        
                        // --- TÍTULO (con el margen que pedías) ---
                        Text("Seleccione la incidencia\ndel servicio")
                            .font(.title2.bold())
                            .foregroundColor(.figmaBlue)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 20)
                            .padding(.top, 40) // <-- Margen extra con el header
                            .padding(.bottom, 40)
                        
                        // --- LISTA DE OPCIONES ---
                        // Agrupación de todas las filas que contienen los checkboxes
                        VStack(spacing: 25) {
                            CheckboxFila(texto: "El trabajo no se completó", estaSeleccionado: $trabajoNoCompletado)
                            CheckboxFila(texto: "Mal comportamiento del profesional", estaSeleccionado: $malComportamiento)
                            CheckboxFila(texto: "El profesional llegó tarde", estaSeleccionado: $llegoTarde)
                            CheckboxFila(texto: "Daños en mi propiedad", estaSeleccionado: $danosPropiedad)
                            
                            // FILA ESPECIAL: "Otros" con bloque de texto expansible
                            VStack(alignment: .leading, spacing: 15) {
                                CheckboxFila(texto: "Otros", estaSeleccionado: $otros)
                                
                                // El bloque de texto solo se renderiza si el checkbox "otros" está marcado
                                if otros {
                                    ZStack(alignment: .topLeading) {
                                        // Fondo blanco del área de texto
                                        RoundedRectangle(cornerRadius: 15)
                                            .fill(Color.white)
                                            .frame(height: 120)
                                            .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 2)
                                        
                                        // Placeholder simulado que guía al usuario (desaparece al escribir)
                                        if otrosTexto.isEmpty {
                                            Text("Describa el problema...")
                                                .foregroundColor(Color.gray.opacity(0.5))
                                                .padding(.horizontal, 15)
                                                .padding(.top, 15)
                                        }
                                        
                                        // Área de texto multilínea nativa de SwiftUI
                                        TextEditor(text: $otrosTexto)
                                            .foregroundColor(.figmaBlue)
                                            .scrollContentBackground(.hidden) // Quita el fondo gris por defecto en iOS 16+
                                            .padding(10)
                                            .frame(height: 120)
                                    }
                                    .padding(.horizontal, 30)
                                    // Animación suave para que aparezca "deslizándose" desde la opción superior
                                    .transition(.opacity.combined(with: .move(edge: .top)))
                                }
                            }
                        }
                        
                        Spacer(minLength: 40) // Empuja el botón hacia la parte inferior
                        
                        // --- BOTÓN FINAL ---
                        // Acción a ejecutar al terminar el reporte de la incidencia
                        Button(action: {
                            print("Reporte enviado...")
                            dismiss() // Regresa a la vista anterior al terminar
                        }) {
                            Text("Reportar problema")
                                .font(.title3.bold())
                                .foregroundColor(.figmaBlue)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(Color.white)
                                .cornerRadius(25)
                                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 3)
                        }
                        .padding(.horizontal, 40)
                        .padding(.bottom, 50)
                    }
                }
            }
        }
        // Ocultamos la barra de navegación estándar de Apple para usar nuestro propio diseño (barra azul)
        .toolbar(.hidden, for: .navigationBar)
        .navigationBarBackButtonHidden(true)
    }
}

// MARK: - COMPONENTES SECUNDARIOS
// ==========================================
// COMPONENTE REUTILIZABLE PARA LOS CHECKBOXES 
// ==========================================
/// `CheckboxFila`: Un componente de fila que contiene un botón (apariencia de casilla) y un texto a la derecha.
struct CheckboxFila: View {
    // El texto que describe la opción
    var texto: String
    // @Binding permite modificar la variable de la vista principal desde este componente secundario
    @Binding var estaSeleccionado: Bool
    
    var body: some View {
        HStack(spacing: 15) {
            // Casilla interactiva
            Button(action: {
                // Al tocar, cambiamos de true a false (o viceversa) con una animación suave
                withAnimation(.easeInOut(duration: 0.2)) {
                    estaSeleccionado.toggle()
                }
            }) {
                // Diseño de la casilla (cuadrado blanco con bordes redondeados)
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color.white)
                    .frame(width: 24, height: 24)
                    .overlay(
                        // Icono del 'check' que solo se muestra si la opción está seleccionada
                        Image(systemName: "checkmark")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.figmaBlue)
                            .opacity(estaSeleccionado ? 1 : 0)
                    )
            }
            
            // Texto descriptivo de la fila
            Text(texto)
                .font(.title3)
                .foregroundColor(.figmaBlue)
                .multilineTextAlignment(.leading)
            
            Spacer() // Asegura que el contenido quede alineado a la izquierda
        }
        .padding(.horizontal, 30) // Margen lateral para alinearlo con el resto del diseño
    }
}

// MARK: - PREVIEW
#Preview {
    ReportarIncidencia()
}
