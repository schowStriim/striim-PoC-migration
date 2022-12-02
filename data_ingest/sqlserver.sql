Declare @Id int
Set @Id = 1

While @Id <= 100000
Begin 
   Insert Into master.dms_sample.employee values (1, 'Albert - ' + CAST(@Id as nvarchar(10)),100)
   Set @Id = @Id + 1
End