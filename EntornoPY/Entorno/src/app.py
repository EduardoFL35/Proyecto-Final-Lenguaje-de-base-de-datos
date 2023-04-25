from flask import Flask, flash, redirect, render_template, request
import cx_Oracle
import calendar

try:
    connection=cx_Oracle.connect(
        user='PROYECTO',
        password='12345',
        dsn='localhost:1521/xe',
        encoding='UTF-8'
    )
except Exception as ex:
    print(ex)


app= Flask(__name__)
@app.route('/')
def index ():
   return render_template('index.html')

#Función para consultar tarea con Procedimiento Almacenado
@app.route('/calendario/<int:id_tarea_asig>')
def consultar_tarea_asignada(id_tarea_asig):
    cursor = connection.cursor()
    p_descripcion = cursor.var(cx_Oracle.STRING)
    p_fecha_ingreso = cursor.var(cx_Oracle.DATE)
    p_estado = cursor.var(cx_Oracle.STRING)
    p_fecha_realizar = cursor.var(cx_Oracle.DATE)
    p_id_curso = cursor.var(cx_Oracle.NUMBER)

    cursor.callproc('consultar_tareas_asignadas', [id_tarea_asig, p_descripcion, p_fecha_ingreso, p_estado, p_fecha_realizar, p_id_curso])

    descripcion = p_descripcion.getvalue()
    fecha_ingreso = p_fecha_ingreso.getvalue().strftime("%d-%m-%Y")
    estado = p_estado.getvalue()
    fecha_realizar = p_fecha_realizar.getvalue().strftime("%d-%m-%Y")
    id_curso = p_id_curso.getvalue()

    cursor.close()

    tarea = {'id_tarea_asig': id_tarea_asig, 'descripcion': descripcion, 'fechaIngreso': fecha_ingreso, 'estado': estado, 'fechaRealizar': fecha_realizar, 'idCurso': id_curso}

    return render_template('calendario.html', tareas=[tarea])



#Validación de usuario en el Login
@app.route('/', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        username = request.form['typeEmailX']
        password = request.form['typePasswordX']

        if username == 'eflores90538@ufide.ac.cr' and password == '12345':
            return render_template('calendario.html')
        else:
            return render_template('index.html')
    return render_template('calendario.html')


# Tareas Asignadas 
@app.route('/insertaTarea', methods=['POST'])
def submit_form():
    try:
        cursor = connection.cursor()
        
        # Obtener los datos enviados por el formulario
        descripcion = request.form['descripcion']
        fecha_ingreso = request.form['fechaIngreso']
        estado = request.form['estado']
        fecha_realizar = request.form['fechaRealizar']
        id_curso = request.form['idCurso']
        
        # Llamar al procedimiento almacenado para insertar los datos en la tabla
        cursor.callproc('Inserta_Tarea_asignadas', [descripcion, fecha_ingreso, estado, fecha_realizar, id_curso])
        connection.commit()
        
        # Cerrar la conexión a la base de datos
        cursor.close()
        
        # Redireccionar a la página de tareas asignadas
        return redirect('/insertaTarea.html')
    except Exception as e:
        # En caso de error, mostrar un mensaje de error y redireccionar a la página anterior
        print(e)
        flash('Ocurrió un error al procesar los datos')
        return redirect(request.referrer)

#Botón
@app.route('/calendario', methods=['POST'])
def redireccionar():
    if request.form['submit_button'] == 'Otra página':
        return render_template('tareasAsignadas.html')
    else:
        # Si no se cumple la condición, devuelve una respuesta predeterminada
       return render_template('calendario.html')

if __name__ == '__main__':
    app.run(debug=True)

