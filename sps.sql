CREATE USER 'connect'@'localhost' IDENTIFIED BY 'connect';

USE PIGA;
DROP FUNCTION IF EXISTS createuser;
DELIMITER $$
CREATE FUNCTION createuser(usuario VARCHAR(50), password1 VARCHAR(150))
RETURNS BOOLEAN
BEGIN
    SET @existe = 0;
    SELECT COUNT(*) INTO @existe FROM Usuarios WHERE Username = usuario;
    IF @existe > 0 THEN
        RETURN false;
    ELSE
        INSERT INTO Usuarios VALUES (SHA1(usuario),usuario);
        INSERT INTO Passwd VALUES (SHA1(usuario),password1);
        RETURN true;
    END IF;
END$$
DELIMITER ;

GRANT EXECUTE ON FUNCTION PIGA.createuser TO 'connect'@'localhost' IDENTIFIED BY 'connect';

DELIMITER $$
CREATE FUNCTION `loginconnect`(usuario VARCHAR(50), password1 VARCHAR(150)) RETURNS tinyint(1)
BEGIN
	SET @usuario_count = 0;
    SET @password_count = 0;
    SELECT COUNT(*) INTO @usuario_count FROM Usuarios WHERE Username = usuario;
    IF @usuario_count = 0 THEN
		RETURN false;
	END IF;
    SELECT ID_Usuario INTO @usuario_ids FROM Usuarios WHERE Username = usuario;
    SELECT COUNT(*) INTO @password_count FROM Passwd WHERE ID_Usuario = @usuario_ids AND Passwords = password1;
    IF @password_count = 0 THEN
		RETURN false;
	ELSE
		RETURN true;
	END IF;
END$$
DELIMITER ;
GRANT EXECUTE ON FUNCTION PIGA.loginconnect TO 'connect'@'localhost' IDENTIFIED BY 'connect';

CREATE VIEW usuarioslist AS
SELECT Username FROM Usuarios;

GRANT SELECT ON PIGA.usuarioslist TO 'connect'@'localhost' IDENTIFIED BY 'connect';

CREATE VIEW tipoincidencia AS
SELECT Nombre FROM Tipo_incidencia;

GRANT SELECT ON PIGA.tipoincidencia TO 'connect'@'localhost' IDENTIFIED BY 'connect';

CREATE VIEW tipoarticulo AS
SELECT Nombre FROM TipodeArticulo;

GRANT SELECT ON PIGA.tipoarticulo TO 'connect'@'localhost' IDENTIFIED BY 'connect';

DELIMITER $$
CREATE DEFINER=`admin`@`192.168.1.%` PROCEDURE `getarticulos`(IN nombretipo VARCHAR(50))
BEGIN
    -- Crear una tabla temporal
    CREATE TEMPORARY TABLE tmp
    (Nombre VARCHAR(50));

    -- Insertar los valores de una consulta SELECT en la tabla temporal
    INSERT INTO tmp (Nombre) 
    SELECT Articulos.Nombre
    FROM Articulos
    INNER JOIN Tipo_Articulo ON Tipo_Articulo.ID_Articulo = Articulos.ID_Articulo
    INNER JOIN TipodeArticulo ON Tipo_Articulo.ID_TipoArt = TipodeArticulo.ID_TipoArt
    WHERE TipodeArticulo.Nombre = nombretipo;

    -- Devolver los datos de la tabla temporal
    SELECT *
    FROM tmp;

    -- Eliminar la tabla temporal
    DROP TABLE tmp;
END$$
DELIMITER ;

GRANT EXECUTE ON PROCEDURE PIGA.getarticulos TO 'connect'@'localhost' IDENTIFIED BY 'connect';

DELIMITER $$
CREATE PROCEDURE tiendas (IN user VARCHAR(50))
BEGIN
    SELECT ID_Local FROM UsuarioTienda INNER JOIN Usuario ON Usuario.ID_Usuario=UsuarioTienda.ID_Usuario WHERE Usuario.Nombre=user;
