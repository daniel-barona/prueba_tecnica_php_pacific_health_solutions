<?php
/**
 * API para buscar cotizaciones
 * Versión simple - Solo consulta
 */
 
require_once __DIR__ . '/../config/database.php';
 
// Headers de seguridad
header('Content-Type: application/json; charset=utf-8');
header('X-Content-Type-Options: nosniff');
header('X-Frame-Options: DENY');
header('X-XSS-Protection: 1; mode=block');
 
// Validar método POST
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode([
        'success' => false,
        'message' => 'Método no permitido'
    ]);
    exit;
}
 
// Obtener y sanitizar ID de cotización
$quotationId = isset($_POST['quotation_id']) ? trim($_POST['quotation_id']) : '';
 
// Validaciones
if (empty($quotationId)) {
    http_response_code(400);
    echo json_encode([
        'success' => false,
        'message' => 'El ID de cotización es requerido'
    ]);
    exit;
}
 
if (!is_numeric($quotationId)) {
    http_response_code(400);
    echo json_encode([
        'success' => false,
        'message' => 'El ID de cotización debe ser numérico'
    ]);
    exit;
}
 
try {
    $db = Database::getInstance();
    $conn = $db->getConnection();
   
    // Consulta con el esquema real de phs_tecnica
    $sql = "SELECT
                cq.com_quotation_id AS id_cotizacion,
                ge.nombre_user AS nombre_paciente,
                ge.apellido_user AS apellido_paciente,
                ge.telefono_user AS telefono_paciente,
                ge.dirrecion_user AS direccion_paciente,
                sc.nombre AS nombre_doctor,
                sc.apellido AS apellido_doctor,
                cmom.descripcion AS descripcion_medicamento,
                se.init_date AS fecha_hora_inicio,
                se.end_date AS fecha_hora_fin
            FROM com_quotation cq
            LEFT JOIN gbl_entity ge ON cq.id_gbl_entity = ge.gbl_entity_id
            LEFT JOIN sch_calendar sc ON cq.id_sch_calendar = sc.sch_calendar_id
            LEFT JOIN sch_event se ON cq.id_sch_event = se.sch_event_id
            LEFT JOIN cnt_medical_order_medicament cmom ON cq.id_medical_order_medicament = cmom.cnt_medical_order_medicament_id
            WHERE cq.com_quotation_id = :id_quotation";
   
    $stmt = $conn->prepare($sql);
    $stmt->bindParam(':id_quotation', $quotationId, PDO::PARAM_INT);
    $stmt->execute();
   
    $result = $stmt->fetch(PDO::FETCH_ASSOC);
   
    if (empty($result)) {
        http_response_code(404);
        echo json_encode([
            'success' => false,
            'message' => 'No se encontró información para el ID de cotización ingresado.'
        ], JSON_UNESCAPED_UNICODE);
        exit;
    }
   
    // Respuesta estructurada
    $response = [
        'id' => $result['id_cotizacion'],
        'paciente' => [
            'nombre' => $result['nombre_paciente'],
            'apellido' => $result['apellido_paciente'],
            'telefono' => $result['telefono_paciente'],
            'direccion' => $result['direccion_paciente']
        ],
        'profesional' => [
            'nombre' => $result['nombre_doctor'],
            'apellido' => $result['apellido_doctor']
        ],
        'cita' => [
            'fecha_inicio' => $result['fecha_hora_inicio'],
            'fecha_fin' => $result['fecha_hora_fin']
        ],
        'medicamento' => $result['descripcion_medicamento']
    ];
   
    http_response_code(200);
    echo json_encode([
        'success' => true,
        'data' => $response
    ], JSON_UNESCAPED_UNICODE);
   
} catch(PDOException $e) {
    http_response_code(500);
    echo json_encode([
        'success' => false,
        'message' => 'Error al consultar la base de datos: ' . $e->getMessage()
    ], JSON_UNESCAPED_UNICODE);
}
?>