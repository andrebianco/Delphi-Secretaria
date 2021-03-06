CREATE OR REPLACE PROCEDURE SP_INSERE_CURSO
(
P_NOME          IN CURSO.NOME%TYPE,
P_DESCRICAO     IN CURSO.DESCRICAO%TYPE
)
IS

NOME_INVALIDO       EXCEPTION;
DESCRICAO_INVALIDA  EXCEPTION;

BEGIN

    BEGIN -- Valida��o do par�metro Nome
        
        IF P_NOME IS NULL OR P_NOME = '' OR LENGTH(P_NOME) > 100 THEN 
            RAISE NOME_INVALIDO;
        END IF;
        
    EXCEPTION
    
        WHEN NOME_INVALIDO THEN
            RAISE_APPLICATION_ERROR(-20001, 'NOME INV�LIDO!');

    END;

    BEGIN -- Valida��o do par�metro Descri��o
        
        IF P_DESCRICAO IS NULL OR P_DESCRICAO = '' OR LENGTH(P_DESCRICAO) > 500 THEN 
            RAISE DESCRICAO_INVALIDA;
        END IF;
        
    EXCEPTION
    
        WHEN DESCRICAO_INVALIDA THEN
            RAISE_APPLICATION_ERROR(-20002, 'DESCRI��O INV�LIDA!');

    END;
        
    BEGIN
    
        INSERT INTO CURSO(ID,
                          NOME, DESCRICAO)
        VALUES(SQ_CURSO.NEXTVAL, 
               P_NOME, P_DESCRICAO);
         
        COMMIT;
        
    EXCEPTION
    
        WHEN OTHERS THEN
            BEGIN
                ROLLBACK;
                RAISE_APPLICATION_ERROR(-20003, 'ERRO INESPERADO - ' || SQLERRM);
            END;
    
    END;

END;