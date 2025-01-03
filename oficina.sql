CREATE DATABASE Oficina;
USE Oficina;

CREATE TABLE Clientes (
    ClienteID INT AUTO_INCREMENT PRIMARY KEY,
    Nome VARCHAR(100) NOT NULL,
    CPF_CNPJ VARCHAR(18) UNIQUE NOT NULL,
    Telefone VARCHAR(15),
    Email VARCHAR(100)
);

CREATE TABLE Veiculos (
    VeiculoID INT AUTO_INCREMENT PRIMARY KEY,
    ClienteID INT NOT NULL,
    Placa VARCHAR(10) UNIQUE NOT NULL,
    Modelo VARCHAR(100),
    Marca VARCHAR(50),
    Ano INT,
    FOREIGN KEY (ClienteID) REFERENCES Clientes(ClienteID)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Funcionarios (
    FuncionarioID INT AUTO_INCREMENT PRIMARY KEY,
    Nome VARCHAR(100) NOT NULL,
    CPF VARCHAR(11) UNIQUE NOT NULL,
    Cargo ENUM('Mecânico', 'Recepcionista', 'Gerente') NOT NULL,
    Salario DECIMAL(10, 2) NOT NULL
);

CREATE TABLE Servicos (
    ServicoID INT AUTO_INCREMENT PRIMARY KEY,
    Descricao VARCHAR(200) NOT NULL,
    Preco DECIMAL(10, 2) NOT NULL,
    DuracaoEstimada INT COMMENT 'Duração estimada em minutos'
);

CREATE TABLE OrdemServico (
    OrdemID INT AUTO_INCREMENT PRIMARY KEY,
    ClienteID INT NOT NULL,
    VeiculoID INT NOT NULL,
    DataAbertura DATE NOT NULL,
    DataFechamento DATE,
    Status ENUM('Aberta', 'Em andamento', 'Concluída') DEFAULT 'Aberta',
    ValorTotal DECIMAL(10, 2),
    FOREIGN KEY (ClienteID) REFERENCES Clientes(ClienteID)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (VeiculoID) REFERENCES Veiculos(VeiculoID)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE OrdemServico_Servicos (
    OrdemServicoID INT NOT NULL,
    ServicoID INT NOT NULL,
    FuncionarioID INT NOT NULL,
    Quantidade INT DEFAULT 1,
    PRIMARY KEY (OrdemServicoID, ServicoID),
    FOREIGN KEY (OrdemServicoID) REFERENCES OrdemServico(OrdemID)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (ServicoID) REFERENCES Servicos(ServicoID)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (FuncionarioID) REFERENCES Funcionarios(FuncionarioID)
        ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE Pagamentos (
    PagamentoID INT AUTO_INCREMENT PRIMARY KEY,
    OrdemServicoID INT NOT NULL,
    FormaPagamento ENUM('Dinheiro', 'Cartão', 'Pix', 'Boleto') NOT NULL,
    ValorPago DECIMAL(10, 2) NOT NULL,
    DataPagamento DATE NOT NULL,
    FOREIGN KEY (OrdemServicoID) REFERENCES OrdemServico(OrdemID)
        ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO Clientes (Nome, CPF_CNPJ, Telefone, Email)
	VALUES
		('João Silva', '12345678901', '99999-1234', 'joao@gmail.com'),
		('Maria Oliveira', '98765432109', '88888-5678', 'maria@gmail.com');
    
INSERT INTO Veiculos (ClienteID, Placa, Modelo, Marca, Ano)
	VALUES
		(1, 'ABC1234', 'Civic', 'Honda', 2020),
		(2, 'XYZ9876', 'Corolla', 'Toyota', 2021);
    
INSERT INTO Funcionarios (Nome, CPF, Cargo, Salario)
	VALUES
		('Carlos Mecânico', '32165498712', 'Mecânico', 3500.00),
		('Ana Recepcionista', '12378945632', 'Recepcionista', 2500.00);
    
INSERT INTO Servicos (Descricao, Preco, DuracaoEstimada)
	VALUES
		('Troca de Óleo', 150.00, 60),
		('Alinhamento', 200.00, 90);

INSERT INTO OrdemServico (ClienteID, VeiculoID, DataAbertura, Status, ValorTotal)
	VALUES 
		(1, 1, '2025-01-01', 'Em andamento', NULL);

INSERT INTO OrdemServico_Servicos (OrdemServicoID, ServicoID, FuncionarioID, Quantidade)
	VALUES
	(1, 1, 1, 1),
	(1, 2, 1, 1);

INSERT INTO Pagamentos (OrdemServicoID, FormaPagamento, ValorPago, DataPagamento)
	VALUES
	(1, 'Cartão', 350.00, '2025-01-02');


SELECT f.Nome, COUNT(os.ServicoID) AS TotalServicos
	FROM Funcionarios f
	JOIN OrdemServico_Servicos os ON f.FuncionarioID = os.FuncionarioID
	GROUP BY f.Nome;

SELECT c.Nome, COUNT(o.OrdemID) AS OrdensAbertas
	FROM Clientes c
	JOIN OrdemServico o ON c.ClienteID = o.ClienteID
	WHERE o.Status = 'Aberta'
	GROUP BY c.Nome;

SELECT MONTH(p.DataPagamento) AS Mes, YEAR(p.DataPagamento) AS Ano, SUM(p.ValorPago) AS TotalFaturado
	FROM Pagamentos p
	GROUP BY YEAR(p.DataPagamento), MONTH(p.DataPagamento)
	ORDER BY Ano, Mes;

SELECT v.Placa, s.Descricao, COUNT(os.ServicoID) AS TotalServicos
	FROM Veiculos v
	JOIN OrdemServico o ON v.VeiculoID = o.VeiculoID
	JOIN OrdemServico_Servicos os ON o.OrdemID = os.OrdemServicoID
	JOIN Servicos s ON os.ServicoID = s.ServicoID
	GROUP BY v.Placa, s.Descricao;