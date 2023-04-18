{
   p3ej6.pas
   
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
	prenda = record
		desc: String[45];
		cod:integer;
		col: string[20];
		tipo: string[20];
		stock: integer;
		precio: real;
	end;
	maestro = file of prenda;
	detalle = file of integer;
procedure leerArc (var arc_log:maestro; var dato:prenda);
begin
	if not eof (arc_log) then
		read (arc_log,dato)
	else
		dato.cod := valorAlto;
end;
procedure actualizar(var arc_m: maestro; c : integer);
var
	p : prenda;
	ok : boolean;
begin
	ok := false;
	reset(arc_m);
	leerArc(arc_m,p);
	while((p.cod <> valorAlto)and not (ok)) do begin
		if(p.cod = c) then begin
			ok := true;
			p.stock := p.stock * -1;
			seek(arc_m, filepos(arc_m)-1);
			write(arc_m, p);
		end
		else begin
			leerArc(arc_m,p);
		end;
	end;
	close(arc_m);
end;
procedure recorrer(var arc_m: maestro; var arc_d : detalle);
var
	c: integer;
begin
	reset(arc_d);
	while(not eof(arc_d)) do begin
		read(arc_d,c);
		actualizar(arc_m,c);
		writeln('actualizado');
	end;
	close(arc_d);
end;
procedure compactar(var arc_m: maestro; var arc_nue: maestro);
var
	p : prenda;
begin
	reset(arc_m);
	rewrite(arc_nue);
	leerArc(arc_m,p);
	while(p.cod <> valorAlto) do begin
		if(p.stock >= 0) then begin
			write(arc_nue,p);
		end;
		leerArc(arc_m,p);
	end;
	close(arc_m);
end;
procedure imprimir (p:prenda);
begin
	with p do begin
		writeln ('CODIGO: ',cod,' STOCK: ',stock,' PRECIO: ',precio:1:1);
		writeln (' ');
	end;
end;
procedure mostrar (var arc_log:maestro);
var
n:prenda;
begin
	reset (arc_log);
	leerArc(arc_log,n);
	while (n.cod <> valorAlto) do begin
		imprimir (n);
		leerArc(arc_log,n);
	end;
	close (arc_log);
end;
var 
	arc_m : maestro;
	arc_nue : maestro;
	arc_d : detalle;
	i : integer;
	prendas: array[1..10] of prenda;
	numero:string;
BEGIN
	for i := 1 to 10 do begin
		Str(i,numero);
		prendas[i].desc := 'Prenda ' + numero;
		writeln(prendas[i].desc);
		prendas[i].cod := i;
		prendas[i].col := 'Negro';
		prendas[i].tipo := 'Camisa';
		prendas[i].stock := 10;
		prendas[i].precio := 200;
	end;

	// Abrir archivo maestro
	assign(arc_m, './Pruebas/prendas.dat');
	rewrite(arc_m);
	for i := 1 to 10 do begin
		write(arc_m, prendas[i]);
	end;
	close(arc_m);

	// Abrir archivo detalle
	assign(arc_d, './Pruebas/prendasDetalle.dat');
	rewrite(arc_d);
	write(arc_d, 3);
	write(arc_d, 6);
	write(arc_d, 9);
	close(arc_d);
	writeln('Antes de actualizar');
	// Actualizar registros en archivo maestro
	reset(arc_m);
	assign(arc_nue, './Pruebas/prendas_aux.dat');
	recorrer(arc_m, arc_d);
	writeln('recorridos');
	compactar(arc_m, arc_nue);
	writeln('compactados');
	close(arc_nue);
	erase(arc_m);
	rename(arc_nue, './Pruebas/prendas.dat');
	mostrar(arc_nue);
END.

