Query com Threads para Delphi 7.

🇧🇷 Português

📌 Funcionalidades

Executa consultas de banco de dados em threads para evitar travamento da interface. Atualiza automaticamente a grid ao finalizar a consulta. Gerenciamento de threads para evitar vazamento de recursos.
Compatível com TADOQuery, TDBGrid e parâmetros.

⚙️ Pré-requisitos: IDE Delphi 7.

Conexão de banco de dados configurada via ADOConnection.

🛠 Como Usar

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

⚠️ Observações Importantes

Segurança de threads: Atualizações da UI usam Synchronize para evitar conflitos.

Parâmetros: Certifique-se de passá-los corretamente para a query.

Limpeza de recursos: Sempre chame CleanupOldThreads ao fechar o formulário.

🇺🇸 English
📌 Features

Executes database queries in background threads to avoid UI freezing.

Automatically updates the grid when the query finishes.

Thread management to prevent resource leaks.

Compatible with TADOQuery, TDBGrid, and parameters.

⚙️ Prerequisites: Delphi 7 IDE.

Database connection configured via ADOConnection.

🛠 How to Use

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

⚠️ Important Notes

Thread safety: UI updates are done via Synchronize to avoid conflicts.
Parameter handling: Ensure parameters are correctly assigned to the query.
Resource cleanup: Always call CleanupOldThreads when closing the form.

Nota do Autor/Author Note
Este é meu primeiro projeto no GitHub! Sinta-se à vontade para contribuir ou reportar issues.
This is my first GitHub project! Feel free to contribute or report issues. 😊
