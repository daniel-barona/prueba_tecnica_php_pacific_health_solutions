/* CREAR BASE DE DATOS*/
CREATE DATABASE phs_tecnica;
/* CONECTAR A LA BASE DE DATOS*/
\c phs_tecnica;
/* CREAR TABLAS*/
# sch_calendar
create table sch_calendar (
    sch_calendar_id SERIAL PRIMARY KEY, 
    nombre VARCHAR(100),
    apellido VARCHAR(100));
#gbl_entity
create table gbl_entity (
    gbl_entity_id SERIAL PRIMARY KEY, 
    nombre_user VARCHAR(100),
    apellido_user VARCHAR(100),
    dirrecion_user VARCHAR(150),
    telefono_user VARCHAR(15),
    id_sch_calendar int references sch_calendar(sch_calendar_id));
#sch_event
create table sch_event (
    sch_event_id SERIAL PRIMARY KEY,
    init_date TIMESTAMP NOT NULL,
    end_date TIMESTAMP NOT NULL,
    CONSTRAINT chk_fechas CHECK (end_date > init_date),
    id_sch_calendar int references sch_calendar(sch_calendar_id)
);
#sch_slot
create table sch_slot (
    sch_slot_id SERIAL PRIMARY KEY,
    id_sch_event int references sch_event(sch_event_id)
);
#sch_slot_assigned
create table sch_slot_assigned (
    sch_slot_assigned_id SERIAL PRIMARY KEY,
    id_gbl_entity int references gbl_entity(gbl_entity_id),
    id_sch_slot int references sch_slot(sch_slot_id)
);
#sch_workflow_slot_assigned
create table sch_workflow_slot_assigned (
    flow_id SERIAL PRIMARY KEY,
    sch_slot_assigned_id int references sch_slot_assigned(sch_slot_assigned_id));

# adm_admission
create table adm_admission (
    adm_admission_id SERIAL PRIMARY KEY
);
#adm_admission_appointment
create table adm_admission_appointment (
    adm_admission_appointment_id SERIAL PRIMARY KEY,
    id_adm_admission int references adm_admission(adm_admission_id),
    id_flow int references sch_workflow_slot_assigned(flow_id));
#adm_admission_flow
create table adm_admission_flow (
    adm_admission_flow_id SERIAL PRIMARY KEY,
    id_adm_admission int references adm_admission(adm_admission_id)
    );
