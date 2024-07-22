-- Create the livro table
CREATE TABLE livro (
    id SERIAL PRIMARY KEY,
    titulo VARCHAR(255) NOT NULL,
    editora VARCHAR(255) NOT NULL
);

-- Create the livro_log table without a timestamp
CREATE TABLE livro_log (
    id SERIAL PRIMARY KEY,
    acao VARCHAR(50) NOT NULL,
    titulo VARCHAR(255) NOT NULL,
    editora VARCHAR(255) NOT NULL
);

-- Function to log new book registrations
CREATE OR REPLACE FUNCTION cadastrar_livro_log_trigger()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO livro_log (acao, titulo, editora)
    VALUES ('Novo cadastro', NEW.titulo, NEW.editora);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger to call the function after inserting a new book
CREATE TRIGGER cadastrar_livro_trigger
AFTER INSERT ON livro
FOR EACH ROW EXECUTE FUNCTION cadastrar_livro_log_trigger();

-- Function to log book updates
CREATE OR REPLACE FUNCTION alterar_livro_log_trigger()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO livro_log (acao, titulo, editora)
    VALUES ('Alteração', NEW.titulo, NEW.editora);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger to call the function after updating a book
CREATE TRIGGER alterar_livro_trigger
AFTER UPDATE ON livro
FOR EACH ROW EXECUTE FUNCTION alterar_livro_log_trigger();

-- Function to log book deletions
CREATE OR REPLACE FUNCTION remover_livro_log_trigger()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO livro_log (acao, titulo, editora)
    VALUES ('Exclusão', OLD.titulo, OLD.editora);
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

-- Trigger to call the function after deleting a book
CREATE TRIGGER remover_livro_trigger
AFTER DELETE ON livro
FOR EACH ROW EXECUTE FUNCTION remover_livro_log_trigger();