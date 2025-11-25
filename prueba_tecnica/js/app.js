/**
 * Aplicación de consulta de cotizaciones
 * Versión Simple
 */

document.addEventListener('DOMContentLoaded', function() {
    const form = document.getElementById('searchForm');
    const input = document.getElementById('quotationId');
    const btnSearch = document.getElementById('btnSearch');
    const btnText = document.getElementById('btnText');
    const spinner = document.getElementById('spinner');
    const alertBox = document.getElementById('alertBox');
    const resultSection = document.getElementById('resultSection');
    
    form.addEventListener('submit', async function(e) {
        e.preventDefault();
        
        const quotationId = input.value.trim();
        
        // Validación básica
        if (!quotationId) {
            showAlert('Por favor ingrese un ID de cotización', 'danger');
            return;
        }
        
        if (!/^\d+$/.test(quotationId)) {
            showAlert('El ID de cotización debe ser numérico', 'danger');
            return;
        }
        
        // Deshabilitar botón y mostrar spinner
        btnSearch.disabled = true;
        btnText.textContent = 'Buscando...';
        spinner.style.display = 'inline-block';
        hideAlert();
        hideResult();
        
        try {
            const formData = new FormData();
            formData.append('quotation_id', quotationId);
            
            const response = await fetch('api/buscar.php', {
                method: 'POST',
                body: formData
            });
            
            const data = await response.json();
            
            if (data.success) {
                showAlert('Cotización encontrada exitosamente', 'success');
                displayResult(data.data);
            } else {
                showAlert(data.message || 'Error al buscar la cotización', 'danger');
            }
            
        } catch (error) {
            showAlert('Error de conexión: ' + error.message, 'danger');
        } finally {
            // Rehabilitar botón
            btnSearch.disabled = false;
            btnText.textContent = 'Buscar Cotización';
            spinner.style.display = 'none';
        }
    });
    
    function showAlert(message, type) {
        alertBox.textContent = message;
        alertBox.className = `alert alert-${type} show`;
    }
    
    function hideAlert() {
        alertBox.classList.remove('show');
    }
    
    function hideResult() {
        resultSection.classList.remove('show');
    }
    
    function displayResult(data) {
        // Rellenar datos del paciente
        document.getElementById('pacienteNombre').textContent = 
            `${data.paciente.nombre} ${data.paciente.apellido}`;
        document.getElementById('pacienteTelefono').textContent = 
            data.paciente.telefono || 'No registrado';
        document.getElementById('pacienteDireccion').textContent = 
            data.paciente.direccion || 'No registrada';
        
        // Rellenar datos del profesional
        document.getElementById('profesionalNombre').textContent = 
            `${data.profesional.nombre} ${data.profesional.apellido}`;
        
        // Rellenar datos de la cita
        const fechaInicio = new Date(data.cita.fecha_inicio);
        const fechaFin = new Date(data.cita.fecha_fin);
        
        document.getElementById('citaFecha').textContent = 
            fechaInicio.toLocaleDateString('es-CO', { 
                year: 'numeric', 
                month: 'long', 
                day: 'numeric' 
            });
        document.getElementById('citaHora').textContent = 
            `${fechaInicio.toLocaleTimeString('es-CO', { hour: '2-digit', minute: '2-digit' })} - ${fechaFin.toLocaleTimeString('es-CO', { hour: '2-digit', minute: '2-digit' })}`;
        
        // Rellenar medicamento
        document.getElementById('medicamento').textContent = 
            data.medicamento || 'No especificado';
        
        // Mostrar sección de resultados
        resultSection.classList.add('show');
        
        // Scroll suave hacia resultados
        resultSection.scrollIntoView({ behavior: 'smooth', block: 'nearest' });
    }
});
