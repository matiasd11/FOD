{
   p3ej7.pas
   
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


program eliminarRegistros;

const
  valorAlto = 5000;

type
  Especie = record
    codigo: integer;
    nombre: string[50];
    familia: string[50];
    descripcion: string[100];
    zona: string[50];
  end;

  ArchivoEspecies = file of Especie;

procedure marcarRegistros(var archivo: ArchivoEspecies);
var
  e: especie;
  codigo: integer;
begin
  reset(archivo);
  writeln('Ingrese el codigo de la especie a eliminar (', valorAlto, ' para terminar): ');
  readln(codigo);
  while (codigo <> valorAlto) do begin
    while (not eof(archivo)) do begin
      read(archivo, e);
      if (e.codigo = codigo) then begin
        // Marcar registro a eliminar
        e.nombre := '@Eliminar';
        seek(archivo, filepos(archivo)-1);
        write(archivo, e);
      end;
    end;
    reset(archivo);
    writeln('Ingrese el codigo de la especie a eliminar (', valorAlto, ' para terminar): ');
    readln(codigo);
  end;
  close(archivo);
end;

procedure compactarArchivo(var archivo: ArchivoEspecies);
var
  e, ultimaEspecie: especie;
  posA: integer;
begin
  reset(archivo);
  read(archivo, e);
  while (not eof(archivo)) do begin
    if (e.nombre = '@Eliminar') then begin
	  writeln('Encontro');
      // Marca registro eliminado, se copia el último registro en su lugar
      posA := filepos(archivo)-1;
      seek(archivo, filesize(archivo)-1);
      read(archivo, ultimaEspecie);
      seek(archivo, posA);
      write(archivo, ultimaEspecie);
      seek(archivo, filesize(archivo)-1);
      truncate(archivo);
    end;
    writeln('Vuelvo a pos');
    seek(archivo, posA);
    read(archivo, e);
  end;
  close(archivo);
end;
procedure leer (var e:especie);
begin
	with e do begin
		write ('INGRESE CODIGO ESPECIE: '); readln (codigo);
		if (codigo <> -1) then begin
			write ('INGRESE NOMBRE DE ESPECIE: '); readln (nombre);
			write ('INGRESE FAMILIA DE ESPECIE: '); readln (familia);
			write ('INGRESE DESCRIPCION: '); readln (descripcion);
			write ('INGRESE ZONA: '); readln (zona);
		end;
		writeln ('')
	end;
end;
procedure crear (var arc_log:ArchivoEspecies);
var
	e: especie;
begin
	rewrite (arc_log);
	leer (e);
	while (e.codigo <> -1) do begin
		write (arc_log,e);
		leer(e);
	end;
	close (arc_log);
end;
procedure leerArc (var arc_log:ArchivoEspecies; var dato:especie);
begin
	if not eof (arc_log) then
		read (arc_log,dato)
	else
		dato.codigo := valorAlto;
end;
procedure imprimir (e: especie);
begin
	with e do begin
		writeln ('CODIGO: ',codigo,' NOMBRE: ',nombre,' FAMILIA: ',familia,' ZONA: ',zona);
		writeln (' ');
	end;
end;
procedure mostrar (var arc_log:ArchivoEspecies);
var
	n: especie;
begin
	reset (arc_log);
	leerArc(arc_log,n);
	while (n.codigo <> valorAlto) do begin
		imprimir (n);
		leerArc(arc_log,n);
	end;
	close (arc_log);
end;
var
  archivo: ArchivoEspecies;

begin
  assign(archivo, './Pruebas/especies.dat');
  //crear(archivo);
  //marcarRegistros(archivo);
  compactarArchivo(archivo);
  mostrar(archivo);
end.

