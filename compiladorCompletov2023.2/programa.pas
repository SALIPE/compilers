PROGRAM EXEMPLO;

VAR NUMERO, MAIOR, MENOR: INTEGER;
BEGIN
	READ(NUMERO);
	MENOR := NUMERO;
	MAIOR := NUMERO;
	WHILE(NUMERO <> 0) DO BEGIN
		IF(NUMERO < MENOR) THEN MENOR := NUMERO;
		IF(NUMERO > MAIOR) THEN  MAIOR := NUMERO;
		READ(NUMERO);	
	END;
	WRITE(MENOR);
	WRITE(MAIOR);

END.