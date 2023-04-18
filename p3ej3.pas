{
   p3ej3.pas
   
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
const
	valorAlto = 9999;
type
	novela = record
		cod: integer;
		genero: string[20];
		nombre: string[20];
		dur: integer;
		dir: string[20];
		precio: real;
	end;
	archivo = file of novela;
procedure leerArc (var arc_log:archivo; var dato:novela);
begin
	if not eof (arc_log) then
		read (arc_log,dato)
	else
		dato.cod := valorAlto;
end;


procedure ingresarNombre (var nombre:string);
begin
	write ('INGRESE NOMBRE DEL ARCHIVO: '); readln (nombre);
	writeln ('')
end;

procedure leer (var n:novela);
begin
	with n do begin
		write ('INGRESE CODIGO: '); readln (cod);
		if (cod <> -1) then begin
			write ('INGRESE GENERO: ');	readln (genero);
			write ('INGRESE NOMBRE: ');	readln (nombre);
			write ('INGRESE DURACION: '); readln (dur);
			write ('INGRESE DIRECTOR: '); readln (dir);
			write ('INGRESE PRECIO: '); readln (precio);
		end;
	end;
	writeln ('');
end;

procedure imprimir (n:novela);
begin
	with n do begin
		writeln ('|CODIGO: ',cod,'|GENERO: ',genero,'|NOMBRE: ',nombre,'|DURACION: ',dur,' |DIRECTOR: ',dir,'|PRECIO: ',precio:0:2);
		writeln ('');
	end;
end;
procedure mostrarPantalla (var arc_log:archivo);
var
	n:novela;
begin
	seek (arc_log,1);
	leerArc(arc_log,n);
	while (n.cod <> valorAlto) do begin
		imprimir (n);
		leerArc(arc_log,n);
	end;
end;
procedure crearArchivo(var arc_nov : archivo);
var
	n : novela;
begin
	rewrite(arc_nov);
	n.cod := 0;
	write(arc_nov, n);
	leer(n);
	while(n.cod <> -1) do begin
		write(arc_nov, n);
		leer(n);
	end;
	close(arc_nov);
end;
procedure darAlta(var arc_nov: archivo);
var
	n1, n2: novela;
begin
	leerArc(arc_nov,n1);
	leer(n2);
	if(n1.cod < 0) then begin
		seek(arc_nov, n1.cod * -1);
		leerArc(arc_nov, n1);
		seek(arc_nov, filepos(arc_nov) -1);
		write(arc_nov,n2);
		seek(arc_nov, 0);
		write(arc_nov, n1);
	end
	else begin
		seek(arc_nov, filesize(arc_nov));
		write(arc_nov, n2);
	end;
end;
procedure modificarNovela (var n:novela);
var
	opcion:integer;

begin
	writeln ('SELECCIONE QUE DESEA MODIFICAR: ');
	writeln ('');
	writeln ('1) PRECIO');
	writeln ('');
	writeln ('2) GENERO');
	writeln ('');
	writeln ('3) NOMBRE');
	writeln ('');
	writeln ('4) DIRECTOR');
	writeln ('');
	writeln ('5) DURACION');
	writeln ('');
	write ('OPCION ELEGIDA --> ');
	readln (opcion);
	writeln ('');
	case opcion of 
	1: 
		begin
			write ('INGRESE NUEVO PRECIO: '); readln (n.precio);
		end;
	2:
		begin
			write ('INGRESE NUEVO GENERO: '); readln (n.genero);
		end;
	3: 	
		begin
			write ('INGRESE NUEVO NOMBRE: '); readln (n.nombre);
		end;
	4:
		begin
			write ('INGRESE NUEVO DIRECTOR: '); readln (n.dir);
		end;
	5: 
		begin
			write ('INGRESE NUEVA DURACION: '); readln (n.dur);
		end;
	else 
		writeln ('NO ES UNA OPCION VALIDA');
	end;
	writeln ('');
end;

procedure modificar (var arc_log:archivo);
var
	codigo:integer;
	ok: boolean;
	n:novela;
begin
	ok:= false;
	write ('INGRESE CODIGO DE LA NOVELA QUE DESEA MODIFICAR: '); readln (codigo);
	writeln ('');
	leerArc (arc_log,n);
	while (n.cod <> valorAlto) and not(ok) do begin
		leerArc (arc_log,n);
		if (codigo = n.cod) then begin
			ok:= true;
			modificarNovela (n);
			seek (arc_log,FilePos(arc_log)-1);
			write (arc_log,n);		
		end;
	end;
	if (ok) then 
		writeln ('NOVELA MODIFICADA CON EXITO')
	else
		writeln ('NO SE ENCONTRO NOVELA');
end;
procedure eliminar(var arc_nov : archivo);
var
	c : integer;
	n, n2 : novela;
	pos: integer;
	ok : boolean;
begin
	ok := false;
	writeln('Ingrese codigo a eliminar:');
	readln(c);
	leerArc(arc_nov,n);
	while((n.cod <> valorAlto) and not(ok)) do begin
		if(n.cod = c)then begin
			ok := true;
			pos := filepos(arc_nov)-1;
			n2.cod := pos *-1;
			seek(arc_nov, 0);
			read(arc_nov, n);
			seek(arc_nov, filepos(arc_nov)- 1);
			write(arc_nov,n2);
			seek(arc_nov, pos);
			write(arc_nov, n);
		end
		else begin
			leerArc(arc_nov, n);
		end;
	end;
end;
procedure abrir (var arc_log:archivo);
var
opcion:integer;
begin
	reset (arc_log);
	writeln ('INGRESE POR TECLADO LA OPCION QUE DESEA REALIZAR CON EL ARCHIVO ABIERTO ');
	writeln ('');
	writeln ('1) MOSTRAR EN PANTALLA');
	writeln ('');
	writeln ('2) DAR DE ALTA NOVELA');
	writeln ('');
	writeln ('3) MODIFICAR NOVELA');
	writeln ('');
	writeln ('4) ELIMINAR NOVELA');
	writeln ('');
	write ('OPCION ELEGIDA --> ');
	readln (opcion);
	writeln ('');
	case opcion of 
		1: mostrarPantalla(arc_log);
		2: darAlta(arc_log);
		3: modificar(arc_log);
		4: eliminar(arc_log)
	else
		writeln ('NO ES UNA OPCION CORRECTA');
	end;
	close (arc_log);
end;

procedure listar (var arc_log:archivo; var arcTxt: Text);
var
n:novela;
begin
	reset (arc_log);
	rewrite (arcTxt);
	seek (arc_log,1); // me salteo el cabecera
	leerArc(arc_log,n);
	while (n.cod <> valorAlto) do begin
		with n do begin
			if (cod > 0) then
				writeln (arcTxt,'CODIGO: ',cod,' NOMBRE: ',nombre,' GENERO: ',genero,' DIRECTOR: ',dir,' DURACION: ',dur,' PRECIO: ',precio:1:1)
			else
				writeln (arcTxt,'ESPACIO LIBRE');
		end;
		leerArc(arc_log,n);
	end;
	close (arc_log);
	close(arcTxt);
end;

procedure menu (var arc_log:archivo; var arcTxt: Text; nombre:string);
var
	opcion:integer;
begin
	writeln ('INGRESE POR TECLADO LA OPCION QUE DESEA REALIZAR CON EL ARCHIVO ',nombre);
	writeln ('');
	writeln ('1) CREAR ARCHIVO');
	writeln ('');
	writeln ('2) ABRIR ARCHIVO');
	writeln ('');
	writeln ('3) LISTAR EN ARCHIVO DE TEXTO');
	writeln ('');
	writeln ('4) SALIR');
	writeln ('');
	write ('OPCION ELEGIDA --> ');
	readln (opcion);
	writeln ('');
	case opcion of 
	1: crearArchivo(arc_log);
	2: abrir(arc_log);
	3: listar (arc_log,arcTxt);
	4:halt;
	else
		writeln ('NO ES UNA OPCION CORRECTA');
	end;
end;


var
	arc_log: archivo;
	arcTxt : Text;
	nombre:string;
	loop: boolean;
	letra: char;
begin
	loop:= true;
	ingresarNombre (nombre);
	Assign (arc_log,nombre);
	Assign (arcTxt,'./Pruebas/novelas.txt');
	menu (arc_log,arcTxt,nombre);
	while (loop) do begin
		writeln ('');
		write ('SI INGRESA CUALQUIER CARACTER SE DESPLEGARA NUEVAMENTE EL MENU. SI INGRESA E SE CERRARA LA CONSOLA: '); readln (letra);
		if (letra = 'E') or (letra = 'e') then
			loop:= false
		else begin
				menu (arc_log,arcTxt,nombre);
		end;
	end;
end.	

