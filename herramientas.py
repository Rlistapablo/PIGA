import mysql.connector
import hashlib
db=mysql.connector.connect(
    host="192.168.1.235",
    user="admin",
    password="abc123.",
    database='PIGA'
)
cursor=db.cursor()

def create(user,passwd):
    cursor.execute(f"SELECT createuser('{user}','{passwd}')")
    cursor.fetchall()
    db.commit()

def mails(var):
        cursor.callproc('getprovmaildirect',[var,])
        r=list(cursor.stored_results())
        for result in r:
            r3 = result.fetchall()
        return r3

def delete(var):
     cursor.execute(f'SELECT ID_Usuario FROM Usuarios WHERE Username = "{var}"')
     id=cursor.fetchone()
     try:
        cursor.execute(f'DELETE FROM UsuarioTienda WHERE ID_Usuario = "{id[0]}"')
     except:
          pass     
     cursor.execute(f'DELETE FROM Passwd WHERE ID_Usuario = "{id[0]}"')
     cursor.execute(f'DELETE FROM Usuarios WHERE Username = "{var}"')
     db.commit()

def addusershop(tienda,user):
     cursor.execute(f'SELECT ID_Usuario FROM Usuarios WHERE Username = "{user}"')
     id=cursor.fetchone()
     cursor.execute(f'INSERT INTO UsuarioTienda VALUES ({tienda},"{id[0]}")')

def createusers(all):
    usuarios=all
    for x in usuarios:
        create(x[0],hashlib.md5(x[1].encode()).hexdigest())

#createusers([['Pablo','12345'],['test','12345']])
#delete('Pablo')
#delete('test')
addusershop('1','test')