DROP DATABASE IF EXISTS PIGA;
CREATE DATABASE PIGA;
USE PIGA;
#CREACION DE LAS TABLAS

CREATE TABLE Provincia
(
    ID_Provincia INT NOT NULL,
    Nombre VARCHAR(50) NOT NULL,
    PRIMARY KEY(ID_Provincia)
);

CREATE TABLE Municipio
(
    ID_Municipio INT NOT NULL,
    Nombre VARCHAR(50) NOT NULL,
    ID_Provincia INT NOT NULL,
    PRIMARY KEY(ID_Municipio),
    FOREIGN KEY(ID_Provincia) REFERENCES Provincia(ID_Provincia)
);

CREATE TABLE Localizacion
(
    ID_Localizacion CHAR(5) NOT NULL,
    ID_Municipio INT NOT NULL,
    CCPP INT NOT NULL,
    Calle VARCHAR(150) NOT NULL,
    Numero INT NOT NULL,
    Piso VARCHAR(5),
    Puerta VARCHAR(5),
    PRIMARY KEY(ID_Localizacion),
    FOREIGN KEY(ID_Municipio) REFERENCES Municipio(ID_Municipio)
);

CREATE TABLE Usuarios
(
	ID_Usuario CHAR(50) NOT NULL,
    Username VARCHAR(50) NOT NULL,
    PRIMARY KEY(ID_Usuario)
);

CREATE TABLE Passwd
(
	ID_Usuario CHAR(50) NOT NULL,
    Passwords VARCHAR(150) NOT NULL,
    PRIMARY KEY(ID_Usuario),
    FOREIGN KEY (ID_Usuario) REFERENCES Usuarios(ID_Usuario)
);

CREATE TABLE Roles
(
	ID_Rol INT NOT NULL auto_increment,
    Nombre VARCHAR(50) NOT NULL,
    Descripcion VARCHAR(150) NOT NULL,
    PRIMARY KEY(ID_Rol)
);

CREATE TABLE ConnectRol
(
	ID_Rol INT NOT NULL,
    Dir VARCHAR(150) NOT NULL,
    PRIMARY KEY(ID_Rol,Dir),
    FOREIGN KEY (ID_Rol) REFERENCES Roles(ID_Rol)
);

CREATE TABLE RolUser
(
	ID_Rol INT NOT NULL,
    ID_Usuario CHAR(50) NOT NULL,
    PRIMARY KEY(ID_Rol,ID_Usuario),
    FOREIGN KEY (ID_Rol) REFERENCES Roles(ID_Rol),
    FOREIGN KEY (ID_Usuario) REFERENCES Usuarios(ID_Usuario)
);

CREATE TABLE Empresa
(
    ID_Empresa INT NOT NULL,
    CID CHAR(9) NOT NULL,
    Nombre VARCHAR(100) NOT NULL,
    ID_Localizacion CHAR(5) NOT NULL,
    PRIMARY KEY(ID_Empresa),
    FOREIGN KEY (ID_Localizacion) REFERENCES Localizacion(ID_Localizacion)
);

CREATE TABLE Locales
(
    ID_Local INT NOT NULL,
    Nombre VARCHAR(100) NOT NULL,
    ID_Localizacion CHAR(5) NOT NULL,
    PRIMARY KEY(ID_Local),
    FOREIGN KEY (ID_Localizacion) REFERENCES Localizacion(ID_Localizacion)
);

CREATE TABLE Articulos
(
    ID_Articulo INT NOT NULL,
    Nombre VARCHAR(100) NOT NULL,
    PRIMARY KEY(ID_Articulo)
);

CREATE TABLE Centro_de_producción
(
    ID_Centro_de_produccion INT NOT NULL,
    Nombre VARCHAR(100) NOT NULL,
    ID_Localizacion CHAR(5) NOT NULL,
    PRIMARY KEY(ID_Centro_de_produccion),
    FOREIGN KEY (ID_Localizacion) REFERENCES Localizacion(ID_Localizacion)
);