#cnt_medical_order
create table cnt_medical_order (
    cnt_medical_order_id SERIAL PRIMARY KEY,
    id_adm_admission_flow int references adm_admission_flow(adm_admission_flow_id)
);
#cnt_medical_order_medicament
create table cnt_medical_order_medicament (
    cnt_medical_order_medicament_id SERIAL PRIMARY KEY,
    descripcion TEXT NOT NULL,
    id_cnt_medical_order int references cnt_medical_order(cnt_medical_order_id)
);
# com_quotation
create table com_quotation (
    com_quotation_id SERIAL PRIMARY KEY,
    id_medical_order_medicament int references cnt_medical_order_medicament(cnt_medical_order_medicament_id),
    id_gbl_entity int references gbl_entity(gbl_entity_id),
    id_sch_calendar int references sch_calendar(sch_calendar_id),
    id_sch_event int references sch_event(sch_event_id)
);
#com_quotation_line
create table com_quotation_line (
    line_id SERIAL PRIMARY KEY,
    id_com_quotation int references com_quotation(com_quotation_id)
);
#cnt_medical_order_medicament_quotation
create table cnt_medical_order_medicament_quotation (
    id_line int references com_quotation_line(line_id),
    id_cnt_medical_order_medicament int references cnt_medical_order_medicament(cnt_medical_order_medicament_id),
    cnt_medical_order_medicament_quotation_id SERIAL PRIMARY KEY
);
/* INSERTAR DATOS DE PRUEBA*/
#DOCTORES
INSERT INTO sch_calendar (nombre, apellido) VALUES ('Juan', 'Perez');
INSERT INTO sch_calendar (nombre, apellido) VALUES ('Daniel', 'Garces');
INSERT INTO sch_calendar (nombre, apellido) VALUES ('Felipe', 'Gonzalez');
#PACIENTES
INSERT INTO gbl_entity (nombre_user, apellido_user, dirrecion_user, telefono_user, id_sch_calendar) VALUES ('Carlos', 'Lopez', 'Calle 123', '555-1234', 1);
INSERT INTO gbl_entity (nombre_user, apellido_user, dirrecion_user, telefono_user, id_sch_calendar) VALUES ('Ana', 'Reacio', 'Carrera 12', '595-1244', 2);
INSERT INTO gbl_entity (nombre_user, apellido_user, dirrecion_user, telefono_user, id_sch_calendar) VALUES ('Luis', 'Martinez', 'Avenida 45', '535-2234', 3);
INSERT INTO gbl_entity (nombre_user, apellido_user, dirrecion_user, telefono_user, id_sch_calendar) VALUES ('Adriana', 'Cuenu', 'Calle 1234', '155-0234', 3);
INSERT INTO gbl_entity (nombre_user, apellido_user, dirrecion_user, telefono_user, id_sch_calendar) VALUES ('Jean', 'Ruiz', 'Calle 345', '235-1234', 1);
#CITAS
INSERT INTO sch_event (init_date, end_date, id_sch_calendar) VALUES ('2025-02-22 09:00:00', '2025-02-22 09:30:00', 1);1
INSERT INTO sch_event (init_date, end_date, id_sch_calendar) VALUES ('2025-03-14 07:00:00', '2025-03-14 07:30:00', 1);2
INSERT INTO sch_event (init_date, end_date, id_sch_calendar) VALUES ('2025-03-22 14:00:00', '2025-03-22 14:30:00', 1);3
INSERT INTO sch_event (init_date, end_date, id_sch_calendar) VALUES ('2025-04-01 10:00:00', '2025-04-01 10:30:00', 1);4
INSERT INTO sch_event (init_date, end_date, id_sch_calendar) VALUES ('2025-05-11 13:00:00', '2025-05-11 13:30:00', 2);5
INSERT INTO sch_event (init_date, end_date, id_sch_calendar) VALUES ('2025-08-22 09:00:00', '2025-08-22 09:30:00', 2);6
INSERT INTO sch_event (init_date, end_date, id_sch_calendar) VALUES ('2025-09-09 16:00:00', '2025-09-09 16:30:00', 3);7
INSERT INTO sch_event (init_date, end_date, id_sch_calendar) VALUES ('2025-11-20 09:00:00', '2025-11-20 09:30:00', 3);8
INSERT INTO sch_event (init_date, end_date, id_sch_calendar) VALUES ('2025-10-31 09:00:00', '2025-10-31 09:30:00', 3);9
INSERT INTO sch_event (init_date, end_date, id_sch_calendar) VALUES ('2025-07-01 09:00:00', '2025-07-01 09:30:00', 3);10
#SLOTS
INSERT INTO sch_slot (id_sch_event) VALUES (1);
INSERT INTO sch_slot (id_sch_event) VALUES (2);
INSERT INTO sch_slot (id_sch_event) VALUES (3);
INSERT INTO sch_slot (id_sch_event) VALUES (4);
INSERT INTO sch_slot (id_sch_event) VALUES (5);
INSERT INTO sch_slot (id_sch_event) VALUES (6);
INSERT INTO sch_slot (id_sch_event) VALUES (7);
INSERT INTO sch_slot (id_sch_event) VALUES (8);
INSERT INTO sch_slot (id_sch_event) VALUES (9);
INSERT INTO sch_slot (id_sch_event) VALUES (10);
#sch_slot_assigned
alter table sch_slot_assigned ADD COLUMN init_time TIME,
ADD COLUMN end_time TIME;
INSERT INTO sch_slot_assigned (id_gbl_entity, id_sch_slot, init_time, end_time) VALUES (1, 2, '09:00:00', '09:30:00');
INSERT INTO sch_slot_assigned (id_gbl_entity, id_sch_slot, init_time, end_time) VALUES (1, 3, '07:00:00', '07:30:00');
INSERT INTO sch_slot_assigned (id_gbl_entity, id_sch_slot, init_time, end_time) VALUES (5, 4, '14:00:00', '14:30:00');
INSERT INTO sch_slot_assigned (id_gbl_entity, id_sch_slot, init_time, end_time) VALUES (5, 5, '10:00:00', '10:30:00');
INSERT INTO sch_slot_assigned (id_gbl_entity, id_sch_slot, init_time, end_time) VALUES (2, 6, '13:00:00', '13:30:00');
INSERT INTO sch_slot_assigned (id_gbl_entity, id_sch_slot, init_time, end_time) VALUES (2, 7, '09:00:00', '09:30:00');
INSERT INTO sch_slot_assigned (id_gbl_entity, id_sch_slot, init_time, end_time) VALUES (3, 8, '16:00:00', '16:30:00');
INSERT INTO sch_slot_assigned (id_gbl_entity, id_sch_slot, init_time, end_time) VALUES (3, 9, '09:00:00', '09:30:00');
INSERT INTO sch_slot_assigned (id_gbl_entity, id_sch_slot, init_time, end_time) VALUES (4, 10, '09:00:00', '09:30:00');

