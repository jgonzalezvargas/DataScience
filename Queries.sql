SELECT 
[impterra].[dbo].[Envases].[numero],
[impterra].[dbo].[embarqueaereo].[origen],
[Basico_InternationalLine_2018].[dbo].[clientes].[empresa],  
[impterra].[dbo].[embarqueaereo].[transportista],
[impterra].[dbo].[embarqueaereo].[Pago],
[Dataset_InternationalLine_2018].[dbo].[Boleta].[agente],   
[Dataset_InternationalLine_2018].[dbo].[Boleta].[consignatario],
[Dataset_InternationalLine_2018].[dbo].[Boleta].[embarcador],
[Basico_InternationalLine_2018].[dbo].[vendedores].[nombre],
--[impterra].[dbo].[embarqueaereo].[movimiento],
[Basico_InternationalLine_2018].[dbo].[CliTraficos].[trafico], 
[impterra].[dbo].[embarqueaereo].[terminos],
[impterra].[dbo].[embarqueaereo].[ContratoCli],
[impterra].[dbo].[embarqueaereo].[ContratoTra],
[seguir].[dbo].[Seguimiento].[eta],
[seguir].[dbo].[Seguimiento].[etd],
[seguir].[dbo].[Seguimiento].[status]

INTO [JoinData].[dbo].[JoinsOneSix]
FROM [impterra].[dbo].[envases]
LEFT JOIN [impterra].[dbo].[embarqueaereo] ON ([impterra].[dbo].[envases].[numero] = [impterra].[dbo].[embarqueaereo].[numero])
LEFT JOIN [Basico_InternationalLine_2018].[dbo].[clientes] ON ([Basico_InternationalLine_2018].[dbo].[clientes].[codigo] = [impterra].[dbo].[Embarqueaereo].[cliente])
LEFT JOIN [Dataset_InternationalLine_2018].[dbo].[Boleta] ON ([Dataset_InternationalLine_2018].[dbo].[Boleta].[numero] = [impterra].[dbo].[embarqueaereo].[numero])
LEFT JOIN [Basico_InternationalLine_2018].[dbo].[vendedores] ON ([impterra].[dbo].[embarqueaereo].[vendedor] = [Basico_InternationalLine_2018].[dbo].[Vendedores].[codigo])
LEFT JOIN [Basico_InternationalLine_2018].[dbo].[CliTraficos] ON ([Basico_InternationalLine_2018].[dbo].[CliTraficos].[codigo] = [impterra].[dbo].[embarqueaereo].[trafico])
LEFT JOIN [seguir].[dbo].[Seguimiento] ON ([seguir].[dbo].[Seguimiento].[numero] = [impterra].[dbo].[embarqueaereo].[numero])

WHERE [Basico_InternationalLine_2018].[dbo].[vendedores].[Activo] = 's'

GROUP BY [impterra].[dbo].[Envases].[numero],
[impterra].[dbo].[embarqueaereo].[origen],
[Basico_InternationalLine_2018].[dbo].[clientes].[empresa],  
[impterra].[dbo].[embarqueaereo].[transportista],
[impterra].[dbo].[embarqueaereo].[Pago],
[Dataset_InternationalLine_2018].[dbo].[Boleta].[agente],    
[Dataset_InternationalLine_2018].[dbo].[Boleta].[consignatario],
[Dataset_InternationalLine_2018].[dbo].[Boleta].[embarcador],
[Basico_InternationalLine_2018].[dbo].[vendedores].[nombre],
--[impterra].[dbo].[Envases].[movimiento],
[Basico_InternationalLine_2018].[dbo].[CliTraficos].[trafico],
[impterra].[dbo].[embarqueaereo].[terminos],
[impterra].[dbo].[embarqueaereo].[ContratoCli],
[impterra].[dbo].[embarqueaereo].[ContratoTra],
[seguir].[dbo].[Seguimiento].[eta],
[seguir].[dbo].[Seguimiento].[etd],
[seguir].[dbo].[Seguimiento].[status]

order by numero
------------------------
CREATE TABLE [JoinTables].[dbo].[JoinAll] (
    ID int IDENTITY(1,1) PRIMARY KEY,
    numero int,
    origen varchar(255),
	empresa varchar(255),
    transportista int,
	Pago varchar(255),
	agente varchar(255),
	consignatario varchar(255),
	embarcador varchar(255),
	nombre varchar(255),
	movimiento varchar(255),
	trafico varchar(255),
	terminos varchar(255),
	ContratoCli varchar(255),
	ContratoTra varchar(255)
);

-----------------------------

Update [JoinTables].[dbo].[JoinAll]
SET 
	[JoinTables].[dbo].[JoinAll].[Operacion] = [expterra].[dbo].[Embarqueaereo].[operacion]
FROM [JoinTables].[dbo].[JoinAll]
INNER JOIN [expterra].[dbo].[Embarqueaereo] ON ([expterra].[dbo].[Embarqueaereo].[numero] = [JoinTables].[dbo].[JoinAll].[numero])

-----------------------------------
SELECT c.name AS ColName, t.name AS TableName
FROM sys.columns c
    JOIN sys.tables t ON c.object_id = t.object_id
WHERE c.name LIKE '%MyCol%';
--------------------------

SELECT 
j.numero,
j.empresa,
e.ETD,
j.ETA,
j.Operacion	
into JoinClientesRecientes
from JoinAll2 as j
INNER JOIN export.dbo.embarqueaereo as e ON (j.numero = e.numero) -- do for the other DBs
Where e.etd >= DATEADD(month, -6, GETDATE())
GROUP BY  
j.numero,
j.empresa,
e.ETD,
j.ETA,
j.Operacion	
 -------
