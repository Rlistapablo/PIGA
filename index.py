from flask import Flask, render_template, redirect, request, url_for, session, render_template_string
from os import getcwd
import engine
import io
from dbs import dbs
app = Flask(__name__, template_folder='templates')
app.secret_key = "2024ascendemos"
app.config['SESSION_PERMANENT'] = True 
app.config['SESSION_TYPE'] = 'filesystem'
#app.config.from_object(__name__)
#session(app)


@app.route('/login', methods=["POST", "GET"])
def login():
    a=engine.eng.userbutton()
    return render_template("logins.html",botones=a)

@app.route('/redirect', methods=['POST'])
def data():
    username=request.form['username']
    password=request.form['password']
    submit=dbs.login(user=username,passwd=password)
    if submit[0][0]==True:
        session['user']=username
        return redirect(url_for('index'))
    else:
        return redirect(url_for('login'))

@app.route('/logout')
def logout():
    session.clear()
    return redirect(url_for('index'))

@app.route('/')
def index():
    if "user" in session:
        return render_template("index.html", user=session['user'])
    else:
        return redirect(url_for('login'))
    
@app.route('/incident', methods=["POST", "GET"])
def incidencias():
    if 'image' in request.form:
        image=request.form['image']
    else:
        image='temp.jpg'
    tipoinc=engine.eng.tipoinc()
    tipoarticulo=engine.eng.tipoarti()
    articulos=engine.eng.articulos()
    if "user" in session:
        return render_template("forminci.html", tipoincidencia=tipoinc, tipoarticulo1=tipoarticulo, art=articulos, img2=image, temp=image)
    else:
        return redirect(url_for('login'))
    
@app.route('/incident/camera', methods=["POST", "GET"])
def camara():
    if "user" in session:
        return render_template("camara.html")
    else:
        return redirect(url_for('login'))

@app.route('/submitforminc', methods=['POST'])
def submitforminc():
    tipoinc=request.form['tipoincidencia']
    art=request.form['articulo']
    desc=request.form['descripcion']
    img=request.form['image']
    engine.eng.incident_reg(tipoinc,art,desc,img,user=session['user'])
    return redirect(url_for('index'))


if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port='443', ssl_context="adhoc")
