{
   p1ej3.pas
   
   Copyright 2023 matid <matid@DESKTOP-47B1HE9>
   
   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2 of the License, or
   (at your option) any later version.
   
   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.
   
   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
   MA 02110-1301, USA.
   
   
}


program untitled;

type
	empleado = record
		num: integer;
		apellido: string[20];
		nombre: string[20];
		edad: integer;
		dni: integer;
	end;
	archivo = file of empleado;
procedure leerEmpleado(var e : empleado);
begin
		writeln('Ingrese un apellido: ');
		readln(e.apellido);
		if(e.apellido <> 'fin') then begin
		writeln('Ingrese un numero de empleado: ');
		readln(e.num);
		writeln('Ingrese un nombre de empleado: ');
		readln(e.nombre);
		writeln('Ingrese edad de empleado: ');
		readln(e.edad);
		writeln('Ingrese dni de empleado: ');
		readln(e.dni);
		end;
end;
procedure crearArchivo(var arc_emp: archivo);
var
	e : empleado;
begin
	rewrite(arc_emp);
	leerEmpleado(e);
	while(e.apellido <> 'fin') do begin
		write(arc_emp, e);
		leerEmpleado(e);
	end;
	close(arc_emp);
end;
procedure imprimir(e : empleado);
begin
	writeln('Nombre: ', e.nombre);
	writeln('Apellido: ', e.apellido);
	writeln('Numero de empleado: ', e.num);
	writeln('Edad: ', e.edad);
	writeln('Dni: ', e.dni);
end;
procedure listarEmplDeterminados(var arc_emp: archivo);
var
	nom: string[20];
	e: empleado;
begin
	reset(arc_emp);
	writeln('Nombre o apellido determinado: ');
	readln(nom);
	while not eof(arc_emp) do begin
		read(arc_emp, e);
		if((e.nombre = nom) or (e.apellido = nom)) then begin
			imprimir(e);
		end;
	end;
	close(arc_emp);
end;
procedure listarEmpleados(var arc_emp: archivo);
var
	e: empleado;
begin
	reset(arc_emp);
	while not eof(arc_emp) do begin
		read(arc_emp, e);
		imprimir(e);
	end;
	close(arc_emp);
end;
procedure listarEmpleadosMayores(var arc_emp: archivo);
var
	e: empleado;
begin
	reset(arc_emp);
	while not eof(arc_emp) do begin
		read(arc_emp, e);
		if(e.edad > 70) then begin
			imprimir(e);
		end;
	end;
	close(arc_emp);
end;
function repetido(var arc_emp: archivo; e2: empleado): boolean;
var
	e: empleado;
begin
	repetido := false;
	while(not eof(arc_emp)) do begin
		read(arc_emp,e);
		if(e.num = e2.num) then begin
			repetido := true;
		end;
	end;
end;
procedure agregarEmpleado(var arc_emp: archivo);
var
	e: empleado;
begin
	leerEmpleado(e);
	reset(arc_emp);
	while(e.apellido <> 'fin')do begin
		if(not repetido(arc_emp,e)) then begin
			seek(arc_emp, fileSize(arc_emp));
			write(arc_emp,e);
		end;
		leerEmpleado(e);
	end;
	close(arc_emp);
end;
procedure modificarEdad(var arc_emp: archivo; n : integer);
var
	nuevaEdad: integer;
	e: empleado;
	encontro: boolean;
begin
	encontro:= false;
	reset(arc_emp);
	writeln('Ingrese edad: ');
	readln(nuevaEdad);
	while(not eof(arc_emp) and not(encontro)) do begin
		read(arc_emp, e);
		if(e.num = n) then begin
			e.edad := nuevaEdad;
			encontro := true;
			seek(arc_emp, filePos(arc_emp)-1);
			write(arc_emp,e);
		end;
	end;
	close(arc_emp);
end;
procedure exportarContenido(var arc_emp: archivo);
var
	txt : Text;
	e: empleado;