SELECT 
j.numero,
j.empresa,
e.ETD,
j.ETA,
j.Operacion	
into JoinClientesAntiguos
from JoinAll2 as j
INNER JOIN export.dbo.embarqueaereo as e ON (j.numero = e.numero) -- do for the other DBs
Where e.etd < DATEADD(month, -6, GETDATE())
GROUP BY  
j.numero,
j.empresa,
e.ETD,
j.ETA,
j.Operacion	
----------------------------------------------------------
SELECT 
j.numero,
j.nombre,
e.volumencubico,
e.profitage * 690 as profit, -- precio dolar
j.Operacion	
into JoinAgentesxProfit
from JoinTables.dbo.JoinAll as j
INNER JOIN export.dbo.embarqueaereo as e ON (j.numero = e.numero) -- do for the other DBs
Where e.moneda = 2 -- dolares
GROUP BY  
j.numero,
j.nombre,
e.volumencubico,
e.profitage,
j.Operacion	
		      
		      
		      
----------------------------------------------------
		      SELECT 
[seguir].[dbo].[Seguimiento].[numero],
[seguir].[dbo].[Seguimiento].[origen],
[seguir].[dbo].[Seguimiento].[destino],
[Basico_InternationalLine_2018].[dbo].[clientes].[empresa],  
[Dataset_InternationalLine_2018].[dbo].[InfoFactura].[transportista],
[seguir].[dbo].[Seguimiento].[Pago],
[Dataset_InternationalLine_2018].[dbo].[Boleta].[agente],   
[Dataset_InternationalLine_2018].[dbo].[Boleta].[consignatario],
[Dataset_InternationalLine_2018].[dbo].[Boleta].[embarcador],
[Basico_InternationalLine_2018].[dbo].[vendedores].[nombre],
[seguir].[dbo].[Envases].[movimiento],
[seguir].[dbo].[Envases].[Peso],
[Basico_InternationalLine_2018].[dbo].[CliTraficos].[trafico], 
[seguir].[dbo].[Seguimiento].[terminos],
[seguir].[dbo].[Seguimiento].[ContratoCli],
[seguir].[dbo].[Seguimiento].[ContratoTra],
[seguir].[dbo].[Seguimiento].[eta],
[seguir].[dbo].[Seguimiento].[etd],
[seguir].[dbo].[Seguimiento].[status],
[seguir].[dbo].[Seguimiento].[modo]

--INTO [JoinData].[dbo].[JoinsOneSix]
FROM [seguir].[dbo].[Seguimiento]
--LEFT JOIN [impterra].[dbo].[embarqueaereo] ON ([impterra].[dbo].[envases].[numero] = [impterra].[dbo].[embarqueaereo].[numero])
LEFT JOIN [Basico_InternationalLine_2018].[dbo].[clientes] ON ([Basico_InternationalLine_2018].[dbo].[clientes].[codigo] = [seguir].[dbo].[Seguimiento].[cliente])
LEFT JOIN [Dataset_InternationalLine_2018].[dbo].[Boleta] ON ([Dataset_InternationalLine_2018].[dbo].[Boleta].[numero] = [seguir].[dbo].[Seguimiento].[numero])
LEFT JOIN [Basico_InternationalLine_2018].[dbo].[vendedores] ON ([seguir].[dbo].[Seguimiento].[vendedor] = [Basico_InternationalLine_2018].[dbo].[Vendedores].[codigo])
LEFT JOIN [Basico_InternationalLine_2018].[dbo].[CliTraficos] ON ([Basico_InternationalLine_2018].[dbo].[CliTraficos].[codigo] = [seguir].[dbo].[Seguimiento].[trafico])
LEFT JOIN [Dataset_InternationalLine_2018].[dbo].[InfoFactura] ON ([Dataset_InternationalLine_2018].[dbo].[InfoFactura].[seguimiento] = [seguir].[dbo].[Seguimiento].[numero])
LEFT JOIN [seguir].[dbo].[Envases] ON ([seguir].[dbo].[Envases].[numero] = [seguir].[dbo].[Seguimiento].[numero])

WHERE [Basico_InternationalLine_2018].[dbo].[vendedores].[Activo] = 's'

GROUP BY [seguir].[dbo].[Seguimiento].[numero],
[seguir].[dbo].[Seguimiento].[origen],
[seguir].[dbo].[Seguimiento].[destino],
[Basico_InternationalLine_2018].[dbo].[clientes].[empresa],  
[Dataset_InternationalLine_2018].[dbo].[InfoFactura].[transportista],
[seguir].[dbo].[Seguimiento].[Pago],
[Dataset_InternationalLine_2018].[dbo].[Boleta].[agente],   
[Dataset_InternationalLine_2018].[dbo].[Boleta].[consignatario],
[Dataset_InternationalLine_2018].[dbo].[Boleta].[embarcador],
[Basico_InternationalLine_2018].[dbo].[vendedores].[nombre],
[seguir].[dbo].[Envases].[movimiento],
[seguir].[dbo].[Envases].[Peso],
[Basico_InternationalLine_2018].[dbo].[CliTraficos].[trafico], 
[seguir].[dbo].[Seguimiento].[terminos],
[seguir].[dbo].[Seguimiento].[ContratoCli],
[seguir].[dbo].[Seguimiento].[ContratoTra],
[seguir].[dbo].[Seguimiento].[eta],
[seguir].[dbo].[Seguimiento].[etd],
[seguir].[dbo].[Seguimiento].[status],
[seguir].[dbo].[Seguimiento].[modo]

order by numero
