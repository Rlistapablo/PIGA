from dbs import dbs
import base64
import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from email.mime.image import MIMEImage
import datetime
from PIL import Image
import io
class eng:

    def imgshow(base64data):
        print(base64data[:30])
        image_data=base64.b64decode((base64data[23:]))
        image=Image.open(io.BytesIO(image_data))
        image.save("img.png")

    def userbutton():
        lista=dbs.getuser()
        cad=''
        for x in range(0,len(lista)):
            #cad+='<div class="container">'
            cad+=f'<input type="button" id="boton{x}" value="{lista[x][0]}" name="valor-boton" class="button" onclick="mostrarCampo({x})" />'
            #cad+='</div>'
        return cad
    
    def tipoinc():
        listado=dbs.getinc()
        cad=''
        for x in listado:
            cad+=f'<option value="{x[0]}">{x[0]}</option>\n'
        return cad

    def tipoarti():
        listado=dbs.gettipoart()
        cad=''
        for x in listado:
            cad+=f'<option value="{x[0]}">{x[0]}</option>\n'
        return cad
    
    def articulos():
        tipos=dbs.gettipoart()
        cad=''
        for x in tipos:
            lista=dbs.getarticulos(var=x[0])
            cad+=f'{x[0]}: ['
            for y in lista:
                cad+=f'"{y[0]}",'
            cad=cad[:-1]
            cad+='],\n'
        cad=cad[:-1]
        return cad
    
    def incident_reg(tipoinc,art,desc1,img,user):
        #eng.imgshow(img)
        try:
            img1=base64.b64decode((img[23:]))
        except:
            img1=base64.b64decode(('iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mOUZJL8CQABnwEvAT8SxQAAAABJRU5ErkJggg=='))
        idinc=dbs.getidinc(var=tipoinc)
        idart=dbs.getidart(var=art)
        tiendas=dbs.tiendas(var=user)
        dbs.incidencia(tipo=idinc[0],art=idart[0],tienda=tiendas[0],desc=desc1,foto=img1)
        eng.correo(tipoinc,art,desc1,img1,tiendas,idart)

    
    def correo(tipoinc,art,desc1,img,tiendas,idart):
        tiendalist=dbs.tiendaall(var=tiendas[0][0])[0]
        mails=dbs.mails(var=idart[0][0])
        smtp_server = 'smtp.gmail.com'
        smtp_port = 587
        smtp_username = 'rlistapablopruebas@gmail.com'
        smtp_password = 'wotgiqtabgjyxdvu'
        msg= MIMEMultipart()
        msg['From'] = smtp_username
        msg['Subject'] = f'Incidencia en {tiendalist[len(tiendalist)-1]} - Fecha {datetime.datetime.now()}'
        mensaje=f"""
Hola buenas. Incidencia registrada en {tiendalist[3]}, {tiendalist[4]}, {tiendalist[5]} {tiendalist[6]}, {tiendalist[1]}, {tiendalist[0]}.\n
Nombre del Local: {tiendalist[7]}\n 
Fecha: {datetime.datetime.now()}\n
Tipo de incidencia: {tipoinc}\n
Articulo: {art}\n
Descripción dada: {desc1}\n
Foto Adjunta.\n
Un Saludo."""
        msg.attach(MIMEText(mensaje, 'plain'))
        try:
            imgall=io.BytesIO(img)
            imagen_raw=MIMEImage(imgall.read())
            imagen_raw.add_header('Content-Disposition', 'attachment', filename='imagen.png')
            msg.attach(imagen_raw)
        except:
            pass
        server=smtplib.SMTP(smtp_server,smtp_port)
        server.starttls()
        server.login(smtp_username,smtp_password)
        for x in mails:
            msg['To']=x[0]
            server.sendmail(smtp_username, x[0], msg.as_string())
        server.quit()
