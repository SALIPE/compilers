PROGRAM EXEMPLO;

VAR CONTADOR, A,B:INTEGER;
BEGIN
	READ(A,B);
	FOR CONTADOR := 2 TO 10 DO
		BEGIN
			A:= A+CONTADOR;
			B:= B+CONTADOR;
			WRITE(A,B)
		END;

	

END.
