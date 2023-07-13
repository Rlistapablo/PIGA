import mysql.connector
import hashlib
class dbs:
    db=mysql.connector.connect(
        host="localhost",
        user="connect",
        password="connect",
        database='PIGA'
    )
    cursor=db.cursor()
    def login(cursor=cursor,user='',passwd=''):
        query=f"SELECT loginconnect('{user}','{hashlib.md5(passwd.encode()).hexdigest()}')"
        cursor.execute(query)
        r=cursor.fetchall()
        return r

    def create(cursor=cursor,user='',passwd=''):
        query=f"SELECT createuser('{user}','{passwd}')"
        cursor.execute(query)
        r=cursor.fetchall()
        return r

    def getuser(cursor=cursor):
        cursor.execute('SELECT * FROM usuarioslist')
        r=cursor.fetchall()
        return r
    
    def getinc(cursor=cursor):
        cursor.execute('SELECT * FROM tipoincidencia')
        r=cursor.fetchall()
        return r
    
    def gettipoart(cursor=cursor):
        cursor.execute('SELECT * FROM tipoarticulo')
        r=cursor.fetchall()
        return r
    
    def getarticulos(cursor=cursor,var=''):
        cursor.callproc('getarticulos',[var,])
        r=list(cursor.stored_results())
        for result in r:
            r3 = result.fetchall()
        return r3
    
    def getidart(cursor=cursor,var=''):
        cursor.callproc('getidart',[var,])
        r=list(cursor.stored_results())
        for result in r:
            r3 = result.fetchall()
        return r3
    
    def getidinc(cursor=cursor,var=''):
        cursor.callproc('getidinc',[var,])
        r=list(cursor.stored_results())
        for result in r:
            r3 = result.fetchall()
        return r3
    
    def getartn(cursor=cursor,var=''):
        cursor.callproc('getartn',[var,])
        r=list(cursor.stored_results())
        for result in r:
            r3 = result.fetchall()
        return r3
    
    def getincn(cursor=cursor,var=''):
        cursor.callproc('getincn',[var,])
        r=list(cursor.stored_results())
        for result in r:
            r3 = result.fetchall()
        return r3
    
    def incidencia(cursor=cursor,cnx=db,tienda='',art='',tipo='',foto='',desc=''):
        args=(tienda[0],art[0],tipo[0],foto,desc)
        cursor.callproc('incidencias',args)
        cnx.commit()
    
    def tiendas(cursor=cursor,var=''):
        cursor.callproc('tiendas',[var,])
        r=list(cursor.stored_results())
        for result in r:
            r3 = result.fetchall()
        return r3
    
    def tiendaall(cursor=cursor,var=''):
        cursor.callproc('getalltienda',[var,])
        r=list(cursor.stored_results())
        for result in r:
            r3 = result.fetchall()
        return r3
    
    def mails(cursor=cursor,var=''):
        cursor.callproc('getprovmaildirect',[var,])
        r=list(cursor.stored_results())
        for result in r:
            r3 = result.fetchall()
        return r3