% Inteligencia Artificial
%Grupo 5A
%Luis Alejandro Varela Ojeda 	- luvarelao@unal.edu.co
%Jacobo Ochoa Ramirez 		 	- jochoara@unal.edu.co
%Juan Manuel Rodríguez Sánchez  - juarodriguezs@unal.edu.co

% Base de conocimientos

% transporte(Nombre, Consumo_min, Consumo_max, Precio_min, Precio_max, Motorizacion).
transporte(caminar, 	  	  0,  100,    0,      0,   no_motorizado).
transporte(trotar,  	  	  0,  200,    0,      0,   no_motorizado).
transporte(correr, 	    	  0,  350,    0,      0,   no_motorizado).
transporte(nadar, 	    	  0,  400,  1000, 10000,   no_motorizado).
transporte(bicicleta, 		101,  200,  1000,  5000,   no_motorizado).
transporte(bici_electrica, 	201,  450,  3000, 11000,   electrico).
transporte(moto, 	  		201,  300,  4000, 18000,    gasolina).
transporte(moto_grande,		301,  650,  4000, 18000,    gasolina).
transporte(metro, 	  		301,  500,  2000, 12000,   electrico).
transporte(carro_electrico, 501,  700, 12000, 40000,   electrico).
transporte(bus,		  		701,  900,  5000, 20000,    gasolina).
transporte(bus_doble_piso,	601, 1000,  7000, 22000,    gasolina).
transporte(carro, 	  		901, 1200,  9000, 35000,    gasolina).
transporte(carro_antiguo,	701, 1200,  5000, 20000,    gasolina).
transporte(scooter_electrico, 201,350,  2000,  8000,   electrico).
transporte(carro_hibrido,    501, 800, 15000, 30000,     hibrido).
transporte(moto_hibrida,     401, 800, 9000,  26000,     hibrido).
transporte(taxi,             301,1000,  8500, 40000,    gasolina).
transporte(tren,             701,1200,  8000, 30000,   electrico).

% Regla de recomendación
recomendacion(Vehiculo, Consumo, Precio, Motorizacion) :-
    transporte(Vehiculo, Remin, Remax, Pmin, Pmax, Motorizacion),
    Consumo >= Remin,
    Consumo =< Remax,
    Precio >= Pmin,
    Precio =< Pmax.

seleccion_de_transporte_por_motor(Motor, Vehi) :-
    transporte(Vehi, _, _, _, _, Motor).

% Menú
iniciar :-
    writeln('Bienvenido al sistema experto de transporte.'),
    writeln('Seleccione una opción:'),
    writeln('1. Recomendar transporte basado en consumo, precio y motorización.'),
    writeln('2. Mostrar tipos de transporte disponibles por motorización.'),
    writeln('3. Salir.'),
    read(Opcion),
    menu(Opcion).

menu(1) :-
    writeln('Seleccionó: Recomendar transporte basado en consumo, precio y motorización.'),
    preguntar_valores(Consumo, Precio, Motorizacion),
    recomendar_transporte(Consumo, Precio, Motorizacion),
    iniciar. % Vuelve al menú.

menu(2) :-
    writeln('Seleccionó: Mostrar tipos de transporte disponibles por motorización.'),
    preguntar_motorizacion(Motorizacion),
    mostrar_transporte_por_motorizacion(Motorizacion),
    iniciar. % Vuelve al menú.

menu(3) :-
    writeln('Gracias por usar el sistema experto. Hasta pronto!').

menu(_) :-
    writeln('Opción no válida, intente nuevamente.'),
    iniciar. % Vuelve al menú si la opción no es válida.

% Preguntar valores para recomendación
preguntar_valores(Consumo, Precio, Motorizacion) :-
    writeln('Ingrese el consumo en gramos por km: entre 0 y 1200 g/Km'),
    read(Consumo),
    validar_consumo(Consumo),
    writeln('Ingrese el precio en COP: entre 0 y 40000 COP'),
    read(Precio),
    validar_precio(Precio),
    writeln('Ingrese el tipo de motorización (none, electrico, gasolina, hibrido):'),
    read(Motorizacion),
    validar_motorizacion(Motorizacion).

% Preguntar motorización para listar transportes
preguntar_motorizacion(Motorizacion) :-
    writeln('Ingrese el tipo de motorización (no_motorizado, electrico, gasolina, hibrido):'),
    read(Motorizacion),
    validar_motorizacion(Motorizacion).

% Validaciones
validar_consumo(Consumo) :-
    (Consumo >= 0, Consumo =< 1200 ->
        true
    ;
        writeln('El valor ingresado para el consumo no es válido. Debe estar entre 0 y 1200.'),
        fail).

validar_precio(Precio) :-
    (Precio >= 0, Precio =< 40000 ->
        true
    ;
        writeln('El valor ingresado para el precio no es válido. Debe estar entre 0 y 40000.'),
        fail).

validar_motorizacion(Motorizacion) :-
    (member(Motorizacion, [no_motorizado, electrico, gasolina, hibrido]) ->
        true
    ;
        writeln('El tipo de motorización ingresado no es válido. Debe ser: none, electrico, gasolina, o hibrido.'),
        fail).

% Mostrar transporte por motorización
mostrar_transporte_por_motorizacion(Motorizacion) :-
    writeln('Los transportes disponibles para la motorización seleccionada son:'),
    findall(Vehi, seleccion_de_transporte_por_motor(Motorizacion, Vehi), Transportes),
    (Transportes \= [] ->
        writeln(Transportes)
    ;
        writeln('No se encontraron transportes para esta motorización.')
    ).

% Recomendación de transporte
recomendar_transporte(Consumo, Precio, Motorizacion) :-
    (   recomendacion(Transporte, Consumo, Precio, Motorizacion)
    ->  format('El medio de transporte recomendado es: ~w~n', [Transporte])
    ;   writeln('No hay ningún transporte que cumpla con los criterios.')
    ).