#sch_workflow_slot_assigned
INSERT INTO sch_workflow_slot_assigned (sch_slot_assigned_id) VALUES (12);
INSERT INTO sch_workflow_slot_assigned (sch_slot_assigned_id) VALUES (13);
INSERT INTO sch_workflow_slot_assigned (sch_slot_assigned_id) VALUES (14);
INSERT INTO sch_workflow_slot_assigned (sch_slot_assigned_id) VALUES (15);
INSERT INTO sch_workflow_slot_assigned (sch_slot_assigned_id) VALUES (16);
INSERT INTO sch_workflow_slot_assigned (sch_slot_assigned_id) VALUES (17);
INSERT INTO sch_workflow_slot_assigned (sch_slot_assigned_id) VALUES (18);
INSERT INTO sch_workflow_slot_assigned (sch_slot_assigned_id) VALUES (19);
INSERT INTO sch_workflow_slot_assigned (sch_slot_assigned_id) VALUES (20);

#adm_admission
INSERT INTO adm_admission DEFAULT VALUES;
INSERT INTO adm_admission DEFAULT VALUES;
INSERT INTO adm_admission DEFAULT VALUES;
INSERT INTO adm_admission DEFAULT VALUES;
INSERT INTO adm_admission DEFAULT VALUES;
INSERT INTO adm_admission DEFAULT VALUES;
INSERT INTO adm_admission DEFAULT VALUES;
INSERT INTO adm_admission DEFAULT VALUES;
INSERT INTO adm_admission DEFAULT VALUES;
INSERT INTO adm_admission DEFAULT VALUES;
#adm_admission_appointment
INSERT INTO adm_admission_appointment (id_adm_admission, id_flow) VALUES (1, 2);
INSERT INTO adm_admission_appointment (id_adm_admission, id_flow) VALUES (2, 3);
INSERT INTO adm_admission_appointment (id_adm_admission, id_flow) VALUES (3, 4);
INSERT INTO adm_admission_appointment (id_adm_admission, id_flow) VALUES (4, 5);
INSERT INTO adm_admission_appointment (id_adm_admission, id_flow) VALUES (5, 6);
INSERT INTO adm_admission_appointment (id_adm_admission, id_flow) VALUES (6, 7);
INSERT INTO adm_admission_appointment (id_adm_admission, id_flow) VALUES (7, 8);
INSERT INTO adm_admission_appointment (id_adm_admission, id_flow) VALUES (8, 9);
INSERT INTO adm_admission_appointment (id_adm_admission, id_flow) VALUES (9, 10);
#adm_admission_flow
INSERT INTO adm_admission_flow (id_adm_admission) VALUES (1);
INSERT INTO adm_admission_flow (id_adm_admission) VALUES (2);
INSERT INTO adm_admission_flow (id_adm_admission) VALUES (3);
INSERT INTO adm_admission_flow (id_adm_admission) VALUES (4);
INSERT INTO adm_admission_flow (id_adm_admission) VALUES (5);
INSERT INTO adm_admission_flow (id_adm_admission) VALUES (6);
INSERT INTO adm_admission_flow (id_adm_admission) VALUES (7);
INSERT INTO adm_admission_flow (id_adm_admission) VALUES (8);
INSERT INTO adm_admission_flow (id_adm_admission) VALUES (9);
INSERT INTO adm_admission_flow (id_adm_admission) VALUES (10);
#cnt_medical_order
INSERT INTO cnt_medical_order (id_adm_admission_flow) VALUES (1);
INSERT INTO cnt_medical_order (id_adm_admission_flow) VALUES (2);
INSERT INTO cnt_medical_order (id_adm_admission_flow) VALUES (3);
INSERT INTO cnt_medical_order (id_adm_admission_flow) VALUES (4);
INSERT INTO cnt_medical_order (id_adm_admission_flow) VALUES (5);
INSERT INTO cnt_medical_order (id_adm_admission_flow) VALUES (6);
INSERT INTO cnt_medical_order (id_adm_admission_flow) VALUES (7);
INSERT INTO cnt_medical_order (id_adm_admission_flow) VALUES (8);
INSERT INTO cnt_medical_order (id_adm_admission_flow) VALUES (9);
INSERT INTO cnt_medical_order (id_adm_admission_flow) VALUES (10);
#cnt_medical_order_medicament
INSERT INTO cnt_medical_order_medicament (descripcion, id_cnt_medical_order) VALUES ('Paracetamol 500mg', 1);
INSERT INTO cnt_medical_order_medicament (descripcion, id_cnt_medical_order) VALUES ('Ibuprofeno 200mg', 2);
INSERT INTO cnt_medical_order_medicament (descripcion, id_cnt_medical_order) VALUES ('Amoxicilina 250mg', 3);
INSERT INTO cnt_medical_order_medicament (descripcion, id_cnt_medical_order) VALUES ('Loratadina 10mg', 4);
INSERT INTO cnt_medical_order_medicament (descripcion, id_cnt_medical_order) VALUES ('Omeprazol 20mg', 5);
INSERT INTO cnt_medical_order_medicament (descripcion, id_cnt_medical_order) VALUES ('Metformina 500mg', 6);
INSERT INTO cnt_medical_order_medicament (descripcion, id_cnt_medical_order) VALUES ('Atorvastatina 10mg', 7);
INSERT INTO cnt_medical_order_medicament (descripcion, id_cnt_medical_order) VALUES ('Amlodipino 5mg', 8);
INSERT INTO cnt_medical_order_medicament (descripcion, id_cnt_medical_order) VALUES ('Salbutamol Inhalador', 9);
INSERT INTO cnt_medical_order_medicament (descripcion, id_cnt_medical_order) VALUES ('Claritromicina 500mg', 10);
#com_quotation
INSERT INTO com_quotation (id_medical_order_medicament, id_gbl_entity, id_sch_calendar, id_sch_event) VALUES (2, 1, 1, 2);
INSERT INTO com_quotation (id_medical_order_medicament, id_gbl_entity, id_sch_calendar, id_sch_event) VALUES (3, 1, 1, 3);
INSERT INTO com_quotation (id_medical_order_medicament, id_gbl_entity, id_sch_calendar, id_sch_event) VALUES (4, 5, 1, 4);
INSERT INTO com_quotation (id_medical_order_medicament, id_gbl_entity, id_sch_calendar, id_sch_event) VALUES (5, 5, 1, 5);
INSERT INTO com_quotation (id_medical_order_medicament, id_gbl_entity, id_sch_calendar, id_sch_event) VALUES (6, 2, 2, 6);
INSERT INTO com_quotation (id_medical_order_medicament, id_gbl_entity, id_sch_calendar, id_sch_event) VALUES (7, 2, 2, 7);
INSERT INTO com_quotation (id_medical_order_medicament, id_gbl_entity, id_sch_calendar, id_sch_event) VALUES (8, 3, 3, 8);
INSERT INTO com_quotation (id_medical_order_medicament, id_gbl_entity, id_sch_calendar, id_sch_event) VALUES (9, 3, 3, 9);
INSERT INTO com_quotation (id_medical_order_medicament, id_gbl_entity, id_sch_calendar, id_sch_event) VALUES (10, 4, 3, 10);
INSERT INTO com_quotation (id_medical_order_medicament, id_gbl_entity, id_sch_calendar, id_sch_event) VALUES (11, 4, 3, 11);
#com_quotation_line
INSERT INTO com_quotation_line (id_com_quotation) VALUES (3);
INSERT INTO com_quotation_line (id_com_quotation) VALUES (4);
INSERT INTO com_quotation_line (id_com_quotation) VALUES (5);
INSERT INTO com_quotation_line (id_com_quotation) VALUES (6);
INSERT INTO com_quotation_line (id_com_quotation) VALUES (7);
INSERT INTO com_quotation_line (id_com_quotation) VALUES (8);
INSERT INTO com_quotation_line (id_com_quotation) VALUES (9);
INSERT INTO com_quotation_line (id_com_quotation) VALUES (10);
INSERT INTO com_quotation_line (id_com_quotation) VALUES (11);
INSERT INTO com_quotation_line (id_com_quotation) VALUES (12);
#cnt_medical_order_medicament_quotation
INSERT INTO cnt_medical_order_medicament_quotation (id_line, id_cnt_medical_order_medicament) VALUES (1, 2);
INSERT INTO cnt_medical_order_medicament_quotation (id_line, id_cnt_medical_order_medicament) VALUES (2, 3);
INSERT INTO cnt_medical_order_medicament_quotation (id_line, id_cnt_medical_order_medicament) VALUES (3, 4);
INSERT INTO cnt_medical_order_medicament_quotation (id_line, id_cnt_medical_order_medicament) VALUES (4, 5);
INSERT INTO cnt_medical_order_medicament_quotation (id_line, id_cnt_medical_order_medicament) VALUES (5, 6);
INSERT INTO cnt_medical_order_medicament_quotation (id_line, id_cnt_medical_order_medicament) VALUES (6, 7);
INSERT INTO cnt_medical_order_medicament_quotation (id_line, id_cnt_medical_order_medicament) VALUES (7, 8);
INSERT INTO cnt_medical_order_medicament_quotation (id_line, id_cnt_medical_order_medicament) VALUES (8, 9);
INSERT INTO cnt_medical_order_medicament_quotation (id_line, id_cnt_medical_order_medicament) VALUES (9, 10);
INSERT INTO cnt_medical_order_medicament_quotation (id_line, id_cnt_medical_order_medicament) VALUES (10, 11);
    
