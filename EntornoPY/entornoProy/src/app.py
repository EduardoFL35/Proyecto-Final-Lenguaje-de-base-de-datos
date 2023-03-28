from flask import Flask, render_template
import cx_Oracle
import calendar

try:
    connection=cx_Oracle.connect(
        user='PROYECTO',
        password='12345',
        dsn='localhost:1521/xe',
        encoding='UTF-8'
    )
    print(connection.version)
    cursor=connection.cursor()
    cursor.execute("select * from Sedes")
    rows=cursor.fetchall()
    for row in rows:
        print(row)
except Exception as ex:
    print(ex)


app= Flask(__name__)

@app.route('/')
def index ():
   data = {
       'titulo':'CalendarioFidelitas',
       'Calendario':'Calendario U Fidélitas'
   }

   return render_template('calendario.html', data=data)

if __name__== '__main__':
    app.run(debug=True, port=5000)