END$$
DELIMITER ;

GRANT EXECUTE ON PROCEDURE PIGA.tiendas TO 'connect'@'localhost' IDENTIFIED BY 'connect';

DELIMITER //
CREATE PROCEDURE incidencias (
	IN Tienda int,
    IN Articulo int,
    IN TipoInc int,
    IN Paint longblob,
    IN Descr VARCHAR(200)
)
BEGIN
INSERT INTO Incidencias (ID_Local,ID_Articulo,ID_Tipo_incidencia,Fecha,Foto,Descripcion)
VALUES (Tienda,Articulo,TipoInc,now(),Paint,Descr);
END //
DELIMITER ;
GRANT EXECUTE ON PROCEDURE PIGA.incidencias TO 'connect'@'localhost' IDENTIFIED BY 'connect';

USE PIGA;
DELIMITER //
CREATE PROCEDURE getidinc (IN name VARCHAR(200))
BEGIN 
SELECT ID_Tipo_incidencia FROM Tipo_incidencia WHERE Nombre = name;
END //
DELIMITER ;
DELIMITER //
CREATE PROCEDURE getidart (IN name VARCHAR(200))
BEGIN 
SELECT ID_Articulo FROM Articulos WHERE Nombre = name;
END //
DELIMITER ;
GRANT EXECUTE ON PROCEDURE PIGA.getidinc TO 'connect'@'localhost' IDENTIFIED BY 'connect';
GRANT EXECUTE ON PROCEDURE PIGA.getidart TO 'connect'@'localhost' IDENTIFIED BY 'connect';

USE PIGA;
DELIMITER //
CREATE PROCEDURE getincn (IN name VARCHAR(200))
BEGIN 
SELECT Nombre FROM Tipo_incidencia WHERE ID_Tipo_incidencia = name;
END //
DELIMITER ;
DELIMITER //
CREATE PROCEDURE getartn (IN name VARCHAR(200))
BEGIN 
SELECT Nombre FROM Articulos WHERE ID_Articulo = name;
END //
DELIMITER ;
GRANT EXECUTE ON PROCEDURE PIGA.getartn TO 'connect'@'localhost' IDENTIFIED BY 'connect';
GRANT EXECUTE ON PROCEDURE PIGA.getincn TO 'connect'@'localhost' IDENTIFIED BY 'connect';

USE PIGA;
DELIMITER //
CREATE PROCEDURE getprovmaildirect (IN Arti INT)
BEGIN
	SELECT Email.Email FROM Email
    INNER JOIN Provedores ON Email.ID_Contacto = Provedores.ID_Proveedor
    INNER JOIN Articulos_Provedores ON Articulos_Provedores.ID_Proveedor = Provedores.ID_Proveedor
    WHERE Articulos_Provedores.ID_Articulo = Arti;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE getalltienda (IN Local INT)
BEGIN
	SELECT Provincia.Nombre AS Provincia, Municipio.Nombre AS Municipio, Localizacion.CCPP AS CCPP, Localizacion.Calle AS Calle, Localizacion.Numero AS Numero, Localizacion.Piso AS Piso, Localizacion.Puerta AS Puerta, Locales.Nombre AS NombreLocal
    FROM Provincia
    INNER JOIN Municipio ON Provincia.ID_Provincia = Municipio.ID_Provincia
    INNER JOIN Localizacion ON Localizacion.ID_Municipio = Municipio.ID_Municipio
    INNER JOIN Locales ON Locales.ID_Localizacion = Localizacion.ID_Localizacion
    WHERE Locales.ID_Local = Local;
END //
DELIMITER ;

GRANT EXECUTE ON PROCEDURE PIGA.getprovmaildirect TO 'connect'@'localhost' IDENTIFIED BY 'connect';
GRANT EXECUTE ON PROCEDURE PIGA.getalltienda TO 'connect'@'localhost' IDENTIFIED BY 'connect';