begin
	assign(txt, './Pruebas/todos_empleados.txt');
	rewrite(txt);
	reset(arc_emp);
	while not eof(arc_emp) do begin
		read(arc_emp, e);
		with e do begin
			write(txt, ' ',num, ' ', apellido, ' ', nombre, ' ', edad, ' ',dni);
		end;
	end;
	close(arc_emp);
	close(txt);
end;
procedure exportarSinDni(var arc_emp: archivo);
var
 txt: Text;
 e: empleado;
begin
	assign(txt, './Pruebas/faltaDNIEmpleado.txt');
	rewrite(txt);
	reset(arc_emp);
	while not eof(arc_emp) do begin
		read(arc_emp, e);
		if(e.dni = 00) then begin
			with e do begin
				write(txt, ' ',num, ' ', apellido, ' ', nombre, ' ', edad, ' ',dni);
			end;
		end;
	end;
	close(arc_emp);
	close(txt);
end;
procedure eliminar(var arc_emp: archivo; n : integer);
var
	ultE, e : empleado;
	encontro : boolean;
begin
	encontro := false;
	reset(arc_emp);
	seek(arc_emp, filesize(arc_emp)-1);
	read(arc_emp, ultE);
	seek(arc_emp, 0);
	while (not eof(arc_emp) and not(encontro)) do begin
		read(arc_emp, e);
		if(e.num = n) then begin
			encontro := true;
			seek(arc_emp, filepos(arc_emp)-1);
			write(arc_emp,ultE);
			seek(arc_emp,filesize(arc_emp)-1);
			truncate(arc_emp);
		end;
	end;
	if not(encontro) then begin
		writeln('No se encontro el archivo');
	end
	else begin
		writeln('Archivo eliminado');
	end;
	close(arc_emp);
end;
procedure abrirArchivo(var arc_emp: archivo);
var
 option, n : integer;
 ok: boolean;
begin
	ok := true;
	while ok do begin
		writeln('Ingrese la opcion a elegir: ');
		writeln('1: Listar empleados con nombre o apellidos determinados');
		writeln('2: Listar empleados');
		writeln('3: Listar empleados mayores de 70');
		writeln('4: Agregar empleado');
		writeln('5: Modificar edad');
		writeln('6: Exportar contenido');
		writeln('7: Exportar empleados sin dni');
		writeln('8: Eliminar empleado');
		readln(option);
		case option of
			1:
			begin
				listarEmplDeterminados(arc_emp);
			end;
			2:
			begin
				listarEmpleados(arc_emp);
			end;
			3:
			begin 
				listarEmpleadosMayores(arc_emp);
			end;
			4:
			begin 
				agregarEmpleado(arc_emp);
			end;
			5:
			begin 
				writeln('Ingrese numero de empleado a modificar(-1 para salir): ');
				readln(n);
				while (n <> -1) do begin
				modificarEdad(arc_emp,n);
				writeln('Ingrese numero de empleado a modificar(-1 para salir): ');
				readln(n);
				end;
			end;
			6:
			begin 
				exportarContenido(arc_emp);
			end;
			7:
			begin 
				exportarSinDni(arc_emp);
			end;
			8:
			begin 
				writeln('Ingrese numero de empleado a borrar: ');
				readln(n);
				eliminar(arc_emp, n);
			end;
			else
				writeln('Opcion invalida');
			end;
		writeln('Continuar operaciones?: ');
		writeln('1: Si');
		writeln('2: No');
		readln(option);
		if (option = 2) then begin
			writeln('Terminando programa');
				ok := false;
		end;
	end;
end;
var 
	arc_emp: archivo;
	nom: string[50];
	option: integer;
BEGIN
	writeln('ingrese el nombre del archivo: ');
	readln(nom);
	Assign(arc_emp,nom);
	writeln('Ingrese la opcion a elegir: ');
	writeln('1: Crear el archivo');
	writeln('2: Abrir el archivo');
	writeln('Terminar programa con cualquier otra tecla');
	readln(option);
	case option of
		1:
		begin
			writeln('Opcion 1 elegida');
			crearArchivo(arc_emp);
		end;
		2:
		begin
			writeln('Opcion 2 elegida');
			abrirArchivo(arc_emp);
		end;
		else
			writeln('Terminando programa');
		end;
		writeln('Termino');
		
END.




