SELECT
    -- paciente
    ge.nombre_user AS nombre_paciente,
    ge.apellido_user AS apellido_paciente,
    ge.dirrecion_user AS direccion_paciente,
    ge.telefono_user AS telefono_paciente,
    -- doctor
    sc.nombre AS nombre_doctor,
    sc.apellido AS apellido_doctor,
    -- medicamento
    cmom.descripcion AS descripcion_medicamento,
    -- fecha de cita
    se.init_date AS fecha_inicial,
    se.end_date AS fecha_final,
    -- hora de cita
    ssa.init_time AS hora_inicio,
    ssa.end_time AS hora_fin,
    -- id de cotizacion
    cq.com_quotation_id AS id_cotizacion
FROM com_quotation cq
-- flujo de admision
JOIN cnt_medical_order_medicament cmom
    ON cmom.id_cnt_medical_order_medicament = cq.id_medical_order_medicament
JOIN cnt_medical_order cmo
    ON cmo.cnt_medical_order_id = cmom.id_cnt_medical_order
JOIN adm_admission_flow aaf
    ON aaf.adm_admission_flow_id = cmo.id_adm_admission_flow
JOIN adm_admission aa
    ON aa.adm_admission_id = aaf.id_adm_admission
-- atencion a paciente 
JOIN adm_admission_appointment aaa
    ON aaa.id_adm_admission = aa.adm_admission_id
JOIN sch_workflow_slot_assigned swsa 
    ON swsa.flow_id = aaa.id_flow
JOIN sch_slot_assigned ssa 
    ON ssa.sch_slot_assigned_id = swsa.sch_slot_assigned_id
JOIN gbl_entity ge
    ON ge.gbl_entity_id = ssa.id_gbl_entity
-- cita
JOIN sch_slot ss
    ON ss.sch_slot_id = ssa.id_sch_slot
JOIN sch_event se
    ON se.sch_event_id = ss.id_sch_event
-- doctor
JOIN sch_calendar sc
    ON sc.sch_calendar_id = se.id_sch_calendar
-- Validacion
WHERE cq.com_quotation_id = :id_quotation;
