{
   p3ej2.pas
   
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
	asistente = record
		num : integer;
		aYn : string[50];
		email: string[50];
		tel: integer;
		dni: integer;
	end;
	asistentes = file of asistente;
procedure leerAsistente(var a : asistente);
begin
		writeln('Ingrese un numero de asistente: ');
		readln(a.num);
		if(a.num <> -1) then begin
			writeln('Ingrese un apellido y nombre: ');
			readln(a.aYn);
			writeln('Ingrese un email de asistente: ');
			readln(a.email);
			writeln('Ingrese tel de asistente: ');
			readln(a.tel);
			writeln('Ingrese dni de asistente: ');
			readln(a.dni);
		end;
end;
procedure crearArchivo(var arc_as: asistentes);
var
	a : asistente;
begin
	rewrite(arc_as);
	leerAsistente(a);
	while(a.num <> -1) do begin
		write(arc_as, a);
		leerAsistente(a);
	end;
	close(arc_as);
end;
procedure leer(var arc_as : asistentes; var a : asistente);
begin
	if not eof(arc_as) then begin
		read(arc_as, a);
	end
	else begin
		a.num := valorAlto;
	end;
end;
procedure eliminar(var arc_as : asistentes);
var
	a : asistente;
begin
	reset(arc_as);
	leer(arc_as, a);
	while (a.num <> valorAlto) do begin
		if(a.num < 1000) then begin
			a.aYn := '@'+a.aYn;
			seek(arc_as, filepos(arc_as)-1);
			write(arc_as,a)
		end;
		leer(arc_as,a);
	end;
	close(arc_as);
end;
procedure imprimir (a:asistente);
begin
	with a do begin
		if (aYn[1] <> '@') then begin
			writeln ('NRO: ',num,' APELLIDO Y NOMBRE: ',aYn,' MAIL: ',email,' TELEFONO: ',tel,' DNI: ',dni);
			writeln ('');
		end;
	end;
end;

procedure mostrarArc (var arc_log:asistentes);
var
a:asistente;
begin
	reset (arc_log);
	while not eof (arc_log) do begin
		read (arc_log,a);
		imprimir(a);
	end;
	close (arc_log);
end;
var 
	arc_as : asistentes;

BEGIN
	Assign (arc_as,'./Pruebas/asistentes.dot');
	//crearArchivo(arc_as);
	//mostrarArc(arc_as);
	eliminar(arc_as);
	mostrarArc(arc_as);
END.

