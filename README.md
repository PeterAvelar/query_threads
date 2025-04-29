<h1>Query com Threads para Delphi 7.</h1>

<h1>Português</h1>

<h2>📌 Funcionalidades</h2>

Executa consultas de banco de dados em threads para evitar travamento da interface. Atualiza automaticamente a grid ao finalizar a consulta. Gerenciamento de threads para evitar vazamento de recursos.
Compatível com TADOQuery, TDBGrid e parâmetros.

<h2>⚙️ Pré-requisitos: IDE Delphi 7.</h2>

Conexão de banco de dados configurada via ADOConnection.

<h2>🛠 Como Usar</h2>

Adicione a unit
Adicione UntThreadPesq.pas ao seu projeto Delphi.

Declare a variável de thread na seção pública do formulário:
Thread: TThreadPesq;  

Execute a pesquisa (ex.: no evento OnChange de um Edit):
try  
  Thread := ThreadPesqManager.CreateNewThread(  
    DM.ADOConnection1.ConnectionString,  
    QEtiq.SQL.Text,  
    QEtiq.Parameters,  
    @GrdEtiq,  
    @QEtiq,  
    @FrmConsultaMovEtiq0533  
  );  
  Thread.Resume;  
except  
  // Trate exceções  
end;  

Limpe threads ao fechar o formulário (em FormClose):
ThreadPesqManager.CleanupOldThreads;  

Formate a grid (no evento OnDataChange do DataSource):
Ajuste a formatação da grid aqui para refletir os resultados.

<h2>⚠️ Observações Importantes</h2>

Segurança de threads: Atualizações da UI usam Synchronize para evitar conflitos.

Parâmetros: Certifique-se de passá-los corretamente para a query.

Limpeza de recursos: Sempre chame CleanupOldThreads ao fechar o formulário.

<h1>English</h1>
<h2>📌 Features</h2>

Executes database queries in background threads to avoid UI freezing.

Automatically updates the grid when the query finishes.

Thread management to prevent resource leaks.

Compatible with TADOQuery, TDBGrid, and parameters.

<h2>⚙️ Prerequisites: Delphi 7 IDE.</h2>

Database connection configured via ADOConnection.

<h2>🛠 How to Use</h2>

Add the unit
Add UntThreadPesq.pas to your Delphi project.

Declare the thread variable in your form's public section:
Thread: TThreadPesq;  

Trigger the search (e.g., in an Edit's OnChange event):
try  
  Thread := ThreadPesqManager.CreateNewThread(  
    DM.ADOConnection1.ConnectionString,  
    QEtiq.SQL.Text,  
    QEtiq.Parameters,  
    @GrdEtiq,  
    @QEtiq,  
    @FrmConsultaMovEtiq0533  
  );  
  Thread.Resume;  
except  
  // Handle exceptions  
end;  

Clean up threads on form close (in FormClose):
ThreadPesqManager.CleanupOldThreads;  

Format the grid (in the DataSource's OnDataChange event):
Adjust grid formatting here to reflect query results.

<h2>⚠️ Important Notes</h2>

Thread safety: UI updates are done via Synchronize to avoid conflicts.
Parameter handling: Ensure parameters are correctly assigned to the query.
Resource cleanup: Always call CleanupOldThreads when closing the form.

Nota do Autor/Author Note
Este é meu primeiro projeto no GitHub! Sinta-se à vontade para contribuir ou reportar issues.
This is my first GitHub project! Feel free to contribute or report issues. 😊