CREATE TABLE Provedores
(
    ID_Proveedor INT NOT NULL,
    Nombre VARCHAR(50) NOT NULL,
    PRIMARY KEY(ID_Proveedor)
);

CREATE TABLE Lote 
(
    ID_Articulo INT NOT NULL,
    Cantidad INT NOT NULL,
    ID_Proveedor INT NOT NULL,
    Fecha DATETIME NOT NULL,
    PRIMARY KEY(ID_Articulo,Fecha),
    FOREIGN KEY (ID_Articulo) REFERENCES Articulos(ID_Articulo),
    FOREIGN KEY (ID_Proveedor) REFERENCES Provedores(ID_Proveedor)
);

CREATE TABLE Stock
(
    ID_Articulo INT NOT NULL,
    Cantidad INT NOT NULL,
    PRIMARY KEY(ID_Articulo),
    FOREIGN KEY (ID_Articulo) REFERENCES Articulos(ID_Articulo)
);

CREATE TABLE Tipo_incidencia
(
    ID_Tipo_incidencia INT NOT NULL,
    Nombre VARCHAR(50) NOT NULL,
    PRIMARY KEY(ID_Tipo_incidencia)
);

CREATE TABLE Incidencias
(
    ID_Incidencia INT NOT NULL,
    ID_Local INT NOT NULL,
    ID_Articulo INT NOT NULL,
    ID_Tipo_incidencia INT NOT NULL,
    Fecha DATETIME NOT NULL,
    Foto LONGBLOB,
    Descripcion VARCHAR(200),
    PRIMARY KEY(ID_Incidencia),
    FOREIGN KEY(ID_Articulo) REFERENCES Articulos(ID_Articulo),
    FOREIGN KEY(ID_Tipo_incidencia) REFERENCES Tipo_incidencia(ID_Tipo_incidencia),
    FOREIGN KEY(ID_Local) REFERENCES Locales(ID_Local)
);

CREATE TABLE Telefono
(
    ID_Contacto INT NOT NULL,
    Telefono CHAR(10) NOT NULL,
    PRIMARY KEY(ID_Contacto,Telefono),
    FOREIGN KEY(ID_Contacto) REFERENCES Provedores(ID_Proveedor)
);

CREATE TABLE Email
(
    ID_Contacto INT NOT NULL,
    Email CHAR(10) NOT NULL,
    PRIMARY KEY(ID_Contacto,Email),
    FOREIGN KEY(ID_Contacto) REFERENCES Provedores(ID_Proveedor)
);

CREATE TABLE Articulos_Provedores
(
    ID_Proveedor INT NOT NULL,
    ID_Articulo INT NOT NULL,
    PRIMARY KEY(ID_Proveedor,ID_Articulo),
    FOREIGN KEY(ID_Proveedor) REFERENCES Provedores(ID_Proveedor),
    FOREIGN KEY(ID_Articulo) REFERENCES Articulos(ID_Articulo)
);

CREATE TABLE UsuarioTienda
(
    ID_Local INT NOT NULL,
    ID_Usuario CHAR(50) NOT NULL,
    PRIMARY KEY (ID_Local,ID_Usuario),
    FOREIGN KEY(ID_Local) REFERENCES Locales(ID_Local),
    FOREIGN KEY(ID_Usuario) REFERENCES Usuarios(ID_Usuario)
);

CREATE TABLE TipodeArticulo
(
	ID_TipoArt INT NOT NULL,
	Nombre VARCHAR(50) NOT NULL,
    primary key (ID_TipoArt)
);
CREATE TABLE Tipo_Articulo
(
    ID_TipoArt INT NOT NULL,
    ID_Articulo INT NOT NULL,
    PRIMARY KEY (ID_TipoArt, ID_Articulo),
    FOREIGN KEY(ID_Articulo) REFERENCES Articulos(ID_Articulo),
    foreign key(ID_TipoArt) REFERENCES TipodeArticulo(ID_TipoArt)
)